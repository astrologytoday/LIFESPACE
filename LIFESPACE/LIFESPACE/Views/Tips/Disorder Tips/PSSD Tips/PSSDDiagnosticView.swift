import SwiftUI

struct PSSDDiagnosticView: View {
    @EnvironmentObject var navModel: NavigationModel

    // --- Symptom Checklist Items (NEW CRITERIA — UNCHANGED COPY) ---
    let symptoms = [
        "I've seen a noticeable reduction in sexual desire compared to my usual baseline",
        "Sexual arousal feels difficult to achieve or maintain even when I want intimacy",
        "Physical stimulation produces less pleasurable sensations than expected",
        "I experience genital numbness",
        "My body does not respond consistently to sexual stimulation",
        "I have difficulty achieving orgasm",
        "I experience delayed orgasms",
        "I achieve orgasms quickly and while unstimulated",
        "Orgasms feel weaker or less satisfying than normal",
        "I experience erectile dysfunction or lubrication difficulties",
        "Sexual activity feels mechanical, disconnected, or lacking in pleasure",
        "I feel emotionally detached or mentally distant during intimate moments",
        "I avoid sexual or intimate situations due to frustration, discomfort, or lack of response",
        "My sexual difficulties cause distress, confusion, or concern about my well-being",
        "My negative sexual symptoms don't resolve on their own",
        "Stress, fatigue, or emotional strain noticeably worsen my sexual functioning",
        "My sense of sexual identity, confidence, or embodiment feels diminished"
    ]

    // --- Substance Use Items ---
    let substances = [
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

    // --- Persistent State (MATCHES STANDARDIZED FORMAT) ---
    @AppStorage("PSSDDiagnostic_symptomChecks") private var symptomChecksData: Data = Data(count: 17)
    @AppStorage("PSSDDiagnostic_substanceChecks") private var substanceChecksData: Data = Data(count: 9)
    @AppStorage("PSSDDiagnostic_lastResultTimestamp") private var lastResultTimestamp: Double = 0
    @AppStorage("PSSDDiagnostic_lastResultRisk") private var lastResultRisk: String = ""
    @AppStorage("diagnosticNotifications") private var diagnosticNotificationsEnabled: Bool = true

    // --- UI State ---
    @State private var symptomChecks: [Bool] = Array(repeating: false, count: 17)
    @State private var substanceChecks: [Bool] = Array(repeating: false, count: 9)

    // MARK: - Save / Load / Clear

    func saveAnswers() {
        symptomChecksData = Data(symptomChecks.map { $0 ? 1 : 0 })
        substanceChecksData = Data(substanceChecks.map { $0 ? 1 : 0 })
    }

    func loadAnswers() {
        if symptomChecksData.count == symptoms.count {
            symptomChecks = symptomChecksData.map { $0 != 0 }
        }
        if substanceChecksData.count == substances.count {
            substanceChecks = substanceChecksData.map { $0 != 0 }
        }
    }

    func clearAnswers() {
        symptomChecks = Array(repeating: false, count: symptoms.count)
        substanceChecks = Array(repeating: false, count: substances.count)
        saveAnswers()
    }

    // MARK: - Submit Logic (3-SYMPTOM THRESHOLD)

    func submitAssessment() {
        saveAnswers()
        lastResultTimestamp = Date().timeIntervalSince1970

        let symptomCount = symptomChecks.filter { $0 }.count
        let usedSubstances = substanceChecks.contains(true)

        let risk: String
        if symptomCount < 3 {
            risk = "Low Risk"
        } else if symptomCount >= 3 && usedSubstances {
            risk = "Moderate Risk"
        } else {
            risk = "High Risk"
        }

        lastResultRisk = risk

        if symptomCount >= 3 && diagnosticNotificationsEnabled {
            NotificationManager.shared.scheduleSixMonthRetestNotification(for: "PSSD")
        }

        navModel.selectedScreen = "PSSDResultView"
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

                    Text("LIFESPACE Sexual Dysfunction Risk Assessment")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 48)

                    Text("""
                    This is a self-reflection tool, not a medical diagnosis. Sexual changes can be distressing and confusing. If symptoms persist or worsen, consider consulting a trusted healthcare professional.
                    """)
                    .font(.custom("Avenir", size: 16))
                    .foregroundColor(.white.opacity(0.85))

                    Text("Check the boxes you feel describe your experience in recent months:")
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
                                        .foregroundColor(symptomChecks[idx] ? Color(red: 0.10, green: 0.48, blue: 0.74) : .white.opacity(0.7))
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
                                        .foregroundColor(substanceChecks[idx] ? .teal : .white.opacity(0.7))
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

                    // Navigation
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
