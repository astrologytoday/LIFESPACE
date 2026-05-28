//
//  DailyGoalView.swift
//  LIFESPACE
//
//  Created by Mario Sbardella on 2025-12-24.
//

import SwiftUI
import UIKit

struct DailyGoalView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var lifespaceLogModel: LifespaceLogModel

    private func lowestThreeModules() -> [LifespaceModule] {
        let sorted = LifespaceModule.allCases.sorted {
            lifespaceLogModel.score(for: $0) < lifespaceLogModel.score(for: $1)
        }
        return Array(sorted.prefix(3))
    }

    private func atRiskDisorders() -> [LifespaceDisorder] {
        let pairs: [(LifespaceDisorder, String)] = [
            (.anxiety, "AnxietyDiagnostic_lastResultRisk"),
            (.depression, "DepressionDiagnostic_lastResultRisk"),
            (.pssd, "PSSDDiagnostic_lastResultRisk"),
            (.adhd, "ADHDDiagnostic_lastResultRisk"),
            (.autism, "AutismDiagnostic_lastResultRisk"),
            (.bpd, "BPDDiagnostic_lastResultRisk"),
            (.psychosis, "PsychosisDiagnostic_lastResultRisk"),
            (.cptsd, "CPTSDDiagnostic_lastResultRisk")
        ]

        let risks = Set(["Moderate Risk", "High Risk"])

        return pairs.compactMap { disorder, key in
            let value = UserDefaults.standard.string(forKey: key) ?? ""
            return risks.contains(value) ? disorder : nil
        }
    }

    private func todayKey() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Calendar.current.startOfDay(for: Date()))
    }

    @AppStorage("DailyGoal_lastShownDate") private var lastShownDate: String = ""
    @AppStorage("DailyGoal_lastTipID") private var lastTipID: String = ""

    @State private var tip: DailyGoalTip? = nil
    @State private var appeared = false
    @State private var pulseTitle = false

    // MARK: - Inline links (yoga / prayer / candle gazing)

    private func linkedBody(_ text: String) -> AttributedString {
        let base = NSMutableAttributedString(string: text)

        let linkSpecs: [(pattern: String, url: URL)] = [
            (#"\bcandle\s+gazing\b"#, URL(string: "lifespace://candlework")!),
            (#"\byoga\b"#, URL(string: "lifespace://yoga")!),
            (#"\bprayer\b"#, URL(string: "lifespace://prayer")!),
            (#"\bcognitive\s+reset\s+button\b"#, URL(string: "lifespace://depressionreset")!),
            (#"\bplan\s+your\s+day\b"#, URL(string: "lifespace://dayplanner")!),
            (#"\byour\s+own\s+recipe\b"#, URL(string: "lifespace://myrecipes")!),
            (#"\bsleep\s+hygiene\s+checklist\b"#, URL(string: "lifespace://sleephygiene")!),
            (#"\bshadow\s+work\b"#, URL(string: "lifespace://shadowwork")!),
            (#"\bhere\b"#, URL(string: "lifespace://communitytips")!),
            (#"\bmeal\s+planner\b"#, URL(string: "lifespace://mealplanner")!),
            (#"\bsupplements?\b"#, URL(string: "https://hypnoaminos.com/products/subscription-5-htp-positive-mind-50-mg-120-capsules?variant=45407862423852")!)
        ]

        for spec in linkSpecs {
            guard let regex = try? NSRegularExpression(pattern: spec.pattern, options: [.caseInsensitive]) else { continue }
            let matches = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))

            for match in matches {
                base.addAttributes(
                    [
                        .link: spec.url,
                        .underlineStyle: NSUnderlineStyle.single.rawValue
                    ],
                    range: match.range
                )
            }
        }

        return AttributedString(base)
    }

    private func handleDeepLink(_ url: URL) {
        guard url.scheme == "lifespace" else { return }

        switch url.host {
        case "candlework":
            navModel.push("CandleWorkView")
        case "yoga":
            navModel.push("YogaView")
        case "prayer":
            navModel.push("PrayerView")
        case "depressionreset":
            navModel.push("DepressionResetView")
        case "dayplanner":
            navModel.push("DayPlannerView")
        case "myrecipes":
            navModel.push("MyRecipesView")
        case "sleephygiene":
            navModel.push("SleepHygieneView")
        case "shadowwork":
            navModel.push("ShadowWorkView")
        case "communitytips":
            navModel.push("CommunityTipsView")
        case "mealplanner":
            navModel.push("MealPlannerView")
        default:
            break
        }

    }

    // MARK: - Tip picker

    private func pickTip(forceNew: Bool) {
        let today = todayKey()

        if !forceNew,
           lastShownDate == today,
           !lastTipID.isEmpty,
           let existing = dailyGoalBank.first(where: { $0.id == lastTipID }) {
            tip = existing
            return
        }

        let disorders = atRiskDisorders()
        let modules = lowestThreeModules()

        var pool = dailyGoalBank.filter { item in
            (disorders.isEmpty ? true : disorders.contains(item.disorder)) &&
            (modules.isEmpty ? true : modules.contains(item.module))
        }

        if pool.isEmpty { pool = dailyGoalBank }

        if let chosen = pool.randomElement() {
            tip = chosen
            lastShownDate = today
            lastTipID = chosen.id
        }
    }

    // MARK: - UI

    var body: some View {
        ZStack {
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

            VStack(spacing: 0) {
                Spacer().frame(height: 80)

                Text("DAILY GOAL")
                    .font(.system(size: 46, weight: .heavy))
                    .foregroundColor(.white)
                    .shadow(color: .white.opacity(0.55), radius: 10, x: 0, y: 0)
                    .shadow(color: .white.opacity(0.25), radius: 18, x: 0, y: 0)
                    .shadow(color: .black.opacity(0.18), radius: 12, x: 0, y: 8)
                    .scaleEffect(pulseTitle ? 1.02 : 1.0)
                    .animation(.easeInOut(duration: 1.1).repeatForever(autoreverses: true), value: pulseTitle)

                Spacer().frame(height: 44)

                if let tip = tip {
                    VStack(alignment: .center, spacing: 14) {
                        Text(tip.title)
                            .font(.system(size: 34, weight: .heavy))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)

                        Text(linkedBody(tip.body))
                            .font(.custom("Avenir", size: 20))
                            .foregroundColor(.white.opacity(0.92))
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .environment(\.openURL, OpenURLAction { url in
                                if url.scheme == "lifespace" {
                                    handleDeepLink(url)
                                    return .handled
                                }
                                return .systemAction(url)
                            })
                    }
                    .padding(.vertical, 26)
                    .padding(.horizontal, 22)
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.12))
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.16), lineWidth: 1)
                    )
                    .padding(.horizontal, 18)
                } else {
                    Text("No daily goal available yet.")
                        .font(.custom("Avenir", size: 18))
                        .foregroundColor(.white.opacity(0.85))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 26)
                }

                Spacer().frame(height: 44)

                HStack(spacing: 16) {
                    Button {
                        navModel.pop()
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .heavy))
                            Text("My Goals")
                                .font(.system(size: 18, weight: .bold))
                        }
                        .foregroundColor(.teal)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.white)
                        .cornerRadius(18)
                    }

                    Button {
                        navModel.push("HomeView")
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "house.fill")
                                .font(.system(size: 18, weight: .heavy))
                            Text("Home")
                                .font(.system(size: 18, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.teal.opacity(0.7))
                        .cornerRadius(18)
                    }
                }
                .padding(.horizontal, 18)

                Image("lifespace_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 170)
                    .opacity(0.35)
                    .padding(.top, 74)

                Spacer()
            }
        }
        .onAppear {
            guard !appeared else { return }
            appeared = true
            pickTip(forceNew: false)
            pulseTitle = true
        }
    }
}
