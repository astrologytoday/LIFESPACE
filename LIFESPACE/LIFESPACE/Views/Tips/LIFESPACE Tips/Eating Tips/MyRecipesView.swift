import Foundation
import SwiftUI

struct MyRecipesView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var userRecipeStore: UserRecipeStore

    @State private var pendingDelete: UserRecipe? = nil

    var body: some View {
        ZONEBackgroundGradient()
            .overlay(
                VStack(spacing: 14) {

                    // Header (unchanged vibe)
                    Text("MY RECIPES")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.09))
                        .cornerRadius(14)
                        .padding(.top, 16)
                        .padding(.horizontal, 14)

                    // ✅ Recipes in their own scrolling container
                    recipesContainer
                        .padding(.horizontal, 14)

                    // ✅ Bottom row: long button + 2 circular buttons
                    bottomActionRow
                        .padding(.horizontal, 14)
                        .padding(.bottom, 24)
                }
            )
            .alert(item: $pendingDelete) { recipe in
                Alert(
                    title: Text("Delete this recipe?"),
                    message: Text("Are you sure you want to delete this recipe?"),
                    primaryButton: .destructive(Text("YES")) {
                        userRecipeStore.delete(id: recipe.id)
                    },
                    secondaryButton: .cancel(Text("NO"))
                )
            }
    }

    // MARK: - Recipes Container

    private var recipesContainer: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white.opacity(0.08))

            if userRecipeStore.recipes.isEmpty {
                Text("No recipes yet.")
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.vertical, 30)
            } else {
                ScrollView {
                    VStack(spacing: 14) {
                        ForEach(userRecipeStore.recipes) { recipe in
                            LifespaceCard {
                                HStack(spacing: 12) {

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(recipe.title)
                                            .font(.headline)
                                            .foregroundColor(.white)

                                        if !recipe.subtitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                            Text(recipe.subtitle)
                                                .font(.subheadline)
                                                .foregroundColor(.white.opacity(0.85))
                                        }

                                        Text(recipe.cookTime.rawValue)
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.7))
                                            .padding(.top, 2)
                                    }

                                    Spacer()

                                    Button {
                                        userRecipeStore.toggleFavorite(id: recipe.id)
                                    } label: {
                                        Image(systemName: recipe.isFavorite ? "heart.fill" : "heart")
                                            .font(.system(size: 20, weight: .semibold))
                                            .foregroundColor(recipe.isFavorite ? .red : .white)
                                    }
                                    .buttonStyle(.plain)

                                    // ✏️ Edit
                                    Button {
                                        withAnimation(.easeInOut(duration: 0.4)) {
                                            navModel.push("RecipePlannerView:\(recipe.id)")
                                        }
                                    } label: {
                                        Image(systemName: "square.and.pencil")
                                            .font(.system(size: 20, weight: .semibold))
                                            .foregroundColor(.white)
                                            .opacity(0.9)
                                    }
                                    .buttonStyle(.plain)

                                    Button {
                                        pendingDelete = recipe
                                    } label: {
                                        Image(systemName: "trash")
                                            .font(.system(size: 20, weight: .semibold))
                                            .foregroundColor(.white)
                                            .opacity(0.9)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                navModel.push("UserRecipeDetailView:\(recipe.id)")
                            }
                        }
                    }
                    .padding(14)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(maxHeight: .infinity)
    }

    // MARK: - Bottom Actions

    private var bottomActionRow: some View {
        HStack(spacing: 12) {

            Button {
                withAnimation(.easeInOut(duration: 0.4)) {
                    navModel.push("RecipePlannerView")
                }
            } label: {
                Text("MAKE A NEW RECIPE")
                    .font(.headline.bold())
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.14))
                    .cornerRadius(16)
            }

            // Back (pop)
            circleIconButton(systemName: "arrow.left") {
                withAnimation(.easeInOut(duration: 0.4)) {
                    navModel.selectedScreen = "EatingTipsView"
                }
            }

            // Home
            circleIconButton(systemName: "house.fill") {
                withAnimation(.easeInOut(duration: 0.4)) {
                    navModel.selectedScreen = "HomeView"
                }
            }
        }
        .padding(.top, 10)
    }

    private func circleIconButton(systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 52, height: 52)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
                .shadow(radius: 4)
        }
        .buttonStyle(.plain)
    }
}
