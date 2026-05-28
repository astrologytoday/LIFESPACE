//
//  LifestyleSurveyLoadingView.swift
//  LIFESPACE
//
//  Created by Mario Sbardella on 2025-12-26.
//


import SwiftUI

struct LifestyleSurveyLoadingView: View {
    let questionCount: Int

    @EnvironmentObject var navModel: NavigationModel
    @State private var rotation: Double = 0

    var body: some View {
        ZStack {
            // Background (same as LoadingView)
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

            VStack(spacing: 40) {
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.85), lineWidth: 2)
                        .frame(width: 180, height: 180)

                    Image("brain_circle_icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 110, height: 110)

                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [Color.white.opacity(0.9), Color.white.opacity(0)]),
                                center: .center,
                                startRadius: 0,
                                endRadius: 14
                            )
                        )
                        .frame(width: 28, height: 28)
                        .offset(y: -90)
                        .rotationEffect(.degrees(rotation))
                        .blur(radius: 0.6)
                        .shadow(color: .white.opacity(0.9), radius: 10)
                }

                Text("Answer each question based on the last 24 hours unless specified otherwise.")
                    .font(Font.custom("Avenir", size: 18))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 22)
            }
        }
        .onAppear {
            // Animate orbit
            withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
                rotation = 360
            }

            // Navigate to the selected LifestyleSurveyQuestionView route
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                navModel.push("LifestyleSurveyQuestionView_\(questionCount)")
            }
        }
    }
}
