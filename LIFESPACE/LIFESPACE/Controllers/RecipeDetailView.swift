import SwiftUI

struct RecipeDetailView: View {
    @EnvironmentObject var navModel: NavigationModel
    let recipe: Recipe

    @AppStorage var isFavorite: Bool

    init(recipe: Recipe) {
        self.recipe = recipe
        self._isFavorite = AppStorage(
            wrappedValue: false,
            "favorite_\(recipe.id)"
        )
    }

    private let gradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 0.35, green: 0.80, blue: 0.75),
            Color(red: 0.20, green: 0.65, blue: 0.60),
            Color(red: 0.10, green: 0.45, blue: 0.45)
        ]),
        startPoint: .top,
        endPoint: .bottom
    )

    var body: some View {
        ZStack {
            gradient.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {

                    // ── Top row: Back + Heart (IDENTICAL to legacy) ──
                    HStack(spacing: 16) {
                        Spacer()
                        Button(action: { navModel.pop() }) {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                                .padding(14)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                        Button(action: { isFavorite.toggle() }) {
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(isFavorite ? .red : .white)
                                .padding(14)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                        .animation(.easeInOut(duration: 0.4), value: isFavorite)
                        .padding(.top, 8)
                        .padding(.trailing, 8)
                    }
                    .padding(.bottom, 2)

                    // ── Title & Subtitle (IDENTICAL typography) ──
                    VStack(spacing: 0) {
                        Text(recipe.title)
                            .font(.system(size: 34, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .shadow(radius: 2)
                            .padding(.horizontal, 6)
                            .padding(.bottom, 12)

                        Text(recipe.subtitle)
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.80))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 6)
                            .padding(.bottom, 3)
                    }
                    .frame(maxWidth: .infinity)

                    // ── Badges Row ──
                    HStack(spacing: 14) {
                        Label(
                            recipe.cookTimeCategory.replacingOccurrences(of: " minutes", with: " min"),
                            systemImage: "clock"
                        )
                        .font(.caption.bold())
                        .foregroundColor(.white)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 14)
                        .background(Color.white.opacity(0.14))
                        .clipShape(Capsule())

                        ForEach(recipe.neurotransmitters, id: \.self) { nt in
                            Label(nt.displayName, systemImage: nt.badgeIcon)
                                .font(.caption.bold())
                                .foregroundColor(.white)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 14)
                                .background(nt.badgeColor)
                                .clipShape(Capsule())
                        }
                    }
                    .padding(.bottom, 6)

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Ingredients")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                            .padding(.bottom, 2)
                        ForEach(recipe.detailedIngredients, id: \.self) { ingredient in
                            Text("• \(ingredient)")
                                .foregroundColor(.white.opacity(0.93))
                                .font(.custom("Avenir", size: 18))
                                .multilineTextAlignment(.leading) // optional, helps wrap left
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .shadow(radius: 7)

                    // ── Method Card ──
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Method")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                            .padding(.bottom, 2)

                        ForEach(recipe.methodSteps.indices, id: \.self) { i in
                            HStack(alignment: .top, spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(Color.white.opacity(0.21))
                                        .frame(width: 30, height: 30)

                                    Text("\(i + 1)")
                                        .font(.system(size: 17, weight: .bold))
                                        .foregroundColor(.white)
                                }

                                Text(recipe.methodSteps[i])
                                    .foregroundColor(.white.opacity(0.93))
                                    .font(.custom("Avenir", size: 17))
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .shadow(radius: 7)

                    Spacer(minLength: 40)
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
            }
        }
    }
}
