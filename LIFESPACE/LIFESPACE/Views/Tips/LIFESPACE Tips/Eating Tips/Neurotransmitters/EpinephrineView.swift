import SwiftUI

struct EpinephrineView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var appeared = false
    @State private var cardOffsets: [CGFloat] = [60, 100, 140, 180]
    @State private var pulse = false

    var body: some View {
        ZStack(alignment: .topLeading) {

            // Background
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

            ScrollView {
                VStack(alignment: .leading, spacing: 40) {

                    // Header
                    VStack(spacing: 16) {
                        Text("Epinephrine")
                            .font(.system(size: 42, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .scaleEffect(pulse ? 1.03 : 1.0)

                        Text("A.K.A. Adrenaline")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white.opacity(0.85))
                    }
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)

                    // Image
                    Image("adrenaline")
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal, 30)
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 60)
                        .animation(.easeOut(duration: 0.8), value: appeared)

                    // What Is Epinephrine
                    glassCard(offset: $cardOffsets[0]) {
                        VStack(alignment: .leading, spacing: 18) {
                            HStack {
                                Image(systemName: "bolt.fill")
                                    .font(.system(size: 36))
                                    .foregroundColor(.orange)

                                Text("What Is Epinephrine?")
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                                    .scaleEffect(pulse ? 1.03 : 1.0)
                            }

                            Text("Epinephrine, commonly known as **adrenaline**, is your brain and body’s primary messenger for energy, alertness, and rapid response.")
                                .foregroundColor(.white.opacity(0.95))

                            Text("It powers your ability to focus under pressure, mobilize energy quickly, and stay motivated throughout the day. When balanced, it gives you that clean, sharp, ready-for-anything feeling.")
                                .foregroundColor(.white.opacity(0.9))
                        }
                    }

                    // Nutrients
                    glassCard(offset: $cardOffsets[1]) {
                        VStack(alignment: .leading, spacing: 20) {

                            HStack {
                                Image(systemName: "atom")
                                    .font(.system(size: 32))
                                    .foregroundColor(.yellow)

                                Text("Key Nutrients for Epinephrine Production")
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                                    .scaleEffect(pulse ? 1.03 : 1.0)
                            }

                            Text("Your body builds epinephrine from the amino acid **tyrosine**, with essential support from:")
                                .foregroundColor(.white.opacity(0.9))

                            NutrientList(items: [
                                "Vitamin C",
                                "Vitamin B6",
                                "Copper & Iron",
                                "Zinc & Magnesium"
                            ])
                        }
                    }

                    // Foods
                    glassCard(offset: $cardOffsets[2]) {
                        VStack(alignment: .leading, spacing: 24) {

                            HStack {
                                Text("🍎")
                                    .font(.system(size: 34))

                                Text("Foods That Support Epinephrine")
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                                    .scaleEffect(pulse ? 1.03 : 1.0)
                            }

                            FoodCategoryGrid()
                        }
                    }

                    // Practical Application
                    glassCard(offset: $cardOffsets[3]) {
                        VStack(alignment: .leading, spacing: 20) {

                            HStack {
                                Image(systemName: "sun.max.fill")
                                    .font(.system(size: 32))
                                    .foregroundColor(.orange)

                                Text("How to Incorporate This Into Your LIFESPACE")
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                                    .scaleEffect(pulse ? 1.03 : 1.0)
                            }

                            Text("When you feel mentally flat, unmotivated, or foggy, prioritize foods rich in tyrosine and Vitamin C earlier in the day. Combine this with movement, morning light, and purposeful activity to naturally support healthy epinephrine levels.")
                                .foregroundColor(.white.opacity(0.92))
                                .lineSpacing(6)
                        }
                    }

                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 24)
            }

            // Back Button (FIXED)
            BackButtonView(customTarget: "EatingTipsView")
                .padding(.top, 4)
                .padding(.leading, 16)

            HomeButton()
        }
        .onAppear {
            appeared = true

            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                pulse.toggle()
            }

            withAnimation(.spring()) {
                cardOffsets = [0,0,0,0]
            }
        }
    }

    private func glassCard<Content: View>(
        offset: Binding<CGFloat>,
        @ViewBuilder content: () -> Content
    ) -> some View {
        content()
            .padding(24)
            .background(Color.white.opacity(0.13))
            .cornerRadius(26)
            .offset(y: appeared ? 0 : offset.wrappedValue)
            .opacity(appeared ? 1 : 0)
    }
}

// MARK: Supporting Views

struct NutrientList: View {
    let items: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(items, id: \.self) { item in
                HStack {
                    Text("•").foregroundColor(.yellow)
                    Text(item).foregroundColor(.white)
                }
            }
        }
    }
}

struct FoodCategoryGrid: View {
    var body: some View {
        VStack(spacing: 16) {
            foodRow(emoji: "🍊", category: "Fruits", items: "Citrus fruits, bananas, avocados")
            foodRow(emoji: "🥬", category: "Vegetables", items: "Spinach, kale, broccoli")
            foodRow(emoji: "🥩", category: "Meat & Dairy", items: "Eggs, beef, salmon, lamb")
            foodRow(emoji: "🌰", category: "Nuts & Seeds", items: "Pumpkin seeds, cashews")
        }
    }

    private func foodRow(emoji: String, category: String, items: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Text(emoji).font(.title)

            VStack(alignment: .leading) {
                Text(category)
                    .font(.headline)
                    .foregroundColor(.white)

                Text(items)
                    .foregroundColor(.white.opacity(0.85))
            }
        }
        .padding(16)
        .background(Color.white.opacity(0.08))
        .cornerRadius(18)
    }
}

struct HomeButton: View {
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
                            .fill(Color.white.opacity(0.85))
                            .frame(width: 62, height: 62)
                            .shadow(radius: 10)

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
