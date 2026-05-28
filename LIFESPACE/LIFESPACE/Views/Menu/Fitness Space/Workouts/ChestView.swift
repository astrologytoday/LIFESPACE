import SwiftUI

struct ChestView: View {
    @EnvironmentObject var navModel: NavigationModel

    @State private var isVisible = false
    @State private var isExiting = false

    var body: some View {
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

            VStack(spacing: 30) {
                Text("Choose a Workout")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 60)

                VStack(spacing: 20) {
                    workoutButton("Push-Ups") {
                        fadeAndNavigate(to: "PushUpsView")
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
                    workoutButton("Chest Cross Raise") {
                        fadeAndNavigate(to: "ChestCrossRaiseView")
                    }
                    workoutButton("Fish Pose Matsyasana") {
                        fadeAndNavigate(to: "FishPoseMatsyasanaView")
                    }
                    workoutButton("Burpee + Jump + Push-Up") {
                        fadeAndNavigate(to: "BurpeeJumpPushUpView")
                    }
                    workoutButton("Elbow Plank") {
                        fadeAndNavigate(to: "ElbowPlankView")
                    }
                }

                Spacer()

                Button(action: {
                    fadeAndNavigate(to: "FitnessSpaceView")
                }) {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .frame(width: 30, height: 20)
                        .foregroundColor(.white)
                        .padding()
                }
                .padding(.bottom, 40)
            }
            .padding(.horizontal, 30)
            .opacity(isVisible ? 1 : 0)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isVisible = true
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



