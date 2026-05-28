import Foundation
import SwiftUI

class PersonalJournalModel: ObservableObject {
    @Published var entries: [JournalEntry] = []

    private let saveKey = "personalJournalEntries"

    init() {
        loadEntries()
    }

    func addEntry(title: String, content: String, date: String) {
        let newEntry = JournalEntry(id: UUID(), date: date, title: title, content: content)
        entries.append(newEntry)
        saveEntries()
    }

    func updateEntry(_ entry: JournalEntry) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index] = entry
            entries = entries.map { $0 } // refresh SwiftUI bindings
            saveEntries()
        }
    }

    func deleteEntry(_ id: UUID) {
        entries.removeAll { $0.id == id }
        saveEntries()
    }

    func entry(for date: String) -> JournalEntry? {
        entries.first(where: { $0.date == date })
    }

    func canCreateEntry(for date: String) -> Bool {
        entry(for: date) == nil
    }

    private func saveEntries() {
        if let data = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }

    private func loadEntries() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([JournalEntry].self, from: data) {
            self.entries = decoded
        }
    }
}

