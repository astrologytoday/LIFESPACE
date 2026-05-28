import SwiftUI

struct AutismDiagnosticView: View {
    @EnvironmentObject var navModel: NavigationModel

    // --- Symptom Checklist Items (UNCHANGED COPY) ---
    private let symptoms = [
        "I don't respond to my name when people talk to me",
        "I have difficulty interpreting body language and social cues",
        "I speak in a monotone or sing-song voice",
        "I avoid eye contact with others",
        "I lack empathy",
        "I often fail to see things from other people's perspective",
        "I have difficulty moving from one task to another",
        "I can't concentrate or pay attention for long periods of time",
        "I am very uncomfortable with physical contact and reject hugs or cuddles",
        "I am very sensitive to loud noises",
        "I often have overly emotional reactions",
        "I am socially isolated",
        "I have issues communicating with others",
        "I have a low social battery and feel fatigued if I'm around others for too long",
        "I get overly obsessed",
        "I have trouble understanding or following social rules",
        "I am prone to speaking in word salads",
        "I lack awareness of my surroundings and am prone to danger",
        "I make jokes that are often misconstrued and laugh at inappropriate times",
        "I can't relate to anyone"
    ]

    // --- Substance Use Items (UNCHANGED COPY) ---
    private let substances = [
        "Amphetamines",
        "Methamphetamines",
        "Marijuana",
        "Psychedelics (e.g. shrooms, LSD)",
        "Opioids (e.g. heroin, fentanyl)",
        "Ketamine",
        "SSRIs",
        "Benzodiazepines",
        "Antipsychotics"
    ]

    // --- Persistent State ---
    @AppStorage("AutismDiagnostic_symptomChecks") private var symptomChecksData: Data = Data()
    @AppStorage("AutismDiagnostic_substanceChecks") private var substanceChecksData: Data = Data()
    @AppStorage("AutismDiagnostic_lastResultTimestamp") private var lastResultTimestamp: Double = 0
    @AppStorage("AutismDiagnostic_lastResultRisk") private var lastResultRisk: String = ""
    @AppStorage("diagnosticNotifications") private var diagnosticNotificationsEnabled: Bool = true

    // --- UI State (must match counts) ---
    @State private var symptomChecks: [Bool] = Array(repeating: false, count: 20)
    @State private var substanceChecks: [Bool] = Array(repeating: false, count: 9)

    // Checkbox color (darker + slightly teal)
    private let checkboxColor = Color(red: 0.10, green: 0.48, blue: 0.74)

    // MARK: - Helpers

    private func decodeBools(from data: Data, count: Int) -> [Bool] {
        var arr = data.map { $0 != 0 }

        // ✅ If old builds saved fewer items, pad with false
        if arr.count < count {
            arr.append(contentsOf: Array(repeating: false, count: count - arr.count))
        }

        // ✅ If somehow more were saved, truncate
        if arr.count > count {
            arr = Array(arr.prefix(count))
        }

        return arr
    }

    // MARK: - Save / Load / Clear

    private func saveAnswers() {
        symptomChecksData = Data(symptomChecks.map { $0 ? 1 : 0 })
        substanceChecksData = Data(substanceChecks.map { $0 ? 1 : 0 })
    }

    private func loadAnswers() {
        symptomChecks = decodeBools(from: symptomChecksData, count: symptoms.count)
        substanceChecks = decodeBools(from: substanceChecksData, count: substances.count)

        // ✅ If this is first run and we had empty data, persist correct-sized arrays
        if symptomChecksData.isEmpty || substanceChecksData.isEmpty {
            saveAnswers()
        }
    }

    private func clearAnswers() {
        symptomChecks = Array(repeating: false, count: symptoms.count)
        substanceChecks = Array(repeating: false, count: substances.count)
        saveAnswers()
    }

    // MARK: - Submit

    private func submitAssessment() {
        saveAnswers()
        lastResultTimestamp = Date().timeIntervalSince1970

        let symptomCount = symptomChecks.filter { $0 }.count
        let usedSubstances = substanceChecks.contains(true)

        let risk: String
        if symptomCount < 5 {
            risk = "Low Risk"
        } else if symptomCount >= 5 && usedSubstances {
            risk = "Moderate Risk"
        } else {
            risk = "High Risk"
        }

        lastResultRisk = risk

        if symptomCount >= 5 && diagnosticNotificationsEnabled {
            NotificationManager.shared.scheduleSixMonthRetestNotification(for: "Autism")
        }

        navModel.selectedScreen = "AutismResultView"
    }

    // MARK: - UI

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.35, green: 0.80, blue: 0.75),
                    Color(red: 0.20, green: 0.65, blue: 0.60),
                    Color(red: 0.10, green: 0.45, blue: 0.45)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    Text("LIFESPACE Autism Risk Assessment")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 48)

                    Text("""
                    This is a self-reflection tool, not a medical diagnosis. If symptoms are severe, persistent, or overwhelming, consider connecting with a licensed healthcare or mental health professional.
                    """)
                    .font(.custom("Avenir", size: 16))
                    .foregroundColor(.white.opacity(0.85))

                    Text("Check the boxes you feel describe you most in the recent months:")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)

                    // Symptoms
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(symptoms.indices, id: \.self) { idx in
                            Button {
                                symptomChecks[idx].toggle()
                                saveAnswers()
                            } label: {
                                HStack(alignment: .top) {
                                    Image(systemName: symptomChecks[idx] ? "checkmark.square.fill" : "square")
                                        .foregroundColor(symptomChecks[idx] ? checkboxColor : .white.opacity(0.7))
                                        .font(.title2)

                                    Text(symptoms[idx])
                                        .foregroundColor(.white)
                                        .font(.custom("Avenir", size: 17))
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    // Substance Use
                    Text("Have you taken any of these substances in the last 6 months?")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.top, 18)

                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(substances.indices, id: \.self) { idx in
                            Button {
                                substanceChecks[idx].toggle()
                                saveAnswers()
                            } label: {
                                HStack {
                                    Image(systemName: substanceChecks[idx] ? "checkmark.square.fill" : "square")
                                        .foregroundColor(substanceChecks[idx] ? checkboxColor : .white.opacity(0.7))
                                        .font(.title2)

                                    Text(substances[idx])
                                        .foregroundColor(.white)
                                        .font(.custom("Avenir", size: 17))
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    // Buttons
                    HStack(spacing: 18) {
                        Button(action: submitAssessment) {
                            Text("Submit Assessment")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.teal)
                                .lineLimit(1)
                                .minimumScaleFactor(0.9)
                                .frame(minWidth: 200)
                                .padding(.vertical, 14)
                                .background(Color.white)
                                .cornerRadius(14)
                        }

                        Button(action: clearAnswers) {
                            Text("Clear Answers")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.vertical, 14)
                                .padding(.horizontal, 20)
                                .background(Color.teal.opacity(0.6))
                                .cornerRadius(14)
                        }
                    }
                    .padding(.top, 28)

                    // Back / Home
                    HStack {
                        Button { navModel.pop() } label: {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .font(.system(size: 24, weight: .bold))
                                .padding(14)
                                .background(Color.teal.opacity(0.7))
                                .clipShape(Circle())
                        }

                        Spacer()

                        Button { navModel.selectedScreen = "HomeView" } label: {
                            Image(systemName: "house.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 24, weight: .bold))
                                .padding(14)
                                .background(Color.teal.opacity(0.7))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.top, 16)
                }
                .padding(.horizontal, 26)
                .padding(.bottom, 32)
            }
            .onAppear {
                loadAnswers()
            }
        }
    }
}
