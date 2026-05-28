import SwiftUI

struct GroceryListView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var userRecipeStore: UserRecipeStore

    @AppStorage("mealPlan") private var mealData: String = ""
    @AppStorage("mealPlanFingerprint") private var mealFingerprint: String = ""

    @AppStorage("groceryItemsData") private var groceryItemsData: String = ""
    @AppStorage("groceryFingerprint") private var groceryFingerprint: String = ""

    @AppStorage("manualGroceryItemsData") private var manualGroceryItemsData: String = ""

    @State private var groceryItems: [GroceryItem] = []
    @State private var manualItems: [GroceryItem] = []
    @State private var newItemText: String = ""
    @State private var showClearListPopup = false

    private let sectionOrder: [IngredientCategory] = [
        .produce,
        .grains,
        .meatFish,
        .dairy,
        .herbsSpices,
        .saucesBroth,
        .other
    ]

    private func key(_ s: String) -> String {
        s.trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
            .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
    }

    private func sortItems(_ items: [GroceryItem], in category: IngredientCategory) -> [GroceryItem] {
        let order = IngredientIndex.subcategoryOrderByCategory[category] ?? [.other]

        return items.sorted { a, b in
            let sa = IngredientIndex.subcategory(for: a.name, in: category)
            let sb = IngredientIndex.subcategory(for: b.name, in: category)
            let ia = order.firstIndex(of: sa) ?? order.count
            let ib = order.firstIndex(of: sb) ?? order.count

            if ia != ib { return ia < ib }

            return a.name.localizedCaseInsensitiveCompare(b.name) == .orderedAscending
        }
    }

    enum GroceryRow: Identifiable, Equatable {
        case header(IngredientCategory)
        case item(GroceryItem)

        var id: String {
            switch self {
            case .header(let category):
                return "header-\(category.rawValue)"
            case .item(let item):
                return item.id.uuidString
            }
        }
    }

    private var rows: [GroceryRow] {
        sectionOrder.flatMap { category -> [GroceryRow] in
            let items = groceryItems.filter { $0.category == category }
            guard !items.isEmpty else { return [] }

            let ordered = sortItems(items, in: category)

            return [.header(category)] + ordered.map { GroceryRow.item($0) }
        }
    }

    var body: some View {
        ZStack {
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

            VStack(spacing: 18) {
                Text("GROCERY LIST")
                    .font(.custom("Avenir-Heavy", size: 28))
                    .foregroundColor(.white)
                    .padding(.top, 16)

                HStack {
                    TextField("Add item…", text: $newItemText)
                        .font(.custom("Avenir", size: 16))
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color.white.opacity(0.18))
                        .cornerRadius(12)

                    Button {
                        addManualItem()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.white)
                    }
                    .disabled(newItemText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding(.horizontal)

                List {
                    ForEach(rows) { row in
                        switch row {
                        case .header(let category):
                            Text(category.rawValue)
                                .font(.custom("Avenir-Heavy", size: 14))
                                .foregroundColor(.white.opacity(0.8))
                                .padding(.top, 8)
                                .padding(.leading, 16)
                                .listRowBackground(Color.clear)
                                .moveDisabled(true)

                        case .item(let item):
                            groceryRow(item: binding(for: item))
                                .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                                .listRowBackground(Color.clear)
                                .tint(Color(red: 0.10, green: 0.45, blue: 0.45))
                                .moveDisabled(false)
                        }
                    }
                    .onMove(perform: moveRow)
                }
                .listStyle(.plain)
                .environment(\.editMode, .constant(.active))
                .scrollContentBackground(.hidden)
                .background(Color.clear)

                Spacer(minLength: 8)

                Button {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        showClearListPopup = true
                    }
                } label: {
                    Text("DONE SHOPPING")
                        .font(.custom("Avenir-Heavy", size: 16))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.red.opacity(0.65))
                        .cornerRadius(14)
                        .padding(.horizontal, 40)
                }

                Button {
                    navModel.pop()
                } label: {
                    Text("BACK")
                        .font(.custom("Avenir-Heavy", size: 16))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(14)
                        .padding(.horizontal, 40)
                }
                .padding(.bottom, 12)
            }

            if showClearListPopup {
                Color.black.opacity(0.35)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            showClearListPopup = false
                        }
                    }

                VStack(spacing: 22) {
                    Text("Clear List?")
                        .font(.custom("Avenir-Heavy", size: 26))
                        .foregroundColor(.white)

                    HStack(spacing: 18) {
                        Button {
                            clearList()

                            withAnimation(.easeInOut(duration: 0.25)) {
                                showClearListPopup = false
                            }
                        } label: {
                            Text("YES")
                                .font(.custom("Avenir-Heavy", size: 16))
                                .foregroundColor(Color(red: 0.05, green: 0.35, blue: 0.38))
                                .frame(width: 90)
                                .padding(.vertical, 10)
                                .background(Color.white.opacity(0.95))
                                .cornerRadius(14)
                        }

                        Button {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                showClearListPopup = false
                            }
                        } label: {
                            Text("NO")
                                .font(.custom("Avenir-Heavy", size: 16))
                                .foregroundColor(.white)
                                .frame(width: 90)
                                .padding(.vertical, 10)
                                .background(Color.white.opacity(0.22))
                                .cornerRadius(14)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(Color.white.opacity(0.55), lineWidth: 1)
                                )
                        }
                    }
                }
                .padding(.vertical, 28)
                .padding(.horizontal, 30)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color(red: 0.10, green: 0.45, blue: 0.45).opacity(0.96))
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color.white.opacity(0.35), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.25), radius: 18, x: 0, y: 8)
                )
                .padding(.horizontal, 34)
                .transition(.scale(scale: 0.92).combined(with: .opacity))
                .zIndex(10)
            }
        }
        .onAppear {
            manualItems = decodeManualItems()
            syncGroceryList()
        }
        .onChange(of: groceryItems) { _ in
            saveGroceryItems()
        }
    }

    private func groceryRow(item: Binding<GroceryItem>) -> some View {
        HStack {
            Image(systemName: item.wrappedValue.isChecked ? "checkmark.square.fill" : "square")
                .font(.system(size: 22))
                .foregroundColor(
                    item.wrappedValue.isChecked
                        ? Color(red: 0.15, green: 0.60, blue: 0.40)
                        : .white.opacity(0.7)
                )
                .contentShape(Rectangle())
                .highPriorityGesture(
                    TapGesture().onEnded {
                        item.wrappedValue.isChecked.toggle()
                    }
                )

            Text(item.wrappedValue.name)
                .font(.custom("Avenir", size: 16))
                .foregroundColor(.white)
                .strikethrough(item.wrappedValue.isChecked, color: .white.opacity(0.6))

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.25))
        )
        .cornerRadius(12)
        .contentShape(Rectangle())
        .onTapGesture {
            item.wrappedValue.isChecked.toggle()
        }
    }

    private func moveRow(from source: IndexSet, to destination: Int) {
        var workingRows = rows
        workingRows.move(fromOffsets: source, toOffset: destination)

        var rebuilt: [GroceryItem] = []
        var currentCategory: IngredientCategory = .other

        for row in workingRows {
            switch row {
            case .header(let category):
                currentCategory = category
            case .item(var item):
                item.category = currentCategory
                rebuilt.append(item)
            }
        }

        groceryItems = rebuilt
    }

    private func syncGroceryList() {
        let meals = decodeMeals()

        let legacyIngredients = RecipeIndex.groceryItems(from: meals)

        let modelIngredients: [String] = meals
            .flatMap { $0.value.values }
            .compactMap { mealTitle in
                modelRecipes.first {
                    $0.title.caseInsensitiveCompare(mealTitle) == .orderedSame
                }?.indexIngredients
            }
            .flatMap { $0 }

        let userIngredients: [String] = meals
            .flatMap { $0.value.values }
            .compactMap { mealTitle in
                userRecipeStore.recipes.first {
                    $0.title.caseInsensitiveCompare(mealTitle) == .orderedSame
                }?.indexIngredients
            }
            .flatMap { $0 }

        let derivedNames = Array(Set(legacyIngredients + modelIngredients + userIngredients))

        if groceryFingerprint == mealFingerprint, let savedMerged = decodeGroceryItems() {
            var dict: [String: GroceryItem] = [:]

            for item in savedMerged {
                dict[key(item.name)] = item
            }

            for item in manualItems {
                dict[key(item.name)] = item
            }

            groceryItems = Array(dict.values)

            return
        }

        let savedMerged = decodeGroceryItems() ?? []

        let derivedItems: [GroceryItem] = derivedNames.map { name in
            if let manual = manualItems.first(where: { key($0.name) == key(name) }) {
                return manual
            }

            if let existing = savedMerged.first(where: { key($0.name) == key(name) }) {
                return existing
            }

            return GroceryItem(name: name)
        }

        var dict: [String: GroceryItem] = [:]

        for item in derivedItems {
            dict[key(item.name)] = item
        }

        for item in manualItems {
            dict[key(item.name)] = item
        }

        groceryItems = Array(dict.values)
        groceryFingerprint = mealFingerprint
        saveGroceryItems()
    }

    private func addManualItem() {
        let trimmed = newItemText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmed.isEmpty else { return }

        if let existing = groceryItems.first(where: { key($0.name) == key(trimmed) }) {
            if !manualItems.contains(where: { key($0.name) == key(trimmed) }) {
                manualItems.append(existing)
            }

            newItemText = ""
            saveGroceryItems()

            return
        }

        let item = GroceryItem(name: trimmed)

        manualItems.append(item)
        groceryItems.append(item)

        newItemText = ""
        saveGroceryItems()
    }

    private func clearList() {
        groceryItems.removeAll()
        manualItems.removeAll()
        saveGroceryItems()
    }

    private func saveGroceryItems() {
        if let encoded = try? JSONEncoder().encode(groceryItems) {
            groceryItemsData = String(data: encoded, encoding: .utf8) ?? ""
        }

        for i in manualItems.indices {
            if let live = groceryItems.first(where: { key($0.name) == key(manualItems[i].name) }) {
                manualItems[i].isChecked = live.isChecked
                manualItems[i].category = live.category
            }
        }

        if let encodedManual = try? JSONEncoder().encode(manualItems) {
            manualGroceryItemsData = String(data: encodedManual, encoding: .utf8) ?? ""
        }
    }

    private func decodeGroceryItems() -> [GroceryItem]? {
        guard let data = groceryItemsData.data(using: .utf8) else { return nil }

        return try? JSONDecoder().decode([GroceryItem].self, from: data)
    }

    private func decodeManualItems() -> [GroceryItem] {
        guard !manualGroceryItemsData.isEmpty,
              let data = manualGroceryItemsData.data(using: .utf8),
              let decoded = try? JSONDecoder().decode([GroceryItem].self, from: data)
        else {
            return []
        }

        return decoded
    }

    private func decodeMeals() -> [String: [String: String]] {
        guard let data = mealData.data(using: .utf8),
              let decoded = try? JSONDecoder().decode([String: [String: String]].self, from: data)
        else {
            return [:]
        }

        return decoded
    }

    private func binding(for item: GroceryItem) -> Binding<GroceryItem> {
        guard let index = groceryItems.firstIndex(of: item) else {
            fatalError("Grocery item not found")
        }

        return $groceryItems[index]
    }
}
