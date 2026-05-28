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

    @AppStorage("lastCheckCompletedDate") private var lastCheckCompletedDate: String = ""
    @AppStorage("newYearFlow_lastShownYear") private var newYearFlowLastShownYear: Int = 0

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
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let logoSize = min(200, screenWidth * 0.48)
            let buttonWidth = min(300, screenWidth * 0.78)

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

                VStack(spacing: 32) {
                    Spacer(minLength: 24)

                    Image("lifespace_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: logoSize, height: logoSize)
                        .opacity(showContent ? 1 : 0)
                        .animation(.easeInOut(duration: 1), value: showContent)

                    Text("LIFESPACE")
                        .font(.system(size: min(48, screenWidth * 0.12), weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.65)
                        .allowsTightening(true)
                        .padding(.horizontal, 24)
                        .opacity(showContent ? 1 : 0)
                        .animation(.easeInOut(duration: 1.2).delay(0.2), value: showContent)

                    Spacer(minLength: 24)

                    Button(action: handleStartTapped) {
                        Text("START")
                            .font(.headline)
                            .foregroundColor(Color(red: 0.12, green: 0.49, blue: 0.45))
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                            .frame(width: buttonWidth, height: 75)
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
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                        .opacity(showContent ? 1 : 0)
                        .animation(.easeInOut(duration: 1).delay(0.4), value: showContent)

                    Spacer(minLength: 24)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .onAppear {
                if isSetupComplete {
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

    private var allDiagnostics: [DiagnosticRetestInfo] {
        [
            DiagnosticRetestInfo(disorder: "Anxiety", lastResultTimestamp: anxietyLastResultTimestamp, lastResultRisk: anxietyLastResultRisk, diagnosticViewName: "AnxietyDiagnosticView"),
            DiagnosticRetestInfo(disorder: "Depression", lastResultTimestamp: depressionLastResultTimestamp, lastResultRisk: depressionLastResultRisk, diagnosticViewName: "DepressionDiagnosticView"),
            DiagnosticRetestInfo(disorder: "PSSD", lastResultTimestamp: pssdLastResultTimestamp, lastResultRisk: pssdLastResultRisk, diagnosticViewName: "PSSDDiagnosticView"),
            DiagnosticRetestInfo(disorder: "ADHD", lastResultTimestamp: adhdLastResultTimestamp, lastResultRisk: adhdLastResultRisk, diagnosticViewName: "ADHDDiagnosticView"),
            DiagnosticRetestInfo(disorder: "Autism", lastResultTimestamp: autismLastResultTimestamp, lastResultRisk: autismLastResultRisk, diagnosticViewName: "AutismDiagnosticView"),
            DiagnosticRetestInfo(disorder: "BPD", lastResultTimestamp: bpdLastResultTimestamp, lastResultRisk: bpdLastResultRisk, diagnosticViewName: "BPDDiagnosticView"),
            DiagnosticRetestInfo(disorder: "Psychosis", lastResultTimestamp: psychosisLastResultTimestamp, lastResultRisk: psychosisLastResultRisk, diagnosticViewName: "PsychosisDiagnosticView"),
            DiagnosticRetestInfo(disorder: "C-PTSD", lastResultTimestamp: cptsdLastResultTimestamp, lastResultRisk: cptsdLastResultRisk, diagnosticViewName: "CPTSDDiagnosticView")
        ]
    }

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

    private func hasPreviousYearSummary() -> Bool {
        let currentYear = Calendar.current.component(.year, from: Date())
        return lifespaceLogModel.loadYearSummary(forYear: currentYear - 1) != nil
    }

    private func parseLastCheckDate(_ raw: String) -> Date? {
        let rawTrimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !rawTrimmed.isEmpty else { return nil }

        let iso = DateFormatter()
        iso.locale = Locale(identifier: "en_US_POSIX")
        iso.timeZone = TimeZone.current
        iso.dateFormat = "yyyy-MM-dd"
        if let d = iso.date(from: rawTrimmed) { return d }

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

        guard hasPreviousYearSummary() else { return false }
        if newYearFlowLastShownYear == currentYear { return false }
        if hasCompletedLifespaceCheckSinceJan1() { return false }
        return true
    }

    private func handleStartTapped() {
        withAnimation(.easeInOut(duration: 0.6)) {
            if isSetupComplete {
                lifespaceLogModel.resetIfNewYear()

                if shouldShowNewYearFlow() {
                    navModel.push("NewYearView")
                    return
                }

                if let due = dueRetest() {
                    navModel.reminderDisorder = due.disorder
                    navModel.reminderDateTaken = Date(timeIntervalSince1970: due.lastResultTimestamp)
                    navModel.reminderRiskLevel = due.lastResultRisk
                    navModel.reminderDiagnosticViewName = due.diagnosticViewName
                    navModel.reminderDailyCheckViewName = "LightCheckView"
                    navModel.selectedScreen = "DiagnosticReminderView"
                    return
                }

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