import SwiftUI

struct FiveYearPlanView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var plan: FiveYearPlanModel

    @AppStorage("fiveYearPlanSubmitted") private var fiveYearPlanSubmitted: Bool = false

    @State private var pulse = false

    // ✅ NEW: Clear confirmation popup
    @State private var showClearPopup: Bool = false

    // Step input state for each section
    @State private var newStep5Years = ""
    @State private var newStep4Years = ""
    @State private var newStep3Years = ""
    @State private var newStep2Years = ""
    @State private var newStep1Year = ""
    @State private var newStepMonth = ""
    @State private var newStepWeek = ""
    @State private var newStepToday = ""
    @State private var newStepNow = ""

    var body: some View {
        ZStack(alignment: .topTrailing) {

            // 🌊 LIFESPACE Gradient
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

            VStack(spacing: 0) {

                // Top-right Back + Home buttons (fixed)
                HStack {
                    Spacer()

                    // Back
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            navModel.pop()
                        }
                    }) {
                        Image(systemName: "arrow.uturn.left.circle.fill")
                            .font(.system(size: 31, weight: .bold))
                            .foregroundColor(.white)
                            .background(
                                Circle()
                                    .fill(Color.teal.opacity(0.82))
                                    .frame(width: 52, height: 52)
                            )
                            .shadow(color: .black.opacity(0.18), radius: 6, y: 2)
                    }
                    .padding(.top, 24)
                    .padding(.trailing, 6)

                    // Home
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            navModel.push("HomeView")
                        }
                    }) {
                        Image(systemName: "house.fill")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                            .background(
                                Circle()
                                    .fill(Color.teal.opacity(0.88))
                                    .frame(width: 52, height: 52)
                            )
                            .shadow(radius: 6)
                    }
                    .padding(.top, 24)
                    .padding(.trailing, 20)
                }

                ScrollView {
                    VStack(alignment: .leading, spacing: 26) {

                        Text("Five Year Plan")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.top, 14)

                        // 📝 Vision
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Where do you want to be in 5 years?")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)

                            ZStack(alignment: .topLeading) {
                                if plan.vision.isEmpty {
                                    Text("Write your answer…")
                                        .foregroundColor(.white.opacity(0.55))
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 10)
                                }

                                TextEditor(text: $plan.vision)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 6)
                                    .frame(height: 140)
                                    .scrollContentBackground(.hidden)
                                    .background(Color.clear)
                            }
                            .background(Color.white.opacity(0.16))
                            .cornerRadius(12)
                        }

                        // Step sections
                        stepSection(title: "What do you need to do in the next 5 years?", list: $plan.steps5Years, newStep: $newStep5Years)
                        stepSection(title: "What do you need to do in the next 4 years?", list: $plan.steps4Years, newStep: $newStep4Years)
                        stepSection(title: "What do you need to do in the next 3 years?", list: $plan.steps3Years, newStep: $newStep3Years)
                        stepSection(title: "What do you need to do in the next 2 years?", list: $plan.steps2Years, newStep: $newStep2Years)
                        stepSection(title: "What do you need to do this year?", list: $plan.steps1Year, newStep: $newStep1Year)
                        stepSection(title: "What do you need to do this month?", list: $plan.stepsMonth, newStep: $newStepMonth)
                        stepSection(title: "What do you need to do this week?", list: $plan.stepsWeek, newStep: $newStepWeek)
                        stepSection(title: "What do you need to do today?", list: $plan.stepsToday, newStep: $newStepToday)

                        // RIGHT NOW section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("What can you be doing right now?")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .scaleEffect(pulse ? 1.07 : 1.0)
                                .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: pulse)
                                .onAppear { pulse = true }

                            stepListEditor(list: $plan.stepsNow, newStep: $newStepNow)
                        }

                        // Bottom Action Buttons
                        HStack(spacing: 16) {

                            Button(action: {
                                NotificationManager.shared.rescheduleFiveYearPlanReminders(plan: plan)
                                fiveYearPlanSubmitted = true

                                withAnimation(.easeInOut(duration: 0.4)) {
                                    navModel.push("FiveYearGoalView")
                                }
                            }) {
                                Text("SUBMIT")
                                    .font(.system(size: 22, weight: .heavy))
                                    .foregroundColor(.black)
                                    .padding(.vertical, 16)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.white.opacity(0.96))
                                    .cornerRadius(34)
                            }

                            // ✅ Now opens confirmation popup
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.4)) {
                                    showClearPopup = true
                                }
                            }) {
                                Text("Clear All Fields")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                                    .padding(.vertical, 16)
                                    .padding(.horizontal, 22)
                                    .background(Color.red.opacity(0.41))
                                    .cornerRadius(34)
                            }
                        }
                        .padding(.top, 28)
                        .padding(.bottom, 38)
                    }
                    .padding(.horizontal, 20)
                }
                .scrollIndicators(.hidden)
            }

            if showClearPopup {
                ZStack {
                    Color.black.opacity(0.45)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                showClearPopup = false
                            }
                        }

                    ClearFieldsPopup(
                        onYes: {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                showClearPopup = false
                            }
                            clearAllFields()
                        },
                        onNo: {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                showClearPopup = false
                            }
                        }
                    )
                    .transition(.scale.combined(with: .opacity))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .zIndex(999)
            }
        }
    }

    // MARK: - Step Section Builder
    private func stepSection(title: String, list: Binding<[String]>, newStep: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .semibold))

            stepListEditor(list: list, newStep: newStep)
        }
    }

    // MARK: - List Editor with Input
    private func stepListEditor(list: Binding<[String]>, newStep: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(Array(list.wrappedValue.enumerated()), id: \.offset) { index, item in
                HStack {
                    Text(item)
                        .foregroundColor(.white)
                    Spacer()
                    Button(action: {
                        list.wrappedValue.remove(at: index)
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.red)
                    }
                }
            }

            HStack {
                TextField("Enter a step...", text: newStep)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(8)
                    .background(Color.white.opacity(0.16))
                    .cornerRadius(8)
                    .foregroundColor(.white)
                    .autocapitalization(.sentences)
                    .disableAutocorrection(false)

                Button(action: {
                    let trimmed = newStep.wrappedValue.trimmingCharacters(in: .whitespacesAndNewlines)
                    if !trimmed.isEmpty {
                        list.wrappedValue.append(trimmed)
                        newStep.wrappedValue = ""
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 26))
                        .foregroundColor(.white)
                }
                .disabled(newStep.wrappedValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .padding()
        .background(Color.white.opacity(0.12))
        .cornerRadius(12)
    }

    // MARK: - Reset Function
    private func clearAllFields() {
        plan.clearAll()
        fiveYearPlanSubmitted = false

        newStep5Years = ""
        newStep4Years = ""
        newStep3Years = ""
        newStep2Years = ""
        newStep1Year = ""
        newStepMonth = ""
        newStepWeek = ""
        newStepToday = ""
        newStepNow = ""
    }
}

// MARK: - Popup UI (GoalPlannerView-style)
private struct ClearFieldsPopup: View {
    var onYes: () -> Void
    var onNo: () -> Void

    var body: some View {
        VStack(spacing: 14) {

            Text("Are you sure you want to clear all fields?")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white.opacity(0.92))
                .multilineTextAlignment(.center)
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
        .frame(height: 190)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .stroke(Color.white.opacity(0.22), lineWidth: 1.3)
        )
        .shadow(color: .black.opacity(0.18), radius: 18, y: 6)
        .padding(.horizontal, 24)
    }
}
