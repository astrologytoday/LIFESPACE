import SwiftUI

struct RecipeResultsView: View {
    @EnvironmentObject var navModel: NavigationModel

    private var recipes: [RecipeItem] {
        RecipeIndex.filteredRecipes(using: RecipeResultsStore.shared.filter)
    }

    // Group by MealType using mealTypes (plural)
    private var mealSections: [(mealType: MealType, items: [RecipeItem])] {
        MealType.allCases.compactMap { mealType in
            let items = recipes.filter { $0.mealTypes.contains(mealType) }
            return items.isEmpty ? nil : (mealType, items)
        }
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

    // MARK: - Pieces

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
        Text("RECIPE RESULTS")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.top, 36)
    }

    private var scrollContainer: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {

                if recipes.isEmpty {
                    Text("No recipes match your selections.")
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.top, 24)
                        .frame(maxWidth: .infinity, alignment: .center)

                } else {
                    ForEach(mealSections, id: \.mealType) { section in
                        mealHeader(section.mealType)

                        ForEach(section.items) { recipe in
                            Button {
                                withAnimation(.easeInOut(duration: 0.4)) {
                                    navModel.push(recipe.destination)
                                }
                            } label: {
                                recipeRow(for: recipe)
                            }
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

    private func mealHeader(_ mealType: MealType) -> some View {
        Text(mealType.rawValue.capitalized)
            .font(.title2.weight(.bold))
            .foregroundColor(.white)
            .padding(.leading, 6)
            .padding(.vertical, 2)
    }

    private var bottomButtons: some View {
        HStack(spacing: 40) {
            Button {
                withAnimation(.easeInOut(duration: 0.4)) {
                    navModel.selectedScreen = "EatingTipsView"
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

    // MARK: - Recipe Row

    private func recipeRow(for recipe: RecipeItem) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)

                Text(recipe.cookTime.rawValue)
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
