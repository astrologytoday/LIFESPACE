import SwiftUI

final class NavigationModel: ObservableObject {

    // MARK: - Navigation State
    @Published var selectedScreen: String = "HomeView"
    @Published var showMenu: Bool = false
    @Published var isTransitioningFromLandscape = false
    @Published var isTransitioningToLandscape: Bool = false
    @Published var openProgressCameraOnAppear: Bool = false

    // MARK: - Meetup
    @Published var meetupUsername: String = ""
    @Published var meetupIntent: String = ""

    // MARK: - Diagnostic Reminder Payload
    @Published var reminderDisorder: String = ""
    @Published var reminderDateTaken: Date = Date()
    @Published var reminderRiskLevel: String = ""
    @Published var reminderDiagnosticViewName: String = ""
    @Published var reminderDailyCheckViewName: String = ""
    @Published var cameFromDiagnosticReminder: Bool = false

    // MARK: - Goal Reminder Deep Link Payload
    @Published var reminderGoalID: String = ""              // goal UUID string
    @Published var reminderGoalBucketKey: String = ""       // 3days, 7days, 2weeks, 1month, 6months, final
    @Published var cameFromGoalReminder: Bool = false

    // MARK: - 5-Year Plan Reminder (optional)
    @Published var reminderFiveYearBucketKey: String = ""   // 1week, 1month, 1year, 2years, 3years, 4years, 5years
    @Published var cameFromFiveYearReminder: Bool = false

    // MARK: - History
    private var screenHistory: [String] = []

    // MARK: - Navigation Actions
    func push(_ screen: String) {
        withAnimation(.easeInOut(duration: 0.4)) {
            screenHistory.append(selectedScreen)
            selectedScreen = screen
        }
    }

    func pop() {
        withAnimation(.easeInOut(duration: 0.4)) {
            if let previous = screenHistory.popLast() {
                selectedScreen = previous
            } else {
                selectedScreen = "HomeView"
            }
        }
    }

    /// Clears back-stack so back navigation can't land on stale screens.
    func clearHistory() {
        withAnimation(.easeInOut(duration: 0.4)) {
            screenHistory.removeAll()
            showMenu = false
        }
    }

    /// Used for normal “go home” resets (and your daily reset behavior).
    func resetToHomeForNewDay() {
        withAnimation(.easeInOut(duration: 0.4)) {
            screenHistory.removeAll()
            showMenu = false
            isTransitioningFromLandscape = false
            isTransitioningToLandscape = false
            selectedScreen = "HomeView"
        }
    }

    func reset() {
        resetToHomeForNewDay()
    }

    // MARK: - Optional: Centralized Reminder Routing
    func routeToDiagnosticReminder() {
        withAnimation(.easeInOut(duration: 0.4)) {
            selectedScreen = "DiagnosticReminderView"
        }
    }
}
