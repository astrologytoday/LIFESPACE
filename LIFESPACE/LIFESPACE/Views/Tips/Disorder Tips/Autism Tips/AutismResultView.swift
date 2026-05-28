import SwiftUI
import StoreKit

struct AutismResultView: View {
    @EnvironmentObject var navModel: NavigationModel

    // --- Stored Answers ---
    @AppStorage("AutismDiagnostic_symptomChecks") private var symptomChecksData: Data = Data(count: 15)
    @AppStorage("AutismDiagnostic_substanceChecks") private var substanceChecksData: Data = Data(count: 9)
    @AppStorage("AutismDiagnostic_lastResultTimestamp") private var lastResultTimestamp: Double = 0

    // Pulse animation state
    @State private var pulse = false

    // --- Decoded State ---
    private var symptomChecks: [Bool] {
        symptomChecksData.map { $0 != 0 }
    }

    private var substanceChecks: [Bool] {
        substanceChecksData.map { $0 != 0 }
    }

    // --- Score Logic ---
    private var symptomCount: Int {
        symptomChecks.filter { $0 }.count
    }

    private var usedSubstances: Bool {
        substanceChecks.contains(true)
    }

    enum RiskLevel {
        case low
        case moderate
        case high
    }

    private var riskLevel: RiskLevel {
        if symptomCount < 5 {
            return .low
        } else if symptomCount >= 5 && usedSubstances {
            return .moderate
        } else {
            return .high
        }
    }

    private var resultTitle: String {
        switch riskLevel {
        case .low:
            return "Low Risk"
        case .moderate:
            return "Moderate Risk"
        case .high:
            return "High Risk"
        }
    }

    private var resultColor: Color {
        switch riskLevel {
        case .low:
            return Color(red: 0.12, green: 0.62, blue: 0.28)
        case .moderate:
            return .orange
        case .high:
            return .red
        }
    }

    private var resultMessage: String {
        if symptomCount >= 5 && !usedSubstances {
            return """
            You reported several traits related to sensory sensitivity, social processing differences, or cognitive rigidity. This could be consistent with an autism diagnosis and should be evaluated by an approved mental health professional.

            Practice LIFESPACE daily and you’ll be notified to reassess for autism risk in 6 months.
            """
        } else if symptomCount >= 5 && usedSubstances {
            return """
            Your symptoms are notable and could be consistent with an autism diagnosis. Recent psychoactive substance use may be contributing to sensory sensitivity, social fatigue, or cognitive strain.

            Practice LIFESPACE daily and you’ll be notified to reassess for autism risk in 6 months.
            """
        } else {
            return """
            Your autism symptoms are very mild and your current sensory and social processing patterns are well supported. Continue supportive routines and keep up with maintaining your LIFESPACE.
            """
        }
    }

    private func maybeRequestReview() {
        guard navModel.cameFromDiagnosticReminder else { return }
        guard resultTitle == "Low Risk" else { return }

        if let scene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }

        // 🔁 Prevent future prompts
        navModel.cameFromDiagnosticReminder = false
    }

    var body: some View {
        ZStack {
            // Background
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
                VStack(alignment: .leading, spacing: 28) {

                    // Header
                    Text("Autism Risk Assessment")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 48)

                    // Risk Level
                    Text(resultTitle)
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(resultColor)

                    // Result Copy
                    Text(resultMessage)
                        .font(.custom("Avenir", size: 17))
                        .foregroundColor(.white.opacity(0.95))
                        .fixedSize(horizontal: false, vertical: true)

                    // ✅ Treatment Plan Button (Moderate/High only)
                    if riskLevel == .moderate || riskLevel == .high {
                        Button {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                navModel.selectedScreen = "AutismTwentyFiveView"
                            }
                        } label: {
                            Text("LIFESPACE Autism Tips")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(red: 0.20, green: 0.90, blue: 0.80),
                                            Color(red: 0.10, green: 0.55, blue: 0.55)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .cornerRadius(18)
                                .shadow(radius: 10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18)
                                        .stroke(Color.white.opacity(0.25), lineWidth: 1)
                                )
                                .scaleEffect(pulse ? 1.03 : 1.0)
                                .shadow(color: Color.white.opacity(pulse ? 0.35 : 0.15),
                                        radius: pulse ? 18 : 10)
                        }
                        .padding(.top, 6)
                        .onAppear {
                            pulse = false
                            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                                pulse = true
                            }
                        }
                    }

                    // Return Button
                    Button {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            navModel.selectedScreen = "AutismTipsView"
                        }
                    } label: {
                        Text("Return to Tips")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.teal)
                            .padding(.vertical, 16)
                            .padding(.horizontal, 40)
                            .background(Color.white)
                            .cornerRadius(16)
                    }
                    .padding(.top, 24)

                    Spacer(minLength: 32)
                }
                .padding(.horizontal, 26)
            }
        }
        .onAppear {
            maybeRequestReview()
        }
    }
}
