import Foundation

struct ToDoItem: Identifiable, Codable, Equatable, Hashable {
    var id = UUID()
    var title: String
    var isCompleted: Bool = false
    var isUrgent: Bool = false

    init(id: UUID = UUID(), title: String, isCompleted: Bool) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
    }
}

