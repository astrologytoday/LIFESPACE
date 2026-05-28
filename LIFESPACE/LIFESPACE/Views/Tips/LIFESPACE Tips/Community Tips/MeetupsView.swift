// MeetupsView.swift (FFC)
// Uses your existing LocationManager (the ObservableObject one)

import SwiftUI
import MapKit
import CoreLocation

struct MeetupsView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var userProfile: UserProfileModel

    @StateObject private var meetups = MeetupsService()
    @StateObject private var locationManager = LocationManager()

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 43.6532, longitude: -79.3832),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )

    @State private var selectedUser: MeetupPresence? = nil
    @State private var showProfilePopup = false

    @State private var hasStartedMeetups = false
    @State private var lastPublish = Date.distantPast
    private let publishInterval: TimeInterval = 30

    var body: some View {
        ZStack(alignment: .topLeading) {

            Map(coordinateRegion: $region, annotationItems: meetups.nearby) { user in
                MapAnnotation(coordinate: user.coordinate) {
                    VStack(spacing: 4) {
                        Text(user.username)
                            .font(.caption2)
                            .foregroundColor(.white)
                            .padding(4)
                            .background(Color.black.opacity(0.6))
                            .cornerRadius(4)

                        Button(action: { selectedUser = user }) {
                            Image(user.gender.lowercased() == "female" ? "pink_avatar" : "blue_avatar")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }

                        if selectedUser?.id == user.id {
                            VStack(spacing: 4) {
                                Text("\(user.gender), \(user.age)")
                                    .font(.caption)
                                    .foregroundColor(.white)

                                Text("Wants to: \(user.intent)")
                                    .font(.caption2)
                                    .foregroundColor(.white.opacity(0.8))

                                Button(action: { showProfilePopup = true }) {
                                    Text("View Full Profile")
                                        .font(.caption2)
                                        .padding(6)
                                        .background(Color.white.opacity(0.9))
                                        .foregroundColor(.black)
                                        .cornerRadius(6)
                                }
                            }
                            .padding(6)
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(10)
                        }
                    }
                }
            }
            .ignoresSafeArea()
            .onAppear {
                locationManager.requestPermission()
            }
            .onChange(of: locationManager.userLocation) { loc in
                guard let loc else { return }
                handleLocationUpdate(loc)
            }
            .onDisappear {
                meetups.stopListening()
                locationManager.stopUpdating()
            }

            if showProfilePopup, let user = selectedUser {
                ZStack(alignment: .topTrailing) {
                    Color.black.opacity(0.6).ignoresSafeArea()

                    VStack(alignment: .leading, spacing: 12) {
                        Text("\(user.username)’s Profile")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        ForEach(user.profile.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                            HStack {
                                Text("\(key):")
                                    .font(.custom("Avenir", size: 16))
                                    .foregroundColor(.white)
                                Spacer()
                                Text(value)
                                    .font(.custom("Avenir", size: 16))
                                    .foregroundColor(.white.opacity(0.9))
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: 320)
                    .background(Color(red: 0.10, green: 0.45, blue: 0.45))
                    .cornerRadius(20)
                    .padding(.top, 60)

                    Button(action: { showProfilePopup = false }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.white)
                            .padding()
                    }
                }
            }

            Button(action: { navModel.push("MeetupsProfileView") }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.5))
                    .clipShape(Circle())
                    .padding(.top, 50)
                    .padding(.leading, 10)
            }
        }
    }

    private func handleLocationUpdate(_ loc: CLLocation) {
        let coord = loc.coordinate

        if !hasStartedMeetups {
            hasStartedMeetups = true
            region.center = coord

            meetups.publishMe(
                username: navModel.meetupUsername,
                intent: navModel.meetupIntent,
                gender: userProfile.gender,
                age: "\(userProfile.age)",              // ✅ force String safely
                profile: buildProfileDict(),
                location: coord
            )

            meetups.startListening(
                myIDToExclude: meetups.myDocumentID(),
                center: coord
            )

            lastPublish = Date()
            return
        }

        let now = Date()
        if now.timeIntervalSince(lastPublish) >= publishInterval {
            meetups.publishMe(
                username: navModel.meetupUsername,
                intent: navModel.meetupIntent,
                gender: userProfile.gender,
                age: "\(userProfile.age)",              // ✅ force String safely
                profile: buildProfileDict(),
                location: coord
            )
            lastPublish = now
        }
    }

    private func buildProfileDict() -> [String: String] {
        [
            "Gender": userProfile.gender,
            "Age": "\(userProfile.age)",
            "Height": "\(userProfile.height) cm",
            "Weight": "\(userProfile.weight) kg",
            "Drinks/Week": "\(userProfile.drinksPerWeek)",
            "Smoker": userProfile.smokingStatus,
            "Fitness Goals": userProfile.fitnessOptions.joined(separator: ", "),
            "Activities": (userProfile.activityOptions + [userProfile.customActivity].compactMap { $0 }).joined(separator: ", "),
            "Creative Outlet": (userProfile.expressionOptions + [userProfile.customExpression].compactMap { $0 }).joined(separator: ", "),
            "Inner Work": (userProfile.innerWorkOptions + [userProfile.customInnerWork].compactMap { $0 }).joined(separator: ", "),
            "Purpose": userProfile.purposeOptions.joined(separator: ", ")
        ]
    }
}
