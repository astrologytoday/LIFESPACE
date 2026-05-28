import Foundation

struct Recipe: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let detailedIngredients: [String]
    let indexIngredients: [String]
    let methodSteps: [String]

    // Already upgraded to support multiple disorders
    let disorders: [RecipeMood]

    // NEW: multiple mealtimes
    let mealTypes: [MealType]

    let neurotransmitters: [Neurotransmitter]
    let cookTimeCategory: String
    let primaryIngredients: [PrimaryIngredient]

    // Primary initializer (use this for new recipes)
    init(
        id: String,
        title: String,
        subtitle: String,
        detailedIngredients: [String],
        indexIngredients: [String],
        methodSteps: [String],
        disorders: [RecipeMood],
        mealTypes: [MealType],
        neurotransmitters: [Neurotransmitter],
        cookTimeCategory: String,
        primaryIngredients: [PrimaryIngredient]
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.detailedIngredients = detailedIngredients
        self.indexIngredients = indexIngredients
        self.methodSteps = methodSteps
        self.disorders = disorders
        self.mealTypes = mealTypes
        self.neurotransmitters = neurotransmitters
        self.cookTimeCategory = cookTimeCategory
        self.primaryIngredients = primaryIngredients
    }

    // BACKWARDS-COMPAT: lets old calls with `mealType:` keep working
    init(
        id: String,
        title: String,
        subtitle: String,
        detailedIngredients: [String],
        indexIngredients: [String],
        methodSteps: [String],
        disorders: [RecipeMood],
        mealType: MealType,
        neurotransmitters: [Neurotransmitter],
        cookTimeCategory: String,
        primaryIngredients: [PrimaryIngredient]
    ) {
        self.init(
            id: id,
            title: title,
            subtitle: subtitle,
            detailedIngredients: detailedIngredients,
            indexIngredients: indexIngredients,
            methodSteps: methodSteps,
            disorders: disorders,
            mealTypes: [mealType],
            neurotransmitters: neurotransmitters,
            cookTimeCategory: cookTimeCategory,
            primaryIngredients: primaryIngredients
        )
    }
}
