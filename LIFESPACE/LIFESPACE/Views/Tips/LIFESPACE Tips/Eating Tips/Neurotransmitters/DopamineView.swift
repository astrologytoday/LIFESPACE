import SwiftUI

struct DopamineView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var appeared = false
    @State private var cardOffsets: [CGFloat] = [80, 120, 160, 200, 240] // Extra for burnout & smoothies

    var body: some View {
        ZStack(alignment: .topLeading) {
            // 🌊 LIFESPACE gradient with subtle red/orange overlay for motivation & reward energy
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
                    gradient: Gradient(colors: [Color.orange.opacity(0.15), Color.clear]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )

            ScrollView {
                VStack(alignment: .leading, spacing: 36) {

                    // MARK: - Title
                    Text("Dopamine: The Brain’s Reward System")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .orange.opacity(0.6), radius: 6)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.top,20)

                    // MARK: - Molecule Image
                    Image("dopamine")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 20)
                        .shadow(color: .orange.opacity(0.4), radius: 12)
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 80)
                        .animation(.easeOut(duration: 0.7).delay(0.4), value: appeared)

                    // MARK: - What It Is
                    glassCard(offset: $cardOffsets[0]) {
                        HStack(spacing: 16) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 34))
                                .foregroundColor(.yellow)
                                .shadow(color: .orange.opacity(0.5), radius: 4)

                            VStack(alignment: .leading, spacing: 14) {
                                Text("What It Is & What It Does")
                                    .font(.title2.bold())
                                    .foregroundColor(.white)

                                Text("Dopamine is the brain’s neurotransmitter responsible for motivation, focus, reward, pleasure, and motor function.")

                                Text("The foundational ingredients for dopamine production are high-tyrosine proteins.")
                                    .foregroundColor(.white.opacity(0.9))

                                Text("Low dopamine is linked to ") +
                                Text("depression, ADHD, Parkinson’s and low libido.").bold().foregroundColor(.red.opacity(0.8))

                                Text("Too much dopamine may lead to mania, risk-taking, compulsive behavior, anxiety or paranoia in extreme cases.")
                                    .foregroundColor(.white.opacity(0.9))
                            }
                        }
                    }

                    // MARK: - Avoiding Dopamine Burnout
                    glassCard(offset: $cardOffsets[1]) {
                        VStack(alignment: .leading, spacing: 20) {
                            HStack(spacing: 12) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.red)
                                Text("Avoiding Dopamine Burnout")
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                            }

                            Text("What leads to Dopamine Burnout?")
                                .font(.headline)
                                .foregroundColor(.white)

                            VStack(spacing: 12) {
                                burnoutItem("🍬 Sugar")
                                burnoutItem("☕ Caffeine")
                                burnoutItem("💻 Porn")
                                burnoutItem("📱 Social Media")
                                burnoutItem("🎮 Video games")
                                burnoutItem("🚬 Nicotine")
                            }

                            Text("All of these things lead to unnatural dopamine explosions and thus depletion of this very important neurotransmitter. These dopamine \"explosions\" overstimulate the mesolimbic pathway, leading to downregulated receptors and a numbed reward response over time, which puts a damper on the natural pleasures of life.")
                                .foregroundColor(.white.opacity(0.9))

                            Text("Real dopamine is sustainable and comes from the natural world.")
                                .font(.headline)
                                .foregroundColor(.white)

                            Text("The beauty of sustainable dopamine is that it builds capacity for joy over time. This is the difference between pleasure and happiness.")
                                .foregroundColor(.white.opacity(0.9))
                        }
                    }

                    // MARK: - Foods That Support
                    glassCard(offset: $cardOffsets[2]) {
                        VStack(alignment: .leading, spacing: 20) {
                            HStack(spacing: 12) {
                                Image(systemName: "leaf.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.green)
                                Text("Foods That Support Dopamine")
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                            }

                            VStack(spacing: 16) {
                                largeFoodCard(emoji: "🍒", title: "Fruits", items: "Avocado, bananas")
                                largeFoodCard(emoji: "🥦", title: "Vegetables", items: "Beets, matcha, green tea, spinach, leafy greens, seaweed")
                                largeFoodCard(emoji: "🥚", title: "Dairy", items: "Pasture-raised Eggs")
                                largeFoodCard(emoji: "🥩", title: "Meat", items: "Beef, lamb, bison, turkey, beef liver, wild game")
                                largeFoodCard(emoji: "🐟", title: "Fish", items: "All fish!")
                                largeFoodCard(emoji: "🥜", title: "Nuts, Seeds and Beans", items: "Spirulina, Cacao, almonds, tempeh, pumpkin seeds, chickpeas, lentils, walnuts, cashews, sesame, watermelon seeds")
                            }
                        }
                    }

                    // MARK: - Meal & Snack Ideas
                    glassCard(offset: $cardOffsets[3]) {
                        VStack(alignment: .leading, spacing: 20) {
                            HStack(spacing: 12) {
                                Image(systemName: "fork.knife")
                                    .font(.system(size: 30))
                                    .foregroundColor(.yellow)
                                Text("LIFESPACE Dopamine Meals & Snack Ideas!")
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                            }

                            VStack(spacing: 16) {
                                largeMealCard("🥚 Scrambled pasture-raised eggs cooked in ghee with sautéed spinach and shiitake mushrooms")
                                largeMealCard("🥑 Half an avocado with Himalayan salt")
                                largeMealCard("🍵 Matcha tea")
                                largeMealCard("🥩 Grass-fed beef stir-fry with broccoli, bok choy, and sesame seeds, served over brown rice or teff")
                                largeMealCard("🥤 Fresh beet smoothie with pomegranate, spirulina, and ginger")
                                largeMealCard("🍖 Grilled lamb chops")
                                largeMealCard("🍔 Bison burger")
                                largeMealCard("🥕 Roasted root vegetables (carrot, parsnip, celery root)")
                                largeMealCard("🥗 Small green salad with olive oil + lemon")
                            }
                        }
                    }

                    // MARK: - Smoothie Recipes
                    glassCard(offset: $cardOffsets[4]) {
                        VStack(alignment: .leading, spacing: 20) {
                            HStack(spacing: 12) {
                                Image(systemName: "drop.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.orange)
                                Text("Dopamine Smoothie Recipes")
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                            }

                            VStack(spacing: 20) {
                                largeSmoothieCard(
                                    title: "Sweet Potato Pie Smoothie",
                                    boosts: "Serotonin + dopamine",
                                    ingredients: """
                                    1/2 cup cooked sweet potato
                                    1/2 banana
                                    1/2 tsp cinnamon
                                    1 tbsp tahini
                                    1/2 cup oat or almond milk
                                    """,
                                    note: "🧠 Complex carbs + B vitamins + tyrosine-rich tahini = balanced bliss"
                                )

                                largeSmoothieCard(
                                    title: "Brain Bliss Cacao Smoothie",
                                    boosts: "Dopamine (focus + motivation)",
                                    ingredients: """
                                    1 tbsp raw cacao powder
                                    1/2 avocado
                                    1 banana
                                    1/2 cup frozen berries
                                    1 tsp maca powder (optional)
                                    1 cup almond or oat milk
                                    """,
                                    note: "🧠 Tyrosine + magnesium + phenylethylamine = brain candy"
                                )

                                largeSmoothieCard(
                                    title: "Thyroid Tonic",
                                    boosts: "Tyrosine, iodine, dopamine",
                                    ingredients: """
                                    1/2 apple
                                    1/2 banana
                                    1 tbsp chopped seaweed (wakame or nori flakes)
                                    1/2 tsp spirulina
                                    1/2 lemon, juiced
                                    Water + ice
                                    """,
                                    note: "🧠 Sea minerals + dopamine precursors = alertness & energy"
                                )
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 64)
                .padding(.bottom, 160)
            }

            // Back Button – matches original
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
                cardOffsets = [0, 0, 0, 0, 0]
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

    // MARK: - Burnout Item
    private func burnoutItem(_ text: String) -> some View {
        HStack(spacing: 14) {
            Text("•")
                .font(.title2)
                .foregroundColor(.red)
                .padding(.top, 4)
            Text(text)
                .font(.body)
                .foregroundColor(.white.opacity(0.95))
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.red.opacity(0.08))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.red.opacity(0.3), lineWidth: 1)
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
    let darkOrange = Color(red: 0.65, green: 0.28, blue: 0.05)
    // MARK: - Large Smoothie Card
    private func largeSmoothieCard(title: String, boosts: String, ingredients: String, note: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title3.bold())
                .foregroundColor(.white)

            Text("Boosts: \(boosts)")
                .font(.subheadline)
                .foregroundColor(darkOrange)

            Text("Ingredients:")
                .font(.headline)
                .foregroundColor(.white)

            Text(ingredients)
                .font(.body)
                .foregroundColor(.white.opacity(0.95))
                .lineSpacing(4)

            Text(note)
                .font(.body.italic())
                .foregroundColor(.yellow.opacity(0.9))
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
