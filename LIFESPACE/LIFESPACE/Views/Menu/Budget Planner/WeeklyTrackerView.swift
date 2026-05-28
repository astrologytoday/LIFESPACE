import SwiftUI

struct WeeklyTrackerView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var model: BudgetModel

    @State private var showResetConfirmation = false

    // Detect iPad
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    // Darker green ONLY for iPad
    private var savingsColor: Color {
        isIPad
        ? Color(red: 0.0, green: 0.5, blue: 0.2) // 👈 darker green
        : .green
    }

    // Wider column widths
    let columnWidths: [CGFloat] = [135, 110, 95, 95, 95, 95]

    // MARK: - Sorted Categories
    private var sortedCategories: [BudgetCategory] {
        model.categories.sorted { a, b in
            let aIsOther = a.name.uppercased() == "OTHER"
            let bIsOther = b.name.uppercased() == "OTHER"

            if aIsOther && !bIsOther { return false }
            if bIsOther && !aIsOther { return true }

            return true
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

            VStack(spacing: 10) {

                // HEADER
                HStack(spacing: 0) {
                    headerCell("Category", width: columnWidths[0])
                    headerCell("Remaining", width: columnWidths[1])
                    ForEach(1...4, id: \.self) { week in
                        headerCell("Week \(week)", width: columnWidths[1 + week])
                    }
                }
                .padding(.top, 10)
                .background(Color.white.opacity(0.05))

                Divider().background(Color.white.opacity(0.3))

                // BODY SCROLL
                ScrollView {
                    VStack(spacing: 0) {

                        ForEach(sortedCategories) { category in
                            rowView(
                                title: category.name.uppercased() == "OTHER" ? "Other" : category.name,
                                amount: category.currentAmount,
                                weekly: (1...4).map { category.weeklySpending[$0] ?? 0 },
                                color: .white
                            )
                        }

                        Divider().background(Color.white.opacity(0.3))

                        // SAVINGS ROW (UPDATED COLOR LOGIC)
                        let overBudgetAmount = model.categories.filter { $0.currentAmount < 0 }
                            .reduce(0) { $0 + abs($1.currentAmount) }

                        let adjustedSavings = model.income
                            - model.totalExpenses
                            - model.otherSpending
                            - overBudgetAmount

                        rowView(
                            title: "SAVINGS",
                            amount: adjustedSavings,
                            weekly: [0, 0, 0, 0],
                            color: savingsColor // 👈 key change
                        )
                    }
                    .padding(.horizontal)
                }

                Spacer()

                // FOOTER
                HStack(spacing: 20) {
                    Button("Budget Planner") {
                        dismissLandscapeWindow(to: "BudgetPlannerView", navModel: navModel)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(12)

                    Button {
                        dismissLandscapeWindow(to: "SpendingView", navModel: navModel)
                    } label: {
                        Image(systemName: "plus.circle")
                            .font(.title)
                            .foregroundColor(.white)
                    }

                    Button {
                        showResetConfirmation = true
                    } label: {
                        Image(systemName: "minus.circle")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    .alert(isPresented: $showResetConfirmation) {
                        Alert(
                            title: Text("Clear all fields?"),
                            message: Text("This will reset all weekly spending to zero."),
                            primaryButton: .destructive(Text("Clear All")) {
                                model.resetWeeklySpending()
                            },
                            secondaryButton: .cancel()
                        )
                    }

                    Spacer()

                    Button {
                        dismissLandscapeWindow(to: "HomeView", navModel: navModel)
                    } label: {
                        Image(systemName: "house.fill")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
            }
        }
    }

    // MARK: - HEADER CELL
    private func headerCell(_ text: String, width: CGFloat) -> some View {
        Text(text)
            .frame(width: width, alignment: .leading)
            .font(.headline)
            .foregroundColor(.white)
            .padding(.vertical, 4)
            .overlay(
                Rectangle()
                    .frame(width: 1)
                    .foregroundColor(.white.opacity(0.2)),
                alignment: .trailing
            )
    }

    // MARK: - ROW VIEW
    private func rowView(title: String, amount: Double, weekly: [Double], color: Color) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text(title)
                    .frame(width: columnWidths[0], alignment: .leading)
                    .foregroundColor(color)

                Text(String(format: "%.0f", amount))
                    .frame(width: columnWidths[1])
                    .foregroundColor(amount < 0 ? .red : color)

                ForEach(0..<4) { i in
                    let value = weekly[i]
                    Text(value == 0 ? "" : String(format: "-%.0f", value))
                        .frame(width: columnWidths[i + 2])
                        .foregroundColor(value == 0 ? .white.opacity(0.4) : .red)
                }
            }

            Rectangle()
                .fill(Color.white.opacity(0.1))
                .frame(height: 1)
        }
    }
}
