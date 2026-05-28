import SwiftUI

struct RecipeInfo: Identifiable {
    let id: String
    let title: String
    let cookTime: String
}

let allRecipes: [RecipeInfo] = [
    // legacy list (you currently have this empty)
]

struct FavoriteRecipesView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var userRecipeStore: UserRecipeStore

    // MARK: - Favorite Sources (same logic as your original)

    private var legacyFavorites: [RecipeInfo] {
        allRecipes.filter { UserDefaults.standard.bool(forKey: "favorite_\($0.id)") }
    }

    // modelRecipes is [Recipe]
    private var modelFavorites: [Recipe] {
        modelRecipes.filter { UserDefaults.standard.bool(forKey: "favorite_\($0.id)") }
    }

    private var userFavorites: [UserRecipe] {
        userRecipeStore.recipes.filter { $0.isFavorite }
    }

    private var hasAnyFavorites: Bool {
        !legacyFavorites.isEmpty || !modelFavorites.isEmpty || !userFavorites.isEmpty
    }

    var body: some View {
        ZStack {
            background

            VStack(spacing: 20) {
                title
                scrollContainer
                bottomButtons
            }
        }
    }

    // MARK: - Pieces (match RecipeResultsView)

    private var background: some View {
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
    }

    private var title: some View {
        Text("FAVORITE RECIPES")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.top, 36)
    }

    private var scrollContainer: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {

                if !hasAnyFavorites {
                    Text("No favorites yet.")
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.top, 24)
                        .frame(maxWidth: .infinity, alignment: .center)

                } else {
                    // --- Legacy Favorites ---
                    ForEach(legacyFavorites) { recipe in
                        Button {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                navModel.push("\(recipe.id)View")
                            }
                        } label: {
                            favoriteRow(title: recipe.title, subtitle: recipe.cookTime)
                        }
                    }

                    // --- Model Favorites ---
                    ForEach(modelFavorites) { recipe in
                        Button {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                navModel.push("RecipeModel:\(recipe.id)")
                            }
                        } label: {
                            favoriteRow(title: recipe.title, subtitle: recipe.cookTimeCategory)
                        }
                    }

                    // --- User Favorites ---
                    ForEach(userFavorites) { recipe in
                        Button {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                navModel.push("UserRecipeDetailView:\(recipe.id)")
                            }
                        } label: {
                            favoriteRow(title: recipe.title, subtitle: recipe.cookTime.rawValue)
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color.white.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
        .padding(.horizontal)
        .padding(.bottom, 6)
    }

    private var bottomButtons: some View {
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
        .padding(.bottom, 24)
    }

    // MARK: - Row (same style as RecipeResultsView)

    private func favoriteRow(title: String, subtitle: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)

                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.white.opacity(0.6))
        }
        .padding()
        .background(Color.white.opacity(0.15))
        .cornerRadius(18)
    }
}
