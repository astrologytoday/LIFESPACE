import SwiftUI

struct CPTSDDiagnosticView: View {
    @EnvironmentObject var navModel: NavigationModel

    // --- Symptom Checklist Items (UNCHANGED COPY) ---
    let symptoms = [
        "I feel easily startled and hypervigilant most of the time",
        "I experienced traumatic events growing up and think about them often",
        "I have nightmares or flashbacks of traumatic events that happened to me",
        "I often have intrusive memories of negative events that happened in my past",
        "I have a strong fear of being hurt or harmed by others",
        "I have difficulty concentrating for long periods of time",
        "I have difficulty remembering important events from my past",
        "I often feel overwhelmed by stress and have difficulty managing my emotions",
        "I have outbursts of anger that are difficult to control",
        "I often cry",
        "I have difficulty sustaining long-term relationships",
        "I often feel defeated or worthless",
        "I have contemplated suicide or had thoughts of self-harm",
        "I feel like a failure most of the time",
        "I have strong physical sensations associated with traumatic memories",
        "I have innappropriate emotional reactions and sometimes can't feel anything at all",
        "I have trouble sleeping at night due to racing thoughts and feelings of stress",
        "I feel disconnected from others and the world"
    ]

    // --- Substance Use Items (UNCHANGED COPY) ---
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

    // --- Persistent State (MATCHES ANXIETY FORMAT) ---
    @AppStorage("CPTSDDiagnostic_symptomChecks") private var symptomChecksData: Data = Data(count: 18)
    @AppStorage("CPTSDDiagnostic_substanceChecks") private var substanceChecksData: Data = Data(count: 9)
    @AppStorage("CPTSDDiagnostic_lastResultTimestamp") private var lastResultTimestamp: Double = 0
    @AppStorage("CPTSDDiagnostic_lastResultRisk") private var lastResultRisk: String = ""
    @AppStorage("diagnosticNotifications") private var diagnosticNotificationsEnabled: Bool = true

    // --- UI State ---
    @State private var symptomChecks: [Bool] = Array(repeating: false, count: 18)
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

    // MARK: - Submit (MATCHES ANXIETY LOGIC)

    func submitAssessment() {
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
            NotificationManager.shared.scheduleSixMonthRetestNotification(for: "C-PTSD")
        }

        navModel.selectedScreen = "CPTSDResultView"
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

                    Text("LIFESPACE C-PTSD Risk Assessment")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 48)

                    Text("""
                    This is a self-reflection tool, not a medical diagnosis. If symptoms feel overwhelming, consider reaching out to a licensed mental health professional.
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
            }
            .onAppear {
                loadAnswers()
            }
        }
    }
}
