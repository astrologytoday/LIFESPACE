import SwiftUI

struct MealPlannerView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var userRecipeStore: UserRecipeStore

    let days = ["SUNDAY", "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY"]

    @AppStorage("mealPlan") private var mealData: String = ""
    @AppStorage("mealPlanFingerprint") private var mealFingerprint: String = ""

    @FocusState private var focusedField: String?
    @State private var meals: [String: [String: String]] = [:]
    @State private var fadeMeals: [String: [String: Double]] = [:]

    // Context menu state
    @State private var contextMenuDay: String? = nil
    @State private var contextMenuMeal: String? = nil
    @State private var contextMenuFrame: CGRect = .zero
    @State private var showContextMenu = false

    // UI State
    @State private var showAutoPopulateBubble = false
    @State private var showNoFavoritesAlert = false
    @State private var focusedDay: String? = nil
    @State private var focusedFieldFrame: CGRect = .zero

    // NEW — help bubble (top-right ?)
    @State private var showHelpBubble = false

    private struct MealFieldFrameData: Equatable {
        let key: String
        let frame: CGRect
    }

    private struct MealFieldFramePreferenceKey: PreferenceKey {
        static var defaultValue: [MealFieldFrameData] = []
        static func reduce(value: inout [MealFieldFrameData], nextValue: () -> [MealFieldFrameData]) {
            value.append(contentsOf: nextValue())
        }
    }

    private func normalized(_ string: String) -> String {
        string
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
            .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
    }

    private let mainGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 0.35, green: 0.80, blue: 0.75),
            Color(red: 0.20, green: 0.65, blue: 0.60),
            Color(red: 0.10, green: 0.45, blue: 0.45)
        ]),
        startPoint: .top,
        endPoint: .bottom
    )

    var body: some View {
        ZStack(alignment: .topTrailing) {
            mainGradient
                .ignoresSafeArea()

            // TOP-RIGHT HELP BUTTON
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showHelpBubble.toggle()
                }
            }) {
                Image(systemName: "questionmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white.opacity(0.6))
                    .padding(7)
                    .background(Color.white.opacity(0.10))
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white.opacity(0.28), lineWidth: 0.8))
            }
            .padding(.top, 8)
            .padding(.trailing, 30)
            .zIndex(6000)

            VStack(spacing: 0) {

                // TITLE (centered)
                VStack(spacing: 8) {
                    Text("MEAL PLANNER")
                        .font(.system(size: 34, weight: .heavy, design: .rounded))
                        .tracking(3)
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.65)
                        .allowsTightening(true)
                        .padding(.horizontal, 20)
                        .shadow(radius: 8)

                    Rectangle()
                        .fill(Color.white.opacity(0.9))
                        .frame(width: 270, height: 2)
                        .cornerRadius(1)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 28)
                .padding(.bottom, 16)

                // CONTENT
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(days, id: \.self) { day in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(day)
                                    .font(.custom("Avenir-Heavy", size: 18))
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.75)

                                mealRow(day: day, meal: "Breakfast", mealType: .breakfast)
                                mealRow(day: day, meal: "Lunch", mealType: .lunch)
                                mealRow(day: day, meal: "Dinner", mealType: .dinner)
                            }
                            .zIndex(focusedDay == day ? 1000 : 0)
                        }

                        Button(action: clearAllMeals) {
                            Text("CLEAR ALL")
                                .font(.custom("Avenir-Heavy", size: 16))
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .minimumScaleFactor(0.75)
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity)
                                .background(Color.red.opacity(0.65))
                                .cornerRadius(14)
                        }
                        .padding(.top, 12)
                        .padding(.bottom, 120)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                }
            }
            .onAppear { loadMeals() }
            .onChange(of: focusedField) { newValue in
                if let key = newValue,
                   let dayPart = key.split(separator: "-").first {
                    focusedDay = String(dayPart)
                } else {
                    focusedDay = nil
                }
            }

            // SUGGESTIONS OVERLAY (global, so it really sits on top)
            suggestionsOverlay()
                .zIndex(2500)

            // AUTO-POPULATE BUBBLE
            if showAutoPopulateBubble {
                Color.black.opacity(0.001)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            showAutoPopulateBubble = false
                        }
                    }
                autoPopulateBubble
                    .zIndex(3000)
            }

            // CONTEXT MENU
            if showContextMenu, let frame = contextMenuFrameIfVisible() {
                Color.black.opacity(0.001)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.18)) {
                            showContextMenu = false
                        }
                    }

                HStack(spacing: 24) {

                    // COPY
                    Button(action: {
                        if let day = contextMenuDay, let meal = contextMenuMeal {
                            let text = meals[day]?[meal] ?? ""
                            UIPasteboard.general.string = text
                            showContextMenu = false
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }
                    }) {
                        VStack(spacing: 2) {
                            Image(systemName: "doc.on.doc")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.black)
                            Text("Copy")
                                .font(.caption.bold())
                                .foregroundColor(.black)
                                .lineLimit(1)
                                .minimumScaleFactor(0.75)
                        }
                        .padding(14)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 2)
                    }

                    // PASTE
                    Button(action: {
                        if let clipboard = UIPasteboard.general.string,
                           let day = contextMenuDay,
                           let meal = contextMenuMeal {
                            meals[day, default: [:]][meal] = clipboard
                            saveMealsAndFingerprint()
                            showContextMenu = false
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }
                    }) {
                        VStack(spacing: 2) {
                            Image(systemName: "doc.on.clipboard")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.green)
                            Text("Paste")
                                .font(.caption.bold())
                                .foregroundColor(.green)
                                .lineLimit(1)
                                .minimumScaleFactor(0.75)
                        }
                        .padding(14)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 2)
                    }

                    // DELETE
                    Button(action: {
                        if let day = contextMenuDay, let meal = contextMenuMeal {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                meals[day]?[meal] = ""
                                saveMealsAndFingerprint()
                                showContextMenu = false
                            }
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }
                    }) {
                        VStack(spacing: 2) {
                            Image(systemName: "trash")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.red)
                            Text("Delete")
                                .font(.caption.bold())
                                .foregroundColor(.red)
                                .lineLimit(1)
                                .minimumScaleFactor(0.75)
                        }
                        .padding(14)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 2)
                    }
                }
                .padding(12)
                .background(
                    Capsule()
                        .fill(Color.white.opacity(0.96))
                        .shadow(radius: 10)
                )
                .position(
                    x: frame.midX,
                    y: max(frame.minY - 115, 90)
                )
                .transition(.scale)
                .zIndex(4000)
            }

            // HELP BUBBLE (meal planner instructions)
            if showHelpBubble {
                VStack {
                    Spacer()

                    Text("Swipe left on any meal row to erase it.\n\nPress and hold a meal row to Copy, Paste, or Delete meals.")
                        .font(.system(size: 15))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(20)
                        .background(
                            ZStack {
                                RoundedRectangle(cornerRadius: 22)
                                    .fill(Color.yellow.opacity(0.35))
                                    .blur(radius: 24)
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(Color.yellow.opacity(0.16))
                                    .blur(radius: 8)

                                RoundedRectangle(cornerRadius: 16)
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color(red: 0.35, green: 0.80, blue: 0.75),
                                                Color(red: 0.20, green: 0.65, blue: 0.60),
                                                Color(red: 0.10, green: 0.45, blue: 0.45)
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .shadow(color: Color.yellow.opacity(0.32), radius: 18, x: 0, y: 6)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.white.opacity(0.75), lineWidth: 1.5)
                                    )
                            }
                        )
                        .padding(.horizontal, 40)
                        .padding(.bottom, 120)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                        .animation(.easeInOut(duration: 0.35), value: showHelpBubble)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    showHelpBubble = false
                                }
                            }
                        }
                }
                .zIndex(5000)
            }
        }
        .safeAreaInset(edge: .bottom) {
            footerBar
        }
        .coordinateSpace(name: "MealPlannerSpace")
        .onPreferenceChange(MealFieldFramePreferenceKey.self) { values in
            guard let focused = focusedField else {
                focusedFieldFrame = .zero
                return
            }
            focusedFieldFrame = values.first(where: { $0.key == focused })?.frame ?? .zero
        }
        .alert(isPresented: $showNoFavoritesAlert) {
            Alert(
                title: Text("No Favorite Meals Found"),
                message: Text("You haven't added any meals to your favorites yet."),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    // MARK: - FOOTER

    private var footerBar: some View {
        HStack(spacing: 34) {
            floatingButton(systemName: "chevron.left") {
                navModel.pop()
            }

            floatingButton(systemName: "star.fill") {
                withAnimation(.easeInOut(duration: 0.25)) {
                    showAutoPopulateBubble.toggle()
                }
            }

            floatingButton(systemName: "list.bullet") {
                navModel.push("GroceryListView")
            }
        }
        .padding(.top, 10)
        .padding(.bottom, 8)
        .frame(maxWidth: .infinity)
        .background(Color(red: 0.08, green: 0.42, blue: 0.42).opacity(0.88))
    }

    private func floatingButton(systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.85, green: 1.0, blue: 0.9),
                            Color(red: 0.4, green: 0.9, blue: 0.8)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 64, height: 64)
                .overlay(
                    Image(systemName: systemName)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                )
        }
    }

    // MARK: - GLOBAL SUGGESTIONS OVERLAY

    @ViewBuilder
    private func suggestionsOverlay() -> some View {
        if let focused = focusedField,
           focusedFieldFrame != .zero {

            let parts = focused.split(separator: "-")

            if parts.count >= 2 {
                let day = String(parts[0])
                let meal = String(parts[1])
                let rawText = meals[day]?[meal] ?? ""
                let trimmed = rawText.trimmingCharacters(in: .whitespacesAndNewlines)

                if !trimmed.isEmpty {
                    let searchText = normalized(trimmed)

                    let legacyResults = RecipeIndex.allRecipes.filter { recipe in
                        normalized(recipe.title).contains(searchText)
                    }

                    let modelResults = modelRecipes.filter { recipe in
                        normalized(recipe.title).contains(searchText)
                    }

                    let userResults = userRecipeStore.recipes.filter { recipe in
                        normalized(recipe.title).contains(searchText)
                    }

                    let combinedTitles: [String] =
                        legacyResults.map { $0.title } +
                        modelResults.map { $0.title } +
                        userResults.map { $0.title }

                    let uniqueTitles = Array(
                        Dictionary(grouping: combinedTitles, by: { normalized($0) })
                            .values
                            .compactMap { $0.first }
                    )

                    if !uniqueTitles.isEmpty {
                        VStack(spacing: 0) {
                            ForEach(uniqueTitles.prefix(6), id: \.self) { title in
                                Button {
                                    meals[day, default: [:]][meal] = title
                                    focusedField = nil
                                    saveMealsAndFingerprint()
                                } label: {
                                    HStack {
                                        Text(title)
                                            .font(.custom("Avenir", size: 14))
                                            .foregroundColor(.black)
                                            .lineLimit(2)
                                            .minimumScaleFactor(0.75)
                                        Spacer()
                                    }
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 12)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.white)
                                    .contentShape(Rectangle())
                                }
                                .buttonStyle(.plain)

                                Divider().opacity(0.45)
                            }
                        }
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 8)
                        .frame(width: focusedFieldFrame.width)
                        .position(
                            x: focusedFieldFrame.midX,
                            y: focusedFieldFrame.maxY + 8 + (CGFloat(min(uniqueTitles.count, 6)) * 22)
                        )
                    }
                }
            }
        }
    }

    // MARK: - CONTEXT MENU HELPERS

    private func contextMenuFrameIfVisible() -> CGRect? {
        guard showContextMenu, contextMenuDay != nil, contextMenuMeal != nil else { return nil }
        return contextMenuFrame == .zero ? nil : contextMenuFrame
    }

    private struct AutoPopulateOption: Identifiable {
        let id = UUID()
        let title: String
        let mood: RecipeMood
    }

    private let autoPopulateOptions: [AutoPopulateOption] = [
        .init(title: "HAPPY MEALS", mood: .depression),
        .init(title: "CALMING MEALS", mood: .anxiety),
        .init(title: "FOCUS MEALS", mood: .adhd),
        .init(title: "GROUNDING MEALS", mood: .psychosis),
    ]

    // MARK: - AUTO-POPULATE BUBBLE

    private var autoPopulateBubble: some View {
        VStack {
            Spacer()
            VStack(spacing: 12) {
                Text("GENERATE MEAL PLAN")
                    .font(.custom("Avenir-Heavy", size: 16))
                    .foregroundColor(.black)
                    .lineLimit(2)
                    .minimumScaleFactor(0.75)
                    .multilineTextAlignment(.center)

                ScrollView {
                    VStack(spacing: 10) {

                        ForEach(autoPopulateOptions) { option in
                            Button {
                                autoPopulate(for: option.mood)
                                showAutoPopulateBubble = false
                            } label: {
                                Text(option.title)
                                    .font(.custom("Avenir-Heavy", size: 14))
                                    .foregroundColor(.black)
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.75)
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(Color.white.opacity(0.9))
                                    .cornerRadius(10)
                            }
                        }

                        // FAVORITES (meal-type aware)
                        Button {
                            autoPopulateFavoritesByMealType()
                            showAutoPopulateBubble = false
                        } label: {
                            Text("FAVORITES")
                                .font(.custom("Avenir-Heavy", size: 14))
                                .foregroundColor(.black)
                                .lineLimit(1)
                                .minimumScaleFactor(0.75)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(Color.white.opacity(0.9))
                                .cornerRadius(10)
                        }
                    }
                }
                .frame(height: 240)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.white.opacity(0.95))
            )
            .padding(.horizontal, 40)
            Spacer(minLength: 140)
        }
    }

    // MARK: - MEAL ROW

    private func mealRow(day: String, meal: String, mealType: MealType) -> some View {
        let key = "\(day)-\(meal)"
        let rawText = meals[day]?[meal] ?? ""

        let matchedModelRecipe = modelRecipes.first { normalized($0.title) == normalized(rawText) }
        let matchedRecipe = RecipeIndex.recipe(matching: rawText)
        let matchedUserRecipe = userRecipeStore.recipes.first { normalized($0.title) == normalized(rawText) }

        return GeometryReader { geo in
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    Text("\(meal):")
                        .font(.custom("Avenir", size: 16))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                        .frame(width: 85, alignment: .leading)

                    ZStack {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.white.opacity(0.18))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color.white.opacity(0.25), lineWidth: 1)
                            )

                        ZStack(alignment: .leading) {
                            TextField(
                                "",
                                text: Binding(
                                    get: { meals[day]?[meal] ?? "" },
                                    set: { newValue in
                                        meals[day, default: [:]][meal] = newValue
                                        saveMealsAndFingerprint()
                                    }
                                )
                            )
                            .focused($focusedField, equals: key)
                            .font(
                                .custom("Avenir", size: 15)
                                    .weight((matchedRecipe != nil || matchedModelRecipe != nil || matchedUserRecipe != nil) ? .bold : .regular)
                            )
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.75)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                            .opacity(fadeMeals[day]?[meal] ?? 1.0)
                            .animation(.easeInOut(duration: 0.5), value: fadeMeals[day]?[meal] ?? 1.0)

                            // Link overlay – only text itself is tappable
                            if let recipe = matchedRecipe, focusedField != key {
                                HStack {
                                    Button(action: {
                                        navModel.push(recipe.destination)
                                    }) {
                                        Text(recipe.title)
                                            .font(.custom("Avenir", size: 15).weight(.bold))
                                            .foregroundColor(.clear)
                                            .lineLimit(1)
                                    }
                                    .buttonStyle(.plain)
                                    Spacer()
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 10)
                            } else if let modelRecipe = matchedModelRecipe, focusedField != key {
                                HStack {
                                    Button(action: {
                                        navModel.push("RecipeModel:\(modelRecipe.id)")
                                    }) {
                                        Text(modelRecipe.title)
                                            .font(.custom("Avenir", size: 15).weight(.bold))
                                            .foregroundColor(.clear)
                                            .lineLimit(1)
                                    }
                                    .buttonStyle(.plain)
                                    Spacer()
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 10)
                            } else if let userRecipe = matchedUserRecipe, focusedField != key {
                                HStack {
                                    Button(action: {
                                        navModel.push("UserRecipeDetailView:\(userRecipe.id)")
                                    }) {
                                        Text(userRecipe.title)
                                            .font(.custom("Avenir", size: 15).weight(.bold))
                                            .foregroundColor(.clear)
                                            .lineLimit(1)
                                    }
                                    .buttonStyle(.plain)
                                    Spacer()
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 10)
                            }
                        }
                        .contentShape(Rectangle())
                        .highPriorityGesture(
                            LongPressGesture(minimumDuration: 0.35)
                                .onEnded { _ in
                                    contextMenuDay = day
                                    contextMenuMeal = meal
                                    contextMenuFrame = geo.frame(in: .global)
                                    showContextMenu = true
                                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                }
                        )
                        .simultaneousGesture(
                            DragGesture(minimumDistance: 25)
                                .onEnded { value in
                                    if value.translation.width < -60 && !(meals[day]?[meal] ?? "").isEmpty {
                                        withAnimation(.easeInOut(duration: 0.5)) {
                                            fadeMeals[day, default: [:]][meal] = 0.0
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            meals[day]?[meal] = ""
                                            saveMealsAndFingerprint()
                                            fadeMeals[day, default: [:]][meal] = 1.0
                                        }
                                    }
                                }
                        )
                    }
                    .background(
                        GeometryReader { proxy in
                            Color.clear.preference(
                                key: MealFieldFramePreferenceKey.self,
                                value: [
                                    MealFieldFrameData(
                                        key: key,
                                        frame: proxy.frame(in: .named("MealPlannerSpace"))
                                    )
                                ]
                            )
                        }
                    )
                    .frame(height: 46)
                    .zIndex(focusedField == key ? 1000 : 0)
                }
            }
            .frame(height: 52)
            .zIndex(focusedField == key ? 999 : 0)
        }
        .frame(height: 52)
    }

    // MARK: - AUTO-POPULATE LOGIC

    private func autoPopulate(for mood: RecipeMood) {
        for day in days {
            meals[day]?["Breakfast"] =
                RecipeIndex.randomRecipeUnified(for: mood, mealType: .breakfast)?.title ?? ""
            meals[day]?["Lunch"] =
                RecipeIndex.randomRecipeUnified(for: mood, mealType: .lunch)?.title ?? ""
            meals[day]?["Dinner"] =
                RecipeIndex.randomRecipeUnified(for: mood, mealType: .dinner)?.title ?? ""
        }
        saveMealsAndFingerprint()
    }

    private func autoPopulateFavoritesByMealType() {
        // Existing favorites (legacy/model via RecipeIndex)
        let favoriteBreakfasts = RecipeIndex.recipes(for: .favorites, mealType: .breakfast).map { $0.title }
        let favoriteLunches    = RecipeIndex.recipes(for: .favorites, mealType: .lunch).map { $0.title }
        let favoriteDinners    = RecipeIndex.recipes(for: .favorites, mealType: .dinner).map { $0.title }

        // ✅ User favorites (meal-type aware)
        let userFavoriteBreakfasts = userRecipeStore.recipes
            .filter { $0.isFavorite && $0.mealTypes.contains(.breakfast) }
            .map { $0.title }

        let userFavoriteLunches = userRecipeStore.recipes
            .filter { $0.isFavorite && $0.mealTypes.contains(.lunch) }
            .map { $0.title }

        let userFavoriteDinners = userRecipeStore.recipes
            .filter { $0.isFavorite && $0.mealTypes.contains(.dinner) }
            .map { $0.title }

        let breakfasts = favoriteBreakfasts + userFavoriteBreakfasts
        let lunches    = favoriteLunches + userFavoriteLunches
        let dinners    = favoriteDinners + userFavoriteDinners

        if breakfasts.isEmpty && lunches.isEmpty && dinners.isEmpty {
            showNoFavoritesAlert = true
            return
        }

        func pick(from list: [String], index: Int) -> String {
            guard !list.isEmpty else { return "" }
            return list[index % list.count]
        }

        var bIndex = 0
        var lIndex = 0
        var dIndex = 0

        for day in days {
            meals[day, default: [:]]["Breakfast"] = pick(from: breakfasts, index: bIndex); if !breakfasts.isEmpty { bIndex += 1 }
            meals[day, default: [:]]["Lunch"]     = pick(from: lunches, index: lIndex);    if !lunches.isEmpty { lIndex += 1 }
            meals[day, default: [:]]["Dinner"]    = pick(from: dinners, index: dIndex);   if !dinners.isEmpty { dIndex += 1 }
        }

        saveMealsAndFingerprint()
    }

    // MARK: - SAVE / LOAD

    private func saveMealsAndFingerprint() {
        saveMeals()
        mealFingerprint = meals
            .flatMap { $0.value.values }
            .sorted()
            .joined(separator: "|")
    }

    private func saveMeals() {
        if let encoded = try? JSONEncoder().encode(meals) {
            mealData = String(data: encoded, encoding: .utf8) ?? ""
        }
    }

    private func loadMeals() {
        guard let data = mealData.data(using: .utf8),
              let decoded = try? JSONDecoder().decode([String: [String: String]].self, from: data)
        else {
            for day in days {
                meals[day] = ["Breakfast": "", "Lunch": "", "Dinner": ""]
                fadeMeals[day] = ["Breakfast": 1.0, "Lunch": 1.0, "Dinner": 1.0]
            }
            return
        }
        meals = decoded
        for day in days {
            fadeMeals[day] = [
                "Breakfast": 1.0,
                "Lunch": 1.0,
                "Dinner": 1.0
            ]
        }
    }

    private func clearAllMeals() {
        for day in days {
            meals[day]?["Breakfast"] = ""
            meals[day]?["Lunch"] = ""
            meals[day]?["Dinner"] = ""
            fadeMeals[day]?["Breakfast"] = 1.0
            fadeMeals[day]?["Lunch"] = 1.0
            fadeMeals[day]?["Dinner"] = 1.0
        }
        saveMealsAndFingerprint()
    }
}