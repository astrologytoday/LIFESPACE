import Foundation
import SwiftUI

struct BudgetCategory: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    var name: String
    var originalAmount: Double
    var currentAmount: Double
    var weeklySpending: [Int: Double]

    init(name: String, amount: Double) {
        self.id = UUID()
        self.name = name
        self.originalAmount = amount
        self.currentAmount = amount
        self.weeklySpending = [:]
    }
}

class BudgetModel: ObservableObject, Codable {
    @Published var income: Double = 0
    @Published var categories: [BudgetCategory] = []
    @Published var otherSpending: Double = 0

    private let storageKey = "lifespaceBudget"

    init() {
        load()
    }

    // ✅ FILTER OUT "OTHER" FROM PLANNED BUDGET
    var plannedCategories: [BudgetCategory] {
        categories.filter {
            $0.name.trimmingCharacters(in: .whitespacesAndNewlines).uppercased() != "OTHER"
        }
    }

    var totalExpenses: Double {
        plannedCategories.reduce(0) { $0 + $1.originalAmount }
    }

    var savings: Double {
        income - totalExpenses
    }

    func addCategory(name: String, amount: Double) {
        let new = BudgetCategory(name: name, amount: amount)
        categories.append(new)
        save()
    }

    func removeCategory(id: UUID) {
        categories.removeAll { $0.id == id }
        save()
    }

    func updateIncome(_ newIncome: Double) {
        income = newIncome
        save()
    }

    func updateCategoryAmount(id: UUID, amount: Double) {
        if let index = categories.firstIndex(where: { $0.id == id }) {
            categories[index].originalAmount = amount

            let spentSoFar = categories[index].weeklySpending.values.reduce(0, +)
            categories[index].currentAmount = amount - spentSoFar

            save()
        }
    }

    func resetWeeklySpending() {
        for i in categories.indices {
            categories[i].currentAmount = categories[i].originalAmount
            categories[i].weeklySpending = [:]
        }
        otherSpending = 0
        save()
    }

    // ✅ REMOVE DUPLICATE "OTHER" CATEGORIES
    func cleanDuplicateOtherCategories() {
        var seenOther = false

        categories.removeAll { category in
            let isOther = category.name
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .uppercased() == "OTHER"

            if isOther {
                if seenOther {
                    return true
                } else {
                    seenOther = true
                    return false
                }
            }

            return false
        }
    }

    // MARK: - Week Helper
    func getCurrentWeekOfMonth(for date: Date = Date()) -> Int {
        let day = Calendar.current.component(.day, from: date)
        switch day {
        case 1...7: return 1
        case 8...17: return 2
        case 18...25: return 3
        case 26...31: return 4
        default: return 0
        }
    }

    // MARK: - Codable

    enum CodingKeys: String, CodingKey {
        case income, categories, otherSpending
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(income, forKey: .income)
        try container.encode(categories, forKey: .categories)
        try container.encode(otherSpending, forKey: .otherSpending)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        income = try container.decode(Double.self, forKey: .income)
        categories = try container.decode([BudgetCategory].self, forKey: .categories)
        otherSpending = try container.decodeIfPresent(Double.self, forKey: .otherSpending) ?? 0
    }

    // MARK: - Persistence

    func save() {
        if let data = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    func load() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode(BudgetModel.self, from: data) {

            self.income = decoded.income
            self.categories = decoded.categories
            self.otherSpending = decoded.otherSpending

            // Normalize currentAmount
            for i in categories.indices {
                let spentSoFar = categories[i].weeklySpending.values.reduce(0, +)
                categories[i].currentAmount = categories[i].originalAmount - spentSoFar
            }

            // ✅ CLEAN DUPLICATES AFTER LOAD
            cleanDuplicateOtherCategories()
        }
    }
}
