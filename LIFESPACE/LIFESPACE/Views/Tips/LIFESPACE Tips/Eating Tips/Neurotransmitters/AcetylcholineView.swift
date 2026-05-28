import SwiftUI

struct AcetylcholineView: View {
    @EnvironmentObject var navModel: NavigationModel

    @State private var appeared = false
    @State private var pulse = false
    @State private var cardOffsets: [CGFloat] = [80, 120, 160, 200]

    private let darkRed = Color(red: 0.70, green: 0.10, blue: 0.15)
    private let darkCyan = Color(red: 0.05, green: 0.35, blue: 0.55)
    private let darkPurple = Color(red: 0.55, green: 0.25, blue: 0.65)

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
                        Color.purple.opacity(0.13),
                        Color.clear
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )

            ScrollView {
                VStack(alignment: .leading, spacing: 40) {

                    VStack(spacing: 12) {
                        Text("Acetylcholine")
                            .font(.system(size: 42, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .purple.opacity(0.55), radius: 8, y: 3)
                            .scaleEffect(pulse ? 1.025 : 1.0)

                        Text("The Learning Molecule")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white.opacity(0.86))
                    }
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)

                    Image("acetylcholine")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 38)
                        .padding(.vertical, 16)
                        .shadow(color: .purple.opacity(0.38), radius: 16, y: 8)
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 70)
                        .animation(.easeOut(duration: 0.75).delay(0.2), value: appeared)

                    // MARK: - What Is Acetylcholine?
                    glassCard(offset: $cardOffsets[0]) {
                        VStack(alignment: .leading, spacing: 18) {
                            HStack(spacing: 12) {
                                Image(systemName: "brain.head.profile")
                                    .font(.system(size: 34))
                                    .foregroundColor(.purple)
                                    .shadow(color: .purple.opacity(0.45), radius: 4)

                                Text("What Is Acetylcholine?")
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                                    .scaleEffect(pulse ? 1.025 : 1.0)
                            }

                            Text("Acetylcholine is the brain’s neurotransmitter responsible for learning, memory, attention, and clarity.")
                                .font(.body)
                                .foregroundColor(.white.opacity(0.95))
                                .lineSpacing(6)

                            Text("More acetylcholine can support clearer thinking, better recall, and stronger attention.")
                                .font(.body)
                                .foregroundColor(.white.opacity(0.9))
                                .lineSpacing(6)

                            Text("It also plays a role in reducing inflammation in the brain, which may contribute to improvements in cognitive and behavioral symptoms associated with psychotic disorders.")
                                .font(.body)
                                .foregroundColor(.white.opacity(0.9))
                                .lineSpacing(6)

                            Text("The foundational ingredients for acetylcholine production are choline, antioxidants, B5, and DHA.")
                                .font(.body)
                                .foregroundColor(.white.opacity(0.9))
                                .lineSpacing(6)

                            Text("Low acetylcholine is linked to brain fog, poor memory, learning difficulties, and Alzheimer’s.")
                                .font(.body)
                                .foregroundColor(darkRed.opacity(0.95))
                                .lineSpacing(6)

                            Text("Too much acetylcholine may lead to muscle cramps, excessive sweating, and irritability.")
                                .font(.body)
                                .foregroundColor(.white.opacity(0.9))
                                .lineSpacing(6)
                        }
                    }

                    // MARK: - Foods
                    glassCard(offset: $cardOffsets[1]) {
                        VStack(alignment: .leading, spacing: 22) {
                            HStack(spacing: 12) {
                                Text("🍎")
                                    .font(.system(size: 34))

                                Text("Foods That Support Acetylcholine")
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                                    .scaleEffect(pulse ? 1.025 : 1.0)
                            }

                            VStack(spacing: 16) {
                                largeFoodCard(emoji: "🍇", title: "Fruits", items: "Pomegranate, blueberries")
                                largeFoodCard(emoji: "🥦", title: "Vegetables", items: "Brussels sprouts, cauliflower, mushrooms, capers, carrots")
                                largeFoodCard(emoji: "🥚", title: "Eggs & Dairy", items: "Egg yolk, goat cheese, duck eggs")
                                largeFoodCard(emoji: "🌾", title: "Grains", items: "Rye bread, sprouted grain bread")
                                largeFoodCard(emoji: "🫒", title: "Oils & Butters", items: "Olive oil")
                                largeFoodCard(emoji: "🥩", title: "Meat", items: "Liver, chicken")
                                largeFoodCard(emoji: "🐟", title: "Fish", items: "Salmon, tuna, cod, sardines, fish eggs")
                                largeFoodCard(emoji: "🌿", title: "Herbs, Spices & Tea", items: "Rosemary, green tea, turmeric")
                                largeFoodCard(emoji: "🥙", title: "Sauces & Broth", items: "Hummus")
                                largeFoodCard(emoji: "🌻", title: "Nuts, Seeds & Beans", items: "Sunflower seeds, walnuts")
                            }
                        }
                    }

                    // MARK: - Meals
                    glassCard(offset: $cardOffsets[2]) {
                        VStack(alignment: .leading, spacing: 22) {
                            HStack(spacing: 12) {
                                Image(systemName: "fork.knife")
                                    .font(.system(size: 30))
                                    .foregroundColor(.yellow)

                                Text("LIFESPACE Meal & Snack Ideas")
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                                    .scaleEffect(pulse ? 1.025 : 1.0)
                            }

                            VStack(spacing: 16) {
                                largeMealCard("🍳 Omelet with egg yolks, mushrooms, and goat cheese")
                                largeMealCard("🫐 Blueberries and walnuts")
                                largeMealCard("🍵 Cup of green tea")
                                largeMealCard("🐟 Sardine salad with capers, celery, lemon zest, and olive oil")
                                largeMealCard("🍞 100% rye toast or sprouted grain bread")
                                largeMealCard("🥚 Hard-boiled duck egg with raw carrots and hummus")
                                largeMealCard("🍢 Liver pâté on cucumber slices")
                                largeMealCard("🥬 Steamed cauliflower with turmeric")
                                largeMealCard("🍗 Roasted rosemary chicken thighs with parsley-lemon salad")
                            }
                        }
                    }

                    // MARK: - Smoothies
                    glassCard(offset: $cardOffsets[3]) {
                        VStack(alignment: .leading, spacing: 22) {
                            HStack(spacing: 12) {
                                Image(systemName: "drop.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.white.opacity(0.75))

                                Text("Acetylcholine Smoothie Recipes")
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                                    .scaleEffect(pulse ? 1.025 : 1.0)
                            }

                            VStack(spacing: 20) {
                                largeSmoothieCard(
                                    title: "Coconut Calm Smoothie",
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
                                    title: "Blue-Green Brain Boost",
                                    boosts: "Neurogenesis + clarity",
                                    ingredients: """
                                    1/2 cup frozen blueberries
                                    1 tsp spirulina or blue-green algae
                                    1 tbsp walnuts or flaxseed
                                    1/2 cup coconut water
                                    1/2 apple
                                    Handful of spinach
                                    """,
                                    note: "🧠 Antioxidants + omega-3s + brain minerals = cellular rejuvenation"
                                )
                            }
                        }
                    }

                    Spacer(minLength: 120)
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)
                .padding(.bottom, 160)
            }

            BackButtonView(customTarget: "EatingTipsView")
                .padding(.top, 4)
                .padding(.leading, 16)

            homeButton
        }
        .onAppear {
            appeared = true

            withAnimation(.easeInOut(duration: 1.25).repeatForever(autoreverses: true)) {
                pulse.toggle()
            }

            withAnimation(.spring(response: 0.7, dampingFraction: 0.78).delay(0.1)) {
                cardOffsets = [0, 0, 0, 0]
            }
        }
    }

    // MARK: - Home Button

    private var homeButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()

                Button {
                    navModel.push("HomeView")
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.85))
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

    // MARK: - Glass Card

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
                    .shadow(color: .black.opacity(0.22), radius: 16, y: 8)
            )
            .offset(y: appeared ? 0 : offset.wrappedValue)
            .opacity(appeared ? 1 : 0)
            .animation(.easeOut(duration: 0.75), value: appeared)
    }

    // MARK: - Food Card

    private func largeFoodCard(emoji: String, title: String, items: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Text(emoji)
                .font(.title)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)

                Text(items)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.85))
                    .lineSpacing(3)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.08))
        .cornerRadius(18)
    }

    // MARK: - Meal Card

    private func largeMealCard(_ text: String) -> some View {
        Text(text)
            .font(.body)
            .foregroundColor(.white.opacity(0.95))
            .lineSpacing(4)
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white.opacity(0.08))
            .cornerRadius(18)
    }

    // MARK: - Smoothie Card

    private func largeSmoothieCard(
        title: String,
        boosts: String,
        ingredients: String,
        note: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title3.bold())
                .foregroundColor(.white)
                .scaleEffect(pulse ? 1.02 : 1.0)

            Text("Boosts: \(boosts)")
                .font(.subheadline)
                .foregroundColor(darkPurple)

            Text("Ingredients")
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
        .background(Color.white.opacity(0.08))
        .cornerRadius(18)
    }
}
