import SwiftUI

// MARK: - Shared Styles

let tealGradient = LinearGradient(
    gradient: Gradient(colors: [
        Color(red: 0.35, green: 0.80, blue: 0.75),
        Color(red: 0.20, green: 0.65, blue: 0.60),
        Color(red: 0.10, green: 0.45, blue: 0.45)
    ]),
    startPoint: .top,
    endPoint: .bottom
)

let depressionSymptomsLeft = [
    "Persistent low mood",
    "Loss of interest or\npleasure",
    "Changes in appetite",
    "Thoughts of death or suicide"
]
let depressionSymptomsRight = [
    "Fatigue or low energy",
    "Feelings of worthlessness",
    "Difficulty concentrating",
    "Sleep disturbances"
]

// MARK: - View

struct DepressionTipsView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var selectedBlock: Int? = nil
    @State private var resetPressed = false
    @AppStorage("DepressionDiagnostic_lastResultTimestamp")
    private var lastResultTimestamp: Double = 0


    let treatments: [(title: String, message: String)] = [
        ("Light Therapy", "Effective for seasonal depression"),
        ("Meditation/Yoga", "Improves emotional regulation"),
        ("Fitness Training", "Boosts endorphins and self-efficacy"),
        ("Orthomolecular Diet", "Restores serotonin and B vitamin levels"),
        ("Occupational Therapy", "Restores purpose and routine"),
        ("Recreational Therapy", "Restores play and pleasure circuits"),
        ("Sleep Optimization", "Crucial for mood regulation"),
        ("Vibrational Audio Therapy","Parasympathetic response induction"),
        ("Judgment-Free Community",  "Encourages openness and vulnerability"),
        ("Art & Music Therapy",      "Unlocks joy and trauma processing")
    ]

    private func canRetakeDepressionDiagnostic() -> Bool {
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

                    // MAIN TITLE with full 3D shadow restored
                    Text("Depression Tips")
                        .font(.system(size: 38, weight: .heavy))
                        .underline()
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.80), radius: 7, x: 0, y: 6)
                        .shadow(color: .teal.opacity(0.6), radius: 18)
                        .shadow(color: .white.opacity(0.30), radius: 5, y: 1)
                        .padding(.top, 34)
                        .frame(maxWidth: .infinity)

                    // WHAT IS MDD (equal spacing left & right)
                    VStack(alignment: .leading, spacing: 18) {
                        Text("What is Major Depressive Disorder?")
                            .font(.system(size: 28, weight: .bold))
                            .padding(.horizontal, 8)
                            .foregroundColor(.white)

                        Text("""
Major Depressive Disorder (MDD) is a mental health condition marked by persistent feelings of sadness, hopelessness, and loss of interest in activities. It affects mood, thinking, and behavior, often interfering with daily life.
""")
                            .font(.system(size: 17))
                            .foregroundColor(.white)
                            .padding(20)
                            .background(.white.opacity(0.12))
                            .cornerRadius(16)
                            .frame(maxWidth: 420)    // << EVEN WALL SPACING
                            .multilineTextAlignment(.leading)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 16)

                    // SIGNS & SYMPTOMS (shifted right to align with MDD)
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Signs & Symptoms")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                            .padding(.leading, 8)

                        HStack(alignment: .top, spacing: 20) {

                            // LEFT COLUMN BUBBLE
                            VStack(alignment: .leading, spacing: 16) {
                                ForEach(depressionSymptomsLeft, id: \.self, content: bulletRow)
                            }
                            .padding(16)
                            .background(.white.opacity(0.12))
                            .cornerRadius(16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 16)   // ← ensures equal wall spacing on the left

                            // RIGHT COLUMN BUBBLE
                            VStack(alignment: .leading, spacing: 16) {
                                ForEach(depressionSymptomsRight, id: \.self, content: bulletRow)
                            }
                            .padding(16)
                            .background(.white.opacity(0.12))
                            .cornerRadius(16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.trailing, 16)  // ← ensures equal wall spacing on the right
                        }
                        .padding(.top, 6)


                        // RESET + 25 TIPS CENTERED — with EXTRA SPACE above/below
                        HStack(spacing: 40) {
                            Button {
                                resetPressed = true
                                withAnimation(.easeInOut(duration: 0.10)) {}
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
                                    navModel.push("DepressionResetView")
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
                                navModel.push("DepressionTwentyFiveView")
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
                        .padding(.vertical, 20)   // << EXTRA SPACING ADDED
                    }
                    .padding(.leading, 16)

                    // BUILDING BLOCKS TITLE with glow restored
                    Text("The Building Blocks of Wellness")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .shadow(color: .yellow.opacity(0.95), radius: 16)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 2)

                    DepressionBuildingBlocksMatrixView(selected: $selectedBlock, treatments: treatments)
                        .padding(.bottom, 10)

                    // NUTRITIONAL SUGGESTIONS — shifted right slightly
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
                        .padding(.leading, 24)   // << SHIFTED RIGHT MORE

                        // Even left/right spacing on bubble
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Nutritional strategies for depression include increasing intake of key nutrients that support neurotransmitter function.")
                            Text("Foods high in B vitamins, omega-3 fatty acids, and magnesium are recommended.")
                        }
                        .font(.system(size: 17))
                        .foregroundColor(.white)
                        .padding(20)
                        .background(.white.opacity(0.12))
                        .cornerRadius(16)
                        .frame(maxWidth: 460)         // << centered + even walls
                        .padding(.horizontal, 20)     // << equal padding both sides
                    }

                    DepressionFoodTableView()
                        .padding(.top, 4)

                    // Bottom buttons
                    VStack(spacing: 26) {
                        HStack {
                            Button(action: { navModel.push("TipsView") }) {
                                Circle()
                                    .fill(tealGradient)
                                    .frame(width: 54, height: 54)
                                    .overlay(Image(systemName: "arrow.left").font(.title2).foregroundColor(.white))
                            }

                            Spacer()

                            Button(action: {
                                if canRetakeDepressionDiagnostic() {
                                    navModel.push("DepressionDiagnosticView")
                                } else {
                                    navModel.push("DepressionResultView")
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
                                    .overlay(Image(systemName: "house.fill").font(.title2).foregroundColor(.white))
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

    // MARK: - Components

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
