import SwiftUI

struct SetupCompletionView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var drawCheck = false
    @State private var fadeText = false
    @State private var showContinue = false

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
                Spacer()

                // Checkmark Animation
                CheckmarkShape()
                    .trim(from: 0, to: drawCheck ? 1 : 0)
                    .stroke(Color.white, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                    .frame(width: 100, height: 100)
                    .padding(.top, 40)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1.5)) {
                            drawCheck = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation(.easeInOut(duration: 1.0)) {
                                fadeText = true
                            }
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                            withAnimation(.easeInOut(duration: 0.8)) {
                                showContinue = true
                            }
                        }
                    }

                // Fade-in confirmation
                if fadeText {
                    Text("SETUP COMPLETE!")
                        .font(Font.custom("Avenir", size: 28).weight(.bold))
                        .foregroundColor(.white)
                        .transition(.opacity)
                        .padding(.top, 10)
                }

                Spacer()

                // Continue Button
                if showContinue {
                    Button(action: {
                        navModel.selectedScreen = "HomeView"
                    }) {
                        Text("Continue")
                            .font(Font.custom("Avenir", size: 18).weight(.medium))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                    .padding(.bottom, 60)
                    .transition(.opacity)
                }
            }
        }
    }
}

// MARK: - Checkmark Shape
struct CheckmarkShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let start = CGPoint(x: rect.width * 0.15, y: rect.height * 0.5)
        let mid = CGPoint(x: rect.width * 0.4, y: rect.height * 0.75)
        let end = CGPoint(x: rect.width * 0.85, y: rect.height * 0.25)

        path.move(to: start)
        path.addLine(to: mid)
        path.addLine(to: end)

        return path
    }
}
