import SwiftUI

// MARK: - PSSD Symptoms

let pssdSymptomsLeft = [
    "Loss of libido or sexual desire",
    "Genital numbness or reduced sensitivity",
    "Erectile dysfunction or lubrication difficulties"
]

let pssdSymptomsRight = [
    "Weak or absent orgasm",
    "Delayed ejaculation or anorgasmia",
    "Symptoms persisting long after stopping SSRIs"
]

// MARK: - PSSDTipsView

struct PSSDTipsView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var selectedBlock: Int? = nil
    @State private var resetPressed = false
    @AppStorage("PSSDDiagnostic_lastResultTimestamp")
    private var lastResultTimestamp: Double = 0


    let treatments: [(title: String, message: String)] = [
        ("Light Therapy", "Improves circadian rhythm"),
        ("Meditation/Yoga", "Reduces sympathetic overactivation"),
        ("Fitness Training", "Enhances blood flow and hormone balance"),
        ("Orthomolecular Diet", "Fix nutrient depletion from chronic SSRI use"),
        ("Vibrational Audio Therapy", "Parasympathetic activation"),
        ("Occupational Therapy", "Restores motivation and self-efficacy"),
        ("Recreational Therapy", "Re-engages natural reward pathways"),
        ("Sleep Optimization", "Improves hormonal regulation"),
        ("Judgment-Free Community", "Reduces shame and rebuilds confidence"),
        ("Art & Music Therapy", "Improves sensory and creative pathways")
    ]

    private func canRetakePSSDDiagnostic() -> Bool {
        guard lastResultTimestamp > 0 else { return true }

        let lastDate = Date(timeIntervalSince1970: lastResultTimestamp)
        guard let sixMonthsLater = Calendar.current.date(byAdding: .month, value: 6, to: lastDate) else {
            return true
        }

        return Date() >= sixMonthsLater
    }
    
    var body: some View {
        ZStack {
            tealGradient.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 28) {

                    // TITLE
                    Text("Sexual Dysfunction Tips")
                        .font(.system(size: 32, weight: .heavy))
                        .underline()
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.80), radius: 7, y: 6)
                        .padding(.top, 34)

                    // WHAT IS PSSD — FIXED ALIGNMENT + SPACING
                    VStack(alignment: .leading, spacing: 18) {

                        Text("What is Post-SSRI Sexual Dysfunction?")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)   // balanced, same as psychosis
                            .padding(.leading, 8)

                        Text("""
Post-SSRI Sexual Dysfunction (PSSD) refers to persistent sexual side effects that continue or appear after reducing or stopping SSRI or SNRI medications. People with PSSD may experience loss of libido, genital numbness, difficulty achieving arousal or orgasm, and a blunted sense of romantic or emotional connection.
""")
                            .font(.system(size: 17))
                            .foregroundColor(.white)
                            .padding(20)
                            .background(.white.opacity(0.12))
                            .cornerRadius(16)
                            .frame(maxWidth: 420)
                            .padding(.horizontal, 20)
                    }

                    // SIGNS & SYMPTOMS — MATCHES PSYCHOSIS LAYOUT
                    VStack(alignment: .leading, spacing: 12) {

                        Text("Signs & Symptoms")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                            .padding(.leading, 16)

                        HStack(alignment: .top, spacing: 20) {

                            VStack(alignment: .leading, spacing: 16) {
                                ForEach(pssdSymptomsLeft, id: \.self, content: bulletRow)
                            }
                            .padding(16)
                            .background(.white.opacity(0.12))
                            .cornerRadius(16)
                            .padding(.leading, 16)

                            VStack(alignment: .leading, spacing: 16) {
                                ForEach(pssdSymptomsRight, id: \.self, content: bulletRow)
                            }
                            .padding(16)
                            .background(.white.opacity(0.12))
                            .cornerRadius(16)
                            .padding(.trailing, 16)
                        }
                        .padding(.top, 6)

                        // RESET + 25 TIPS
                        HStack(spacing: 40) {
                            Button {
                                resetPressed = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
                                    navModel.push("PSSDResetView")
                                    resetPressed = false
                                }
                            } label: {
                                Image(resetPressed ? "cognitive-reset-pushed" : "cognitive-reset")
                                    .resizable()
                                    .frame(width: 122, height: 122)
                                    .shadow(color: .red.opacity(0.38), radius: 14, y: 5)
                            }
                            .scaleEffect(resetPressed ? 0.94 : 1)

                            Button {
                                navModel.push("PSSDTwentyFiveView")
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [.yellow, .orange, .pink]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 120, height: 120)
                                        .shadow(radius: 10, y: 4)

                                    Text("More\nTips")
                                        .font(.system(size: 30, weight: .bold))
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)

                    }
                    .padding(.leading, 0) // prevents right shift

                    // BUILDING BLOCKS TITLE
                    Text("The Building Blocks of Wellness")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .yellow.opacity(0.95), radius: 16)
                        .padding(.vertical, 2)

                    // MATRIX
                    PSSDBuildingBlocksMatrixView(
                        selected: $selectedBlock,
                        treatments: treatments
                    )
                    .padding(.bottom, 10)

                    // NUTRITIONAL SUGGESTIONS
                    VStack(alignment: .leading, spacing: 14) {

                        HStack(spacing: 10) {
                            Text("Nutritional Suggestions")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)

                            Image("apple")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 28)
                        }
                        .padding(.leading, 24)

                        VStack(alignment: .leading, spacing: 10) {
                            Text("""
For PSSD, nutrition can support hormone production, nerve health, and overall energy. Zinc, Vitamin D, magnesium, healthy fats (especially omega-3s), and adequate protein all play key roles in testosterone regulation, neurotransmitter synthesis, and nitric oxide signaling.
""")

                            Text("""
Eating nutrient-dense meals, stabilizing blood sugar, and avoiding chronic deficiencies can give your body the raw materials it needs to repair, rebalance, and support sexual function over time.
""")
                        }
                        .font(.system(size: 17))
                        .foregroundColor(.white)
                        .padding(20)
                        .background(.white.opacity(0.12))
                        .cornerRadius(16)
                        .frame(maxWidth: 460)
                        .padding(.horizontal, 20)
                    }

                    PSSDFoodTableView()
                        .padding(.top, 4)

                    // BOTTOM NAVIGATION
                    VStack(spacing: 26) {
                        HStack {
                            Button(action: { navModel.push("TipsView") }) {
                                Circle()
                                    .fill(tealGradient)
                                    .frame(width: 54, height: 54)
                                    .overlay(Image(systemName: "arrow.left")
                                        .font(.title2)
                                        .foregroundColor(.white))
                            }

                            Spacer()

                            Button(action: {
                                if canRetakePSSDDiagnostic() {
                                    navModel.push("PSSDDiagnosticView")
                                } else {
                                    navModel.push("PSSDResultView")
                                }
                            }) {
                                Text("RISK ASSESSMENT")
                                    .font(.system(size: 20, weight: .bold))
                                    .padding(.vertical, 14)
                                    .padding(.horizontal, 28)
                                    .background(tealGradient)
                                    .cornerRadius(18)
                                    .foregroundColor(.white)
                            }

                            Spacer()

                            Button(action: { navModel.push("HomeView") }) {
                                Circle()
                                    .fill(tealGradient)
                                    .frame(width: 54, height: 54)
                                    .overlay(Image(systemName: "house.fill")
                                        .font(.title2)
                                        .foregroundColor(.white))
                            }
                        }
                        .padding(.horizontal, 34)
                    }
                    .padding(.top, 30)
                    .padding(.bottom, 50)

                }
                .padding(.horizontal, 10)
            }
        }
    }

    // MARK: - Bullet Row
    private func bulletRow(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
                .font(.system(size: 22).bold())
                .foregroundColor(.white)

            Text(text)
                .foregroundColor(.white.opacity(0.96))
                .font(.system(size: 17))
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
