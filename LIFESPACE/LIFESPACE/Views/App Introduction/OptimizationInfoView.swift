import SwiftUI

struct OptimizationInfoView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var tapCount = 0
    @State private var showText: [Bool] = Array(repeating: false, count: 7)
    @State private var pulse = false
    @State private var showArrows = false
    @AppStorage("hasSeenOptimizationInfo") private var hasSeenOptimizationInfo: Bool = false

    let bulletPoints = [
        "When is Brain Optimization most important?",
        "•  Big exams",
        "•  Job interviews",
        "•  First date",
        "•  Court date",
        "Can you think of others?"
    ]

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

            VStack(spacing: 30) {
                Spacer().frame(height: UIScreen.main.bounds.height * 0.10)

                Group {
                    Text("The LIFESPACE app will gently guide you with simple questions, personal insights, and a wellness score to help you maintain")
                        .font(Font.custom("Avenir", size: 18))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 300)

                    Text("Brain Optimization")
                        .font(Font.custom("Avenir", size: 18).weight(.bold))
                        .foregroundColor(.white)
                        .scaleEffect(pulse ? 1.15 : 1.0)
                        .shadow(color: .white.opacity(pulse ? 0.8 : 0.3), radius: pulse ? 8 : 4)
                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: pulse)
                        .onAppear { pulse = true }
                }

                ForEach(0..<bulletPoints.count, id: \.self) { index in
                    if showText[index] {
                        Text(bulletPoints[index])
                            .font(Font.custom("Avenir", size: 18))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .transition(.opacity)
                    }
                }

                Spacer()

                if showText[bulletPoints.count - 1] {
                    HStack {
                        NavArrowButton(
                            direction: .left,
                            target: "MenuTutorialView",
                            padding: EdgeInsets(top: 0, leading: 30, bottom: 30, trailing: 0)
                        )

                        Spacer()

                        NavArrowButton(
                            direction: .right,
                            target: "StartView",
                            padding: EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 30)
                        )
                    }
                    .opacity(showArrows ? 1 : 0)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.6)) {
                            showArrows = true
                        }
                    }
                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if tapCount < bulletPoints.count {
                withAnimation(.easeInOut(duration: 0.6)) {
                    showText[tapCount] = true
                }
                tapCount += 1
            }
        }
        .onAppear {
            hasSeenOptimizationInfo = true
        }
    }
}

