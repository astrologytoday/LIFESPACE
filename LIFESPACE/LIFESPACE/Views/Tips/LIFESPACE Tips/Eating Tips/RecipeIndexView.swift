import SwiftUI

struct RecipeIndexView: View {

    @EnvironmentObject var navModel: NavigationModel

    // SEARCH
    @State private var searchText: String = ""
    @State private var showSuggestions: Bool = false

    // MULTI-SELECT (max 2 each)
    @State private var selectedDisorders: [RecipeMood] = []
    @State private var selectedMealTimes: [MealType] = []
    @State private var selectedIngredients: [PrimaryIngredient] = []

    // SINGLE SELECT
    @State private var selectedNeuro: Neurotransmitter? = nil
    @State private var selectedCookTime: CookTimeCategory? = nil

    private let maxMultiSelect = 2

    private let mainGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 0.35, green: 0.80, blue: 0.75),
            Color(red: 0.20, green: 0.65, blue: 0.60),
            Color(red: 0.10, green: 0.45, blue: 0.45)
        ]),
        startPoint: .top,
        endPoint: .bottom
    )

    // ✅ disable Find Recipes if no criteria
    private var hasAnyCriteria: Bool {
        let typed = !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        return typed
            || !selectedDisorders.isEmpty
            || !selectedMealTimes.isEmpty
            || !selectedIngredients.isEmpty
            || selectedNeuro != nil
            || selectedCookTime != nil
    }

    // Suggestions from unified index keywords
    private var suggestionTitles: [String] {
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !q.isEmpty else { return [] }

        let titles = RecipeIndex.recipeSearchItems
            .filter { item in
                item.title.lowercased().contains(q)
                || item.keywords.contains(where: { $0.lowercased().contains(q) })
            }
            .map { $0.title }

        var seen = Set<String>()
        let unique = titles.filter { seen.insert($0.lowercased()).inserted }
        return Array(unique.prefix(6))
    }

    var body: some View {
        ZStack {
            mainGradient.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 18) {

                    // TITLE (now safe + scrollable)
                    VStack(spacing: 8) {
                        Text("RECIPE INDEX")
                            .font(.system(size: 34, weight: .heavy, design: .rounded))
                            .tracking(3)
                            .foregroundColor(.white)
                            .shadow(radius: 8)

                        Rectangle()
                            .fill(Color.white.opacity(0.85))
                            .frame(width: 260, height: 2)
                            .cornerRadius(1)
                    }
                    .padding(.top, 54)

                    // MAIN CARD
                    VStack(spacing: 16) {

                        // SEARCH BOX (TipsView look)
                        VStack(spacing: 8) {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.white.opacity(0.7))

                                TextField("Search recipes or ingredients…", text: $searchText)
                                    .foregroundColor(.white)
                                    .onChange(of: searchText) { _ in
                                        showSuggestions = !searchText
                                            .trimmingCharacters(in: .whitespacesAndNewlines)
                                            .isEmpty
                                    }

                                Spacer()
                            }
                            .padding()
                            .background(Color.white.opacity(0.15))
                            .cornerRadius(16)

                            if showSuggestions && !suggestionTitles.isEmpty {
                                VStack(spacing: 0) {
                                    ForEach(Array(suggestionTitles.enumerated()), id: \.offset) { index, title in
                                        Button {
                                            searchText = title
                                            showSuggestions = false
                                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                        } label: {
                                            HStack {
                                                Text(title)
                                                    .font(.custom("Avenir", size: 14))
                                                    .foregroundColor(.white)
                                                    .padding(.vertical, 12)
                                                Spacer()
                                            }
                                            .padding(.horizontal, 12)
                                            .background(Color.white.opacity(0.18))
                                        }
                                        .buttonStyle(.plain)

                                        if index < suggestionTitles.count - 1 {
                                            Rectangle()
                                                .fill(Color.white.opacity(0.12))
                                                .frame(height: 0.6)
                                                .padding(.horizontal, 12)
                                        }
                                    }
                                }
                                .cornerRadius(14)
                                .transition(.opacity)
                            }
                        }
                        .zIndex(10)

                        filterSection(title: "MEAL TIME") {
                            multiBubbleGrid(items: MealType.allCases, selection: $selectedMealTimes)
                        }

                        filterSection(title: "SUPPORT") {
                            multiBubbleGrid(
                                items: RecipeMood.allCases.filter { $0 != .favorites },
                                selection: $selectedDisorders
                            )
                        }

                        // PrimaryIngredient
                        filterSection(title: "MEAL TYPE") {
                            multiBubbleGrid(items: PrimaryIngredient.allCases, selection: $selectedIngredients)
                        }

                        filterSection(title: "NEUROTRANSMITTER") {
                            singleBubbleGrid(items: Neurotransmitter.allCases, selection: $selectedNeuro)
                        }

                        filterSection(title: "COOK TIME") {
                            singleBubbleGrid(items: CookTimeCategory.allCases, selection: $selectedCookTime)
                        }

                        // FIND RECIPES (disabled if no criteria)
                        Button {
                            persistSelectionsForResults()
                            navModel.push("RecipeResultsView")
                        } label: {
                            Text("FIND RECIPES")
                                .font(.custom("Avenir-Heavy", size: 16))
                                .foregroundColor(hasAnyCriteria ? .black : .black.opacity(0.35))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(
                                    hasAnyCriteria
                                        ? Color.white.opacity(0.95)
                                        : Color.white.opacity(0.45)
                                )
                                .cornerRadius(16)
                                .shadow(radius: hasAnyCriteria ? 4 : 0)
                        }
                        .disabled(!hasAnyCriteria)
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 22)
                            .fill(Color.white.opacity(0.12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 22)
                                    .stroke(Color.white.opacity(0.25), lineWidth: 1)
                            )
                    )
                    .padding(.horizontal, 20)

                    // extra bottom padding so button never feels clipped
                    Spacer(minLength: 30)
                }
            }
        }
        .onTapGesture { showSuggestions = false }
    }

    // MARK: - SECTION UI

    private func filterSection<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.custom("Avenir-Heavy", size: 14))
                .foregroundColor(.white.opacity(0.9))

            content()
        }
    }

    private func multiBubbleGrid<T: Hashable & CustomStringConvertible>(
        items: [T],
        selection: Binding<[T]>
    ) -> some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 110), spacing: 10)], spacing: 10) {
            ForEach(items, id: \.self) { item in
                let isSelected = selection.wrappedValue.contains(item)

                Button {
                    if isSelected {
                        selection.wrappedValue.removeAll { $0 == item }
                    } else if selection.wrappedValue.count < maxMultiSelect {
                        selection.wrappedValue.append(item)
                    }
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                } label: {
                    Text(item.description.uppercased())
                        .font(.custom("Avenir-Heavy", size: 12))
                        .foregroundColor(isSelected ? .black : .white)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(isSelected ? Color.white : Color.white.opacity(0.18))
                        .cornerRadius(14)
                        .shadow(radius: isSelected ? 4 : 0)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func singleBubbleGrid<T: Hashable & CustomStringConvertible>(
        items: [T],
        selection: Binding<T?>
    ) -> some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 110), spacing: 10)], spacing: 10) {
            ForEach(items, id: \.self) { item in
                let isSelected = selection.wrappedValue == item

                Button {
                    selection.wrappedValue = isSelected ? nil : item
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                } label: {
                    Text(item.description.uppercased())
                        .font(.custom("Avenir-Heavy", size: 12))
                        .foregroundColor(isSelected ? .black : .white)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(isSelected ? Color.white : Color.white.opacity(0.18))
                        .cornerRadius(14)
                        .shadow(radius: isSelected ? 4 : 0)
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - SAVE FOR RESULTS / FILTER ENGINE

    private func persistSelectionsForResults() {
        UserDefaults.standard.set(true, forKey: "RecipeIndex_useSavedFilter")

        UserDefaults.standard.set(searchText, forKey: "RecipeIndex_searchText")
        UserDefaults.standard.set(selectedDisorders.map { $0.rawValue }, forKey: "RecipeIndex_selectedDisorders")
        UserDefaults.standard.set(selectedMealTimes.map { $0.rawValue }, forKey: "RecipeIndex_selectedMealTimes")
        UserDefaults.standard.set(selectedIngredients.map { $0.rawValue }, forKey: "RecipeIndex_selectedIngredients")

        UserDefaults.standard.set(selectedNeuro?.rawValue ?? "", forKey: "RecipeIndex_selectedNeuro")
        UserDefaults.standard.set(selectedCookTime?.rawValue ?? "", forKey: "RecipeIndex_selectedCookTime")
    }
}
