import Foundation

final class RecipeResultsStore {
    static let shared = RecipeResultsStore()
    private init() {}

    var filter: RecipeFilter?
}
