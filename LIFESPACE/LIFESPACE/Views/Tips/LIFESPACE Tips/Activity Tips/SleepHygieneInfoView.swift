//
//  SleepHygieneInfoView.swift
//  LIFESPACE
//
//  Created by Mario Sbardella on 2026-04-24.
//


//
//  SleepHygieneInfoView.swift
//  LIFESPACE
//

import SwiftUI

struct SleepHygieneInfoView: View {
    @EnvironmentObject var navModel: NavigationModel

    @State private var appeared = false

    var body: some View {
        ZStack(alignment: .topLeading) {

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

            VStack(spacing: 22) {

                HStack {
                    Button(action: { navModel.pop() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.black.opacity(0.22))
                            .clipShape(Circle())
                    }

                    Spacer()
                }
                .padding(.horizontal, 18)
                .padding(.top, 14)

                VStack(spacing: 8) {
                    Text("Sleep Hygiene")
                        .font(.system(size: 38, weight: .heavy))
                        .foregroundColor(.white)
                        .shadow(radius: 4)

                    Text("Training your body to rest, recover, and reset.")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : -10)
                .animation(.easeInOut(duration: 0.4), value: appeared)

                VStack(spacing: 18) {

                    Image(systemName: "moon.stars.fill")
                        .font(.system(size: 58, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(radius: 8)
                        .padding(.top, 6)

                    Text("What Is Sleep Hygiene?")
                        .font(.system(size: 24, weight: .heavy))
                        .foregroundColor(.white)

                    Text("Sleep hygiene means creating habits, routines, and an environment that help your body fall asleep more easily and stay asleep through the night.")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white.opacity(0.94))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)

                    VStack(alignment: .leading, spacing: 12) {
                        SleepInfoBullet(text: "Go to bed and wake up at consistent times")
                        SleepInfoBullet(text: "Keep your bedroom cool, dark, and quiet")
                        SleepInfoBullet(text: "Avoid screens, caffeine, nicotine, and heavy meals too close to bed")
                        SleepInfoBullet(text: "Use your bed mainly for sleep so your brain associates it with rest")
                    }
                    .padding(.top, 4)

                    Text("The goal is simple: teach your nervous system that nighttime is for recovery.")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white.opacity(0.92))
                        .multilineTextAlignment(.center)
                        .padding(.top, 4)
                }
                .padding(22)
                .background(
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Color.black.opacity(0.22))
                        .overlay(
                            RoundedRectangle(cornerRadius: 28)
                                .stroke(Color.white.opacity(0.18), lineWidth: 1)
                        )
                )
                .shadow(radius: 16)
                .padding(.horizontal, 20)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 14)
                .animation(.easeInOut(duration: 0.5).delay(0.08), value: appeared)

                Spacer()
            }
        }
        .onAppear {
            appeared = true
        }
    }
}

private struct SleepInfoBullet: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color(red: 0.72, green: 0.95, blue: 0.86))
                .padding(.top, 1)

            Text(text)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}