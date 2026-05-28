//
//  OrthomolecularView.swift
//  LIFESPACE
//
//  Created by Mario Sbardella on 2025-12-20.
//


import SwiftUI

struct OrthomolecularView: View {
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
                    Text("Orthomolecular Diet")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(radius: 4)
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 10)
                        .animation(.easeInOut(duration: 0.4), value: appeared)

                    Text("Nutrient density with intention: food as targeted brain chemistry support.")
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

                        infoCard(title: "What “Orthomolecular” Means") {
                            bullet("Orthomolecular nutrition focuses on providing the body with optimal, often high, doses of naturally occurring substances.")
                            bullet("In practice, that usually means nutrient-dense whole foods, strategic macronutrient balance, and repeating supportive foods consistently.")
                            bullet("The goal is not perfection. The goal is steady input of the raw materials your body uses to build energy, hormones, and neurotransmitters.")
                        }

                        infoCard(title: "Why LIFESPACE Meal Plans Use It") {
                            bullet("Neurotransmitters are built from amino acids, vitamins, minerals, and fatty acids.")
                            bullet("If those building blocks are missing or inconsistent, mood and focus can become more fragile, especially under stress.")
                            bullet("Orthomolecular-style meal plans aim to keep the brain supplied so your baseline is stronger, then lifestyle tools can work better on top of that.")
                        }

                        infoCard(title: "How Food Supports Neurotransmitters") {
                            bullet("Amino acids are the core starting point: tryptophan (serotonin), tyrosine (dopamine and norepinephrine), glutamine (GABA pathway support).")
                            bullet("Cofactors help convert and regulate: B vitamins, magnesium, zinc, iron, and vitamin C are common examples.")
                            bullet("Healthy fats support brain structure and signaling. Many neurotransmitter receptors sit in cell membranes, and membranes are built from fats.")
                            smallNote("This is a functional framework, not a diagnosis tool. It is about supporting the body’s chemistry, not labeling it.")
                        }

                        infoCard(title: "Targeting Neurotransmitters With Meals") {
                            bullet("Serotonin-supporting patterns often include protein plus complex carbohydrates, along with B vitamins and minerals that support conversion.")
                            bullet("Dopamine and focus-supporting patterns often emphasize tyrosine-rich proteins, stable blood sugar, and micronutrients like iron and B6.")
                            bullet("GABA and calm-supporting patterns often emphasize magnesium-rich foods, steady glucose, and soothing, simple meals that reduce digestive stress.")
                            bullet("Acetylcholine and memory-supporting patterns often include choline-rich foods plus supportive fats for absorption and nerve signaling.")
                        }

                        infoCard(title: "Slow-Digesting Carbs and Healthy Fats") {
                            bullet("Slow-digesting carbohydrates help stabilize blood sugar, which can reduce irritability, cravings, and “energy crash” anxiety.")
                            bullet("Stable blood sugar supports consistent brain fuel, which supports steadier neurotransmitter activity.")
                            bullet("Healthy fats can improve absorption of fat-soluble nutrients and support brain membrane health.")
                            bullet("Pairing carbs with healthy fats and protein tends to slow digestion and improve nutrient uptake.")
                        }

                        infoCard(title: "Examples of “Supportive Pairing”") {
                            bullet("Oats or quinoa plus nuts or seeds, plus a protein source.")
                            bullet("Sweet potato plus avocado or olive oil, plus fish or chicken.")
                            bullet("Greek yogurt plus berries and chia, with a small handful of nuts if tolerated.")
                            bullet("Bean-based meals with extra-virgin olive oil and a protein anchor.")
                        }

                        infoCard(title: "A Simple Starting Protocol") {
                            bullet("Start with consistency: two or three repeatable meals that make you feel stable.")
                            bullet("Build each meal with: protein + slow carbs + healthy fat + micronutrient-rich produce.")
                            bullet("If a meal makes you feel worse, simplify it and retry with smaller changes.")
                            bullet("Track outcomes that matter: energy stability, focus, digestion comfort, sleep quality, mood steadiness.")
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
