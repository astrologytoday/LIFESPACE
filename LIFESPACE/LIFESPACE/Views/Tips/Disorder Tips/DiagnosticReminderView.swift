import SwiftUI

struct DiagnosticReminderView: View {
    @EnvironmentObject var navModel: NavigationModel
    @AppStorage("lastCheckCompletedDate") private var lastCheckCompletedDate: String = ""

    // --- Data comes from NavigationModel ---
    var disorder: String { navModel.reminderDisorder }
    var dateTaken: Date { navModel.reminderDateTaken }
    var riskLevel: String { navModel.reminderRiskLevel }
    var diagnosticViewName: String { navModel.reminderDiagnosticViewName }
    var dailyCheckViewName: String { navModel.reminderDailyCheckViewName }

    var dateFormatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: dateTaken)
    }

    // Grammar helper (a/an)
    var article: String {
        let first = disorder.lowercased().first ?? "a"
        return ["a", "e", "i", "o", "u"].contains(first) ? "an" : "a"
    }

    // ✅ NEW — reset diagnostic state when user selects NO
    private func resetDiagnosticState() {
        let diagnosticKey = disorder.replacingOccurrences(of: "-", with: "") + "Diagnostic"

        UserDefaults.standard.set(0.0, forKey: "\(diagnosticKey)_lastResultTimestamp")
        UserDefaults.standard.set("",  forKey: "\(diagnosticKey)_lastResultRisk")

        NotificationManager.shared.cancelSixMonthRetestNotification(for: disorder)
    }

    private func routeAfterNo() {
        let today = DateFormatter.localizedString(
            from: Date(),
            dateStyle: .short,
            timeStyle: .none
        )

        if lastCheckCompletedDate == today {
            navModel.selectedScreen = "ResultsView"
        } else {
            navModel.selectedScreen = dailyCheckViewName
        }
    }

    
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

            VStack(spacing: 32) {
                Spacer(minLength: 60)

                Text("Hello!")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)

                VStack(spacing: 20) {
                    Text(.init(
                        "You took \(article) **\(disorder) Diagnostic Test** on **\(dateFormatted)** and were marked \(riskLevel.capitalized) for **\(disorder).**"
                    ))

                    Text(.init(
                        "Has using LIFESPACE been improving your symptoms?"
                    ))

                    Text(.init(
                        "Take the test again to find out!"
                    ))
                }
                .font(.system(size: 20))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()
                .background(Color.white.opacity(0.12))
                .cornerRadius(16)
                .frame(maxWidth: 440)

                HStack(spacing: 40) {
                    Button {
                        navModel.cameFromDiagnosticReminder = true
                        navModel.selectedScreen = diagnosticViewName
                    } label: {
                        Text("YES")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.teal)
                            .padding(.vertical, 14)
                            .padding(.horizontal, 44)
                            .background(Color.white)
                            .cornerRadius(16)
                    }

                    Button {
                        resetDiagnosticState()
                        routeAfterNo()
                    } label: {
                        Text("NO")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.vertical, 14)
                            .padding(.horizontal, 44)
                            .background(Color.teal.opacity(0.7))
                            .cornerRadius(16)
                    }
                }

                Spacer()
            }
            .padding(.horizontal, 24)
        }
    }
}
