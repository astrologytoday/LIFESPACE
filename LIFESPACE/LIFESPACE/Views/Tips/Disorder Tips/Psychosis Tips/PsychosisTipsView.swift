import SwiftUI

let psychosisSymptomsLeft = [
    "Extreme sleep disruption",
    "Heightened sensitivity to light and sound",
    "Muscle tension and agitation",
    "Racing thoughts"
]

let psychosisSymptomsRight = [
    "Difficulty separating imagination from reality",
    "Extreme paranoia",
    "Hallucinations",
    "Self-harming behaviors"
]

struct PsychosisTipsView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var selectedBlock: Int? = nil
    @State private var resetPressed = false
    @AppStorage("PsychosisDiagnostic_lastResultTimestamp")
    private var lastResultTimestamp: Double = 0


    let treatments: [(title: String, message: String)] = [
        ("Light Therapy", "Reduces negative symptoms"),
        ("Meditation/Yoga", "Improves circadian rhythm"),
        ("Fitness Training", "Improves cognition"),
        ("Orthomolecular Diet", "Reduces brain inflammation"),
        ("Vibrational Audio Therapy", "Soothes anxiety"),
        ("Occupational Therapy", "Builds autonomy and function"),
        ("Recreational Therapy", "Stimulates positive socialization"),
        ("Sleep Optimization", "Reduces psychotic risk and improves clarity"),
        ("Judgment-Free Community", "Reduces paranoia and defensiveness"),
        ("Art & Music Therapy", "Increases expression and reduces isolation")
    ]

    private func canRetakePsychosisDiagnostic() -> Bool {
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

                    // -----------------------------------------------------------------
                    // TITLE
                    // -----------------------------------------------------------------
                    Text("Psychosis Tips")
                        .font(.system(size: 38, weight: .heavy))
                        .underline()
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.80), radius: 7, y: 6)
                        .shadow(color: .teal.opacity(0.6), radius: 18)
                        .shadow(color: .white.opacity(0.3), radius: 5, y: 1)
                        .padding(.top, 34)

                    // -----------------------------------------------------------------
                    // WHAT IS SSD?
                    // -----------------------------------------------------------------
                    VStack(alignment: .leading, spacing: 18) {

                        Text("What is Schizophrenia Spectrum Disorder?")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.leading, 16)

                        Text("""
Schizophrenia Spectrum Disorder (SSD) is a condition where perception, thinking, and sensory processing become dysregulated. People may experience hallucinations, paranoia, disrupted sleep, emotional disconnection, and difficulty distinguishing internal thoughts from external reality. SSD often emerges during periods of extreme stress, trauma, neurological vulnerability, or chronic inflammation.
""")
                            .font(.system(size: 17))
                            .foregroundColor(.white)
                            .padding(20)
                            .background(.white.opacity(0.12))
                            .cornerRadius(16)
                            .frame(maxWidth: 420)
                            .padding(.horizontal, 20)
                    }

                    // -----------------------------------------------------------------
                    // SIGNS & SYMPTOMS — shifted right
                    // -----------------------------------------------------------------
                    VStack(alignment: .leading, spacing: 12) {

                        Text("Signs & Symptoms")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                            .padding(.leading, 8)

                        HStack(alignment: .top, spacing: 20) {

                            VStack(alignment: .leading, spacing: 16) {
                                ForEach(psychosisSymptomsLeft, id: \.self, content: bulletRow)
                            }
                            .padding(16)
                            .background(.white.opacity(0.12))
                            .cornerRadius(16)
                            .padding(.leading, 16)

                            VStack(alignment: .leading, spacing: 16) {
                                ForEach(psychosisSymptomsRight, id: \.self, content: bulletRow)
                            }
                            .padding(16)
                            .background(.white.opacity(0.12))
                            .cornerRadius(16)
                            .padding(.trailing, 16)
                        }
                        .padding(.top, 6)



                        // -----------------------------------------------------------------
                        // CENTERED RESET + 25 TIPS BUTTONS
                        // -----------------------------------------------------------------
                        HStack(spacing: 40) {

                            // Cognitive Reset
                            Button {
                                resetPressed = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
                                    navModel.push("PsychosisResetView")
                                    resetPressed = false
                                }
                            } label: {
                                Image(resetPressed ? "cognitive-reset-pushed" : "cognitive-reset")
                                    .resizable()
                                    .frame(width: 122, height: 122)
                                    .shadow(color: .red.opacity(0.38), radius: 14, y: 5)
                            }
                            .scaleEffect(resetPressed ? 0.94 : 1)


                            // 25 Tips Button
                            Button {
                                navModel.push("PsychosisTwentyFiveView")
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
                        .frame(maxWidth: .infinity, alignment: .center)   // << CENTERED
                        .padding(.vertical, 20)

                    }
                    .padding(.leading, 16)   // << whole section slightly right



                    // -----------------------------------------------------------------
                    // BUILDING BLOCKS TITLE
                    // -----------------------------------------------------------------
                    Text("The Building Blocks of Wellness")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .yellow.opacity(0.95), radius: 16)
                        .padding(.vertical, 2)



                    // -----------------------------------------------------------------
                    // MATRIX
                    // -----------------------------------------------------------------
                    PsychosisBuildingBlocksMatrixView(
                        selected: $selectedBlock,
                        treatments: treatments
                    )
                    .padding(.bottom, 10)



                    // -----------------------------------------------------------------
                    // NUTRITIONAL SUGGESTIONS
                    // -----------------------------------------------------------------
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
Psychosis is often linked to a combination of hyperactive dopamine receptors and inflammation in the brain.
""")

                            Text("""
Nutrition can help regulate neurotransmitters, stabilize blood sugar, reduce oxidative stress, and support cognitive clarity. Prioritize foods rich in choline, omega-3s, fermented foods, antioxidants, and minerals.
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



                    // -----------------------------------------------------------------
                    // FOOD TABLES
                    // -----------------------------------------------------------------
                    PsychosisFoodTableView()
                        .padding(.top, 4)



                    // -----------------------------------------------------------------
                    // BOTTOM NAVIGATION
                    // -----------------------------------------------------------------
                    VStack(spacing: 26) {
                        HStack {
                            Button(action: { navModel.push("TipsView") }) {
                                Circle()
                                    .fill(tealGradient)
                                    .frame(width: 54, height: 54)
                                    .overlay(
                                        Image(systemName: "arrow.left")
                                            .font(.title2)
                                            .foregroundColor(.white)
                                    )
                            }

                            Spacer()

                            Button(action: {
                                if canRetakePsychosisDiagnostic() {
                                    navModel.push("PsychosisDiagnosticView")
                                } else {
                                    navModel.push("PsychosisResultView")
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
                                    .overlay(
                                        Image(systemName: "house.fill")
                                            .font(.title2)
                                            .foregroundColor(.white)
                                    )
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
