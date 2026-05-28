import SwiftUI

let adhdSymptomsLeft = [
    "Restlessness, fidgeting or impulsive movement",
    "Sleep disruption and inconsistent energy levels",
    "Trouble focusing or finishing tasks"
]

let adhdSymptomsRight = [
    "Easily distracted by thoughts or environment",
    "Chronic procrastination",
    "Forgetfulness",
    "Rapid shifts in interest or mood"
]

struct ADHDTipsView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var selectedBlock: Int? = nil
    @State private var resetPressed = false
    @AppStorage("ADHDDiagnostic_lastResultTimestamp")
    private var lastResultTimestamp: Double = 0

    let treatments: [(title: String, message: String)] = [
        ("Light Therapy", "Helps regulate wakefulness"),
        ("Meditation/Yoga", "Enhances focus and reduces hyperactivity"),
        ("Fitness Training", "Improves dopamine release"),
        ("Orthomolecular Diet", "Supports focus and mood"),
        ("Vibrational Audio Therapy", "Improves sustained attention"),
        ("Occupational Therapy", "Executive functioning and organization"),
        ("Recreational Therapy", "Provides healthy stimulation"),
        ("Sleep Optimization", "Restores attention and cognitive stamina"),
        ("Judgment-Free Community", "Prevents shame and encourages motivation"),
        ("Art & Music Therapy", "Stimulates creativity and sustained focus")
    ]

    private func canRetakeADHDDiagnostic() -> Bool {
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
                    Text("ADHD Tips")
                        .font(.system(size: 38, weight: .heavy))
                        .underline()
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.80), radius: 7, y: 6)
                        .shadow(color: .teal.opacity(0.6), radius: 18)
                        .shadow(color: .white.opacity(0.3), radius: 5, y: 1)
                        .padding(.top, 34)
                        .frame(maxWidth: .infinity)

                    // WHAT IS ADHD?
                    VStack(alignment: .leading, spacing: 18) {

                        Text("What is Attention Deficit/Hyperactivity Disorder?")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.leading, 16)

                        Text("""
ADHD is a condition that affects motivation, attention, and self-regulation. It often appears when the brain’s reward and focus systems are under-supported, especially during stress, nutrient deficiency, or emotional overwhelm.
""")
                            .font(.system(size: 17))
                            .foregroundColor(.white)
                            .padding(20)
                            .background(.white.opacity(0.12))
                            .cornerRadius(16)
                            .frame(maxWidth: 420)
                            .padding(.horizontal, 20)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    // SYMPTOMS
                    VStack(alignment: .leading, spacing: 12) {

                        Text("Signs & Symptoms")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                            .padding(.leading, 24)

                        HStack(alignment: .top, spacing: 20) {

                            VStack(alignment: .leading, spacing: 16) {
                                ForEach(adhdSymptomsLeft, id: \.self, content: bulletRow)
                            }
                            .padding(16)
                            .background(.white.opacity(0.12))
                            .cornerRadius(16)
                            .padding(.leading, 16)

                            VStack(alignment: .leading, spacing: 16) {
                                ForEach(adhdSymptomsRight, id: \.self, content: bulletRow)
                            }
                            .padding(16)
                            .background(.white.opacity(0.12))
                            .cornerRadius(16)
                            .padding(.trailing, 16)
                        }
                        .padding(.top, 6)

                        // CENTERED RESET + 25 TIPS BUTTONS
                        HStack(spacing: 40) {

                            Button {
                                resetPressed = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
                                    navModel.push("ADHDResetView")
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
                                navModel.push("ADHDTwentyFiveView")
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
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 20)
                    }

                    // BUILDING BLOCKS TITLE
                    Text("The Building Blocks of Wellness")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .yellow.opacity(0.95), radius: 16)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 2)

                    // MATRIX
                    ADHDBuildingBlocksMatrixView(selected: $selectedBlock, treatments: treatments)
                        .padding(.bottom, 10)

                    // NUTRITION SUGGESTIONS
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
ADHD is a state of brain and body chemistry that affects dopamine and norepinephrine receptors. Nutrition plays a major role in supporting attention, mood, and emotional regulation. Focus on omega-3s (EPA/DHA) for cognitive clarity, protein for neurotransmitters, and minerals like zinc, iron, and magnesium for stable energy and focus.
""")

                            Text("""
A balanced, nutrient-dense diet won’t “cure” ADHD, but it provides the raw materials your nervous system needs to stay regulated, focused, and resilient under stress.
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

                    // FOOD TABLES
                    ADHDFoodTableView()
                        .padding(.top, 4)

                    // BOTTOM NAVIGATION
                    VStack(spacing: 26) {

                        HStack {
                            Button(action: {         navModel.push("TipsView") }) {
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
                                if canRetakeADHDDiagnostic() {
                                    navModel.push("ADHDDiagnosticView")
                                } else {
                                    navModel.push("ADHDResultView")
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
