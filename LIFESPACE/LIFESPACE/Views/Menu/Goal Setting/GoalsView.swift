import SwiftUI

struct GoalsView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var goalsViewModel: GoalsViewModel

    @AppStorage("fiveYearPlanSubmitted") var fiveYearPlanSubmitted: Bool = false

    // ✅ Risk flags (reactive, so the sunshine button appears/disappears immediately)
    @AppStorage("AnxietyDiagnostic_lastResultRisk") private var anxietyRisk: String = ""
    @AppStorage("DepressionDiagnostic_lastResultRisk") private var depressionRisk: String = ""
    @AppStorage("PSSDDiagnostic_lastResultRisk") private var pssdRisk: String = ""
    @AppStorage("ADHDDiagnostic_lastResultRisk") private var adhdRisk: String = ""
    @AppStorage("AutismDiagnostic_lastResultRisk") private var autismRisk: String = ""
    @AppStorage("BPDDiagnostic_lastResultRisk") private var bpdRisk: String = ""
    @AppStorage("PsychosisDiagnostic_lastResultRisk") private var psychosisRisk: String = ""
    @AppStorage("CPTSDDiagnostic_lastResultRisk") private var cptsdRisk: String = ""

    @State private var newGoalTitle: String = ""
    @State private var showDeleteAlert: Bool = false
    @State private var goalToDelete: Goal?
    @State private var pulse = false

    private var hasAtLeastOneModerateOrHigh: Bool {
        let risks = [anxietyRisk, depressionRisk, pssdRisk, adhdRisk, autismRisk, bpdRisk, psychosisRisk, cptsdRisk]
        return risks.contains("Moderate Risk") || risks.contains("High Risk")
    }

    var body: some View {
        ZStack(alignment: .bottom) {

            // 🌊 LIFESPACE gradient background
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

            VStack(spacing: 18) {

                Text("Set a New Goal")
                    .font(.system(size: 38, weight: .heavy))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.18), radius: 10, y: 6)
                    .padding(.top, 26)

                // ✅ KEEP EXACT INPUT BOX DESIGN (unchanged)
                HStack(spacing: 0) {
                    ZStack(alignment: .leading) {
                        if newGoalTitle.isEmpty {
                            Text("Enter new goal…")
                                .foregroundColor(.white.opacity(0.5))
                                .padding(.horizontal, 16)
                        }
                        TextField("", text: $newGoalTitle)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color.white.opacity(0.17))
                            .cornerRadius(12)
                            .font(.system(size: 19, weight: .regular, design: .default))
                            .disableAutocorrection(false)
                            .autocapitalization(.sentences)
                    }
                    .frame(height: 48)
                    .frame(maxWidth: .infinity)

                    Button(action: {
                        let trimmed = newGoalTitle.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !trimmed.isEmpty else { return }
                        goalsViewModel.addGoal(title: trimmed)
                        newGoalTitle = ""
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 42, height: 42)
                            .foregroundColor(.white)
                            .shadow(radius: 3)
                            .scaleEffect(newGoalTitle.isEmpty ? 1 : 1.08)
                            .opacity(newGoalTitle.isEmpty ? 0.6 : 1)
                            .animation(.easeInOut(duration: 0.32), value: newGoalTitle)
                    }
                    .padding(.leading, 8)
                }
                .padding(.horizontal, 16)
                .padding(.top, 6)

                // Goals list (scrolls cleanly, does not fight the bottom dock)
                ScrollView {
                    VStack(spacing: 14) {

                        if goalsViewModel.goals.isEmpty {
                            VStack(spacing: 10) {
                                Text("No goals yet.")
                                    .font(.system(size: 20, weight: .heavy))
                                    .foregroundColor(.white)

                                Text("Add one above, then tap it to get started.")
                                    .font(.custom("Avenir", size: 16))
                                    .foregroundColor(.white.opacity(0.85))
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.vertical, 22)
                            .padding(.horizontal, 18)
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.10))
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white.opacity(0.14), lineWidth: 1)
                            )
                            .padding(.top, 6)
                        }

                        ForEach(goalsViewModel.goals, id: \.id) { goal in
                            HStack(spacing: 10) {

                                Button(action: {
                                    if goal.hasStarted {
                                        if goal.goalStepsSet {
                                            navModel.push("GoalView:\(goal.id)")
                                        } else {
                                            navModel.push("GoalStepsView:\(goal.id)")
                                        }
                                    } else {
                                        navModel.push("GoalPlannerView:\(goal.id)")
                                    }
                                }) {
                                    HStack(spacing: 12) {
                                        Image(systemName: "target")
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundColor(.white.opacity(0.85))

                                        Text(goal.title)
                                            .foregroundColor(.white)
                                            .font(.system(size: 18, weight: .semibold))
                                            .lineLimit(2)
                                            .minimumScaleFactor(0.9)

                                        Spacer()

                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(.white.opacity(0.55))
                                    }
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 14)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.white.opacity(0.11))
                                    .cornerRadius(14)
                                }

                                Button(action: {
                                    goalToDelete = goal
                                    showDeleteAlert = true
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .font(.system(size: 26, weight: .bold))
                                        .foregroundColor(Color.red.opacity(0.92))
                                        .shadow(color: .black.opacity(0.18), radius: 6, y: 4)
                                        .accessibilityLabel("Delete Goal")
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 120) // ✅ space for bottom dock
                }
            }

            // ✅ Bottom Dock (fixed sizing so buttons never vanish)
            HStack(spacing: 12) {

                // 5-Year Plan
                Button(action: {
                    if fiveYearPlanSubmitted {
                        navModel.push("FiveYearGoalView")
                    } else {
                        navModel.push("FiveYearPlanView")
                    }
                }) {
                    HStack(spacing: 10) {
                        Image(systemName: "calendar.circle.fill")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)

                        Text("5-Year Plan")
                            .font(.system(size: 20, weight: .heavy))
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.85)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.teal.opacity(0.98),
                                Color.cyan.opacity(0.89)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(22)
                    .scaleEffect(pulse ? 1.02 : 1.0)
                    .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: pulse)
                }
                .layoutPriority(1)

                // Daily Goal (ONLY if user has >= 1 Moderate/High disorder)
                if hasAtLeastOneModerateOrHigh {
                    Button {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            navModel.push("DailyGoalView")
                        }
                    } label: {
                        Image(systemName: "sun.max.fill")
                            .font(.system(size: 24, weight: .heavy))
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(red: 0.22, green: 0.88, blue: 0.78),
                                        Color(red: 0.10, green: 0.55, blue: 0.55)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(18)
                            .shadow(color: .white.opacity(0.12), radius: 10, y: 5)
                    }
                    .layoutPriority(2)
                }

                // Home
                Button(action: { navModel.push("HomeView") }) {
                    Image(systemName: "house.fill")
                        .font(.system(size: 24, weight: .heavy))
                        .foregroundColor(.white)
                        .frame(width: 56, height: 56)
                        .background(Color.white.opacity(0.14))
                        .cornerRadius(18)
                }
                .layoutPriority(2)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white.opacity(0.08))
            .cornerRadius(26)
            .padding(.horizontal, 16)
            .padding(.bottom, 22)
            .onAppear { pulse = true }
        }
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("Delete Goal"),
                message: Text("Do you want to delete this goal?"),
                primaryButton: .destructive(Text("Delete")) {
                    if let goal = goalToDelete {
                        goalsViewModel.deleteGoal(goal)
                    }
                    goalToDelete = nil
                },
                secondaryButton: .cancel { goalToDelete = nil }
            )
        }
    }
}
