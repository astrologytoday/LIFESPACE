//
//  NewYearView.swift
//  LIFESPACE
//
//  Created by Mario Sbardella on 2025-12-24.
//

import SwiftUI

struct NewYearView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var lifespaceLogModel: LifespaceLogModel

    @State private var pulse = false

    private var currentYear: Int { Calendar.current.component(.year, from: Date()) }
    private var previousYear: Int { currentYear - 1 }

    private let darkTeal = Color(red: 0.05, green: 0.35, blue: 0.38)
    private let gold = Color(red: 0.95, green: 0.80, blue: 0.25)

    private let letters = Array("LIFESPACE")
    private let tails: [String] = [
        "ight",
        "nner Work",
        "itness",
        "ating Healthy",
        "ensory Health",
        "urpose",
        "ctivity",
        "ommunity",
        "xpression"
    ]

    private let modules: [LifespaceModule] = [
        .light, .innerWork, .fitness, .eating, .sensory, .purpose, .activity, .community, .expression
    ]

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.05, green: 0.40, blue: 0.45),
                    Color(red: 0.10, green: 0.60, blue: 0.58),
                    Color(red: 0.35, green: 0.85, blue: 0.80)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            FireworksView()
                .opacity(0.85)
                .ignoresSafeArea()

            VStack(spacing: 18) {

                Text("A New Year Means A New You")
                    .font(.system(size: 30, weight: .heavy))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .shadow(radius: 10)
                    .padding(.horizontal, 18)
                    .padding(.top, 20)

                VStack(spacing: 10) {
                    ForEach(modules.indices, id: \.self) { i in
                        acrosticRow(index: i)
                    }
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 16)
                .background(Color.white.opacity(0.14))
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.white.opacity(0.18), lineWidth: 1)
                )
                .padding(.horizontal, 16)

                let overall = overallScoreForPreviousYear()
                Text("\(String(previousYear)) LIFESPACE Score = \(Int(overall.rounded()))%")
                    .font(.system(size: 24, weight: .heavy))
                    .foregroundColor(.white)
                    .shadow(radius: 10)
                    .padding(.top, 8)

                Spacer()

                HStack {
                    Spacer()
                    Button {
                        navModel.push("FinalWordView")
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(darkTeal)
                            .padding(18)
                            .background(Color.white.opacity(0.95))
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 4)
                    }
                }
                .padding(.horizontal, 22)
                .padding(.bottom, 26)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.1).repeatForever(autoreverses: true)) {
                pulse = true
            }
        }
    }

    private func acrosticRow(index i: Int) -> some View {
        let module = modules[i]
        let score = moduleScoreForPreviousYear(module)
        let letter = String(letters[i])
        let tail = tails[i]

        return HStack(spacing: 12) {
            Text(letter)
                .font(.system(size: 30, weight: .heavy, design: .rounded))
                .foregroundColor(.white)
                .frame(width: 40, alignment: .leading)
                .scaleEffect(pulse ? 1.06 : 0.96)

            Text(tail)
                .font(.custom("Avenir", size: 18))
                .foregroundColor(.white.opacity(0.92))
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("= \(Int(score.rounded()))%")
                .font(.system(size: 18, weight: .heavy))
                .foregroundColor(gold)
                .shadow(radius: 6)
        }
    }

    private func moduleScoreForPreviousYear(_ module: LifespaceModule) -> Double {
        if let summary = lifespaceLogModel.loadYearSummary(forYear: previousYear) {
            return summary.modules[module] ?? 0
        }
        return lifespaceLogModel.yearModuleAverages(forYear: previousYear)[module] ?? 0
    }

    private func overallScoreForPreviousYear() -> Double {
        if let summary = lifespaceLogModel.loadYearSummary(forYear: previousYear) {
            return summary.overall
        }
        return lifespaceLogModel.yearOverallScore(forYear: previousYear)
    }
}

fileprivate struct FireworkParticle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var velocity: CGVector
    var color: Color
    var size: CGFloat
    var life: Double
    var maxLife: Double
}

