import SwiftUI

struct TricepsView: View {
    @EnvironmentObject var navModel: NavigationModel

    @State private var isVisible = false
    @State private var isExiting = false

    var body: some View {
        GeometryReader { geometry in
            let safeBottom = geometry.safeAreaInsets.bottom
            let bottomPadding = max(40, safeBottom + 18)

            ZStack {
                // LIFESPACE Teal Gradient Background
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

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 30) {
                        Text("Choose a Workout")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.top, 60)

                        VStack(spacing: 20) {
                            workoutButton("Push-Ups") {
                                fadeAndNavigate(to: "PushUpsView")
                            }
                            workoutButton("Arnold Press") {
                                fadeAndNavigate(to: "ArnoldPressView")
                            }
                            workoutButton("Complex Shoulder Raise") {
                                fadeAndNavigate(to: "ComplexShoulderRaiseView")
                            }
                            workoutButton("Burpee + Jump + Push-Up") {
                                fadeAndNavigate(to: "BurpeeJumpPushUpView")
                            }
                            workoutButton("Negative Push-Ups") {
                                fadeAndNavigate(to: "NegativePushUpsView")
                            }
                            workoutButton("Glute Bridge Chest Press") {
                                fadeAndNavigate(to: "GluteBridgeChestPressView")
                            }
                            workoutButton("Floor Squeeze Chest Press") {
                                fadeAndNavigate(to: "FloorSqueezeChestPressView")
                            }
                        }

                        Button(action: {
                            fadeAndNavigate(to: "FitnessSpaceView")
                        }) {
                            Image(systemName: "arrow.left")
                                .resizable()
                                .frame(width: 30, height: 20)
                                .foregroundColor(.white)
                                .padding()
                        }
                        .padding(.bottom, bottomPadding)
                    }
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity)
                }
                .opacity(isVisible ? 1 : 0)
                .onAppear {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        isVisible = true
                    }
                }
            }
        }
    }

    // MARK: - Reusable Button
    func workoutButton(_ title: String, action: @escaping () -> Void = {}) -> some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.15))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.25), lineWidth: 1)
                        )
                )
        }
    }

    // MARK: - Fade Out + Navigate
    private func fadeAndNavigate(to screen: String) {
        withAnimation(.easeInOut(duration: 0.5)) {
            isVisible = false
            isExiting = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            navModel.push(screen)
        }
    }
}
