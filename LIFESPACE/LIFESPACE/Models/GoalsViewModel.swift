import Foundation
import SwiftUI

@MainActor
class GoalsViewModel: ObservableObject {
    @Published var goals: [Goal] = [] {
        didSet { saveGoals() } // ✅ persist on every change
    }

    private let goalsKey = "userGoals"

    init() {
        loadGoals()

        // ✅ Cleanup on launch:
        // If the user deleted goals but iOS still had old goalStep_... notifications pending,
        // this will cancel them (and reschedule only if there are valid upcoming steps).
        NotificationManager.shared.rescheduleGoalStepReminders(goals: goals)
    }

    // ✅ Returns the created goal so caller can nav to it
    @discardableResult
    func addGoal(title: String) -> Goal {
        let newGoal = Goal(title: title)
        goals.append(newGoal)
        return newGoal
    }

    func deleteGoal(_ goal: Goal) {
        goals.removeAll { $0.id == goal.id }

        // ✅ CRITICAL: prevents “ghost” goal reminders after deletion
        NotificationManager.shared.rescheduleGoalStepReminders(goals: goals)
    }

    // Optional: replace an updated goal in-place (by id)
    func updateGoal(_ updated: Goal) {
        if let idx = goals.firstIndex(where: { $0.id == updated.id }) {
            goals[idx] = updated
        }
    }

    // Optional: index helper for router logic
    func index(for id: UUID) -> Int? {
        goals.firstIndex { $0.id == id }
    }

    // MARK: - Persistence
    private func saveGoals() {
        do {
            let encoded = try JSONEncoder().encode(goals)
            UserDefaults.standard.set(encoded, forKey: goalsKey)
        } catch {
            print("❌ Failed to encode goals: \(error)")
        }
    }

    private func loadGoals() {
        guard let data = UserDefaults.standard.data(forKey: goalsKey) else { return }
        do {
            let decoded = try JSONDecoder().decode([Goal].self, from: data)
            goals = decoded
        } catch {
            print("❌ Failed to decode goals: \(error)")
            goals = [] // fallback
        }
    }
}
