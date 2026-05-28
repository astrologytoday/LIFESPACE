//
//  UserRecipeStore.swift
//  LIFESPACE
//
//  Created by Mario Sbardella on 2025-12-16.
//

import Foundation
import SwiftUI

@MainActor
final class UserRecipeStore: ObservableObject {

    @AppStorage("userRecipesData") private var userRecipesData: String = ""

    @Published private(set) var recipes: [UserRecipe] = []

    init() {
        load()
    }

    func load() {
        guard !userRecipesData.isEmpty,
              let data = userRecipesData.data(using: .utf8) else {
            recipes = []
            return
        }

        do {
            recipes = try JSONDecoder().decode([UserRecipe].self, from: data)
        } catch {
            recipes = []
        }
    }

    private func save() {
        do {
            let data = try JSONEncoder().encode(recipes)
            userRecipesData = String(decoding: data, as: UTF8.self)
        } catch {
            // If encoding fails, do nothing (keeps last good save)
        }
    }

    func add(_ recipe: UserRecipe) {
        recipes.insert(recipe, at: 0)
        save()
    }

    func delete(id: String) {
        recipes.removeAll { $0.id == id }
        save()
    }

    func toggleFavorite(id: String) {
        guard let idx = recipes.firstIndex(where: { $0.id == id }) else { return }
        recipes[idx].isFavorite.toggle()
        save()
    }

    func update(_ recipe: UserRecipe) {
        guard let idx = recipes.firstIndex(where: { $0.id == recipe.id }) else { return }
        recipes[idx] = recipe
        save()
    }

    func recipe(id: String) -> UserRecipe? {
        recipes.first(where: { $0.id == id })
    }
}
