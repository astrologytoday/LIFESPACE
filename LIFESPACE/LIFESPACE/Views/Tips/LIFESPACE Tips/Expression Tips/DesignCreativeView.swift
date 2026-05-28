//
//  DesignCreativeView.swift
//  LIFESPACE
//
//  Created by Mario Sbardella on 2025-12-23.
//


//
//  DesignCreativeView.swift
//  LIFESPACE
//
//  Created by Mario Sbardella on 2025-12-23.
//

import SwiftUI

struct DesignCreativeView: View {
    @EnvironmentObject var navModel: NavigationModel

    @State private var isVisible = false

    private var lifescapeButtonGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.85, green: 1.0, blue: 0.9),
                Color(red: 0.4, green: 0.9, blue: 0.8)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private func topIconButton(systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Circle()
                .fill(lifescapeButtonGradient)
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: systemName)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                )
        }
        .buttonStyle(.plain)
    }

    private func bigLinkButton(systemName: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: systemName)
                    .font(.system(size: 24, weight: .heavy))
                    .foregroundColor(.black)
                    .frame(width: 34)

                Text(title)
                    .font(Font.custom("Avenir-Heavy", size: 18))
                    .foregroundColor(.black)

                Spacer()
            }
            .padding(.vertical, 18)
            .padding(.horizontal, 18)
            .frame(maxWidth: .infinity)
            .background(lifescapeButtonGradient)
            .cornerRadius(24)
            .shadow(color: .black.opacity(0.18), radius: 10, x: 0, y: 6)
        }
        .buttonStyle(.plain)
    }

    var body: some View {
        ZStack {
            // 🌊 Teal Gradient Background
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

            VStack(spacing: 16) {

                // ✅ Back only
                HStack {
                    topIconButton(systemName: "chevron.left") {
                        fadeOutThen { navModel.pop() }
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 10)

                // ✅ Prompts card
                VStack(alignment: .leading, spacing: 14) {
                    Text("Creative Design Prompts")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.bottom, 2)

                    VStack(alignment: .leading, spacing: 14) {
                        tipRow("Build mood boards for colors, shapes, or feelings.")
                        tipRow("Study patterns in nature for design inspiration.")
                        tipRow("Try mini challenges like designing a logo in 3 minutes.")
                        tipRow("Create within limitations: only two colors, or one shape family.")
                        tipRow("Make three variations of the same idea to push creativity.")
                    }
                }
                .padding(18)
                .background(
                    RoundedRectangle(cornerRadius: 26)
                        .fill(Color.white.opacity(0.12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 26)
                                .stroke(Color.white.opacity(0.20), lineWidth: 1.2)
                        )
                        .shadow(color: .black.opacity(0.18), radius: 12, x: 0, y: 8)
                )
                .padding(.horizontal)
                .padding(.top, 28)

                // ✅ Single big link button
                VStack(spacing: 14) {
                    bigLinkButton(systemName: "square.grid.2x2.fill", title: "Create Mood Board") {
                        navModel.push("MoodBoardView")
                    }
                }
                .padding(.horizontal, 26)
                .padding(.top, 6)

                Spacer()
            }
            .opacity(isVisible ? 1 : 0)
            .animation(.easeInOut(duration: 0.6), value: isVisible)
            .onAppear { withAnimation { isVisible = true } }
        }
    }

    private func tipRow(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(Color.white.opacity(0.95))
                .frame(width: 9, height: 9)
                .padding(.top, 7)

            Text(text)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func fadeOutThen(_ action: @escaping () -> Void) {
        withAnimation(.easeInOut(duration: 0.5)) { isVisible = false }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { action() }
    }
}
