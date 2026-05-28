import Foundation

struct WeightEntry: Identifiable, Codable {
    let id: UUID
    let date: Date
    let weight: Double
}

class WeightLogModel: ObservableObject {
    @Published var entries: [WeightEntry] = [] {
        didSet {
            saveEntries()
        }
    }

    private let weightDataKey = "weightData"

    init() {
        loadEntries()
    }

    private func saveEntries() {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: weightDataKey)
        }
    }

    private func loadEntries() {
        if let data = UserDefaults.standard.data(forKey: weightDataKey),
           let decoded = try? JSONDecoder().decode([WeightEntry].self, from: data) {
            entries = decoded
        }
    }

    func addEntry(date: Date, weight: Double) {
        let newEntry = WeightEntry(id: UUID(), date: date, weight: weight)
        entries.append(newEntry)
        entries.sort { $0.date < $1.date }
    }

    func clearAll() {
        entries.removeAll()
    }
    
    func hasEntryForToday() -> Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return entries.contains { calendar.isDate($0.date, inSameDayAs: today) }
    }

}

