//
//  GutBrainView.swift
//  LIFESPACE
//
//  Created by Mario Sbardella on 2025-12-20.
//


import SwiftUI

struct GutBrainView: View {
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
                    Text("The Gut-Brain Connection")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(radius: 4)
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 10)
                        .animation(.easeInOut(duration: 0.4), value: appeared)

                    Text("Your digestion, immune system, and mood are constantly talking to each other.")
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

                        infoCard(title: "What It Means") {
                            bullet("The gut and brain communicate through nerves (especially the vagus nerve), hormones, and immune signals.")
                            bullet("Your gut microbiome (the ecosystem of bacteria and other microbes) can influence how you feel, think, and respond to stress.")
                            bullet("Digestion is not just about food. It can affect energy, sleep quality, focus, and emotional resilience.")
                        }

                        infoCard(title: "How the Gut Talks to the Brain") {
                            bullet("Nerve signaling: The vagus nerve is like a two-way highway between your gut and brain.")
                            bullet("Neurochemistry: Gut microbes can influence neurotransmitter activity, including serotonin and GABA pathways.")
                            bullet("Immune messaging: Inflammation can send “danger” signals that affect mood, anxiety, and fatigue.")
                            bullet("Stress response: Chronic stress can change gut motility and microbiome balance, and gut issues can also amplify stress.")
                        }

                        infoCard(title: "Gut Health Basics") {
                            bullet("Fiber: Feeds helpful gut bacteria. A “fiber win” often looks like fruits, vegetables, legumes, oats, and whole grains.")
                            bullet("Prebiotics: Certain fibers that specifically nourish good microbes (like onions, garlic, oats, bananas, and asparagus).")
                            bullet("Probiotics: Helpful live cultures found in fermented foods like yogurt with live cultures, kefir, sauerkraut, kimchi, and miso.")
                            bullet("Fermented foods: Not magic, but they can support diversity and resilience in the gut.")
                            bullet("Hydration + movement: Both support regular digestion and gut comfort.")
                        }

                        infoCard(title: "What a “Happy Gut” Often Looks Like") {
                            bullet("Comfortable digestion most days (not perfect, but generally stable).")
                            bullet("Regular bowel movements without straining, urgency, or frequent surprises.")
                            bullet("Less bloating after meals and fewer random stomach flare-ups.")
                            bullet("Steadier energy and fewer intense cravings from blood sugar swings.")
                            bullet("Better stress tolerance and fewer mood crashes after eating.")
                            smallNote("If you have persistent pain, blood in stool, rapid weight loss, or symptoms that keep worsening, it’s worth getting medical support.")
                        }

                        infoCard(title: "Inflammation and Food") {
                            bullet("Ultra-processed foods can push inflammation upward for some people, especially when they dominate the diet.")
                            bullet("Added sugar and refined carbs can spike and crash blood sugar, which can feel like irritability, brain fog, or low energy.")
                            bullet("Fats matter: Many diets are heavy in omega-6 fats. You do not need to fear them, but balance helps.")
                            bullet("Anti-inflammatory patterns are usually consistent, not extreme: more whole foods, more plants, more quality protein, and fewer “food-like products.”")
                        }

                        infoCard(title: "Omega-6 Balance (Without Being Dogmatic)") {
                            bullet("Omega-6 fats are not “bad.” They are essential, but modern diets often have a lot of them.")
                            bullet("The practical goal is balance: include omega-3 sources while limiting fried and heavily processed oils.")
                            bullet("Omega-3 sources often include fatty fish, chia seeds, flax, walnuts, and omega-3 enriched eggs.")
                            smallNote("If you are allergic to any of these, skip them. Balance is a direction, not a rule.")
                        }

                        infoCard(title: "Simple Anti-Inflammatory Habits") {
                            bullet("Build meals around whole foods more often than not.")
                            bullet("Aim for color: different plant colors support different nutrients and polyphenols.")
                            bullet("Prioritize protein + fiber: helps stabilize blood sugar and cravings.")
                            bullet("Include fermented foods if you tolerate them.")
                            bullet("Sleep and stress matter: gut health is lifestyle, not just ingredients.")
                        }

                        infoCard(title: "7-Day Gut-Brain Reset (Low Pressure)") {
                            bullet("Add one fiber-forward food per day (berries, oats, beans, or a big veggie side).")
                            bullet("Try one fermented food 3 times this week if it agrees with you.")
                            bullet("Swap one ultra-processed snack for a whole-food snack (fruit, yogurt, nuts, or a homemade option).")
                            bullet("Get 10 minutes of movement after one meal each day.")
                            bullet("Do a 2-minute downshift at night (slow breathing, gentle stretch, or quiet music).")
                            smallNote("If any change makes you feel worse, scale it back. Your body is the feedback system.")
                        }

                        infoCard(title: "A Quick Reality Check") {
                            bullet("Food is powerful, but it is not the only lever. Stress, sleep, relationships, and movement all shape your gut-brain axis.")
                            bullet("You do not need a perfect diet. Consistency beats intensity.")
                            bullet("If you are dealing with severe digestive symptoms, it is okay to get help. You do not have to figure it out alone.")
                        }

                        Spacer(minLength: 10)
                    }
                    .padding(16)
                }
                .background(Color.white.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
                .padding(.horizontal, 14)

                // Bottom buttons (match your standard)
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
        .onAppear {
            appeared = true
        }
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
