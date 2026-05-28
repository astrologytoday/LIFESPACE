import SwiftUI

struct ForearmsView: View {
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
                    workoutButton("Wrist Push-Ups") {
                        fadeAndNavigate(to: "WristPushUpView")
                    }
                    workoutButton("Rotated Wrist Curls") {
                        fadeAndNavigate(to: "RotatedWristCurlsView")
                    }
                    workoutButton("Neutral Wrist Curls") {
                        fadeAndNavigate(to: "NeutralWristCurlsView")
                    }
                    workoutButton("Forearm Rotations") {
                        fadeAndNavigate(to: "ForearmRotationView")
                    }
                    workoutButton("Reverse Wrist Curls") {
                        fadeAndNavigate(to: "ReverseWristCurlsView")
                    }
                    workoutButton("Hammer Wrist Curls") {
                        fadeAndNavigate(to: "HammerWristCurlsView")
                    }
                    workoutButton("Bent-Over Curls") {
                        fadeAndNavigate(to: "BentOverCurlsView")
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



