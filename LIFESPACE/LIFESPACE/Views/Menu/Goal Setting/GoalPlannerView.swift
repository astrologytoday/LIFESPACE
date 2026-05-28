import SwiftUI

struct GoalPlannerView: View {
    @Binding var goal: Goal
    @State private var stepText: String = ""
    @State private var helperText1: Bool = false
    @State private var helperText2: Bool = false
    @State private var selectedDuration: GoalDuration = .week
    @State private var showDuplicateStepWarning: Bool = false
    @EnvironmentObject var navModel: NavigationModel

    // ✅ Relevance popup
    @State private var showRelevancePopup: Bool = false

    private var reflection: Binding<String> {
        Binding(get: { goal.reflection }, set: { goal.reflection = $0 })
    }

    private var yearlyReflection: Binding<String> {
        Binding(get: { goal.yearlyReflection }, set: { goal.yearlyReflection = $0 })
    }

    private var isReady: Bool {
        !goal.steps.isEmpty &&
        !goal.reflection.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !goal.yearlyReflection.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func normalizedStep(_ text: String) -> String {
        text
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
            .lowercased()
    }

    private func addStep() {
        let trimmed = stepText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        let cleanedStep = trimmed.replacingOccurrences(
            of: "\\s+",
            with: " ",
            options: .regularExpression
        )

        let newStepNormalized = normalizedStep(cleanedStep)

        let alreadyExists = goal.steps.contains { existingStep in
            normalizedStep(existingStep) == newStepNormalized
        }

        if alreadyExists {
            withAnimation(.easeInOut(duration: 0.25)) {
                showDuplicateStepWarning = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeInOut(duration: 0.25)) {
                    showDuplicateStepWarning = false
                }
            }

            return
        }

        goal.steps.append(cleanedStep)
        stepText = ""

        withAnimation(.easeInOut(duration: 0.25)) {
            showDuplicateStepWarning = false
        }
    }

    // ✅ Your original start logic, extracted so YES can trigger it
    private func startPlanningNow() {
        if goal.duration != selectedDuration {
            goal.stepsNext3Days = []
            goal.stepsToday = []
            goal.stepsRightNow = []
            goal.stepsNext2Weeks = []
            goal.stepsNextWeek = []
            goal.stepsNext6Months = []
            goal.stepsNextMonth = []
            goal.completedStepIDs = []
        }

        goal.duration = selectedDuration
        goal.hasStarted = true
        goal.startDate = Date()

        navModel.push("GoalStepsView:\(goal.id)")
    }

    var body: some View {
        ZStack {
            ZONEBackgroundGradient()

            ScrollView {
                VStack(spacing: 30) {

                    // Title
                    Text(goal.title)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.09))
                        .cornerRadius(14)
                        .padding(.top, 16)

                    // ---------- Reflection ----------
                    SectionHeaderBubble(
                        text: "What will tell you this goal is complete?",
                        helpToggle: $helperText1,
                        richHelp: AnyView(
                            VStack(alignment: .leading, spacing: 8) {
                                (
                                    Text("A strong goal has a")
                                    +
                                    Text(" clear finish line. ").bold()
                                    +
                                    Text("Define exactly what needs to happen for this goal to be considered complete.")
                                )
                            }
                        )
                    )

                    LifespaceCard {
                        LifespaceTextArea(
                            text: reflection,
                            placeholder: "Write your answer…"
                        )
                    }

                    // ---------- Steps ----------
                    VStack(alignment: .leading, spacing: 8) {
                        Text("What are the steps you need to take to achieve this goal?")
                            .font(.headline)
                            .foregroundColor(.white)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .layoutPriority(1)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .layoutPriority(1)

                        ForEach(Array(goal.steps.enumerated()), id: \.offset) { idx, step in
                            HStack {
                                Text(step)
                                    .foregroundColor(.white)
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .layoutPriority(1)

                                Spacer(minLength: 8)

                                Button {
                                    goal.steps.remove(at: idx)
                                } label: {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.red)
                                }
                            }
                        }

                        HStack {
                            TextField("Enter a step…", text: $stepText)
                                .padding(8)
                                .background(Color.white.opacity(0.16))
                                .cornerRadius(8)
                                .foregroundColor(.white)
                                .autocorrectionDisabled()

                            Button {
                                addStep()
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 26))
                            }
                            .disabled(stepText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        }

                        if showDuplicateStepWarning {
                            Text("This step has already been added.")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.white.opacity(0.95))
                                .padding(.top, 2)
                                .transition(.opacity)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.12))
                    .cornerRadius(12)

                    // ---------- Long-term reflection ----------
                    SectionHeaderBubble(
                        text: "How does this goal align with your long-term plans?",
                        helpToggle: $helperText2,
                        richHelp: AnyView(
                            Text("A good goal is relevant and makes sense in the bigger picture. Use this box to reflect on how your goal is worthwhile and aligned with your other objectives, values, or long-term plans.")
                        )
                    )

                    LifespaceCard {
                        LifespaceTextArea(
                            text: yearlyReflection,
                            placeholder: "Write your answer…"
                        )
                    }

                    // ---------- Duration ----------
                    VStack(alignment: .leading, spacing: 4) {
                        Text("How long will it take to complete this goal?")
                            .font(.headline)
                            .foregroundColor(.white)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .layoutPriority(1)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .layoutPriority(1)

                        HStack {
                            Text("A")
                                .font(.title2.bold())
                                .foregroundColor(.white)

                            Picker("Duration", selection: $selectedDuration) {
                                ForEach(GoalDuration.allCases, id: \.self) { d in
                                    Text(d.rawValue)
                                }
                            }
                            .pickerStyle(.segmented)
                            .frame(maxWidth: 240)
                        }
                        .padding(.horizontal)
                    }

                    // ---------- Start button ----------
                    Button {
                        guard isReady else { return }

                        if !goal.hasStarted {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                showRelevancePopup = true
                            }
                        } else {
                            startPlanningNow()
                        }
                    } label: {
                        Text("START PLANNING")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(isReady ? Color.teal : Color.gray)
                            .cornerRadius(18)
                    }
                    .disabled(!isReady)
                    .padding(.bottom, 50)
                }
                .padding(.horizontal, 14)
            }

            // ✅ Popup overlay
            if showRelevancePopup {
                Color.black.opacity(0.45)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            showRelevancePopup = false
                        }
                    }

                RelevancePopup(
                    onYes: {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            showRelevancePopup = false
                        }
                        startPlanningNow()
                    },
                    onNo: {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            showRelevancePopup = false
                        }
                        navModel.pop()
                    }
                )
                .transition(.scale.combined(with: .opacity))
                .zIndex(10)
            }
        }
        .onAppear {
            selectedDuration = goal.duration
        }
    }
}

private struct RelevancePopup: View {
    var onYes: () -> Void
    var onNo: () -> Void

    var body: some View {
        VStack(spacing: 14) {
            Text("Goal Check")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
                .shadow(radius: 3)

            Text("Is this a relevant goal that aligns with your long-term plans?")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white.opacity(0.92))
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 10)

            HStack(spacing: 12) {
                Button(action: onNo) {
                    Text("NO")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.14))
                        .cornerRadius(16)
                }

                Button(action: onYes) {
                    Text("YES")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(Color.teal.opacity(0.85))
                        .cornerRadius(16)
                }
            }
        }
        .padding(18)
        .frame(maxWidth: 360)
        .background(
            BlurView(style: .systemUltraThinMaterial)
        )
        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .stroke(Color.white.opacity(0.22), lineWidth: 1.3)
        )
        .shadow(color: .black.opacity(0.18), radius: 18, y: 6)
        .padding(.horizontal, 24)
    }
}

//
// MARK: - GLASSY BUBBLE, SUPPORTS RICH TEXT
//
private struct SectionHeaderBubble: View {
    let text: String
    @Binding var helpToggle: Bool
    var richHelp: AnyView

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Text(text)
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .layoutPriority(1)

                Button {
                    withAnimation(.easeInOut(duration: 0.22)) {
                        helpToggle.toggle()
                    }
                } label: {
                    Image(systemName: "questionmark.circle.fill")
                        .foregroundColor(.white.opacity(0.92))
                        .font(.system(size: 20))
                }
            }

            if helpToggle {
                GlassyBubble { richHelp }
                    .transition(.opacity.combined(with: .scale))
            }
        }
    }
}

private struct GlassyBubble<Content: View>: View {
    @ViewBuilder var content: () -> Content

    var body: some View {
        ZStack {
            BlurView(style: .systemUltraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Color.white.opacity(0.22), lineWidth: 1.3)
                )

            content()
                .padding(.all, 17)
                .foregroundColor(.white)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: 480)
        .padding(.vertical, 2)
        .shadow(color: .black.opacity(0.13), radius: 14, y: 3)
        .padding(.trailing, 24)
        .padding(.top, 2)
    }
}

// Universal BlurView for glass effect
struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemMaterial

    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

//
// MARK: - Gradient
//
struct ZONEBackgroundGradient: View {
    var body: some View {
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
    }
}

//
// MARK: - Card
//
struct LifespaceCard<Content: View>: View {
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading) {
            content
        }
        .padding()
        .background(Color.white.opacity(0.12))
        .cornerRadius(12)
    }
}

//
// MARK: - TextArea
//
struct LifespaceTextArea: View {
    @Binding var text: String
    var placeholder: String

    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.white.opacity(0.55))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
            }

            TextEditor(text: $text)
                .foregroundColor(.white)
                .padding(.horizontal, 4)
                .frame(minHeight: 56, maxHeight: 140)
                .scrollContentBackground(.hidden)
        }
        .background(Color.white.opacity(0.16))
        .cornerRadius(8)
    }
}
