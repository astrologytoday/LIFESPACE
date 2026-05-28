import SwiftUI

struct SideMenuView: View {
    @EnvironmentObject var navModel: NavigationModel
    @AppStorage("isSetupComplete") var isSetupComplete: Bool = false
    var onSelect: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            MenuItem(title: "Lifestyle Survey") {
                onSelect("LifestyleSurveyView")
            }
            MenuItem(title: "Fitness Space") {
                onSelect("FitnessSpaceView")
            }
            MenuItem(title: "To-Do List") {
                onSelect("ToDoListView")
            }
            MenuItem(title: "Day Planner") {
                onSelect("DayPlannerView")
            }
            MenuItem(title: "Budget Planner") {
                onSelect("BudgetPlannerView")
            }
            MenuItem(title: "Daily Journal") {
                let passwordCreated = UserDefaults.standard.bool(forKey: "dreamPasswordCreated")
                onSelect(passwordCreated ? "DreamPasswordView" : "CreateDreamPasswordView")
            }
            MenuItem(title: "My Goals") {
                onSelect("GoalsView")
            }

            MenuItem(title: "Music Player") {
                onSelect("MusicView")
            }
            MenuItem(title: "User Profile") {
                onSelect("SetupConfirmationView")
            }
            MenuItem(title: "Settings") {
                onSelect("NotificationsView")
            }

            Spacer()

            HStack {
                Spacer()
                Button(action: { onSelect("HomeView") }) {
                    Image(systemName: "house.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                }
            }
        }
        .padding(.top, 70)
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundColor(.white)
        .edgesIgnoringSafeArea(.all)
    }
}

// MARK: - Menu Item Component
struct MenuItem: View {
    var title: String
    var disabled: Bool = false
    var action: () -> Void

    var body: some View {
        Button(action: {
            if !disabled { action() }
        }) {
            Text(title)
                .font(.headline)
                .foregroundColor(disabled ? .white.opacity(0.7) : .white)
                .padding(.vertical, 8)
                .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(disabled)
    }
}

