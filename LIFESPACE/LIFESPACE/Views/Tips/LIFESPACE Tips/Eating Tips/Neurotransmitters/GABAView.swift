import SwiftUI

struct GABAView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var appeared = false
    @State private var cardOffsets: [CGFloat] = [80, 120, 160, 200] // Extra for smoothie section

    var body: some View {
        ZStack(alignment: .topLeading) {
            // 🌊 LIFESPACE gradient background with subtle blue overlay for calm/zen theme
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
                    gradient: Gradient(colors: [Color.blue.opacity(0.12), Color.clear]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )

            ScrollView {
                VStack(alignment: .leading, spacing: 36) {

                    // MARK: - Title
                    Text("GABA: The Breaks")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .blue.opacity(0.6), radius: 6)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.top,20)

                    // MARK: - Molecule Image
                    Image("gaba")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 20)
                        .shadow(color: .blue.opacity(0.4), radius: 12)
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 80)
                        .animation(.easeOut(duration: 0.7).delay(0.4), value: appeared)

                    // MARK: - What It Is
                    glassCard(offset: $cardOffsets[0]) {
                        HStack(spacing: 16) {
                            Image(systemName: "moon.stars.fill")
                                .font(.system(size: 34))
                                .foregroundColor(.blue)
                                .shadow(color: .blue.opacity(0.5), radius: 4)

                            VStack(alignment: .leading, spacing: 14) {
                                Text("What It Is & What It Does")
                                    .font(.title2.bold())
                                    .foregroundColor(.white)

                                Text("GABA is the brain’s primary inhibitory neurotransmitter responsible for ") +
                                Text("calm, sleep, and reducing stress and anxiety.").bold().foregroundColor(.blue)

                                Text("The foundational ingredients for GABA production are glutamine, magnesium, B6, zinc, and taurine. Aside from being the zen master of brain chemistry, GABA also supports:")
                                    .foregroundColor(.white.opacity(0.9))

                                VStack(alignment: .leading, spacing: 8) {
                                    Text("• Pain modulation: Activates inhibitory pathways in the spinal cord to reduce pain perception")
                                    Text("• Muscle tone: Helps regulate motor control and prevent tremors")
                                    Text("• Hormonal balance: Indirectly affects the stress axis and even reproductive hormones")
                                }
                                .foregroundColor(.white.opacity(0.9))

                                Text("Low GABA is linked to ") +
                                Text("anxiety, insomnia, panic disorders, and epilepsy.").bold().foregroundColor(.red.opacity(0.8))

                                Text("Too much GABA may lead to feeling sluggish or sedated.")
                                    .foregroundColor(.white.opacity(0.9))
                            }
                        }
                    }

                    // MARK: - Foods That Support
                    glassCard(offset: $cardOffsets[1]) {
                        VStack(alignment: .leading, spacing: 20) {
                            HStack(spacing: 12) {
                                Image(systemName: "leaf.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.green)
                                Text("Foods That Support GABA Production")
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                            }

                            VStack(spacing: 16) {
                                largeFoodCard(emoji: "🍌", title: "Fruits", items: "Banana, blueberries, mango")
                                largeFoodCard(emoji: "🥬", title: "Vegetables", items: "Spinach, kimchi, sauerkraut, broccoli, kale, sweet potatoes, cabbage, seaweed, mushrooms")
                                largeFoodCard(emoji: "🥛", title: "Dairy", items: "Kefir")
                                largeFoodCard(emoji: "🍚", title: "Grains", items: "Brown rice, steel cut oats, quinoa")
                                largeFoodCard(emoji: "🥣", title: "Sauces & Broth", items: "Bone broth, tahini, miso")
                                largeFoodCard(emoji: "🥜", title: "Nuts, Seeds & Beans", items: "Almonds, chia seeds, hemp hearts, tofu, chestnuts, amaranth")
                                largeFoodCard(emoji: "💊", title: "Vitamins", items: "Magnesium")
                            }
                        }
                    }

                    // MARK: - Meal & Snack Ideas
                    glassCard(offset: $cardOffsets[2]) {
                        VStack(alignment: .leading, spacing: 20) {
                            HStack(spacing: 12) {
                                Image(systemName: "fork.knife")
                                    .font(.system(size: 30))
                                    .foregroundColor(.yellow)
                                Text("LIFESPACE GABA Meals & Snack Ideas!")
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                            }

                            VStack(spacing: 16) {
                                largeMealCard("🥣 Steel-cut oats with almond butter, chia seeds, and blueberries")
                                largeMealCard("🍲 Quinoa, roasted pumpkin, steamed kale, tahini, and fermented veggies (kimchi or sauerkraut)")
                                largeMealCard("🥤 Kefir smoothie with cacao nibs, hemp hearts, and frozen mango")
                                largeMealCard("🍵 Miso soup with tofu, seaweed, and shiitake mushrooms")
                                largeMealCard("🥦 Steamed broccoli + sesame oil drizzle")
                                largeMealCard("🌰 Roasted chestnuts or amaranth crackers with Reishi tea")
                            }
                        }
                    }

                    // MARK: - Smoothie Recipes
                    glassCard(offset: $cardOffsets[3]) {
                        VStack(alignment: .leading, spacing: 20) {
                            HStack(spacing: 12) {
                                Image(systemName: "drop.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.gray)
                                Text("Smoothie Recipes")
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                            }

                            VStack(spacing: 20) {
                                largeSmoothieCard(
                                    title: "Coconut Calm & Focus",
                                    boosts: "Acetylcholine + GABA",
                                    ingredients: """
                                    1 tbsp coconut oil or coconut milk
                                    1/2 avocado
                                    1/2 banana
                                    1/2 cup frozen blueberries
                                    Pinch of sea salt
                                    1/2 tsp vanilla
                                    """,
                                    note: "🧠 Choline + fats + antioxidants = relaxed alertness"
                                )

                                largeSmoothieCard(
                                    title: "GABA Grounder",
                                    boosts: "GABA (calm + relaxation)",
                                    ingredients: """
                                    1/2 cup cooked sweet potato
                                    1 tbsp almond butter
                                    1/2 tsp ground cinnamon
                                    1/2 cup Greek yogurt or kefir
                                    Dash of nutmeg
                                    Water or oat milk to blend
                                    """,
                                    note: "🧠 Magnesium + glutamine + B6 = anti-anxiety elixir"
                                )
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 64)
                .padding(.bottom, 160)
            }

            // Back Button
            BackButtonView(customTarget: "EatingTipsView")
                .padding(.top, 12)
                .padding(.leading, 56)

            // Home Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        navModel.push("HomeView")
                    } label: {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.white.opacity(0.9),
                                            Color.white.opacity(0.6)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 60, height: 60)
                                .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 6)
                            Image(systemName: "house.fill")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(Color(red: 0.10, green: 0.45, blue: 0.45))
                        }
                    }
                    .padding(.trailing, 22)
                    .padding(.bottom, 22)
                }
            }
        }
        .onAppear {
            appeared = true
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2)) {
                cardOffsets = [0, 0, 0, 0]
            }
        }
    }

    // MARK: - Glass Card
    @ViewBuilder
    private func glassCard<Content: View>(offset: Binding<CGFloat>, @ViewBuilder content: () -> Content) -> some View {
        VStack {
            content()
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white.opacity(0.14))
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.white.opacity(0.25), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.2), radius: 12)
        )
        .offset(y: appeared ? 0 : offset.wrappedValue)
        .opacity(appeared ? 1 : 0)
        .animation(.easeOut(duration: 0.7), value: appeared)
    }

    // MARK: - Large Food Card
    private func largeFoodCard(emoji: String, title: String, items: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 10) {
                Text(emoji)
                    .font(.system(size: 32))
                Text(title + ":")
                    .font(.title3.bold())
                    .foregroundColor(.white)
            }
            Text(items)
                .font(.body)
                .foregroundColor(.white.opacity(0.95))
                .lineSpacing(4)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.09))
        .cornerRadius(18)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }

    // MARK: - Large Meal Card
    private func largeMealCard(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Text("•")
                .font(.title2)
                .foregroundColor(.yellow)
                .padding(.top, 4)
            Text(text)
                .font(.body)
                .foregroundColor(.white.opacity(0.95))
                .lineSpacing(4)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.09))
        .cornerRadius(18)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }
    let darkCyan = Color(red: 0.05, green: 0.35, blue: 0.55)
    // MARK: - Large Smoothie Card
    private func largeSmoothieCard(title: String, boosts: String, ingredients: String, note: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title3.bold())
                .foregroundColor(.white)

            Text("Boosts: \(boosts)")
                .font(.subheadline)
                .foregroundColor(.blue.opacity(0.9))

            Text("Ingredients:")
                .font(.headline)
                .foregroundColor(.white)

            Text(ingredients)
                .font(.body)
                .foregroundColor(.white.opacity(0.95))
                .lineSpacing(4)

            Text(note)
                .font(.body.italic())
                .foregroundColor(darkCyan)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.09))
        .cornerRadius(18)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }
}
