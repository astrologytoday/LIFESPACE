import SwiftUI
import Foundation

struct HomeView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var lifespaceLogModel: LifespaceLogModel

    @State private var showContent = false
    @GestureState private var isPressed = false

    @AppStorage("isSetupComplete") var isSetupComplete: Bool = false
    @AppStorage("hasSeenDisclaimer") private var hasSeenDisclaimer: Bool = false
    @AppStorage("hasSeenLifespaceInfo") private var hasSeenLifespaceInfo: Bool = false
    @AppStorage("hasSeenMenuTutorial") private var hasSeenMenuTutorial: Bool = false
    @AppStorage("hasSeenOptimizationInfo") private var hasSeenOptimizationInfo: Bool = false
    @AppStorage("hasSeenStartView") private var hasSeenStartView: Bool = false

    // ✅ This key is written by LifespaceLogModel.addEntry using "yyyy-MM-dd"
    @AppStorage("lastCheckCompletedDate") private var lastCheckCompletedDate: String = ""

    // ✅ NEW: gates the NewYear flow to happen once per year
    @AppStorage("newYearFlow_lastShownYear") private var newYearFlowLastShownYear: Int = 0

    // Diagnostic states for all disorders
    @AppStorage("AnxietyDiagnostic_lastResultTimestamp") var anxietyLastResultTimestamp: Double = 0
    @AppStorage("AnxietyDiagnostic_lastResultRisk") var anxietyLastResultRisk: String = ""
    @AppStorage("DepressionDiagnostic_lastResultTimestamp") var depressionLastResultTimestamp: Double = 0
    @AppStorage("DepressionDiagnostic_lastResultRisk") var depressionLastResultRisk: String = ""
    @AppStorage("PSSDDiagnostic_lastResultTimestamp") var pssdLastResultTimestamp: Double = 0
    @AppStorage("PSSDDiagnostic_lastResultRisk") var pssdLastResultRisk: String = ""
    @AppStorage("ADHDDiagnostic_lastResultTimestamp") var adhdLastResultTimestamp: Double = 0
    @AppStorage("ADHDDiagnostic_lastResultRisk") var adhdLastResultRisk: String = ""
    @AppStorage("AutismDiagnostic_lastResultTimestamp") var autismLastResultTimestamp: Double = 0
    @AppStorage("AutismDiagnostic_lastResultRisk") var autismLastResultRisk: String = ""
    @AppStorage("BPDDiagnostic_lastResultTimestamp") var bpdLastResultTimestamp: Double = 0
    @AppStorage("BPDDiagnostic_lastResultRisk") var bpdLastResultRisk: String = ""
    @AppStorage("PsychosisDiagnostic_lastResultTimestamp") var psychosisLastResultTimestamp: Double = 0
    @AppStorage("PsychosisDiagnostic_lastResultRisk") var psychosisLastResultRisk: String = ""
    @AppStorage("CPTSDDiagnostic_lastResultTimestamp") var cptsdLastResultTimestamp: Double = 0
    @AppStorage("CPTSDDiagnostic_lastResultRisk") var cptsdLastResultRisk: String = ""

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.35, green: 0.80, blue: 0.75),
                    Color(red: 0.20, green: 0.65, blue: 0.60),
                    Color(red: 0.10, green: 0.45, blue: 0.45)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 40) {
                Spacer()

                Image("lifespace_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .opacity(showContent ? 1 : 0)
                    .animation(.easeInOut(duration: 1), value: showContent)

                Text("LIFESPACE")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .opacity(showContent ? 1 : 0)
                    .animation(.easeInOut(duration: 1.2).delay(0.2), value: showContent)

                Spacer()

                Button(action: handleStartTapped) {
                    Text("START")
                        .font(.headline)
                        .foregroundColor(Color(red: 0.12, green: 0.49, blue: 0.45))
                        .frame(width: 300, height: 75)
                        .background(Color.white)
                        .cornerRadius(25)
                        .shadow(color: .black.opacity(0.3), radius: isPressed ? 1 : 5, x: 0, y: isPressed ? 1 : 4)
                        .scaleEffect(isPressed ? 0.96 : 1.0)
                        .animation(.easeInOut(duration: 0.15), value: isPressed)
                }
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .updating($isPressed) { _, state, _ in state = true }
                )

                Text("Version 1.0")
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.8))
                    .opacity(showContent ? 1 : 0)
                    .animation(.easeInOut(duration: 1).delay(0.4), value: showContent)

                Spacer()
            }
            .onAppear {
                if isSetupComplete {
                    // ✅ Ensure New Year reset + year-summary save happens as soon as app opens
                    lifespaceLogModel.resetIfNewYear()

                    NotificationManager.shared.resetSuppressionIfNeeded()
                    initializeNotifications(lifespaceLogModel: lifespaceLogModel)
                    NotificationManager.shared.scheduleDailyCheckNotification(
                        enabled: UserDefaults.standard.bool(forKey: "dailyCheckNotification"),
                        lifespaceLogModel: lifespaceLogModel
                    )
                }

                withAnimation {
                    showContent = true
                }
            }
        }
    }

    // MARK: - All Diagnostic Retests
    private var allDiagnostics: [DiagnosticRetestInfo] {
        [
            DiagnosticRetestInfo(
                disorder: "Anxiety",
                lastResultTimestamp: anxietyLastResultTimestamp,
                lastResultRisk: anxietyLastResultRisk,
                diagnosticViewName: "AnxietyDiagnosticView"
            ),
            DiagnosticRetestInfo(
                disorder: "Depression",
                lastResultTimestamp: depressionLastResultTimestamp,
                lastResultRisk: depressionLastResultRisk,
                diagnosticViewName: "DepressionDiagnosticView"
            ),
            DiagnosticRetestInfo(
                disorder: "PSSD",
                lastResultTimestamp: pssdLastResultTimestamp,
                lastResultRisk: pssdLastResultRisk,
                diagnosticViewName: "PSSDDiagnosticView"
            ),
            DiagnosticRetestInfo(
                disorder: "ADHD",
                lastResultTimestamp: adhdLastResultTimestamp,
                lastResultRisk: adhdLastResultRisk,
                diagnosticViewName: "ADHDDiagnosticView"
            ),
            DiagnosticRetestInfo(
                disorder: "Autism",
                lastResultTimestamp: autismLastResultTimestamp,
                lastResultRisk: autismLastResultRisk,
                diagnosticViewName: "AutismDiagnosticView"
            ),
            DiagnosticRetestInfo(
                disorder: "BPD",
                lastResultTimestamp: bpdLastResultTimestamp,
                lastResultRisk: bpdLastResultRisk,
                diagnosticViewName: "BPDDiagnosticView"
            ),
            DiagnosticRetestInfo(
                disorder: "Psychosis",
                lastResultTimestamp: psychosisLastResultTimestamp,
                lastResultRisk: psychosisLastResultRisk,
                diagnosticViewName: "PsychosisDiagnosticView"
            ),
            DiagnosticRetestInfo(
                disorder: "C-PTSD",
                lastResultTimestamp: cptsdLastResultTimestamp,
                lastResultRisk: cptsdLastResultRisk,
                diagnosticViewName: "CPTSDDiagnosticView"
            )
        ]
    }

    // MARK: - Find Due Retest (first due in order)
    private func dueRetest() -> DiagnosticRetestInfo? {
        let now = Date()

        for info in allDiagnostics {
            guard info.lastResultTimestamp > 0 else { continue }
            guard ["High Risk", "Moderate Risk"].contains(info.lastResultRisk) else { continue }

            guard let sixMonthsLater = Calendar.current.date(
                byAdding: .month,
                value: 6,
                to: Date(timeIntervalSince1970: info.lastResultTimestamp)
            ) else { continue }

            if now >= sixMonthsLater {
                return info
            }
        }
        return nil
    }

    // MARK: - ✅ New Year gating helpers
    private func hasPreviousYearSummary() -> Bool {
        let currentYear = Calendar.current.component(.year, from: Date())
        return lifespaceLogModel.loadYearSummary(forYear: currentYear - 1) != nil
    }


    private func parseLastCheckDate(_ raw: String) -> Date? {
        let rawTrimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !rawTrimmed.isEmpty else { return nil }

        // Primary: "yyyy-MM-dd"
        let iso = DateFormatter()
        iso.locale = Locale(identifier: "en_US_POSIX")
        iso.timeZone = TimeZone.current
        iso.dateFormat = "yyyy-MM-dd"
        if let d = iso.date(from: rawTrimmed) { return d }

        // Fallback: locale short date (in case older builds stored it)
        let short = DateFormatter()
        short.locale = Locale.current
        short.timeZone = TimeZone.current
        short.dateStyle = .short
        short.timeStyle = .none
        return short.date(from: rawTrimmed)
    }

    private func hasCompletedLifespaceCheckSinceJan1() -> Bool {
        let calendar = Calendar.current
        let now = Date()
        let year = calendar.component(.year, from: now)

        guard let jan1 = calendar.date(from: DateComponents(year: year, month: 1, day: 1)) else {
            return false
        }

        guard let completed = parseLastCheckDate(lastCheckCompletedDate) else {
            return false
        }

        return completed >= calendar.startOfDay(for: jan1)
    }

    private func shouldShowNewYearFlow() -> Bool {
        let currentYear = Calendar.current.component(.year, from: Date())

        // ✅ Brand-new installs: no previous-year summary => never show NewYearView
        guard hasPreviousYearSummary() else { return false }

        // Only once per year, and only if they haven't completed a check since Jan 1.
        if newYearFlowLastShownYear == currentYear { return false }
        if hasCompletedLifespaceCheckSinceJan1() { return false }
        return true
    }

    // MARK: - START Button Logic
    private func handleStartTapped() {
        withAnimation(.easeInOut(duration: 0.6)) {
            if isSetupComplete {

                // ✅ Ensure reset occurs once per year (even if user missed Jan 1)
                lifespaceLogModel.resetIfNewYear()

                // ✅ NEW YEAR ROUTE (only if they haven’t completed a check since reset)
                if shouldShowNewYearFlow() {
                    navModel.push("NewYearView")
                    return
                }

                // --- Diagnostic Retest Reminder Check ---
                if let due = dueRetest() {
                    navModel.reminderDisorder = due.disorder
                    navModel.reminderDateTaken = Date(timeIntervalSince1970: due.lastResultTimestamp)
                    navModel.reminderRiskLevel = due.lastResultRisk
                    navModel.reminderDiagnosticViewName = due.diagnosticViewName
                    navModel.reminderDailyCheckViewName = "LightCheckView"

                    navModel.selectedScreen = "DiagnosticReminderView"
                    return
                }

                // ✅ Use the same format LifespaceLogModel writes: "yyyy-MM-dd"
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.timeZone = TimeZone.current
                formatter.dateFormat = "yyyy-MM-dd"
                let todayKey = formatter.string(from: Calendar.current.startOfDay(for: Date()))

                if lastCheckCompletedDate == todayKey {
                    navModel.push("ResultsView")
                } else {
                    navModel.push("LightCheckView")
                }

            } else {
                if !hasSeenDisclaimer {
                    navModel.push("DisclaimerView")
                } else if !hasSeenLifespaceInfo {
                    navModel.push("LifespaceInfoView")
                } else if !hasSeenMenuTutorial {
                    navModel.push("MenuTutorialView")
                } else if !hasSeenOptimizationInfo {
                    navModel.push("OptimizationInfoView")
                } else if !hasSeenStartView {
                    navModel.push("StartView")
                } else {
                    navModel.push("StatsSetupView")
                }
            }
        }
    }
}
