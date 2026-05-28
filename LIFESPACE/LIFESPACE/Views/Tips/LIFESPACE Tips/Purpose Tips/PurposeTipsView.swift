import SwiftUI

struct PurposeTipsView: View {
    @EnvironmentObject var navModel: NavigationModel
    @Environment(\.openURL) private var openURL
    
    @State private var appeared = false

    // Collapsible states (default CLOSED)
    @State private var showGoalModels: Bool = false
    @State private var showRoadmap: Bool = false
    @State private var showWorkflow: Bool = false
    @State private var showCalendar: Bool = false
    @State private var showOnlineTools: Bool = false
    @State private var showFinance: Bool = false

    var body: some View {
        ZStack {
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

            // ✅ Layout bars so buttons DON'T hover over content
            VStack(spacing: 0) {

                // TOP BAR (non-overlapping)
                HStack {
                    BackButtonView(customTarget: "TipsView")
                    Spacer()
                }
                .padding(.leading, 14)
                .padding(.top, 8)
                .padding(.bottom, 8)

                // CONTENT
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {

                        // 🧠 Header
                        Text("Purpose Tips")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(radius: 4)

                        Text("To give you a reason for living")
                            .font(.title3)
                            .italic()
                            .foregroundColor(Color.white.opacity(0.95))
                            .fixedSize(horizontal: false, vertical: true)

                        // 📘 Dictionary card
                        DictionaryCard(
                            headword: "Purpose",
                            partOfSpeech: "noun",
                            definition: "1: a clear sense of direction that organizes your time, strengthens your identity, and makes effort feel meaningful."
                        )

                        // ✅ 1) GOAL MODELS FIRST
                        CollapsibleCard(
                            title: "Goal Models That Actually Work",
                            systemImage: "target",
                            isExpanded: $showGoalModels
                        ) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Most people fail goals for one reason: the goal is vague. These two frameworks fix that by turning hope into structure.")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.92))
                                    .fixedSize(horizontal: false, vertical: true)

                                DividerLine()

                                Text("SMART Goals")
                                    .font(.system(size: 18, weight: .heavy))
                                    .foregroundColor(.white)

                                BulletRow("Specific: define exactly what you will do.")
                                BulletRow("Measurable: include numbers or clear proof of progress.")
                                BulletRow("Achievable: ambitious, but realistic with your resources.")
                                BulletRow("Relevant: connected to your values and long-term direction.")
                                BulletRow("Time-bound: a deadline that creates urgency and focus.")

                                DividerLine()

                                Text("The 5-Year Plan")
                                    .font(.system(size: 18, weight: .heavy))
                                    .foregroundColor(.white)

                                Text("A 5-year plan works because it gives your brain a map. It reduces decision fatigue, helps you ignore distractions, and makes short-term sacrifices feel worth it.")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.92))
                                    .fixedSize(horizontal: false, vertical: true)

                                Text("How do I make a 5-year plan?")
                                    .font(.system(size: 18, weight: .heavy))
                                    .foregroundColor(.white)

                                BulletRow("Start with a clear vision: describe the life you want in five years in a few sentences.")
                                BulletRow("Choose 3–5 categories to plan across (career, money, health, relationships, creative work, spiritual growth).")
                                BulletRow("Write specific outcomes for each category (what “done” looks like).")
                                BulletRow("Reverse-engineer milestones: year 5 → year 3 → year 1 → next 90 days.")
                                BulletRow("Turn the next 90 days into SMART goals, then schedule the work in your calendar.")
                                BulletRow("Review weekly to adjust your tasks, and review monthly to adjust the plan.")
                            }
                        }

                        // ✅ 2) PURPOSE ROADMAP SECOND
                        CollapsibleCard(
                            title: "Purpose Roadmap",
                            systemImage: "sparkles",
                            isExpanded: $showRoadmap
                        ) {
                            RoadmapContent(
                                onFiveYear: { navModel.push("FiveYearPlanView") },
                                onGoals: { navModel.push("SmartView") },
                                onDailyPlan: { navModel.push("DayPlannerView") }
                            )
                        }

                        // ✅ To-Do + Day Planner workflow (clickable pills, no bottom buttons)
                        CollapsibleCard(
                            title: "To-Do List + Day Planner Workflow",
                            systemImage: "calendar.badge.clock",
                            isExpanded: $showWorkflow
                        ) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("These two tools are designed to function together: your To-Do List holds everything, and your Day Planner turns it into a realistic schedule.")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.92))
                                    .fixedSize(horizontal: false, vertical: true)

                                FlowStrip(items: [
                                    FlowStripItem(
                                        title: "iPhone Reminders",
                                        icon: "apple.logo",
                                        action: {
                                            if let url = URL(string: "x-apple-reminderkit://") {
                                                openURL(url)
                                            }
                                        }
                                    ),
                                    FlowStripItem(title: "To-Do List", icon: "checklist", action: { navModel.push("ToDoListView") }),
                                    FlowStripItem(title: "Day Planner", icon: "calendar", action: { navModel.push("DayPlannerView") }),
                                    FlowStripItem(title: "Drag + Drop", icon: "hand.draw", action: { navModel.push("DayPlannerView") })
                                ])

                                VStack(alignment: .leading, spacing: 10) {
                                    BulletRow("Capture tasks in the To-Do List so nothing stays in your head.")
                                    BulletRow("To-Do items auto-populate into the Day Planner so you can plan fast.")
                                    BulletRow("Drag-and-drop tasks into time slots to create a realistic day.")
                                    BulletRow("Optionally import tasks from iPhone Reminders to pull your life into one place.")
                                }
                                .padding(.top, 2)
                            }
                        }

                        // ✅ NEW: Building a Calendar
                        CollapsibleCard(
                            title: "Building a Calendar",
                            systemImage: "calendar.circle",
                            isExpanded: $showCalendar
                        ) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("A calendar is your external brain. Use it to protect your time, reduce stress, and make your goals real in the physical world.")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.92))
                                    .fixedSize(horizontal: false, vertical: true)

                                DividerLine()

                                Text("Use a calendar outside of LIFESPACE app to track:")
                                    .font(.system(size: 18, weight: .heavy))
                                    .foregroundColor(.white)

                                BulletRow("Appointments, meetings, and commitments with other people.")
                                BulletRow("Deadlines, bill due dates, and important life dates.")
                                BulletRow("Health routines, workouts, therapy, rest days, and recovery time.")
                                BulletRow("Creative blocks, deep work sessions, and focused building time.")

                                DividerLine()

                                Text("How it connects to your To-Do List + Goal Planner")
                                    .font(.system(size: 18, weight: .heavy))
                                    .foregroundColor(.white)

                                BulletRow("Press and hold a task on your To-Do List to mark it as urgent.")
                                BulletRow("Review your To-Do List and schedule the highest-impact tasks first.")
                                BulletRow("Take your goals and put the due dates on your calendar so the plan becomes tangible.")
                                BulletRow("Add milestone markers leading up to deadlines, so you remember to keep making progress.")
                            }
                        }

                        // ✅ Online Focus Tools
                        CollapsibleCard(
                            title: "Online Focus Tools",
                            systemImage: "bolt.slash",
                            isExpanded: $showOnlineTools
                        ) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Short-form feeds can quietly hijack hours and leave you with attention fatigue. If your purpose matters, protecting your focus is not optional.")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.92))
                                    .fixedSize(horizontal: false, vertical: true)

                                DividerLine()

                                Text("Shorts blockers")
                                    .font(.system(size: 18, weight: .heavy))
                                    .foregroundColor(.white)

                                BulletRow("Block Shorts/Reels-style feeds so you do not slip into autopilot.")
                                BulletRow("Remove the lowest-effort dopamine loops from your environment.")

                                DividerLine()

                                Text("Scheduled website blocking")
                                    .font(.system(size: 18, weight: .heavy))
                                    .foregroundColor(.white)

                                Text("Free website-blocking apps can block distracting websites during working hours, so your day stays aligned with your goals instead of your impulses.")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.92))
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }

                        // ✅ Financial Tracking
                        CollapsibleCard(
                            title: "Financial Tracking",
                            systemImage: "dollarsign.circle",
                            isExpanded: $showFinance
                        ) {
                            VStack(alignment: .leading, spacing: 14) {
                                Text("Money is fuel for your goals. Tracking it reduces stress and turns chaos into strategy.")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.92))
                                    .fixedSize(horizontal: false, vertical: true)

                                StepsGrid(steps: [
                                    ("1", "Enter your monthly income and expenses in Budget Planner.", "square.and.pencil"),
                                    ("2", "Use Weekly Tracker to see what is left to spend.", "chart.line.uptrend.xyaxis"),
                                    ("3", "Log purchases using the (+) button so your tracker stays accurate.", "plus.circle")
                                ])

                                DividerLine()

                                ActionPillButton(title: "Open Budget Planner", systemImage: "dollarsign.circle") {
                                    navModel.push("BudgetPlannerView")
                                }
                            }
                        }

                        // ✅ Reflection (NOT collapsible) — glowing pulsating bubble
                        ReflectionGlowBubble(
                            textTop: "What makes you feel alive?",
                            textBottom: "These are clues to your purpose."
                        )
                        .padding(.top, 6)

                        Spacer(minLength: 24)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 10)
                    .padding(.bottom, 18)
                    .opacity(appeared ? 1 : 0)
                    .animation(.easeInOut(duration: 0.6), value: appeared)
                }

                // BOTTOM BAR (non-overlapping)
                HStack {
                    Spacer()
                    Button(action: { navModel.push("HomeView") }) {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.white.opacity(0.9),
                                        Color.white.opacity(0.6)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .frame(width: 58, height: 58)
                                .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 6)

                            Image(systemName: "house.fill")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(Color(red: 0.10, green: 0.45, blue: 0.45))
                        }
                    }
                }
                .padding(.horizontal, 18)
                .padding(.top, 8)
                .padding(.bottom, 14)
            }
        }
        .onAppear { appeared = true }
        .transition(.opacity)
    }
}

// MARK: - Collapsible Card

private struct CollapsibleCard<Content: View>: View {
    let title: String
    let systemImage: String
    @Binding var isExpanded: Bool
    @ViewBuilder let content: Content

    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white.opacity(0.14))
                .overlay(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .stroke(Color.white.opacity(0.16), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.18), radius: 12, x: 0, y: 10)

            VStack(alignment: .leading, spacing: 14) {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        isExpanded.toggle()
                    }
                }) {
                    HStack(spacing: 10) {
                        Image(systemName: systemImage)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white.opacity(0.95))

                        Text(title)
                            .font(.system(size: 22, weight: .heavy))
                            .foregroundColor(.white)

                        Spacer()

                        Image(systemName: isExpanded ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white.opacity(0.85))
                    }
                }
                .buttonStyle(.plain)

                if isExpanded {
                    DividerLine()
                        .transition(.opacity)

                    content
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .padding(18)
        }
    }
}

// MARK: - Roadmap Content

private struct RoadmapContent: View {
    let onFiveYear: () -> Void
    let onGoals: () -> Void
    let onDailyPlan: () -> Void

    @State private var pulse = false

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {

            // ✅ right-aligned
            HStack {
                Spacer()
                Text("Vision → Goals → Day")
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundColor(.white.opacity(0.88))
            }

            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.white.opacity(0.12))
                    .frame(height: 56)

                HStack(spacing: 0) {
                    RoadmapStop(title: "5-Year", icon: "map", action: onFiveYear, pulse: pulse)
                    RoadmapDivider()
                    RoadmapStop(title: "SMART", icon: "target", action: onGoals, pulse: pulse)
                    RoadmapDivider()
                    RoadmapStop(title: "Today", icon: "calendar", action: onDailyPlan, pulse: pulse)
                }
                .padding(.horizontal, 10)
            }

            Text("Tap a stop to jump directly into planning.")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white.opacity(0.88))
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.05).repeatForever(autoreverses: true)) {
                pulse = true
            }
        }
    }

    private struct RoadmapStop: View {
        let title: String
        let icon: String
        let action: () -> Void
        let pulse: Bool

        var body: some View {
            Button(action: action) {
                VStack(spacing: 6) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.20))
                            .frame(width: 36, height: 36)
                            .overlay(
                                Circle()
                                    .stroke(Color.white.opacity(pulse ? 0.85 : 0.45), lineWidth: pulse ? 2.5 : 1)
                                    .shadow(color: Color.white.opacity(pulse ? 0.35 : 0.0), radius: 10)
                            )

                        Image(systemName: icon)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    }

                    Text(title)
                        .font(.system(size: 13, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.plain)
        }
    }

    private struct RoadmapDivider: View {
        var body: some View {
            Rectangle()
                .fill(Color.white.opacity(0.18))
                .frame(width: 1, height: 34)
                .padding(.horizontal, 10)
        }
    }
}

// MARK: - Flow Strip Items

private struct FlowStripItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let action: (() -> Void)?
}

// MARK: - Flow Strip (clickable pills)

private struct FlowStrip: View {
    let items: [FlowStripItem]

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white.opacity(0.10))

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(items.indices, id: \.self) { i in
                        let item = items[i]

                        Button(action: {
                            item.action?()
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: item.icon)
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white.opacity(0.95))

                                Text(item.title)
                                    .font(.system(size: 13, weight: .heavy, design: .rounded))
                                    .foregroundColor(.white.opacity(0.95))
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 12)
                            .frame(minWidth: 128)
                            .background(Color.white.opacity(item.action == nil ? 0.10 : 0.14))
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .stroke(Color.white.opacity(item.action == nil ? 0.08 : 0.16), lineWidth: 1)
                            )
                        }
                        .buttonStyle(.plain)
                        .disabled(item.action == nil)

                        if i != items.count - 1 {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 13, weight: .heavy))
                                .foregroundColor(.white.opacity(0.55))
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
            }
        }
    }
}

// MARK: - Reflection Glow Bubble

private struct ReflectionGlowBubble: View {
    let textTop: String
    let textBottom: String
    @State private var pulse = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(Color.white.opacity(0.14))
                .overlay(
                    RoundedRectangle(cornerRadius: 26, style: .continuous)
                        .stroke(Color.white.opacity(pulse ? 0.38 : 0.18), lineWidth: pulse ? 2 : 1)
                        .shadow(color: Color.white.opacity(pulse ? 0.35 : 0.15), radius: pulse ? 16 : 10)
                )
                .shadow(color: .black.opacity(0.18), radius: 14, x: 0, y: 10)

            VStack(alignment: .leading, spacing: 10) {
                Text(textTop)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white.opacity(0.95))
                    .fixedSize(horizontal: false, vertical: true)

                Text(textBottom)
                    .font(.system(size: 16, weight: .heavy))
                    .foregroundColor(.white.opacity(0.92))
            }
            .padding(20)
        }
        .scaleEffect(pulse ? 1.01 : 1.0)
        .animation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true), value: pulse)
        .onAppear { pulse = true }
    }
}

// MARK: - Bullets

private struct BulletRow: View {
    let text: String
    init(_ text: String) { self.text = text }

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Text("•")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white.opacity(0.95))
                .padding(.top, 1)

            Text(text)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white.opacity(0.92))
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

// MARK: - Action Pill Button

private struct ActionPillButton: View {
    let title: String
    let systemImage: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: systemImage)
                    .font(.system(size: 16, weight: .bold))
                Text(title)
                    .font(.system(size: 15, weight: .heavy, design: .rounded))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }
            .foregroundColor(.white)
            .padding(.vertical, 12)
            .padding(.horizontal, 14)
            .frame(maxWidth: .infinity)
            .background(Color.white.opacity(0.18))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.white.opacity(0.20), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Steps Grid

private struct StepsGrid: View {
    let steps: [(String, String, String)]

    var body: some View {
        VStack(spacing: 10) {
            ForEach(steps.indices, id: \.self) { i in
                let s = steps[i]
                ZStack {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(Color.white.opacity(0.10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .stroke(Color.white.opacity(0.12), lineWidth: 1)
                        )

                    HStack(alignment: .top, spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.18))
                                .frame(width: 34, height: 34)

                            Text(s.0)
                                .font(.system(size: 16, weight: .heavy, design: .rounded))
                                .foregroundColor(.white)
                        }

                        HStack(spacing: 8) {
                            Image(systemName: s.2)
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white.opacity(0.95))

                            Text(s.1)
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white.opacity(0.92))
                                .fixedSize(horizontal: false, vertical: true)
                        }

                        Spacer(minLength: 0)
                    }
                    .padding(14)
                }
            }
        }
    }
}

// MARK: - Divider Line

private struct DividerLine: View {
    var body: some View {
        Rectangle()
            .fill(Color.white.opacity(0.14))
            .frame(height: 1)
            .padding(.vertical, 2)
    }
}

// MARK: - Dictionary Card

private struct DictionaryCard: View {
    let headword: String
    let partOfSpeech: String
    let definition: String

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.12))
                .blur(radius: 16)

            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.18))
                .overlay(
                    HStack(spacing: 0) {
                        Rectangle()
                            .fill(Color.white.opacity(0.55))
                            .frame(width: 3)
                            .padding(.vertical, 18)
                            .padding(.leading, 16)
                        Spacer()
                    }
                )
                .shadow(color: .black.opacity(0.18), radius: 12, x: 0, y: 8)

            VStack(alignment: .leading, spacing: 8) {
                Text(headword)
                    .font(.system(size: 28, weight: .semibold, design: .serif))
                    .foregroundColor(.white)

                Text(partOfSpeech)
                    .font(.system(size: 16, weight: .semibold, design: .serif))
                    .foregroundColor(Color.white.opacity(0.85))
                    .textCase(.lowercase)
                    .padding(.bottom, 6)

                Text(definition)
                    .font(.system(size: 18, weight: .regular, design: .serif))
                    .foregroundColor(Color.white.opacity(0.95))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 26)
        }
    }
}
