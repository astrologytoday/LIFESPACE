//
//  CircadianRhythmView.swift
//  LIFESPACE
//
//  Created by Mario Sbardella on 2025-12-20.
//


import SwiftUI

struct CircadianRhythmView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var appeared = false

    var body: some View {
        ZStack(alignment: .topLeading) {

            // 🌊 LIFESPACE gradient background
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

            VStack(spacing: 18) {

                // Header
                VStack(alignment: .leading, spacing: 10) {
                    Text("Circadian Rhythm")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(radius: 4)
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 10)
                        .animation(.easeInOut(duration: 0.4), value: appeared)

                    Text("Timing is biology. Your brain and metabolism run on a daily rhythm.")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white.opacity(0.9))
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 10)
                        .animation(.easeInOut(duration: 0.4).delay(0.08), value: appeared)
                }
                .padding(.top, 28)
                .padding(.horizontal, 18)

                // Scrollable content container
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 16) {

                        infoCard(title: "What Is a Circadian Rhythm?") {
                            bullet("Your circadian rhythm is your internal 24-hour clock that helps coordinate sleep, energy, hormones, digestion, and body temperature.")
                            bullet("Light in the morning helps “set” this clock, but meal timing also acts like a daily signal for your metabolism.")
                            bullet("When your sleep schedule and eating schedule are consistent, your body becomes more predictable: steadier energy, better digestion, and smoother mood regulation.")
                        }

                        infoCard(title: "Correct Times to Eat") {
                            bullet("Breakfast: 5:00AM–9:00AM")
                            bullet("Lunch: 11:00AM–2:00PM")
                            bullet("Dinner: 5:00PM–7:00PM")
                            smallNote("If your life schedule is different, aim to keep the same pattern: earlier meals, a consistent routine, and not eating heavy right before sleep.")
                        }

                        infoCard(title: "Why Eat at the Correct Times?") {
                            bullet("Hormones follow a rhythm: cortisol is naturally higher in the morning, and melatonin rises at night. Eating out-of-sync can blur these signals.")
                            bullet("Better blood sugar control: your body usually handles carbohydrates more efficiently earlier in the day than late at night.")
                            bullet("Improved digestion: gut motility and digestive enzyme activity tend to be stronger earlier in the day.")
                            bullet("Sleep quality: heavy late meals can raise body temperature and disrupt deeper sleep, which affects mood, focus, and recovery.")
                            bullet("Neurotransmitter stability: stable blood sugar and consistent nutrient timing can reduce crashes that feel like anxiety, irritability, or brain fog.")
                        }

                        infoCard(title: "What Happens When Timing Is Random?") {
                            bullet("More cravings and snacking because the body can’t predict when fuel is coming.")
                            bullet("Bigger energy swings: spikes and crashes can feel emotional, not just physical.")
                            bullet("More inflammation signaling in some people, especially with late-night ultra-processed eating.")
                            bullet("Harder sleep onset and lighter sleep, which makes the next day’s cravings and stress sensitivity worse.")
                        }

                        infoCard(title: "A Simple Way to Start") {
                            bullet("Pick a consistent breakfast time, even if the meal is small.")
                            bullet("Eat lunch in a predictable window instead of grazing all afternoon.")
                            bullet("Keep dinner earlier and lighter when possible.")
                            bullet("If you miss a meal, don’t punish yourself. Just return to your next planned time window.")
                        }

                        infoCard(title: "LIFESPACE Timing Tip") {
                            bullet("Think of meal timing like light exposure: consistency trains the system.")
                            bullet("If you want a strong brain optimization score, build a strong rhythm first.")
                            smallNote("Small daily consistency beats rare perfect days.")
                        }

                        Spacer(minLength: 10)
                    }
                    .padding(16)
                }
                .background(Color.white.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
                .padding(.horizontal, 14)

                // Bottom buttons
                HStack(spacing: 40) {
                    Button {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            navModel.pop()
                        }
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }

                    Button {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            navModel.selectedScreen = "HomeView"
                        }
                    } label: {
                        Image(systemName: "house.fill")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                }
                .padding(.bottom, 22)
            }
        }
        .onAppear { appeared = true }
        .transition(.opacity)
    }

    // MARK: - Components

    private func infoCard(title: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)

            content()
        }
        .padding(16)
        .background(Color.white.opacity(0.14))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(radius: 4)
    }

    private func bullet(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Text("•")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white.opacity(0.95))
                .padding(.top, 1)

            Text(text)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white.opacity(0.92))
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func smallNote(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(.white.opacity(0.78))
            .padding(.top, 2)
    }
}
