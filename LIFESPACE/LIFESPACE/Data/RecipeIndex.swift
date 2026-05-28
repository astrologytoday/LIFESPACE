import Foundation
import SwiftUI

// MARK: - Enums for categorization

enum RecipeMood: String, CaseIterable {
    case depression
    case anxiety
    case adhd
    case psychosis
    case pssd
    case favorites
}

enum MealType: String, CaseIterable {
    case breakfast
    case lunch
    case dinner
}

enum PrimaryIngredient: String, CaseIterable {
    case toast, eggs, fruit, oats, pancakes, smoothie, baking, yogurt,
         burrito, sandwich, salad, fish, meat, rice, pizza, soup, burger,
         vegetable, pasta, tofu, other
}

enum Neurotransmitter: String, CaseIterable {
    case dopamine, acetylcholine, serotonin, gaba, epinephrine
}

enum CookTimeCategory: String, CaseIterable {
    case quick = "5–15 Minutes"
    case medium = "15–60 Minutes"
    case long = "1 Hour +"
}

extension MealType: CustomStringConvertible {
    var description: String { rawValue.capitalized }
}

extension RecipeMood: CustomStringConvertible {
    var description: String { rawValue.capitalized }
}

extension PrimaryIngredient: CustomStringConvertible {
    var description: String { rawValue.capitalized }
}

extension Neurotransmitter: CustomStringConvertible {
    var description: String { rawValue.capitalized }
}

extension CookTimeCategory: CustomStringConvertible {
    var description: String { rawValue }
}

// MARK: - Core Recipe Index Models

struct RecipeItem: Identifiable, Hashable {
    let id: String

    let title: String
    let destination: String
    let moods: [RecipeMood]
    let mealTypes: [MealType]
    let primaryIngredients: [PrimaryIngredient]
    let cookTime: CookTimeCategory
    let neurotransmitters: [Neurotransmitter]
    let ingredients: [String]
}

struct RecipeSearchItem: Identifiable {
    let id = UUID()
    let title: String
    let keywords: [String]
    let recipeTitle: String
}

// MARK: - Central Recipe Index shell

struct RecipeIndex {
    // Legacy arrays are effectively unused now, but you can keep placeholders if needed.
    static let depressionRecipes: [RecipeItem] = []
    static let allRecipes: [RecipeItem] = depressionRecipes
}

// MARK: - Filtered Recipes (Search / ResultsView)

extension RecipeIndex {

    static func filteredRecipes(using filter: RecipeFilter?) -> [RecipeItem] {

        // ✅ If coming from RecipeIndexView, use the saved multi-filter
        let useSaved = UserDefaults.standard.bool(forKey: "RecipeIndex_useSavedFilter")
        if useSaved {
            let rawSearch = (UserDefaults.standard.string(forKey: "RecipeIndex_searchText") ?? "")
            let q = rawSearch.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

            let disorderRaw = UserDefaults.standard.stringArray(forKey: "RecipeIndex_selectedDisorders") ?? []
            let mealTimeRaw = UserDefaults.standard.stringArray(forKey: "RecipeIndex_selectedMealTimes") ?? []
            let ingRaw      = UserDefaults.standard.stringArray(forKey: "RecipeIndex_selectedIngredients") ?? []

            let neuroRaw = UserDefaults.standard.string(forKey: "RecipeIndex_selectedNeuro") ?? ""
            let cookRaw  = UserDefaults.standard.string(forKey: "RecipeIndex_selectedCookTime") ?? ""

            let disorders: [RecipeMood] = disorderRaw.compactMap { RecipeMood(rawValue: $0) }
            let mealTimes: [MealType] = mealTimeRaw.compactMap { MealType(rawValue: $0) }
            let ingredients: [PrimaryIngredient] = ingRaw.compactMap { PrimaryIngredient(rawValue: $0) }

            let neuro: Neurotransmitter? = neuroRaw.isEmpty ? nil : Neurotransmitter(rawValue: neuroRaw)
            let cook: CookTimeCategory? = cookRaw.isEmpty ? nil : CookTimeCategory(rawValue: cookRaw)

            return unifiedRecipes.filter { recipe in

                // SEARCH
                let matchesSearch: Bool = {
                    guard !q.isEmpty else { return true }

                    let haystack: [String] =
                        [recipe.title] +
                        recipe.ingredients +
                        recipe.moods.map { $0.rawValue } +
                        recipe.neurotransmitters.map { $0.rawValue } +
                        recipe.primaryIngredients.map { $0.rawValue }

                    return haystack.contains { $0.lowercased().contains(q) }
                }()

                // DISORDER (OR)
                let matchesDisorder: Bool = {
                    guard !disorders.isEmpty else { return true }
                    return disorders.contains(where: { recipe.moods.contains($0) })
                }()

                // MEAL TIME (OR)
                let matchesMealTime: Bool = {
                    guard !mealTimes.isEmpty else { return true }
                    return mealTimes.contains(where: { recipe.mealTypes.contains($0) })
                }()

                // PRIMARY INGREDIENT (AND) — this is what makes fruit + yogurt strict
                let matchesIngredients: Bool = {
                    guard !ingredients.isEmpty else { return true }
                    return ingredients.allSatisfy { recipe.primaryIngredients.contains($0) }
                }()

                // NEURO
                let matchesNeuro: Bool = {
                    guard let neuro else { return true }
                    return recipe.neurotransmitters.contains(neuro)
                }()

                // COOK TIME
                let matchesCook: Bool = {
                    guard let cook else { return true }
                    return recipe.cookTime == cook
                }()

                return matchesSearch
                    && matchesDisorder
                    && matchesMealTime
                    && matchesIngredients
                    && matchesNeuro
                    && matchesCook
            }
        }

        // ✅ Otherwise, keep your existing behavior for other entry points
        guard let filter else { return unifiedRecipes }

        return unifiedRecipes.filter { recipe in
            let matchesMeal: Bool
            if let requestedMeal = filter.mealType {
                matchesMeal = recipe.mealTypes.contains(requestedMeal)
            } else {
                matchesMeal = true
            }

            let matchesDisorder =
                (filter.disorder == nil || recipe.moods.contains(filter.disorder!))

            let matchesIngredient =
                (filter.primaryIngredient == nil
                 || recipe.primaryIngredients.contains(filter.primaryIngredient!))

            let matchesNeuro =
                (filter.neurotransmitter == nil
                 || recipe.neurotransmitters.contains(filter.neurotransmitter!))

            let matchesCookTime =
                (filter.cookTime == nil || recipe.cookTime == filter.cookTime)

            return matchesMeal && matchesDisorder && matchesIngredient && matchesNeuro && matchesCookTime
        }
    }
}


extension RecipeIndex {

    static func randomRecipe(for mood: RecipeMood, mealType: MealType) -> RecipeItem? {
        let options = RecipeIndex.recipes(for: mood, mealType: mealType)
        return options.randomElement()
    }
}

// MARK: - Model → Index bridge (from RecipeData.swift)

extension Recipe {

    func asRecipeItem() -> RecipeItem {

        let mappedCookTime: CookTimeCategory = {
            let normalized = cookTimeCategory
                .lowercased()
                .replacingOccurrences(of: "–", with: "-")
                .trimmingCharacters(in: .whitespacesAndNewlines)

            switch normalized {
            case "5-15 minutes":
                return .quick
            case "15-60 minutes":
                return .medium
            case "1 hour +", "1 hour+", "60+ minutes":
                return .long
            default:
                return .medium
            }
        }()

        return RecipeItem(
            id: id,
            title: title,
            destination: "RecipeModel:\(id)",
            moods: disorders,
            mealTypes: mealTypes,
            primaryIngredients: primaryIngredients,
            cookTime: mappedCookTime,
            neurotransmitters: neurotransmitters,
            ingredients: indexIngredients
        )
    }
}

// MARK: - Unified Recipe Access (only modelRecipes now)

extension RecipeIndex {

    static var unifiedRecipes: [RecipeItem] {
        // All live recipes come from RecipeData.swift (modelRecipes)
        let model = modelRecipes.map { $0.asRecipeItem() }
        return model
    }
}

// MARK: - Unified Auto-Populate Helper (MealPlanner)

extension RecipeIndex {

    static func randomRecipeUnified(
        for mood: RecipeMood,
        mealType: MealType
    ) -> RecipeItem? {

        unifiedRecipes
            .filter {
                $0.moods.contains(mood)
                && $0.mealTypes.contains(mealType)
            }
            .randomElement()
    }
}

// MARK: - Grocery List Helper

extension RecipeIndex {

    static func groceryItems(from meals: [String: [String: String]]) -> [String] {

        let mealTitles: [String] = meals
            .flatMap { (_, dayMeals) in
                dayMeals.values
            }
            .filter { !$0.isEmpty }

        let ingredients: [String] = mealTitles
            .compactMap { title in
                RecipeIndex.recipe(named: title)
            }
            .flatMap { (recipeItem: RecipeItem) in
                recipeItem.ingredients
            }

        return Array(Set(ingredients)).sorted()
    }
}

// MARK: - Recipe Search Items for MealPlanner

extension RecipeIndex {

    static var recipeSearchItems: [RecipeSearchItem] {
        unifiedRecipes.map { recipeItem in
            RecipeSearchItem(
                title: recipeItem.title,
                keywords:
                    recipeItem.ingredients
                + recipeItem.moods.map { $0.rawValue }
                + recipeItem.neurotransmitters.map { $0.rawValue }
                + recipeItem.primaryIngredients.map { $0.rawValue },
                recipeTitle: recipeItem.title
            )
        }
    }
}

// MARK: - High-level recipe queries (used by DepressionRecipesView, etc.)

extension RecipeIndex {

    static func recipes(
        for mood: RecipeMood,
        mealType: MealType? = nil,
        ingredient: PrimaryIngredient? = nil,
        cookTime: CookTimeCategory? = nil,
        neurotransmitter: Neurotransmitter? = nil
    ) -> [RecipeItem] {
        if mood == .favorites {
            let favorites = unifiedRecipes.filter {
                UserDefaults.standard.bool(forKey: "favorite_\($0.id)")
                || UserDefaults.standard.bool(forKey: "favorite_\($0.title)") // legacy support
            }

            return favorites.filter { recipe in
                (mealType == nil || recipe.mealTypes.contains(mealType!))
                && (ingredient == nil || recipe.primaryIngredients.contains(ingredient!))
                && (cookTime == nil || recipe.cookTime == cookTime)
                && (neurotransmitter == nil || recipe.neurotransmitters.contains(neurotransmitter!))
            }
        }

        return unifiedRecipes.filter { recipe in
            recipe.moods.contains(mood)
            && (mealType == nil || recipe.mealTypes.contains(mealType!))
            && (ingredient == nil || recipe.primaryIngredients.contains(ingredient!))
            && (cookTime == nil || recipe.cookTime == cookTime)
            && (neurotransmitter == nil || recipe.neurotransmitters.contains(neurotransmitter!))
        }
    }
}

// MARK: - Lookup by title / free text

extension RecipeIndex {

    static func recipe(named title: String) -> RecipeItem? {
        unifiedRecipes.first { $0.title == title }
    }

    static func recipe(matching rawText: String) -> RecipeItem? {
        let normalized = rawText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !normalized.isEmpty else { return nil }
        return unifiedRecipes.first { $0.title.lowercased() == normalized }
    }
}

// MARK: - Search with mealType constraint (MealPlanner search box)



extension RecipeIndex {

    static func searchRecipes(
        query: String,
        mealType: MealType
    ) -> [RecipeSearchItem] {

        let normalizedQuery = query
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        guard !normalizedQuery.isEmpty else { return [] }

        let results = recipeSearchItems.filter { item in
            item.keywords.contains { keyword in
                keyword.lowercased().contains(normalizedQuery)
            }
        }

        // Only keep recipes that can be served at this mealtime
        return results.filter { item in
            if let recipe = RecipeIndex.recipe(named: item.recipeTitle) {
                return recipe.mealTypes.contains(mealType)
            }
            return false
        }
    }
}
