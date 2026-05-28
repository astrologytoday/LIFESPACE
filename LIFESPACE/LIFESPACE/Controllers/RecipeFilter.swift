import Foundation

struct RecipeFilter {
    let mealType: MealType?

    // Primary picks (unchanged)
    let disorder: RecipeMood?
    let primaryIngredient: PrimaryIngredient?

    // ✅ Minimal additions for 1–2 selection support
    let disorder2: RecipeMood?
    let primaryIngredient2: PrimaryIngredient?

    let neurotransmitter: Neurotransmitter?
    let cookTime: CookTimeCategory?

    // ✅ Optional search text for the textbox
    let searchText: String?

    // ✅ Backwards-compatible init (so your existing code keeps compiling)
    init(
        mealType: MealType? = nil,
        disorder: RecipeMood? = nil,
        primaryIngredient: PrimaryIngredient? = nil,
        neurotransmitter: Neurotransmitter? = nil,
        cookTime: CookTimeCategory? = nil
    ) {
        self.mealType = mealType
        self.disorder = disorder
        self.disorder2 = nil
        self.primaryIngredient = primaryIngredient
        self.primaryIngredient2 = nil
        self.neurotransmitter = neurotransmitter
        self.cookTime = cookTime
        self.searchText = nil
    }

    // ✅ New init used by RecipeIndexView for multi-select + search
    init(
        mealType: MealType? = nil,
        disorders: [RecipeMood] = [],
        primaryIngredients: [PrimaryIngredient] = [],
        neurotransmitter: Neurotransmitter? = nil,
        cookTime: CookTimeCategory? = nil,
        searchText: String? = nil
    ) {
        self.mealType = mealType
        self.disorder = disorders.first
        self.disorder2 = disorders.dropFirst().first
        self.primaryIngredient = primaryIngredients.first
        self.primaryIngredient2 = primaryIngredients.dropFirst().first
        self.neurotransmitter = neurotransmitter
        self.cookTime = cookTime
        self.searchText = searchText
    }
}
