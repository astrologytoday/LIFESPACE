import Foundation
import SwiftUI

final class CreativeWritingModel: ObservableObject {
    @Published var entries: [CreativeEntry] = []

    private let saveKey = "creativeWritingEntries"

    init() {
        loadEntries()
    }

    func addEntry(title: String, content: String, date: String) {
        let newEntry = CreativeEntry(
            id: UUID(),
            date: date,
            createdAt: Date(),
            title: title,
            content: content
        )
        entries.append(newEntry)
        saveEntries()
    }

    func updateEntry(_ entry: CreativeEntry) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index] = entry
            entries = entries.map { $0 }
            saveEntries()
        }
    }

    func deleteEntry(_ id: UUID) {
        entries.removeAll { $0.id == id }
        saveEntries()
    }

    func sortedEntriesNewestFirst() -> [CreativeEntry] {
        entries.sorted { $0.createdAt > $1.createdAt }
    }

    private func saveEntries() {
        if let data = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }

    private func loadEntries() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([CreativeEntry].self, from: data) {
            self.entries = decoded
            return
        }

        // ✅ Backward compatibility: migrate old entries (without createdAt) if any
        // If decoding fails because older entries lack createdAt, try decoding legacy format.
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let legacy = try? JSONDecoder().decode([LegacyCreativeEntry].self, from: data) {
            self.entries = legacy.map {
                CreativeEntry(id: $0.id, date: $0.date, createdAt: Date(), title: $0.title, content: $0.content)
            }
            saveEntries()
        }
    }
}

// ✅ Legacy support (so you don’t lose existing saved entries)
private struct LegacyCreativeEntry: Codable {
    let id: UUID
    let date: String
    var title: String
    var content: String
}
