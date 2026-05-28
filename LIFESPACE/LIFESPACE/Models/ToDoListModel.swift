import Foundation

class ToDoListModel: ObservableObject {
    @Published var tasks: [ToDoItem] = [] {
        didSet {
            saveTasks()
        }
    }

    private let tasksKey = "userTasks"

    init() {
        loadTasks()
    }

    // Loads tasks from UserDefaults (on app start)
    private func loadTasks() {
        if let data = UserDefaults.standard.data(forKey: tasksKey),
           let decoded = try? JSONDecoder().decode([ToDoItem].self, from: data) {
            self.tasks = decoded
        }
    }

    // Saves tasks to UserDefaults (whenever they change)
    private func saveTasks() {
        if let data = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(data, forKey: tasksKey)
        }
    }
}

