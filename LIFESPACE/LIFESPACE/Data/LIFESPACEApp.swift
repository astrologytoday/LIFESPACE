import SwiftUI
import UserNotifications
import Firebase

// MARK: - Notification Tap Delegate (MUST be a class)
final class NotificationTapDelegate: NSObject, UNUserNotificationCenterDelegate {

    weak var navModel: NavigationModel?

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let identifier = response.notification.request.identifier

        // --- Goal Step Reminders (deep link to GoalView + highlight) ---
        if identifier.hasPrefix("goalStep_") {
            let parts = identifier.split(separator: "_").map { String($0) }
            // goalStep_<goalUUID>_<bucketKey>_<idx>
            if parts.count >= 4 {
                let goalID = parts[1]
                let bucketKey = parts[2]

                DispatchQueue.main.async {
                    guard let navModel = self.navModel else {
                        completionHandler()
                        return
                    }

                    navModel.reminderGoalID = goalID
                    navModel.reminderGoalBucketKey = bucketKey
                    navModel.cameFromGoalReminder = true

                    navModel.selectedScreen = "GoalView:\(goalID)"
                }

                completionHandler()
                return
            } else {
                DispatchQueue.main.async {
                    self.navModel?.selectedScreen = "GoalsView"
                }
                completionHandler()
                return
            }
        }

        // --- 5-Year Plan Reminders (optional deep link) ---
        if identifier.hasPrefix("fiveYearStep_") {
            let parts = identifier.split(separator: "_").map { String($0) }
            // fiveYearStep_<bucketKey>_<idx>
            let bucketKey = parts.count >= 2 ? parts[1] : ""

            DispatchQueue.main.async {
                guard let navModel = self.navModel else {
                    completionHandler()
                    return
                }

                navModel.reminderFiveYearBucketKey = bucketKey
                navModel.cameFromFiveYearReminder = true
                navModel.selectedScreen = "FiveYearGoalView"
            }

            completionHandler()
            return
        }

        // --- Diagnostic Retest Notifications ---
        if identifier.hasPrefix("retest_") {
            let disorder = identifier.replacingOccurrences(of: "retest_", with: "")

            guard let navModel = self.navModel else {
                completionHandler()
                return
            }

            let timestamp = UserDefaults.standard.double(forKey: "\(disorder)Diagnostic_lastResultTimestamp")
            let risk = UserDefaults.standard.string(forKey: "\(disorder)Diagnostic_lastResultRisk") ?? ""

            DispatchQueue.main.async {
                navModel.reminderDisorder = disorder
                navModel.reminderDateTaken = Date(timeIntervalSince1970: timestamp)
                navModel.reminderRiskLevel = risk
                navModel.reminderDiagnosticViewName = "\(disorder)DiagnosticView"
                navModel.reminderDailyCheckViewName = "LightCheckView"

                navModel.selectedScreen = "DiagnosticReminderView"
            }

            completionHandler()
            return
        }

        completionHandler()
    }

    // Optional: show banner while app is open
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound])
    }
}

@main
struct LifespaceApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate // Orientation support
    @Environment(\.scenePhase) private var scenePhase

    @StateObject var navModel = NavigationModel()
    @StateObject var userProfile = UserProfileModel()
    @StateObject var lifespaceLogModel = LifespaceLogModel()
    @StateObject var goalsViewModel = GoalsViewModel()
    @StateObject var fiveYearPlan = FiveYearPlanModel.load()
    @StateObject var musicPlayer = MusicPlayerModel()
    @StateObject var toDoListModel = ToDoListModel()
    @StateObject private var userRecipeStore = UserRecipeStore()
    @StateObject private var lifespaceSyncModel = LifespaceSyncModel()

    // Keep the delegate alive (plain stored property, not @StateObject)
    private let notificationTapDelegate = NotificationTapDelegate()

    @AppStorage("hasSeenDisclaimer") var hasSeenDisclaimer: Bool = false
    @AppStorage("hasSeenLifespaceInfo") var hasSeenLifespaceInfo: Bool = false
    @AppStorage("hasSeenMenuTutorial") var hasSeenMenuTutorial: Bool = false
    @AppStorage("notificationsInitialized") var notificationsInitialized: Bool = false

    // ✅ Daily reset stamp
    @AppStorage("lastActiveDayStamp") private var lastActiveDayStamp: Double = 0

    // ✅ Midnight timer (only relevant if app stays open across midnight)
    @State private var midnightTimer: Timer?

    init() {
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = notificationTapDelegate
    }

    var body: some Scene {
        WindowGroup {
            MenuContainerView()
                .environmentObject(navModel)
                .environmentObject(goalsViewModel)
                .environmentObject(userProfile)
                .environmentObject(lifespaceLogModel)
                .environmentObject(musicPlayer)
                .environmentObject(fiveYearPlan)
                .environmentObject(toDoListModel)
                .environmentObject(userRecipeStore)
                .environmentObject(lifespaceSyncModel)
                .onAppear {
                    // ✅ Do not interrupt Spotify / Apple Music / podcasts when LIFESPACE opens.
                    AudioSessionManager.shared.allowBackgroundMusic()

                    notificationTapDelegate.navModel = navModel

                    let introComplete = hasSeenDisclaimer && hasSeenLifespaceInfo && hasSeenMenuTutorial
                    if introComplete {
                        initializeNotifications(lifespaceLogModel: lifespaceLogModel)
                    }

                    // ✅ On first appearance, enforce daily reset logic
                    handleDailyRerouteIfNeeded()
                    scheduleMidnightReset()
                }
                .onChange(of: scenePhase) { _, phase in
                    switch phase {
                    case .active:
                        // ✅ Re-allow background music when returning to the app.
                        if !musicPlayer.isPlaying {
                            AudioSessionManager.shared.allowBackgroundMusic()
                        }

                        handleDailyRerouteIfNeeded()
                        scheduleMidnightReset()

                    case .inactive, .background:
                        midnightTimer?.invalidate()
                        midnightTimer = nil

                    @unknown default:
                        break
                    }
                }
        }
    }

    // MARK: - Daily Reroute
    private func handleDailyRerouteIfNeeded() {
        let now = Date()

        // First run: stamp and exit
        guard lastActiveDayStamp != 0 else {
            lastActiveDayStamp = now.timeIntervalSince1970
            return
        }

        let last = Date(timeIntervalSince1970: lastActiveDayStamp)

        // ✅ New calendar day?
        if !Calendar.current.isDate(last, inSameDayAs: now) {
            // If the app is actively deep-linking from a notification, don't override the destination.
            // Just clear history so Back can't land on stale Results/Analytics.
            if shouldPreserveCurrentScreenOnNewDay() {
                navModel.clearHistory()
            } else {
                navModel.resetToHomeForNewDay()
            }
        }

        lastActiveDayStamp = now.timeIntervalSince1970
    }

    private func shouldPreserveCurrentScreenOnNewDay() -> Bool {
        if navModel.cameFromGoalReminder { return true }
        if navModel.cameFromFiveYearReminder { return true }
        if navModel.selectedScreen == "DiagnosticReminderView" { return true }
        return false
    }

    // MARK: - Midnight Reset (only if app is open)
    private func scheduleMidnightReset() {
        midnightTimer?.invalidate()

        let now = Date()
        let nextMidnight = Calendar.current.nextDate(
            after: now,
            matching: DateComponents(hour: 0, minute: 0, second: 0),
            matchingPolicy: .nextTime
        ) ?? now.addingTimeInterval(60)

        let interval = nextMidnight.timeIntervalSince(now)

        midnightTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { _ in
            // Same logic at midnight
            if shouldPreserveCurrentScreenOnNewDay() {
                navModel.clearHistory()
            } else {
                navModel.resetToHomeForNewDay()
            }

            lastActiveDayStamp = Date().timeIntervalSince1970
            scheduleMidnightReset()
        }
    }
}

// MARK: - Notification Initialization
func initializeNotifications(lifespaceLogModel: LifespaceLogModel) {
    if UserDefaults.standard.bool(forKey: "notificationsInitialized") {
        return
    }

    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
        if granted {
            print("✅ Notifications granted.")

            UserDefaults.standard.set(true, forKey: "mealtimeNotifications")
            UserDefaults.standard.set(true, forKey: "dailyCheckNotification")
            UserDefaults.standard.set(true, forKey: "notificationsInitialized")

            NotificationManager.shared.scheduleMealtimeNotifications(enabled: true)
            NotificationManager.shared.scheduleDailyCheckNotification(
                enabled: true,
                lifespaceLogModel: lifespaceLogModel
            )
        } else {
            print("❌ Notifications denied: \(error?.localizedDescription ?? "No error")")
        }
    }
}
