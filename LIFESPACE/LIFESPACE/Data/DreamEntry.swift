import Foundation

struct DreamEntry: Identifiable, Codable, Equatable {
    let id: UUID
    let date: String // Format: "MM/DD"
    var title: String
    var content: String
}

