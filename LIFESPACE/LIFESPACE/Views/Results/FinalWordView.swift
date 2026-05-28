//
//  FinalWordView.swift
//  LIFESPACE
//
//  Created by Mario Sbardella on 2025-12-24.
//


import SwiftUI

struct FinalWordView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var lifespaceLogModel: LifespaceLogModel

    @AppStorage("newYearFlow_lastShownYear") private var newYearFlowLastShownYear: Int = 0

    @State private var showText = false

    private var currentYear: Int { Calendar.current.component(.year, from: Date()) }
    private var previousYear: Int { currentYear - 1 }

    private let darkTeal = Color(red: 0.05, green: 0.35, blue: 0.38)

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.05, green: 0.34, blue: 0.38),
                    Color(red: 0.15, green: 0.60, blue: 0.58),
                    Color(red: 0.35, green: 0.85, blue: 0.80)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack {
                Spacer()

                Text(messageText())
                    .font(.system(size: 34, weight: .heavy))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .opacity(showText ? 1 : 0)
                    .animation(.easeInOut(duration: 2.2), value: showText)

                Spacer()
            }
        }
        .onAppear {
            showText = true

            // ✅ Mark that the flow was completed for this year, so HomeView behaves normally after this.
            newYearFlowLastShownYear = currentYear

            let delay = messageDurationSeconds()
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    navModel.selectedScreen = "HomeView"
                }
            }
        }
    }

    private func previousYearOverall() -> Double {
        if let summary = lifespaceLogModel.loadYearSummary(forYear: previousYear) {
            return summary.overall
        }
        return lifespaceLogModel.yearOverallScore(forYear: previousYear)
    }

    private func messageText() -> String {
        let overall = previousYearOverall()
        if overall >= 65 {
            return "Your LIFESPACE is looking great."
        } else {
            return "Keep working hard at your LIFESPACE.\n\nGreat things are still to come."
        }
    }

    private func messageDurationSeconds() -> Double {
        let overall = previousYearOverall()
        return overall >= 65 ? 7.0 : 10.0
    }
}
