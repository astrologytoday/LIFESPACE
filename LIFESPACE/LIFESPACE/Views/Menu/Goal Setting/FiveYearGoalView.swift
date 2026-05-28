import SwiftUI

struct FiveYearGoalView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var plan: FiveYearPlanModel
    @State private var shimmerPhase: CGFloat = 0

    var body: some View {
        ZStack(alignment: .bottomLeading) {
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

            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 26) {

                        // In your body...
                        Text("GOAL:")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.top, 10)
                            .padding(.bottom, -6) // Reduce space under title

                        ZStack(alignment: .topLeading) {
                            // Glow/shimmer outline
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.white.opacity(0.65),
                                            Color.teal.opacity(0.9),
                                            Color.white.opacity(0.65)
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ),
                                    lineWidth: 2.2
                                )
                                .shadow(color: .teal.opacity(0.25), radius: 7, x: 0, y: 3)
                                .opacity(0.45)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18)
                                        .stroke(
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    Color.white.opacity(0.3),
                                                    Color.teal.opacity(0.8),
                                                    Color.white.opacity(0.3)
                                                ]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 4
                                        )
                                        .blur(radius: 3)
                                        .opacity(0.6 + 0.3 * Double(sin(shimmerPhase)))
                                )
                                .animation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true), value: shimmerPhase)

                            Color.white.opacity(0.09)
                                .cornerRadius(18)

                            VStack {
                                Spacer(minLength: 0)
                                ScrollView(.vertical, showsIndicators: false) {
                                    Text(plan.vision)
                                        .foregroundColor(.white)
                                        .font(.system(size: 18, weight: .bold))
                                        .multilineTextAlignment(.leading)
                                        .padding(.vertical, 12)    // Equal vertical padding
                                        .padding(.horizontal, 18)  // Nice horizontal padding
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .frame(maxHeight: .infinity)
                                Spacer(minLength: 0)
                            }
                            .padding(.vertical, 0)
                            .frame(height: 110)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                        }
                        .frame(height: 110)
                        .padding(.bottom, 8)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                                shimmerPhase = .pi * 14
                            }
                        }



                        dueSection(label: "Due Right Now", steps: plan.stepsNow)
                        dueSection(label: todayLabel(), steps: plan.stepsToday)
                        dueSection(label: weekLabel(), steps: plan.stepsWeek)
                        dueSection(label: monthLabel(), steps: plan.stepsMonth)
                        dueSection(label: yearLabel(), steps: plan.steps1Year)
                        dueSection(label: yearOffset(2), steps: plan.steps2Years)
                        dueSection(label: yearOffset(3), steps: plan.steps3Years)
                        dueSection(label: yearOffset(4), steps: plan.steps4Years)
                        dueSection(label: yearOffset(5), steps: plan.steps5Years)
                    }
                    .padding()
                }
                .scrollIndicators(.hidden)

                // --- BUTTON BAR ---
                HStack {

                    // 🔙 NEW Back to Goals Button
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            navModel.push("GoalsView")
                        }
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "arrow.uturn.left.circle.fill")
                                .font(.system(size: 26, weight: .bold))
                            Text("Back to Goals")
                                .font(.system(size: 18, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(Color.teal.opacity(0.85))
                        .cornerRadius(30)
                        .shadow(color: .black.opacity(0.25), radius: 6, y: 3)
                    }

                    Spacer()

                    // ✏️ Edit Goal
                    Button(action: {
                        navModel.push("FiveYearPlanView")
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "pencil")
                            Text("Edit Goal")
                        }
                        .font(.headline.bold())
                        .foregroundColor(.white)
                        .padding(.horizontal, 22)
                        .padding(.vertical, 14)
                        .background(Color.teal.opacity(0.85))
                        .cornerRadius(30)
                        .shadow(color: Color.teal.opacity(0.2), radius: 6, y: 3)
                    }

                    Spacer()

                    // 🏠 Home Button
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            navModel.push("HomeView")
                        }
                    }) {
                        Image(systemName: "house.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 30, weight: .bold))
                            .padding()
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
    }
    
    // MARK: - Due Section Builder
    func dueSection(label: String, steps: [String]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label + ":")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)

            ForEach(steps, id: \.self) { step in
                HStack {
                    Button(action: {
                        toggle(step)
                    }) {
                        Image(systemName: plan.completedSteps.contains(step) ? "checkmark.square.fill" : "square")
                            .foregroundColor(.white)
                            .font(.system(size: 24))
                    }

                    Text(step)
                        .foregroundColor(.white)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.12))
        .cornerRadius(14)
    }

    func toggle(_ step: String) {
        if plan.completedSteps.contains(step) {
            plan.completedSteps.remove(step)
        } else {
            plan.completedSteps.insert(step)
        }
    }

    // MARK: - Date Labels
    func todayLabel() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return "Due \(formatter.string(from: Date()))"
    }

    func weekLabel() -> String {
        let weekFromNow = Calendar.current.date(byAdding: .day, value: 7, to: Date())!
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return "Due \(formatter.string(from: weekFromNow))"
    }

    func monthLabel() -> String {
        let month = Calendar.current.date(byAdding: .month, value: 1, to: Date())!
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return "Due \(formatter.string(from: month))"
    }

    func yearLabel() -> String {
        let year = Calendar.current.date(byAdding: .year, value: 1, to: Date())!
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return "Due \(formatter.string(from: year))"
    }

    func yearOffset(_ n: Int) -> String {
        let date = Calendar.current.date(byAdding: .year, value: n, to: Date())!
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return "Due \(formatter.string(from: date))"
    }
}

