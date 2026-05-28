//
//  RecipePlannerView.swift
//  LIFESPACE
//
//  Created by Mario Sbardella on 2025-12-16.
//

import Foundation
import SwiftUI

struct RecipePlannerView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var userRecipeStore: UserRecipeStore

    /// If provided, this view loads the existing recipe and saves edits back into the store.
    let recipeID: String?

    init(recipeID: String? = nil) {
        self.recipeID = recipeID
    }

    @State private var title: String = ""
    @State private var subtitle: String = ""
    @State private var cookTime: UserRecipeCookTime = .medium

    // ✅ NEW: meal-type selection (checkboxes)
    @State private var selectedMealTypes: Set<MealType> = [.dinner]

    @State private var ingredientText: String = ""
    @State private var methodText: String = ""
    @State private var groceryText: String = ""

    @State private var detailedIngredients: [String] = []
    @State private var methodSteps: [String] = []
    @State private var indexIngredients: [String] = []

    @State private var didLoadForEdit: Bool = false

    private var isEditing: Bool {
        recipeID != nil
    }

    private var existingRecipe: UserRecipe? {
        guard let id = recipeID else { return nil }
        return userRecipeStore.recipe(id: id)
    }

    private var isReady: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        && !detailedIngredients.isEmpty
        && !methodSteps.isEmpty
        && !selectedMealTypes.isEmpty
    }

    private func trimmed(_ s: String) -> String {
        s.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        ZONEBackgroundGradient()
            .overlay(
                ScrollView {
                    VStack(spacing: 22) {

                        Text(isEditing ? "EDIT RECIPE" : "MAKE A NEW RECIPE")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.09))
                            .cornerRadius(14)
                            .padding(.top, 16)

                        // Title
                        LifespaceCard {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Title:")
                                    .font(.headline)
                                    .foregroundColor(.white)

                                TextField("Enter title…", text: $title)
                                    .padding(10)
                                    .background(Color.white.opacity(0.16))
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                            }
                        }

                        // Subtitle
                        LifespaceCard {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Subtitle:")
                                    .font(.headline)
                                    .foregroundColor(.white)

                                TextField("Enter subtitle…", text: $subtitle)
                                    .padding(10)
                                    .background(Color.white.opacity(0.16))
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                            }
                        }

                        // Cook time
                        LifespaceCard {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Cook/Prep Time:")
                                    .font(.headline)
                                    .foregroundColor(.white)

                                Picker("Cook/Prep Time", selection: $cookTime) {
                                    ForEach(UserRecipeCookTime.allCases, id: \.self) { t in
                                        Text(t.rawValue).tag(t)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(height: 110)
                                .clipped()
                            }
                        }

                        // ✅ Meal Types
                        LifespaceCard {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Meal Type:")
                                    .font(.headline)
                                    .foregroundColor(.white)

                                mealTypeRow(.breakfast, label: "Breakfast")
                                mealTypeRow(.lunch, label: "Lunch")
                                mealTypeRow(.dinner, label: "Dinner")
                            }
                        }

                        // Ingredients & Measurements
                        listEditorCard(
                            title: "Ingredients & Measurements:",
                            items: $detailedIngredients,
                            text: $ingredientText,
                            placeholder: "Add ingredient…"
                        )

                        // Method
                        listEditorCard(
                            title: "Method:",
                            items: $methodSteps,
                            text: $methodText,
                            placeholder: "Add step…"
                        )

                        // Grocery Items
                        listEditorCard(
                            title: "Grocery Items:",
                            items: $indexIngredients,
                            text: $groceryText,
                            placeholder: "Add grocery item…"
                        )

                        // ✅ Bottom row
                        HStack(spacing: 14) {
                            Button {
                                if isEditing, let existing = existingRecipe {
                                    let updated = UserRecipe(
                                        id: existing.id,
                                        title: trimmed(title),
                                        subtitle: trimmed(subtitle),
                                        cookTime: cookTime,
                                        detailedIngredients: detailedIngredients,
                                        indexIngredients: sanitizedIndexIngredients(indexIngredients),
                                        methodSteps: methodSteps,
                                        mealTypes: Array(selectedMealTypes),
                                        isFavorite: existing.isFavorite
                                    )

                                    userRecipeStore.update(updated)
                                    withAnimation(.easeInOut(duration: 0.4)) {
                                        navModel.pop()
                                    }
                                } else {
                                    let newRecipe = UserRecipe(
                                        title: trimmed(title),
                                        subtitle: trimmed(subtitle),
                                        cookTime: cookTime,
                                        detailedIngredients: detailedIngredients,
                                        indexIngredients: sanitizedIndexIngredients(indexIngredients),
                                        methodSteps: methodSteps,
                                        mealTypes: Array(selectedMealTypes),
                                        isFavorite: false
                                    )

                                    userRecipeStore.add(newRecipe)
                                    withAnimation(.easeInOut(duration: 0.4)) {
                                        navModel.push("MyRecipesView")
                                    }
                                }
                            } label: {
                                Text(isEditing ? "SAVE CHANGES" : "MAKE RECIPE")
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(isReady ? Color.teal : Color.gray)
                                    .cornerRadius(18)
                            }
                            .disabled(!isReady)

                            Button {
                                withAnimation(.easeInOut(duration: 0.4)) {
                                    navModel.pop()
                                }
                            } label: {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: 56, height: 56)
                                    .background(Color.white.opacity(0.14))
                                    .clipShape(Circle())
                                    .shadow(color: .black.opacity(0.18), radius: 10, y: 6)
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.bottom, 20)
                    }
                    .padding(.horizontal, 14)
                }
            )
            .onAppear {
                populateFromExistingIfNeeded()
            }
    }

    private func populateFromExistingIfNeeded() {
        guard !didLoadForEdit,
              let id = recipeID,
              let r = userRecipeStore.recipe(id: id) else {
            return
        }

        title = r.title
        subtitle = r.subtitle
        cookTime = r.cookTime
        detailedIngredients = r.detailedIngredients
        methodSteps = r.methodSteps
        indexIngredients = r.indexIngredients
        selectedMealTypes = Set(r.mealTypes)

        didLoadForEdit = true
    }

    // MARK: - Meal type checkbox rows

    private func toggleMealType(_ type: MealType) {
        if selectedMealTypes.contains(type) {
            // Prevent zero selections
            guard selectedMealTypes.count > 1 else { return }
            selectedMealTypes.remove(type)
        } else {
            selectedMealTypes.insert(type)
        }
    }

    @ViewBuilder
    private func mealTypeRow(_ type: MealType, label: String) -> some View {
        let isOn = selectedMealTypes.contains(type)

        Button {
            toggleMealType(type)
        } label: {
            HStack(spacing: 10) {
                Image(systemName: isOn ? "checkmark.square.fill" : "square")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(isOn ? Color(red: 0.15, green: 0.60, blue: 0.40) : .white.opacity(0.75))

                Text(label.uppercased())
                    .font(.custom("Avenir-Heavy", size: 14))
                    .foregroundColor(.white)

                Spacer()
            }
            .padding(.vertical, 6)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Reusable list editor card

    @ViewBuilder
    private func listEditorCard(
        title: String,
        items: Binding<[String]>,
        text: Binding<String>,
        placeholder: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)

            ForEach(Array(items.wrappedValue.enumerated()), id: \.offset) { idx, item in
                HStack {
                    Text(item)
                        .foregroundColor(.white)
                    Spacer()
                    Button {
                        items.wrappedValue.remove(at: idx)
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.red)
                    }
                }
            }

            HStack {
                TextField(placeholder, text: text)
                    .padding(10)
                    .background(Color.white.opacity(0.16))
                    .cornerRadius(10)
                    .foregroundColor(.white)

                Button {
                    let t = trimmed(text.wrappedValue)
                    guard !t.isEmpty else { return }
                    items.wrappedValue.append(t)
                    text.wrappedValue = ""
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 26))
                }
                .disabled(trimmed(text.wrappedValue).isEmpty)
            }
        }
        .padding()
        .background(Color.white.opacity(0.12))
        .cornerRadius(12)
    }

    // Quiet sanitization for indexIngredients
    private func sanitizedIndexIngredients(_ items: [String]) -> [String] {
        let blocked = Set(["butter", "olive oil", "salt", "pepper"])
        return items.filter { !blocked.contains(trimmed($0).lowercased()) }
    }
}
