import SwiftUI

// MARK: - Symptoms Arrays

let anxietySymptomsLeft = [
    "Rapid heartbeat or palpitations",
    "Sweating or feeling overheated",
    "Restlessness",
    "Racing thoughts"
]

let anxietySymptomsRight = [
    "Fear of losing control",
    "Hypervigilance",
    "Difficulty concentrating",
    "Feeling disconnected from reality or self"
]

// -----------------------------------------------------------------------------
// MARK: - AnxietyTipsView (FULL VERSION)
// -----------------------------------------------------------------------------
struct AnxietyTipsView: View {
    @EnvironmentObject var navModel: NavigationModel

    // ✅ Diagnostic gate timestamp
    @AppStorage("AnxietyDiagnostic_lastResultTimestamp")
    private var lastResultTimestamp: Double = 0

    @State private var selectedBlock: Int? = nil
    @State private var resetPressed = false

    // Building blocks of wellness for Anxiety
    let treatments: [(title: String, message: String)] = [
        ("Light Therapy",            "Stabilizes energy levels and mood"),
        ("Meditation/Yoga",          "Reduces amygdala activity"),
        ("Fitness Training",         "Grounds excess energy"),
        ("Orthomolecular Diet",      "Reduce nervous system hyperactivity"),
        ("Vibrational Audio Therapy","Calms and centers attention"),
        ("Occupational Therapy",     "Encourages self-efficacy"),
        ("Recreational Therapy",     "Distracts from anxiety loops"),
        ("Sleep Optimization",       "Regulates cortisol"),
        ("Judgment-Free Community",  "Provides safety to explore triggers"),
        ("Art & Music Therapy",      "Somatic regulation and emotional release")
    ]

    // -------------------------------------------------------------------------
    // MARK: - Diagnostic Gate Logic
    // -------------------------------------------------------------------------
    private func canRetakeAnxietyDiagnostic() -> Bool {
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
                    // MAIN TITLE
                    // -----------------------------------------------------------------
                    Text("Anxiety Tips")
                        .font(.system(size: 38, weight: .heavy))
                        .underline()
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.80), radius: 7, x: 0, y: 6)
                        .shadow(color: .teal.opacity(0.6), radius: 18)
                        .shadow(color: .white.opacity(0.30), radius: 5, y: 1)
                        .padding(.top, 34)
                        .frame(maxWidth: .infinity)

                    // -----------------------------------------------------------------
                    // WHAT IS GAD?
                    // -----------------------------------------------------------------
                    VStack(alignment: .leading, spacing: 18) {

                        Text("What is Generalized Anxiety Disorder?")
                            .font(.system(size: 28, weight: .bold))
                            .padding(.horizontal, 8)
                            .foregroundColor(.white)

                        Text("""
Generalized Anxiety Disorder (GAD) is a condition where anxiety becomes persistent, excessive, and difficult to control. People with GAD often feel chronically tense, hyperaware, and unable to relax. This heightened state of alert can interfere with sleep, focus, decision-making, and the ability to feel grounded in daily experiences.
""")
                        .font(.system(size: 17))
                        .foregroundColor(.white)
                        .padding(20)
                        .background(.white.opacity(0.12))
                        .cornerRadius(16)
                        .frame(maxWidth: 420)
                        .multilineTextAlignment(.leading)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 16)

                    // -----------------------------------------------------------------
                    // SIGNS & SYMPTOMS SECTION
                    // -----------------------------------------------------------------
                    VStack(alignment: .leading, spacing: 12) {

                        Text("Signs & Symptoms")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                            .padding(.leading, 8)

                        HStack(alignment: .top, spacing: 20) {

                            VStack(alignment: .leading, spacing: 16) {
                                ForEach(anxietySymptomsLeft, id: \.self, content: bulletRow)
                            }
                            .padding(16)
                            .background(.white.opacity(0.12))
                            .cornerRadius(16)

                            VStack(alignment: .leading, spacing: 16) {
                                ForEach(anxietySymptomsRight, id: \.self, content: bulletRow)
                            }
                            .padding(16)
                            .background(.white.opacity(0.12))
                            .cornerRadius(16)
                            .padding(.trailing, 8)
                        }
                        .padding(.top, 6)
                        .padding(.horizontal, 10)

                        // -------------------------------------------------------------
                        // RESET + 25 TIPS BUTTONS
                        // -------------------------------------------------------------
                        HStack(spacing: 40) {

                            Button {
                                resetPressed = true
                                withAnimation(.easeInOut(duration: 0.10)) {}
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
                                    navModel.push("AnxietyResetView")
                                    resetPressed = false
                                }
                            } label: {
                                Image(resetPressed ? "cognitive-reset-pushed" : "cognitive-reset")
                                    .resizable()
                                    .frame(width: 122, height: 122)
                                    .shadow(color: .red.opacity(0.38), radius: 14, y: 5)
                            }
                            .scaleEffect(resetPressed ? 0.94 : 1.0)

                            Button {
                                navModel.push("AnxietyTwentyFiveView")
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
                    .padding(.leading, 16)

                    // -----------------------------------------------------------------
                    // BUILDING BLOCKS TITLE
                    // -----------------------------------------------------------------
                    Text("The Building Blocks of Wellness")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .yellow.opacity(0.95), radius: 16)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 2)

                    // -----------------------------------------------------------------
                    // MATRIX VIEW
                    // -----------------------------------------------------------------
                    AnxietyBuildingBlocksMatrixView(
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
For anxiety, nutrition plays a powerful role in calming the body and stabilizing mood. Focus on foods rich in magnesium, B-vitamins, omega-3 fatty acids, and zinc. These nutrients help regulate stress hormones, support neurotransmitter balance, and reduce nervous system hyperactivity.
""")

                            Text("""
Reduce sugar, ultra-processed foods, caffeine, and alcohol whenever possible, as they can worsen cortisol spikes, increase jitteriness, and intensify anxiety symptoms.
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
                    AnxietyFoodTableView()
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

                            // ✅ DIAGNOSTIC GATED BUTTON
                            Button(action: {
                                if canRetakeAnxietyDiagnostic() {
                                    navModel.push("AnxietyDiagnosticView")
                                } else {
                                    navModel.push("AnxietyResultView")
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

    // -------------------------------------------------------------------------
    // MARK: - Bullet point row
    // -------------------------------------------------------------------------
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
