import Foundation

struct CreativeEntry: Identifiable, Codable, Equatable {
    let id: UUID
    let date: String // "MM/DD"
    let createdAt: Date
    var title: String
    var content: String
}
