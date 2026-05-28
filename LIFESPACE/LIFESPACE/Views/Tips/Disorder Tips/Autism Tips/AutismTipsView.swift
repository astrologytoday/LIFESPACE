import SwiftUI

// MARK: - Symptom text

let autismSymptomsLeft = [
    "Sensory sensitivity (sound, light, textures)",
    "Social fatigue or overwhelm",
    "Challenges with conversational reciprocity"
]

let autismSymptomsRight = [
    "Difficulty interpreting social cues",
    "Emotional overload, shutdowns, or meltdowns",
    "Preference for predictable environments"
]

// MARK: - View

struct AutismTipsView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var selectedBlock: Int? = nil
    @State private var resetPressed = false
    @AppStorage("AutismDiagnostic_lastResultTimestamp")
    private var lastResultTimestamp: Double = 0


    let treatments: [(title: String, message: String)] = [
        (
            "Light Therapy",
            "Restores routine and energy balance"
        ),
        (
            "Meditation/Yoga",
            "Improves eye-contact and awareness"
        ),
        (
            "Fitness Training",
            "Supports balance and confidence"
        ),
        (
            "Orthomolecular Diet",
            "Improves gut-brain health"
        ),
        (
            "Vibrational Audio Therapy",
            "Eases sensory overload"
        ),
        (
            "Occupational Therapy",
            "Increases autonomy and self-efficacy"
        ),
        (
            "Recreational Therapy",
            "Socialization and interest exploration"
        ),
        (
            "Sleep Optimization",
            "Prevents meltdowns and burnout"
        ),
        (
            "Judgment-Free Community",
            "Affirms identity"
        ),
        (
            "Art & Music Therapy",
            "Supports expression and emotional clarity"
        )
    ]

    private func canRetakeAutismDiagnostic() -> Bool {
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
                    Text("Autism Tips")
                        .font(.system(size: 38, weight: .heavy))
                        .underline()
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.80), radius: 7, y: 6)
                        .shadow(color: .teal.opacity(0.6), radius: 18)
                        .shadow(color: .white.opacity(0.3), radius: 5, y: 1)
                        .padding(.top, 34)
                        .frame(maxWidth: .infinity)

                    // WHAT IS ASD?
                    
                    VStack(alignment: .leading, spacing: 18) {

                        Text("What is Autism Spectrum Disorder?")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.leading, 16)
                        
                        Text("""
Autism Spectrum Disorder (ASD) is a neurodevelopmental disorder affecting how someone processes sensory input, communicates, and relates to the world. Autistic people may experience heightened or reduced sensitivity to sound, light, touch, and social cues, as well as unique communication styles, focused interests, and different patterns of movement or expression.
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

                    // SIGNS & SYMPTOMS
                    VStack(alignment: .leading, spacing: 12) {

                        Text("Signs & Symptoms")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                            .padding(.leading, 24)

                        HStack(alignment: .top, spacing: 20) {

                            VStack(alignment: .leading, spacing: 16) {
                                ForEach(autismSymptomsLeft, id: \.self, content: bulletRow)
                            }
                            .padding(16)
                            .background(.white.opacity(0.12))
                            .cornerRadius(16)
                            .padding(.leading, 16)

                            VStack(alignment: .leading, spacing: 16) {
                                ForEach(autismSymptomsRight, id: \.self, content: bulletRow)
                            }
                            .padding(16)
                            .background(.white.opacity(0.12))
                            .cornerRadius(16)
                            .padding(.trailing, 16)
                        }
                        .padding(.top, 6)

                        // COGNITIVE RESET + 25 TIPS (centered)
                        HStack(spacing: 40) {
                            Button {
                                resetPressed = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
                                    navModel.push("AutismResetView")
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
                                navModel.push("AutismTwentyFiveView")
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
                    AutismBuildingBlocksMatrixView(selected: $selectedBlock, treatments: treatments)
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
A specialized diet can reduce sensory overload, stabilize mood, and support overall regulation. Patterns in sensitivity reflect low levels or imbalances of inhibitory neurotransmitters in the brain, especially GABA, which helps calm and filter sensory input.
""")

                            Text("""
Nutritionally, foods that support GABA-related pathways include balanced meals with quality protein, magnesium-rich vegetables, healthy fats, and fermented or whole foods that support gut-brain communication. 
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
                    AutismFoodTableView()
                        .padding(.top, 4)

                    // BOTTOM NAVIGATION
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
                                if canRetakeAutismDiagnostic() {
                                    navModel.push("AutismDiagnosticView")
                                } else {
                                    navModel.push("AutismResultView")
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
