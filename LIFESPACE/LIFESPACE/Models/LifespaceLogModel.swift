import Foundation

// MARK: - Step 1: Enums for Check Type and Module

enum CheckType: String, Codable {
    case lifespace
    case lifestyleSurvey
}

enum LifespaceModule: String, Codable, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    case light
    case innerWork
    case fitness
    case eating
    case sensory
    case purpose
    case activity
    case community
    case expression
}

// MARK: - Step 2: Unified Log Entry Struct

struct LifespaceLogEntry: Identifiable, Codable {
    let id: UUID
    let date: Date
    let type: CheckType
    let module: LifespaceModule
    let questionCount: Int
    let yesCount: Int

    init(
        date: Date = Date(),
        type: CheckType,
        module: LifespaceModule,
        questionCount: Int,
        yesCount: Int
    ) {
        self.id = UUID()
        self.date = date
        self.type = type
        self.module = module
        self.questionCount = questionCount
        self.yesCount = yesCount
    }
}

// MARK: - Step 4: Unified Log Model

class LifespaceLogModel: ObservableObject {
    @Published var entries: [LifespaceLogEntry] = [] {
        didSet { saveEntries() }
    }

    private let storageKey = "lifespaceLogEntries"

    // ✅ NEW: year-based reset tracking + year summary storage
    private let lastResetYearKey = "lifespaceLog_lastResetYear"
    private let yearSummaryPrefix = "lifespaceYearSummary" // keys like: lifespaceYearSummary_2025_light

    init() {
        loadEntries()
    }

    // MARK: - Scores (existing)

    func todayLifespaceScore() -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        let todaysEntries = entries.filter {
            $0.type == .lifespace && calendar.isDate($0.date, inSameDayAs: today)
        }

        let totalQs = todaysEntries.reduce(0) { $0 + $1.questionCount }
        let totalYes = todaysEntries.reduce(0) { $0 + $1.yesCount }

        return totalQs > 0 ? Int((Double(totalYes) / Double(totalQs)) * 100) : 0
    }

    func todayModulePercentages() -> [LifespaceModule : Double] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        let todaysEntries = entries.filter {
            $0.type == .lifespace && calendar.isDate($0.date, inSameDayAs: today)
        }

        let grouped = Dictionary(grouping: todaysEntries, by: { $0.module })

        var result: [LifespaceModule : Double] = [:]

        for module in LifespaceModule.allCases {
            if let moduleEntries = grouped[module] {
                let totalQs = moduleEntries.reduce(0) { $0 + $1.questionCount }
                let totalYes = moduleEntries.reduce(0) { $0 + $1.yesCount }
                let percent = totalQs > 0 ? (Double(totalYes) / Double(totalQs)) * 100 : 0
                result[module] = percent
            } else {
                result[module] = 0
            }
        }

        return result
    }

    func lifetimeModuleAverages() -> [LifespaceModule : Double] {
        var results: [LifespaceModule : Double] = [:]

        for module in LifespaceModule.allCases {
            let moduleEntries = entries.filter { $0.module == module }

            let totalQs = moduleEntries.reduce(0) { $0 + $1.questionCount }
            let totalYes = moduleEntries.reduce(0) { $0 + $1.yesCount }

            results[module] = totalQs > 0 ? (Double(totalYes) / Double(totalQs)) * 100 : 0
        }

        return results
    }

    // ✅ Add a new entry and update UserDefaults if all 9 modules are completed today
    func addEntry(_ entry: LifespaceLogEntry) {
        entries.append(entry)

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        let modulesToday = entries
            .filter { $0.type == .lifespace && calendar.isDate($0.date, inSameDayAs: today) }
            .map { $0.module }

        let uniqueModules = Set(modulesToday)
        if uniqueModules.count == LifespaceModule.allCases.count {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            UserDefaults.standard.set(formatter.string(from: today), forKey: "lastCheckCompletedDate")
        }
    }

    func entries(for module: LifespaceModule) -> [LifespaceLogEntry] {
        entries.filter { $0.module == module }
    }

    func score(for module: LifespaceModule) -> Double {
        let relevant = entries(for: module)
        let totalQs = relevant.reduce(0) { $0 + $1.questionCount }
        let totalYes = relevant.reduce(0) { $0 + $1.yesCount }
        return totalQs > 0 ? (Double(totalYes) / Double(totalQs)) * 100.0 : 0.0
    }

    func weeklyAverages() -> [WeeklyAverage] {
        let calendar = Calendar.current
        let groupedByWeek = Dictionary(grouping: entries.filter { $0.type == .lifespace }) { entry -> Date in
            calendar.dateInterval(of: .weekOfYear, for: entry.date)?.start ?? entry.date
        }

        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMM"

        return groupedByWeek
            .sorted { $0.key < $1.key }
            .map { (date, entries) in
                let totalQs = entries.reduce(0) { $0 + $1.questionCount }
                let totalYes = entries.reduce(0) { $0 + $1.yesCount }
                let percentage = totalQs > 0 ? (Double(totalYes) / Double(totalQs)) * 100.0 : 0.0

                let components = calendar.dateComponents([.month, .weekOfMonth], from: date)
                let month = monthFormatter.string(from: date)
                let week = components.weekOfMonth ?? 1

                return WeeklyAverage(label: "\(month) W\(week)", averageScore: percentage)
            }
    }

    // MARK: - ✅ Year Summary (NEW)

    func yearModuleAverages(forYear year: Int) -> [LifespaceModule : Double] {
        let calendar = Calendar.current
        let yearEntries = entries.filter {
            $0.type == .lifespace && calendar.component(.year, from: $0.date) == year
        }

        var results: [LifespaceModule : Double] = [:]
        for module in LifespaceModule.allCases {
            let moduleEntries = yearEntries.filter { $0.module == module }
            let totalQs = moduleEntries.reduce(0) { $0 + $1.questionCount }
            let totalYes = moduleEntries.reduce(0) { $0 + $1.yesCount }
            results[module] = totalQs > 0 ? (Double(totalYes) / Double(totalQs)) * 100.0 : 0.0
        }
        return results
    }

    func yearOverallScore(forYear year: Int) -> Double {
        let calendar = Calendar.current
        let yearEntries = entries.filter {
            $0.type == .lifespace && calendar.component(.year, from: $0.date) == year
        }

        let totalQs = yearEntries.reduce(0) { $0 + $1.questionCount }
        let totalYes = yearEntries.reduce(0) { $0 + $1.yesCount }
        return totalQs > 0 ? (Double(totalYes) / Double(totalQs)) * 100.0 : 0.0
    }

    func saveYearSummary(forYear year: Int) {
        let modules = yearModuleAverages(forYear: year)
        let overall = yearOverallScore(forYear: year)

        for module in LifespaceModule.allCases {
            let key = "\(yearSummaryPrefix)_\(year)_\(module.rawValue)"
            UserDefaults.standard.set(modules[module] ?? 0, forKey: key)
        }

        UserDefaults.standard.set(overall, forKey: "\(yearSummaryPrefix)_\(year)_overall")
    }

    func loadYearSummary(forYear year: Int) -> (modules: [LifespaceModule: Double], overall: Double)? {
        // If overall key doesn't exist, treat as missing
        let overallKey = "\(yearSummaryPrefix)_\(year)_overall"
        guard UserDefaults.standard.object(forKey: overallKey) != nil else {
            return nil
        }

        var modules: [LifespaceModule: Double] = [:]
        for module in LifespaceModule.allCases {
            let key = "\(yearSummaryPrefix)_\(year)_\(module.rawValue)"
            modules[module] = UserDefaults.standard.double(forKey: key)
        }

        let overall = UserDefaults.standard.double(forKey: overallKey)
        return (modules, overall)
    }

    // MARK: - ✅ Reset once per year (UPGRADED)

    /// Performs the "New Year reset" once per year (even if the app wasn't opened on Jan 1).
    /// - Saves a summary for the previous year before clearing entries.
    func resetIfNewYear() {
        let calendar = Calendar.current
        let now = Date()
        let currentYear = calendar.component(.year, from: now)

        let lastResetYear = UserDefaults.standard.integer(forKey: lastResetYearKey)

        // If we already reset for this year, do nothing.
        if lastResetYear == currentYear { return }

        // Only reset if we have *any* data to reset.
        // (If there's no data, we still mark reset so we don't keep re-checking every launch.)
        let previousYear = currentYear - 1

        // Save previous year summary if there were any entries in previous year
        let hasPrevYearData = entries.contains { entry in
            entry.type == .lifespace && calendar.component(.year, from: entry.date) == previousYear
        }

        if hasPrevYearData {
            saveYearSummary(forYear: previousYear)
        }

        // Clear entries (this is your reset)
        entries.removeAll()

        // Clear "lastCheckCompletedDate" so HomeView doesn't think anything is done for the new year
        UserDefaults.standard.set("", forKey: "lastCheckCompletedDate")

        // Mark reset complete for this year
        UserDefaults.standard.set(currentYear, forKey: lastResetYearKey)
    }

    // MARK: - Persistence (existing)

    private func saveEntries() {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }

    private func loadEntries() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([LifespaceLogEntry].self, from: data) {
            entries = decoded
        }
    }
}
