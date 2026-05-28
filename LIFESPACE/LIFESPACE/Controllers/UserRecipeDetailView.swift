import SwiftUI

struct UserRecipeDetailView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var userRecipeStore: UserRecipeStore

    let recipeID: String

    private var recipe: UserRecipe? {
        userRecipeStore.recipe(id: recipeID)
    }

    private var isFavorite: Bool {
        recipe?.isFavorite ?? false
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

                    // ── Top row: Back + Heart ──
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

                        Button(action: {
                            if let r = recipe {
                                userRecipeStore.toggleFavorite(id: r.id)
                            }
                        }) {
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

                    if let r = recipe {
                        // ── Title & Subtitle ──
                        VStack(spacing: 0) {
                            Text(r.title)
                                .font(.system(size: 34, weight: .heavy, design: .rounded))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .shadow(radius: 2)
                                .padding(.horizontal, 6)
                                .padding(.bottom, 12)

                            Text(r.subtitle)
                                .font(.headline)
                                .foregroundColor(.white.opacity(0.80))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 6)
                                .padding(.bottom, 3)
                                .opacity(r.subtitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0 : 1)
                        }
                        .frame(maxWidth: .infinity)

                        // ── Badges Row (cook time only) ──
                        HStack(spacing: 14) {
                            Label(
                                r.cookTime.rawValue.replacingOccurrences(of: " minutes", with: " min"),
                                systemImage: "clock"
                            )
                            .font(.caption.bold())
                            .foregroundColor(.white)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 14)
                            .background(Color.white.opacity(0.14))
                            .clipShape(Capsule())
                        }
                        .padding(.bottom, 6)

                        // ── Ingredients Card ──
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Ingredients")
                                .font(.title2.bold())
                                .foregroundColor(.white)
                                .padding(.bottom, 2)

                            ForEach(r.detailedIngredients, id: \.self) { ingredient in
                                Text("• \(ingredient)")
                                    .foregroundColor(.white.opacity(0.93))
                                    .font(.custom("Avenir", size: 18))
                                    .multilineTextAlignment(.leading)
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

                            ForEach(r.methodSteps.indices, id: \.self) { i in
                                HStack(alignment: .top, spacing: 12) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.white.opacity(0.21))
                                            .frame(width: 30, height: 30)

                                        Text("\(i + 1)")
                                            .font(.system(size: 17, weight: .bold))
                                            .foregroundColor(.white)
                                    }

                                    Text(r.methodSteps[i])
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

                    } else {
                        Text("Recipe not found.")
                            .foregroundColor(.white.opacity(0.9))
                            .padding(.top, 40)
                    }

                    Spacer(minLength: 40)
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
            }
        }
    }
}
