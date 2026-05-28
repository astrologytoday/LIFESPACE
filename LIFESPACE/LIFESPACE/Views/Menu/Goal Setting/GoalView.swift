import SwiftUI

struct GoalView: View {
    @Binding var goal: Goal
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var goalsViewModel: GoalsViewModel
    @State private var showCompletionAlert = false

    // ✅ Reminder highlight
    @State private var highlightedSectionID: String = ""
    @State private var highlightPulse: Bool = false

    func dateString(offsetDays: Int, from date: Date) -> String {
        let dueDate = Calendar.current.date(byAdding: .day, value: offsetDays, to: date)!
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: dueDate)
    }

    var completionDateString: String {
        guard let start = goal.startDate else { return "--" }
        let offset: Int = {
            switch goal.duration {
            case .week: return 7
            case .month: return 30
            case .year: return 365
            }
        }()
        let end = Calendar.current.date(byAdding: .day, value: offset, to: start)!
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: end)
    }

    var leftoverSteps: [String] {
        let assigned = Set(
            goal.stepsRightNow + goal.stepsToday + goal.stepsNext3Days +
            goal.stepsNextWeek + goal.stepsNext2Weeks + goal.stepsNextMonth + goal.stepsNext6Months
        )
        return goal.steps.filter { !assigned.contains($0) }
    }

    private func shouldHighlight(_ sectionID: String) -> Bool {
        sectionID == highlightedSectionID
    }

    private func hasSection(_ sectionID: String) -> Bool {
        switch sectionID {
        case "rightnow": return !goal.stepsRightNow.isEmpty
        case "today": return !goal.stepsToday.isEmpty
        case "3days": return !goal.stepsNext3Days.isEmpty
        case "7days": return !goal.stepsNextWeek.isEmpty
        case "2weeks": return !goal.stepsNext2Weeks.isEmpty
        case "1month": return !goal.stepsNextMonth.isEmpty
        case "6months": return !goal.stepsNext6Months.isEmpty
        case "final": return !leftoverSteps.isEmpty
        default: return false
        }
    }

    private func clearGoalReminderPayload() {
        navModel.reminderGoalID = ""
        navModel.reminderGoalBucketKey = ""
        navModel.cameFromGoalReminder = false
    }

    private func triggerReminderScrollIfNeeded(proxy: ScrollViewProxy) {
        guard navModel.cameFromGoalReminder else { return }
        guard navModel.reminderGoalID == goal.id.uuidString else { return }

        let target = navModel.reminderGoalBucketKey.lowercased()
        guard !target.isEmpty else {
            clearGoalReminderPayload()
            return
        }

        guard hasSection(target) else {
            clearGoalReminderPayload()
            return
        }

        // Consume payload immediately so it does not re-trigger later
        clearGoalReminderPayload()

        // Scroll + highlight (after layout settles)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            withAnimation(.easeInOut(duration: 0.6)) {
                proxy.scrollTo(target, anchor: .top)
            }

            highlightedSectionID = target
            highlightPulse = true

            // Auto-clear highlight after a few seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
                withAnimation(.easeInOut(duration: 0.4)) {
                    highlightPulse = false
                    highlightedSectionID = ""
                }
            }
        }
    }

    func checklistSection(sectionID: String, title: String, dueDate: String?, steps: [String]) -> some View {
        let isHot = shouldHighlight(sectionID)

        return VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Due:")
                    .font(.headline)
                    .foregroundColor(.white)
                if let date = dueDate {
                    Text(date)
                        .font(.headline).bold()
                        .foregroundColor(.yellow)
                } else {
                    Text(title)
                        .font(.headline).bold()
                        .foregroundColor(.yellow)
                }
            }

            ForEach(steps, id: \.self) { step in
                HStack(spacing: 12) {
                    Button(action: {
                        toggleCheckbox(for: step)
                    }) {
                        Image(systemName: goal.completedStepIDs.contains(step) ? "checkmark.square.fill" : "square")
                            .foregroundColor(goal.completedStepIDs.contains(step) ? .teal : .white.opacity(0.8))
                            .font(.system(size: 28, weight: .bold))
                    }
                    Text(step)
                        .foregroundColor(.white)
                        .font(.title3).bold()
                        .strikethrough(goal.completedStepIDs.contains(step), color: .teal)
                }
                .padding(.vertical, 2)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
        .background(isHot ? Color.yellow.opacity(0.18) : Color.white.opacity(0.12))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(isHot ? Color.yellow.opacity(0.85) : Color.clear, lineWidth: 2)
        )
        .shadow(color: isHot ? Color.yellow.opacity(highlightPulse ? 0.55 : 0.18) : Color.clear,
                radius: isHot ? (highlightPulse ? 18 : 8) : 0,
                y: isHot ? 6 : 0)
        .animation(.easeInOut(duration: 0.75).repeatForever(autoreverses: true), value: highlightPulse)
        .padding(.bottom, 8)
        .id(sectionID)
    }

    func toggleCheckbox(for step: String) {
        if goal.completedStepIDs.contains(step) {
            goal.completedStepIDs.remove(step)
        } else {
            goal.completedStepIDs.insert(step)
        }
        goalsViewModel.updateGoal(goal)
        if allStepsChecked() { showCompletionAlert = true }
    }

    func allStepsChecked() -> Bool {
        let allSteps = goal.stepsRightNow + goal.stepsToday + goal.stepsNext3Days +
                       goal.stepsNextWeek + goal.stepsNext2Weeks + goal.stepsNextMonth + goal.stepsNext6Months +
                       leftoverSteps
        return !allSteps.isEmpty && allSteps.allSatisfy { goal.completedStepIDs.contains($0) }
    }

    // MARK: - Dates for each section
    private var todayDate: String? {
        goal.startDate.map {
            DateFormatter.localizedString(from: $0, dateStyle: .medium, timeStyle: .none)
        }
    }
    private var threeDaysDate: String? {
        goal.startDate.map { dateString(offsetDays: 3, from: $0) }
    }
    private var sevenDaysDate: String? {
        goal.startDate.map { dateString(offsetDays: 7, from: $0) }
    }
    private var twoWeeksDate: String? {
        goal.startDate.map { dateString(offsetDays: 14, from: $0) }
    }
    private var oneMonthDate: String? {
        goal.startDate.map { dateString(offsetDays: 30, from: $0) }
    }
    private var sixMonthsDate: String? {
        goal.startDate.map { dateString(offsetDays: 180, from: $0) }
    }
    private var completionDate: String? {
        goal.startDate.map { _ in completionDateString }
    }

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.21, green: 0.85, blue: 0.79),
                    Color(red: 0.20, green: 0.65, blue: 0.60),
                    Color(red: 0.10, green: 0.45, blue: 0.45)
                ]),
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollViewReader { proxy in
                VStack {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 28) {
                            Text(goal.title.uppercased())
                                .font(.system(size: 34, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                                .padding(.top, 16)
                                .padding(.bottom, 8)
                                .shadow(color: .teal.opacity(0.3), radius: 7, x: 0, y: 4)
                                .id("top")

                            HStack {
                                Text("Completion Date:")
                                    .font(.title3)
                                    .foregroundColor(.white)
                                Text(completionDateString)
                                    .font(.title3).bold()
                                    .foregroundColor(.yellow)
                            }
                            .padding(.bottom, 10)

                            if !goal.stepsRightNow.isEmpty {
                                checklistSection(sectionID: "rightnow", title: "Right Now!", dueDate: nil, steps: goal.stepsRightNow)
                            }
                            if !goal.stepsToday.isEmpty {
                                checklistSection(sectionID: "today", title: "Today", dueDate: todayDate, steps: goal.stepsToday)
                            }
                            if !goal.stepsNext3Days.isEmpty {
                                checklistSection(sectionID: "3days", title: "3 Days", dueDate: threeDaysDate, steps: goal.stepsNext3Days)
                            }
                            if !goal.stepsNextWeek.isEmpty {
                                checklistSection(sectionID: "7days", title: "7 Days", dueDate: sevenDaysDate, steps: goal.stepsNextWeek)
                            }
                            if !goal.stepsNext2Weeks.isEmpty {
                                checklistSection(sectionID: "2weeks", title: "2 Weeks", dueDate: twoWeeksDate, steps: goal.stepsNext2Weeks)
                            }
                            if !goal.stepsNextMonth.isEmpty {
                                checklistSection(sectionID: "1month", title: "1 Month", dueDate: oneMonthDate, steps: goal.stepsNextMonth)
                            }
                            if !goal.stepsNext6Months.isEmpty {
                                checklistSection(sectionID: "6months", title: "6 Months", dueDate: sixMonthsDate, steps: goal.stepsNext6Months)
                            }
                            if !leftoverSteps.isEmpty {
                                checklistSection(sectionID: "final", title: "Final Deadline", dueDate: completionDate, steps: leftoverSteps)
                            }
                        }
                        .padding(.horizontal, 22)
                        .padding(.top, 10)
                        .padding(.bottom, 85)
                    }
                    .scrollIndicators(.hidden)
                    .onAppear { triggerReminderScrollIfNeeded(proxy: proxy) }
                    .onChange(of: navModel.reminderGoalID) { _ in
                        triggerReminderScrollIfNeeded(proxy: proxy)
                    }

                    Spacer()

                    HStack(alignment: .center, spacing: 22) {
                        VStack(spacing: 15) {
                            Button(action: {
                                navModel.push("GoalsView")
                            }) {
                                HStack {
                                    Image(systemName: "arrow.uturn.left.circle.fill")
                                        .font(.system(size: 28, weight: .bold))
                                        .foregroundColor(.teal)
                                    Text("Back to Goals")
                                        .font(.headline).bold()
                                        .foregroundColor(.white)
                                }
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(Color.teal.opacity(0.93))
                                .cornerRadius(30)
                                .shadow(radius: 7)
                            }

                            Button(action: {
                                navModel.push("GoalPlannerView:\(goal.id)")
                            }) {
                                HStack {
                                    Image(systemName: "pencil.circle.fill")
                                        .font(.system(size: 27, weight: .bold))
                                        .foregroundColor(.teal)
                                    Text("Edit Goal")
                                        .font(.headline).bold()
                                        .foregroundColor(.white)
                                }
                                .padding(.horizontal, 18)
                                .padding(.vertical, 8)
                                .background(Color.teal.opacity(0.82))
                                .cornerRadius(30)
                                .shadow(radius: 7)
                            }
                        }

                        Spacer()

                        Button(action: {
                            navModel.push("HomeView")
                        }) {
                            Image(systemName: "house.fill")
                                .font(.system(size: 38, weight: .bold))
                                .frame(width: 76, height: 82)
                                .background(Color.teal)
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 37, style: .continuous))
                                .shadow(radius: 7)
                        }
                    }
                    .padding(.horizontal, 28)
                    .padding(.bottom, 28)
                }
            }
        }
        .alert(isPresented: $showCompletionAlert) {
            Alert(
                title: Text("Have you completed your goal?"),
                message: Text("If so, you can mark this goal as complete."),
                primaryButton: .default(Text("Yes")) {
                    navModel.push("GoalCompleteView:\(goal.id)")
                },
                secondaryButton: .cancel(Text("No"))
            )
        }
    }
}
