import SwiftUI

struct GoalStepsView: View {
    @Binding var goal: Goal
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var goalsViewModel: GoalsViewModel

    @State private var stepsAssigned: Set<String> = []
    @State private var pulsate = false

    @State private var selected3Days: String = ""
    @State private var selectedToday: String = ""
    @State private var selected2Weeks: String = ""
    @State private var selectedWeek: String = ""
    @State private var selected6Months: String = ""
    @State private var selectedMonth: String = ""
    @State private var selectedRightNow: String = ""

    // MARK: - Headline Helpers
    private var daysString: String {
        switch goal.duration {
        case .week: return "7 DAYS"
        case .month: return "30 DAYS"
        case .year: return "365 DAYS"
        }
    }

    private var durationString: String {
        switch goal.duration {
        case .week: return "WEEK"
        case .month: return "MONTH"
        case .year: return "YEAR"
        }
    }

    // MARK: - Sync Logic
    private func syncGoalStepsWithBreakdowns() {
        let allStepsSet = Set(goal.steps)

        goal.stepsToday.removeAll { !allStepsSet.contains($0) }
        goal.stepsRightNow.removeAll { !allStepsSet.contains($0) }
        goal.stepsNext3Days.removeAll { !allStepsSet.contains($0) }
        goal.stepsNextWeek.removeAll { !allStepsSet.contains($0) }
        goal.stepsNext2Weeks.removeAll { !allStepsSet.contains($0) }
        goal.stepsNextMonth.removeAll { !allStepsSet.contains($0) }
        goal.stepsNext6Months.removeAll { !allStepsSet.contains($0) }

        stepsAssigned = Set(
            goal.stepsRightNow +
            goal.stepsToday +
            goal.stepsNext3Days +
            goal.stepsNextWeek +
            goal.stepsNext2Weeks +
            goal.stepsNextMonth +
            goal.stepsNext6Months
        )
    }

    // MARK: - Breakdown definition
    private var breakdowns: [BreakdownPickerData] {
        switch goal.duration {

        case .week:
            return [
                BreakdownPickerData(
                    label: "What can you be doing RIGHT NOW?",
                    steps: $goal.stepsRightNow,
                    selected: $selectedRightNow,
                    isRightNow: true
                ),
                BreakdownPickerData(
                    label: "What do you need to do TODAY?",
                    steps: $goal.stepsToday,
                    selected: $selectedToday
                ),
                BreakdownPickerData(
                    label: "What do you need to do in the next 3 DAYS?",
                    steps: $goal.stepsNext3Days,
                    selected: $selected3Days
                )
            ]

        case .month:
            return [
                BreakdownPickerData(
                    label: "What can you be doing RIGHT NOW?",
                    steps: $goal.stepsRightNow,
                    selected: $selectedRightNow,
                    isRightNow: true
                ),
                BreakdownPickerData(
                    label: "What do you need to do TODAY?",
                    steps: $goal.stepsToday,
                    selected: $selectedToday
                ),
                BreakdownPickerData(
                    label: "What do you need to do in the next 7 DAYS?",
                    steps: $goal.stepsNextWeek,
                    selected: $selectedWeek
                ),
                BreakdownPickerData(
                    label: "What do you need to do in the next 2 WEEKS?",
                    steps: $goal.stepsNext2Weeks,
                    selected: $selected2Weeks
                )
            ]

        case .year:
            return [
                BreakdownPickerData(
                    label: "What can you be doing RIGHT NOW?",
                    steps: $goal.stepsRightNow,
                    selected: $selectedRightNow,
                    isRightNow: true
                ),
                BreakdownPickerData(
                    label: "What do you need to do TODAY?",
                    steps: $goal.stepsToday,
                    selected: $selectedToday
                ),
                BreakdownPickerData(
                    label: "What do you need to do in the next 7 DAYS?",
                    steps: $goal.stepsNextWeek,
                    selected: $selectedWeek
                ),
                BreakdownPickerData(
                    label: "What do you need to do in the next 30 DAYS?",
                    steps: $goal.stepsNextMonth,
                    selected: $selectedMonth
                ),
                BreakdownPickerData(
                    label: "What do you need to do in the next 6 MONTHS?",
                    steps: $goal.stepsNext6Months,
                    selected: $selected6Months
                )
            ]
        }
    }

    // MARK: - Unassigned steps list
    private func availableSteps() -> [String] {
        let assigned = Set(
            goal.stepsRightNow +
            goal.stepsToday +
            goal.stepsNext3Days +
            goal.stepsNextWeek +
            goal.stepsNext2Weeks +
            goal.stepsNextMonth +
            goal.stepsNext6Months
        )

        return goal.steps.filter { !assigned.contains($0) }
    }

    // MARK: - Headline View
    @ViewBuilder
    private var headlineDurationView: some View {
        if goal.duration == .month {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("It will take a")
                        .foregroundColor(.white)

                    Text(durationString)
                        .foregroundColor(.yellow)
                        .bold()
                        .scaleEffect(pulsate ? 1.13 : 1.0)
                        .animation(
                            .easeInOut(duration: 0.7).repeatForever(autoreverses: true),
                            value: pulsate
                        )

                    Text("to complete")
                        .foregroundColor(.white)
                }

                Text("this goal.")
                    .foregroundColor(.white)
            }
        } else {
            HStack {
                Text("It will take a")
                    .foregroundColor(.white)

                Text(durationString)
                    .foregroundColor(.yellow)
                    .bold()
                    .scaleEffect(pulsate ? 1.13 : 1.0)
                    .animation(
                        .easeInOut(duration: 0.7).repeatForever(autoreverses: true),
                        value: pulsate
                    )

                Text("to complete this goal.")
                    .foregroundColor(.white)
            }
        }
    }

    // MARK: - UI
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {

                Text(goal.title)
                    .font(.system(size: 36, weight: .black))
                    .foregroundColor(.white)
                    .padding(.top, 12)

                headlineDurationView
                    .font(.title2)
                    .onAppear { pulsate = true }

                Text("Start with what you can do right now, then assign the remaining steps further into the future.")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.9))

                // Unassigned Steps
                VStack(alignment: .leading, spacing: 10) {
                    if availableSteps().isEmpty {
                        Text("All steps have been assigned.")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.75))
                    } else {
                        ForEach(availableSteps(), id: \.self) { step in
                            HStack(spacing: 12) {
                                Circle()
                                    .fill(Color.white.opacity(0.5))
                                    .frame(width: 10, height: 10)

                                Text(step)
                                    .font(.title3)
                                    .foregroundColor(.white)
                                    .bold()
                            }
                        }
                    }
                }
                .padding()
                .background(Color.white.opacity(0.05))
                .cornerRadius(16)

                Divider().background(Color.white.opacity(0.2))

                // Breakdown Sections
                ForEach(breakdowns) { section in
                    BreakdownStepPickerSectionV2(
                        title: section.label,
                        isRightNow: section.isRightNow,
                        allSteps: goal.steps,
                        steps: section.steps,
                        selectedStep: section.selected,
                        stepsAssigned: $stepsAssigned
                    )
                }

                // Start Goal Button
                Button(action: {
                    goal.goalStepsSet = true

                    goalsViewModel.updateGoal(goal)

                    NotificationManager.shared.rescheduleGoalStepReminders(
                        goals: goalsViewModel.goals
                    )

                    withAnimation(.easeInOut(duration: 0.4)) {
                        navModel.push("GoalView:\(goal.id)")
                    }
                }) {
                    Text("START GOAL")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                        .padding(.vertical, 18)
                        .frame(maxWidth: .infinity)
                        .background(Color.teal)
                        .cornerRadius(40)
                        .shadow(radius: 8)
                }
                .padding(.vertical, 20)
            }
            .padding(.horizontal, 20)
            .onAppear {
                syncGoalStepsWithBreakdowns()
            }
        }
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.35, green: 0.80, blue: 0.75),
                    Color(red: 0.20, green: 0.65, blue: 0.60),
                    Color(red: 0.10, green: 0.45, blue: 0.45)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }
}

// MARK: - Breakdown Data
struct BreakdownPickerData: Identifiable {
    let id = UUID()
    let label: String
    var steps: Binding<[String]>
    var selected: Binding<String>
    var isRightNow: Bool = false
}

// MARK: - Picker Section UI
struct BreakdownStepPickerSectionV2: View {
    let title: String
    let isRightNow: Bool
    let allSteps: [String]
    @Binding var steps: [String]
    @Binding var selectedStep: String
    @Binding var stepsAssigned: Set<String>

    var availableSteps: [String] {
        allSteps.filter { !stepsAssigned.contains($0) }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            Text(title)
                .font(.headline)
                .foregroundColor(.white)

            VStack(spacing: 7) {
                ForEach(steps.indices, id: \.self) { idx in
                    HStack {
                        Text(steps[idx])
                            .foregroundColor(.white)

                        Spacer()

                        Button {
                            stepsAssigned.remove(steps[idx])
                            steps.remove(at: idx)
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                                .font(.title2)
                        }
                    }
                    .padding(6)
                    .background(Color.white.opacity(0.07))
                    .cornerRadius(10)
                }
            }

            if !availableSteps.isEmpty {
                HStack(spacing: 12) {

                    Menu {
                        ForEach(availableSteps, id: \.self) { step in
                            Button(step) {
                                selectedStep = step
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedStep.isEmpty ? "Select Step" : selectedStep)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)

                            Image(systemName: "chevron.down")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.white.opacity(0.12))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.white.opacity(0.25), lineWidth: 1)
                        )
                        .shadow(
                            color: Color.black.opacity(0.15),
                            radius: 4,
                            x: 0,
                            y: 2
                        )
                    }

                    Button {
                        steps.append(selectedStep)
                        stepsAssigned.insert(selectedStep)
                        selectedStep = ""
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .padding(10)
                            .background(
                                Circle().fill(Color.teal.opacity(0.8))
                            )
                            .shadow(radius: 4)
                    }
                    .disabled(selectedStep.isEmpty)
                    .opacity(selectedStep.isEmpty ? 0.3 : 1)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
        .padding(.bottom, 6)
    }
}
