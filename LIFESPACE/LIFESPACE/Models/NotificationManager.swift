import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

    private init() {}

    // Request permission to show notifications
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            if granted {
                print("✅ Notifications permission granted.")
            } else {
                print("❌ Notifications permission denied.")
            }
        }
    }

    /// Schedules a notification 6 months from now to remind user to retake a diagnostic
    func scheduleSixMonthRetestNotification(for testName: String) {
        // Cancel any previously scheduled retest notification for this test
        cancelNotifications(withPrefix: "retest_\(testName)")

        let content = UNMutableNotificationContent()
        content.title = "Time to Retake Your LIFESPACE \(testName) Check"
        content.body = "It's been 6 months since your last \(testName.lowercased()) self-check. Would you like to take it again and see what's changed?"
        content.sound = .default

        // 6 months in seconds
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 15778463,
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: "retest_\(testName)",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Error scheduling 6-month retest for \(testName): \(error.localizedDescription)")
            } else {
                print("✅ 6-month retest notification scheduled for \(testName)")
            }
        }
    }

    func scheduleMealtimeNotifications(enabled: Bool) {
        cancelNotifications(withPrefix: "mealtime")

        guard enabled else { return }

        scheduleDailyNotification(
            id: "mealtime_breakfast",
            title: "Breakfast Reminder",
            body: "Get your breakfast before in 9:00AM 🔅",
            hour: 8,
            minute: 15
        )

        scheduleDailyNotification(
            id: "mealtime_lunch",
            title: "Lunch Reminder",
            body: "Don't forget to eat lunch 🥬",
            hour: 13,
            minute: 15
        )

        scheduleDailyNotification(
            id: "mealtime_dinner",
            title: "Dinner Reminder",
            body: "Get dinner started if you haven't yet 🍄‍🟫",
            hour: 17,
            minute: 45
        )
    }

    func cancelSixMonthRetestNotification(for testName: String) {
        cancelNotifications(withPrefix: "retest_\(testName)")
    }

    func scheduleDailyCheckNotification(enabled: Bool, lifespaceLogModel: LifespaceLogModel) {
        // Ensure suppression flag is reset if a new day has started
        resetSuppressionIfNeeded()

        // Remove any previously scheduled daily check notifications
        cancelNotifications(withPrefix: "dailyCheck")

        guard enabled else {
            print("🔕 Daily check notifications disabled.")
            return
        }

        // If today is marked as suppressed, skip scheduling
        let suppressToday = UserDefaults.standard.bool(forKey: "suppressDailyCheckNotificationToday")
        if suppressToday {
            print("🔕 Daily LIFESPACE Check notification suppressed for today.")
            return
        }

        var dateComponents = DateComponents()
        dateComponents.hour = 19   // 7 PM
        dateComponents.minute = 30 // :30

        let content = UNMutableNotificationContent()
        content.title = "LIFESPACE Reminder"
        content.body = "Tap to complete your LIFESPACE Check today 🌿"
        content.sound = .default

        // One scheduled fire time (next matching 7:30PM)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: "dailyCheck", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Error scheduling daily check: \(error.localizedDescription)")
            } else {
                print("✅ Daily LIFESPACE Check notification scheduled (7:30PM, repeats: false)")
            }
        }
    }

    // MARK: - Public: Suppress today's daily check notification

    func suppressDailyCheckForToday() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        let todayString = formatter.string(from: Date())
        UserDefaults.standard.set(true, forKey: "suppressDailyCheckNotificationToday")
        UserDefaults.standard.set(todayString, forKey: "suppressResetDate")

        cancelNotifications(withPrefix: "dailyCheck")

        print("🔕 Suppressed LIFESPACE daily check notification for today.")
    }

    // MARK: - Daily Suppression Reset

    func resetSuppressionIfNeeded() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        let todayString = formatter.string(from: Date())
        let lastReset = UserDefaults.standard.string(forKey: "suppressResetDate") ?? ""

        if lastReset != todayString {
            UserDefaults.standard.set(todayString, forKey: "suppressResetDate")
            UserDefaults.standard.set(false, forKey: "suppressDailyCheckNotificationToday")
            print("🔄 Reset daily check notification suppression for new day.")
        }
    }

    // MARK: - Helper: Daily Notification Scheduler (REPEATS DAILY, FOR MEALTIMES)

    private func scheduleDailyNotification(id: String, title: String, body: String, hour: Int, minute: Int) {
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

    // MARK: - Helper: Cancel by Prefix

    private func cancelNotifications(withPrefix prefix: String, completion: (() -> Void)? = nil) {
        let center = UNUserNotificationCenter.current()

        center.getPendingNotificationRequests { requests in
            let ids = requests
                .map(\.identifier)
                .filter { $0.hasPrefix(prefix) }

            center.removePendingNotificationRequests(withIdentifiers: ids)
            center.removeDeliveredNotifications(withIdentifiers: ids) // ✅ clears notification center too

            completion?()
        }
    }
}

// MARK: - Goal Step Reminders (2 days before)

extension NotificationManager {

    /// Identifier format:
    /// goalStep_<goalUUID>_<bucketKey>_<idx>
    /// bucketKey: 3days, 7days, 2weeks, 1month, 6months, final
    func rescheduleGoalStepReminders(goals: [Goal]) {
        cancelGoalStepReminders()

        let now = Date()
        let calendar = Calendar.current

        // iOS has a practical limit (often 64 pending). Keep room for your other notifications.
        let maxGoalReminders = 45
        var pending: [(fire: Date, id: String)] = []

        for goal in goals {
            guard goal.hasStarted, let start = goal.startDate else { continue }

            // Build leftover steps (Final Deadline) the same way GoalView does
            let assigned = Set(
                goal.stepsRightNow +
                goal.stepsToday +
                goal.stepsNext3Days +
                goal.stepsNextWeek +
                goal.stepsNext2Weeks +
                goal.stepsNextMonth +
                goal.stepsNext6Months
            )
            let leftover = goal.steps.filter { !assigned.contains($0) }

            let durationDays: Int = {
                switch goal.duration {
                case .week: return 7
                case .month: return 30
                case .year: return 365
                }
            }()

            // (steps, dueOffsetDaysFromStart, bucketKey)
            let buckets: [([String], Int, String)] = [
                (goal.stepsNext3Days, 3, "3days"),
                (goal.stepsNextWeek, 7, "7days"),
                (goal.stepsNext2Weeks, 14, "2weeks"),
                (goal.stepsNextMonth, 30, "1month"),
                (goal.stepsNext6Months, 180, "6months"),
                (leftover, durationDays, "final")
            ]

            for (steps, dueOffset, bucketKey) in buckets {
                for (idx, step) in steps.enumerated() {
                    if goal.completedStepIDs.contains(step) { continue }

                    guard let dueDate = calendar.date(byAdding: .day, value: dueOffset, to: start) else { continue }
                    guard let fireDay = calendar.date(byAdding: .day, value: -2, to: dueDate) else { continue }
                    guard let fireAtNine = calendar.date(bySettingHour: 9, minute: 0, second: 0, of: fireDay) else { continue }

                    if fireAtNine <= now { continue }

                    let id = "goalStep_\(goal.id.uuidString)_\(bucketKey)_\(idx)"
                    pending.append((fireAtNine, id))
                }
            }
        }

        pending.sort { $0.fire < $1.fire }
        if pending.count > maxGoalReminders {
            pending = Array(pending.prefix(maxGoalReminders))
        }

        for item in pending {
            let content = UNMutableNotificationContent()
            content.title = "Goal Reminder"
            content.body = "Check your goal progress to stay on track!"
            content.sound = .default
            content.userInfo = ["route": "GoalView"]

            let comps = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: item.fire)
            let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
            let request = UNNotificationRequest(identifier: item.id, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        }
    }

    /// Updated identifier format:
    /// fiveYearStep_<bucketKey>_<idx>
    /// bucketKey: 1week, 1month, 1year, 2years, 3years, 4years, 5years
    func rescheduleFiveYearPlanReminders(plan: FiveYearPlanModel) {
        cancelFiveYearPlanReminders()

        let now = Date()
        let calendar = Calendar.current
        let maxPlanReminders = 15

        let buckets: [(String, [String], () -> Date?)] = [
            ("1week", plan.stepsWeek, { calendar.date(byAdding: .day, value: 7, to: Date()) }),
            ("1month", plan.stepsMonth, { calendar.date(byAdding: .month, value: 1, to: Date()) }),
            ("1year", plan.steps1Year, { calendar.date(byAdding: .year, value: 1, to: Date()) }),
            ("2years", plan.steps2Years, { calendar.date(byAdding: .year, value: 2, to: Date()) }),
            ("3years", plan.steps3Years, { calendar.date(byAdding: .year, value: 3, to: Date()) }),
            ("4years", plan.steps4Years, { calendar.date(byAdding: .year, value: 4, to: Date()) }),
            ("5years", plan.steps5Years, { calendar.date(byAdding: .year, value: 5, to: Date()) })
        ]

        var pending: [(fire: Date, id: String)] = []

        for (bucketKey, steps, dueBuilder) in buckets {
            guard let dueDate = dueBuilder() else { continue }
            guard let fireDay = calendar.date(byAdding: .day, value: -2, to: dueDate) else { continue }
            guard let fireAtNine = calendar.date(bySettingHour: 9, minute: 0, second: 0, of: fireDay) else { continue }
            if fireAtNine <= now { continue }

            for (idx, step) in steps.enumerated() {
                if plan.completedSteps.contains(step) { continue }
                let id = "fiveYearStep_\(bucketKey)_\(idx)"
                pending.append((fireAtNine, id))
            }
        }

        pending.sort { $0.fire < $1.fire }
        if pending.count > maxPlanReminders {
            pending = Array(pending.prefix(maxPlanReminders))
        }

        for item in pending {
            let content = UNMutableNotificationContent()
            content.title = "5-Year Plan Reminder"
            content.body = "Check your goal progress to stay on track!"
            content.sound = .default
            content.userInfo = ["route": "FiveYearGoalView"]

            let comps = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: item.fire)
            let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)

            let request = UNNotificationRequest(identifier: item.id, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        }
    }

    // ✅ UPDATED: clears pending + delivered using your helper
    func cancelGoalStepReminders() {
        cancelNotifications(withPrefix: "goalStep_")
    }

    // ✅ UPDATED: clears pending + delivered using your helper
    func cancelFiveYearPlanReminders() {
        cancelNotifications(withPrefix: "fiveYearStep_")
    }
}
