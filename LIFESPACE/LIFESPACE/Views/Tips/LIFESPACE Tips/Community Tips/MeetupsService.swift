// MeetupsService.swift (FFC)

import Foundation
import FirebaseFirestore
import CoreLocation

struct MeetupPresence: Identifiable {
    let id: String
    let username: String
    let intent: String
    let gender: String
    let age: String                 // ✅ String, matches your UserProfileModel
    let profile: [String: String]
    let coordinate: CLLocationCoordinate2D
    let updatedAt: Date
}

final class MeetupsService: ObservableObject {
    @Published var nearby: [MeetupPresence] = []

    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?

    private var deviceID: String {
        if let existing = UserDefaults.standard.string(forKey: "meetups_device_id") {
            return existing
        }
        let new = UUID().uuidString
        UserDefaults.standard.setValue(new, forKey: "meetups_device_id")
        return new
    }

    func myDocumentID() -> String { deviceID }

    func publishMe(
        username: String,
        intent: String,
        gender: String,
        age: String,                              // ✅ String
        profile: [String: String],
        location: CLLocationCoordinate2D
    ) {
        let doc = db.collection("meetups_presence").document(deviceID)

        var data: [String: Any] = [
            "username": username,
            "intent": intent,
            "gender": gender,
            "age": age,                            // ✅ store as String
            "profile": profile,
            "lat": location.latitude,
            "lon": location.longitude,
            "updatedAt": FieldValue.serverTimestamp()
        ]

        // Optional: also store an Int version if possible (helps later)
        if let ageInt = Int(age.trimmingCharacters(in: .whitespacesAndNewlines)) {
            data["ageInt"] = ageInt
        }

        doc.setData(data, merge: true) { err in
            if let err = err {
                print("❌ publishMe failed:", err.localizedDescription)
            } else {
                print("✅ publishMe OK")
            }
        }
    }

    func startListening(
        myIDToExclude: String? = nil,
        center: CLLocationCoordinate2D,
        maxDistanceMeters: Double = 2500,
        onlyRecentMinutes: Int = 20
    ) {
        stopListening()

        let since = Date().addingTimeInterval(TimeInterval(-60 * onlyRecentMinutes))
        let excludeID = myIDToExclude ?? deviceID

        listener = db.collection("meetups_presence")
            .whereField("updatedAt", isGreaterThan: Timestamp(date: since))
            .order(by: "updatedAt", descending: true)
            .limit(to: 200)
            .addSnapshotListener { [weak self] snap, err in
                guard let self else { return }

                if let err = err {
                    print("❌ listener failed:", err.localizedDescription)
                    return
                }

                let docs = snap?.documents ?? []
                print("✅ listener docs:", docs.count)

                let centerLoc = CLLocation(latitude: center.latitude, longitude: center.longitude)

                var results: [MeetupPresence] = []
                results.reserveCapacity(docs.count)

                for d in docs {
                    if d.documentID == excludeID { continue }

                    let data = d.data()
                    let username = data["username"] as? String ?? "Unknown"
                    let intent = data["intent"] as? String ?? ""
                    let gender = data["gender"] as? String ?? ""

                    // ✅ accept either String or Int (in case older docs were Int)
                    let age: String = {
                        if let s = data["age"] as? String { return s }
                        if let i = data["age"] as? Int { return "\(i)" }
                        if let i = data["ageInt"] as? Int { return "\(i)" }
                        return ""
                    }()

                    let profile = data["profile"] as? [String: String] ?? [:]

                    let lat = data["lat"] as? Double ?? 0
                    let lon = data["lon"] as? Double ?? 0
                    let updatedAtTS = data["updatedAt"] as? Timestamp
                    let updatedAt = updatedAtTS?.dateValue() ?? Date.distantPast

                    let coord = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                    let dist = centerLoc.distance(from: CLLocation(latitude: lat, longitude: lon))
                    if dist > maxDistanceMeters { continue }

                    results.append(
                        MeetupPresence(
                            id: d.documentID,
                            username: username,
                            intent: intent,
                            gender: gender,
                            age: age,
                            profile: profile,
                            coordinate: coord,
                            updatedAt: updatedAt
                        )
                    )
                }

                self.nearby = results
            }
    }

    func stopListening() {
        listener?.remove()
        listener = nil
    }
}
