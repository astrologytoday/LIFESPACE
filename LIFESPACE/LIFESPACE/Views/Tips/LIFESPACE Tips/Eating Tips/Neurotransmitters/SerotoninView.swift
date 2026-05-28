import SwiftUI

struct SerotoninView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var appeared = false
    @State private var pulse = false
    @State private var cardOffsets: [CGFloat] = [60, 100, 140, 180]

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
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.pink.opacity(0.16),
                        Color.clear
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )

            ScrollView {
                VStack(alignment: .leading, spacing: 38) {

                    VStack(spacing: 14) {
                        Text("Serotonin")
                            .font(.system(size: 42, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .pink.opacity(0.55), radius: 10, y: 4)
                            .scaleEffect(pulse ? 1.025 : 1.0)

                        Text("The Molecule of Calm & Contentment")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white.opacity(0.88))
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 20)

                    Image("serotonin")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 30)
                        .shadow(color: .pink.opacity(0.4), radius: 22, y: 12)
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 70)
                        .animation(.easeOut(duration: 0.85).delay(0.2), value: appeared)

                    glassCard(offset: $cardOffsets[0]) {
                        VStack(alignment: .leading, spacing: 18) {
                            HStack(spacing: 14) {
                                Image(systemName: "heart.fill")
                                    .font(.system(size: 36))
                                    .foregroundColor(.pink)

                                Text("What Is Serotonin?")
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                                    .scaleEffect(pulse ? 1.025 : 1.0)
                            }

                            Text("Serotonin is often called the body’s natural “feel-good” neurotransmitter. It plays a central role in regulating mood, emotional stability, sleep quality, appetite, and self-worth.")
                                .foregroundColor(.white.opacity(0.95))
                                .lineSpacing(6)

                            Text("When serotonin levels are balanced, we tend to feel calmer, more optimistic, socially confident, and emotionally resilient.")
                                .foregroundColor(.white.opacity(0.92))
                                .lineSpacing(6)
                        }
                    }

                    glassCard(offset: $cardOffsets[1]) {
                        VStack(alignment: .leading, spacing: 22) {
                            HStack(spacing: 12) {
                                Image(systemName: "atom")
                                    .font(.system(size: 32))
                                    .foregroundColor(.pink)

                                Text("Key Nutrients for Serotonin Production")
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                                    .scaleEffect(pulse ? 1.025 : 1.0)
                            }

                            Text("Serotonin is synthesized from the amino acid tryptophan. For optimal conversion, the body also needs:")
                                .foregroundColor(.white.opacity(0.9))
                                .lineSpacing(5)

                            SerotoninNutrientGrid()
                        }
                    }

                    glassCard(offset: $cardOffsets[2]) {
                        VStack(alignment: .leading, spacing: 24) {
                            HStack(spacing: 12) {
                                Text("🍎")
                                    .font(.system(size: 34))

                                Text("Foods That Support Serotonin")
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                                    .scaleEffect(pulse ? 1.025 : 1.0)
                            }

                            SerotoninFoodGrid()
                        }
                    }

                    glassCard(offset: $cardOffsets[3]) {
                        VStack(alignment: .leading, spacing: 22) {
                            HStack(spacing: 12) {
                                Image(systemName: "sun.max.fill")
                                    .font(.system(size: 32))
                                    .foregroundColor(.orange)

                                Text("How to Support Serotonin Naturally")
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                                    .scaleEffect(pulse ? 1.025 : 1.0)
                            }

                            VStack(spacing: 14) {
                                lifestyleRow("☀️", bold: "Get morning sunlight", text: "to help trigger natural serotonin production.")
                                lifestyleRow("🏃‍♀️", bold: "Move your body daily", text: "because exercise supports serotonin and mood.")
                                lifestyleRow("🧘", bold: "Practice mindfulness", text: "to lower stress and regulate the nervous system.")
                                lifestyleRow("🌙", bold: "Prioritize sleep", text: "because quality rest supports serotonin balance.")
                                lifestyleRow("👥", bold: "Connect with others", text: "through safe, positive social interaction.")
                            }
                        }
                    }

                    Spacer(minLength: 130)
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)
                .padding(.bottom, 160)
            }

            BackButtonView(customTarget: "EatingTipsView")
                .padding(.top, 4)
                .padding(.leading, 16)

            SerotoninHomeButton()
        }
        .onAppear {
            appeared = true

            withAnimation(.easeInOut(duration: 1.25).repeatForever(autoreverses: true)) {
                pulse.toggle()
            }

            withAnimation(.spring(response: 0.75, dampingFraction: 0.78).delay(0.1)) {
                cardOffsets = [0, 0, 0, 0]
            }
        }
    }

    private func glassCard<Content: View>(
        offset: Binding<CGFloat>,
        @ViewBuilder content: () -> Content
    ) -> some View {
        content()
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 26)
                    .fill(Color.white.opacity(0.135))
                    .overlay(
                        RoundedRectangle(cornerRadius: 26)
                            .stroke(Color.white.opacity(0.22), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.25), radius: 16, y: 8)
            )
            .offset(y: appeared ? 0 : offset.wrappedValue)
            .opacity(appeared ? 1 : 0)
            .animation(.easeOut(duration: 0.8), value: appeared)
    }

    private func lifestyleRow(_ emoji: String, bold: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Text(emoji)
                .font(.system(size: 26))
                .frame(width: 34)

            VStack(alignment: .leading, spacing: 4) {
                Text(bold)
                    .font(.headline)
                    .foregroundColor(.pink.opacity(0.95))

                Text(text)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.88))
                    .lineSpacing(3)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.08))
        .cornerRadius(18)
    }
}

// MARK: - Serotonin Nutrient Grid

struct SerotoninNutrientGrid: View {
    var body: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ],
            spacing: 14
        ) {
            nutrientCard(icon: "B6", title: "Vitamin B6", text: "Supports serotonin synthesis")
            nutrientCard(icon: "Mg", title: "Magnesium", text: "Calms the nervous system")
            nutrientCard(icon: "Zn", title: "Zinc", text: "Supports receptor sensitivity")
            nutrientCard(icon: "🌾", title: "Complex Carbs", text: "Help transport tryptophan")
        }
    }

    private func nutrientCard(icon: String, title: String, text: String) -> some View {
        VStack(spacing: 8) {
            Text(icon)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .frame(width: 54, height: 54)
                .background(
                    Circle()
                        .fill(Color.pink.opacity(0.55))
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.25), lineWidth: 1)
                        )
                )

            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            Text(text)
                .font(.caption)
                .foregroundColor(.white.opacity(0.82))
                .multilineTextAlignment(.center)
                .lineSpacing(2)
        }
        .padding(14)
        .frame(maxWidth: .infinity, minHeight: 150)
        .background(Color.white.opacity(0.08))
        .cornerRadius(18)
    }
}

// MARK: - Serotonin Food Grid

struct SerotoninFoodGrid: View {
    var body: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ],
            spacing: 14
        ) {
            foodCard("🍌", "Fruits", "Bananas, pineapple, kiwi, tart cherries, dark berries")
            foodCard("🥬", "Vegetables", "Spinach, mustard greens, mushrooms, red cabbage")
            foodCard("🥩", "Meat & Dairy", "Turkey, chicken, salmon, eggs, liver, Greek yogurt")
            foodCard("🌰", "Nuts & Seeds", "Pumpkin seeds, tahini, flaxseed")
            foodCard("🌾", "Whole Grains", "Oats, quinoa, brown rice")
            foodCard("🍫", "Other", "Dark chocolate, tart cherry juice, raw honey")
        }
    }

    private func foodCard(_ emoji: String, _ title: String, _ items: String) -> some View {
        VStack(spacing: 10) {
            Text(emoji)
                .font(.system(size: 34))

            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            Text(items)
                .font(.caption)
                .foregroundColor(.white.opacity(0.84))
                .multilineTextAlignment(.center)
                .lineSpacing(3)
        }
        .padding(14)
        .frame(maxWidth: .infinity, minHeight: 165)
        .background(Color.white.opacity(0.08))
        .cornerRadius(18)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.white.opacity(0.14), lineWidth: 1)
        )
    }
}

// MARK: - Serotonin Home Button

struct SerotoninHomeButton: View {
    @EnvironmentObject var navModel: NavigationModel

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()

                Button {
                    navModel.push("HomeView")
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.88))
                            .frame(width: 62, height: 62)
                            .shadow(color: .black.opacity(0.25), radius: 10, y: 6)

                        Image(systemName: "house.fill")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(Color(red: 0.10, green: 0.45, blue: 0.45))
                    }
                }
                .padding(.trailing, 20)
                .padding(.bottom, 24)
            }
        }
    }
}
