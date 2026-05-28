import Foundation
import SwiftUI

class DreamJournalModel: ObservableObject {
    @Published var entries: [DreamEntry] = []

    private let saveKey = "dreamJournalEntries"

    init() {
        loadEntries()
    }

    // ADD ENTRY
    func addEntry(title: String, content: String, date: String) {
        let newEntry = DreamEntry(id: UUID(), date: date, title: title, content: content)
        entries.append(newEntry)
        saveEntries()
    }

    // UPDATE ENTRY
    func updateEntry(_ entry: DreamEntry) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index] = entry
            entries = entries.map { $0 }  // Force SwiftUI refresh
            saveEntries()
        }
    }

    // DELETE ENTRY (added)
    func deleteEntry(_ id: UUID) {
        entries.removeAll { $0.id == id }
        saveEntries()
    }

    // GET ENTRY FOR SPECIFIC DATE
    func entry(for date: String) -> DreamEntry? {
        return entries.first(where: { $0.date == date })
    }

    // CHECK IF NEW ENTRY CAN BE CREATED FOR TODAY
    func canCreateEntry(for date: String) -> Bool {
        return entry(for: date) == nil
    }

    // SAVE TO USERDEFAULTS
    private func saveEntries() {
        if let data = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }

    // LOAD FROM USERDEFAULTS
    private func loadEntries() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([DreamEntry].self, from: data) {
            self.entries = decoded
        }
    }
}
