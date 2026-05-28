import EventKit

class ReminderManager: ObservableObject {
    private let store = EKEventStore()

    @Published var reminderLists: [EKCalendar] = []
    @Published var reminders: [EKReminder] = []

    // Request permission
    func requestAccess(completion: @escaping (Bool) -> Void) {
        store.requestAccess(to: .reminder) { granted, error in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }

    // Load all reminder lists (calendars)
    func loadReminderLists() {
        reminderLists = store.calendars(for: .reminder)
    }

    // Load reminders inside a specific list
    func loadReminders(from calendar: EKCalendar, completion: @escaping () -> Void) {
        let predicate = store.predicateForIncompleteReminders(
            withDueDateStarting: nil,
            ending: nil,
            calendars: [calendar]
        )

        store.fetchReminders(matching: predicate) { reminders in
            DispatchQueue.main.async {
                self.reminders = reminders ?? []
                completion()
            }
        }
    }
}

