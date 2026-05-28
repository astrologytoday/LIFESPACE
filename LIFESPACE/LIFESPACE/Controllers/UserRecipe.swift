//
//  UserRecipe.swift
//  LIFESPACE
//
//  Created by Mario Sbardella on 2025-12-16.
//

import Foundation

enum UserRecipeCookTime: String, CaseIterable, Codable {
    case quick = "5-15 minutes"
    case medium = "15-60 minutes"
    case long = "1 Hour +"
}

struct UserRecipe: Identifiable, Codable, Equatable {
    var id: String
    var title: String
    var subtitle: String
    var cookTime: UserRecipeCookTime

    var detailedIngredients: [String]
    var indexIngredients: [String]
    var methodSteps: [String]

    /// Stored as raw strings for safe Codable + backward compatibility.
    /// (MealType itself does not need to be Codable.)
    var mealTypeRawValues: [String]

    var isFavorite: Bool = false

    /// Convenience for app logic (MealPlanner favorites auto-populate, filtering, etc.)
    var mealTypes: [MealType] {
        let decoded = mealTypeRawValues.compactMap { MealType(rawValue: $0) }
        return decoded.isEmpty ? [.dinner] : decoded
    }

    init(
        id: String = UUID().uuidString,
        title: String,
        subtitle: String,
        cookTime: UserRecipeCookTime,
        detailedIngredients: [String],
        indexIngredients: [String],
        methodSteps: [String],
        mealTypes: [MealType] = [.dinner],
        isFavorite: Bool = false
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.cookTime = cookTime
        self.detailedIngredients = detailedIngredients
        self.indexIngredients = indexIngredients
        self.methodSteps = methodSteps
        self.mealTypeRawValues = mealTypes.map { $0.rawValue }
        self.isFavorite = isFavorite
    }

    // MARK: - Codable (backward safe)

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case subtitle
        case cookTime
        case detailedIngredients
        case indexIngredients
        case methodSteps
        case mealTypeRawValues
        case isFavorite
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try c.decode(String.self, forKey: .id)
        self.title = try c.decode(String.self, forKey: .title)
        self.subtitle = try c.decode(String.self, forKey: .subtitle)
        self.cookTime = try c.decode(UserRecipeCookTime.self, forKey: .cookTime)
        self.detailedIngredients = try c.decode([String].self, forKey: .detailedIngredients)
        self.indexIngredients = try c.decode([String].self, forKey: .indexIngredients)
        self.methodSteps = try c.decode([String].self, forKey: .methodSteps)

        // Backward compatibility: old saved recipes won't have this key
        self.mealTypeRawValues = try c.decodeIfPresent([String].self, forKey: .mealTypeRawValues)
        ?? [MealType.dinner.rawValue]

        self.isFavorite = try c.decodeIfPresent(Bool.self, forKey: .isFavorite) ?? false
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(title, forKey: .title)
        try c.encode(subtitle, forKey: .subtitle)
        try c.encode(cookTime, forKey: .cookTime)
        try c.encode(detailedIngredients, forKey: .detailedIngredients)
        try c.encode(indexIngredients, forKey: .indexIngredients)
        try c.encode(methodSteps, forKey: .methodSteps)
        try c.encode(mealTypeRawValues, forKey: .mealTypeRawValues)
        try c.encode(isFavorite, forKey: .isFavorite)
    }
}
