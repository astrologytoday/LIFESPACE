import Foundation

struct GroceryItem: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    var isChecked: Bool
    var category: IngredientCategory

    init(
        id: UUID = UUID(),
        name: String,
        isChecked: Bool = false,
        category: IngredientCategory? = nil
    ) {
        self.id = id
        self.name = name
        self.isChecked = isChecked
        self.category = category ?? IngredientIndex.category(for: name)
    }
}
