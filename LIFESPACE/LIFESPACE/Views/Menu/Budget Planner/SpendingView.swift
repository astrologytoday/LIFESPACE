import SwiftUI

struct SpendingView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var model: BudgetModel
    @EnvironmentObject var userProfile: UserProfileModel
    @EnvironmentObject var lifespaceLogModel: LifespaceLogModel

    @State private var selectedCategory: String = ""
    @State private var amountSpent: String = ""
    @State private var showConfirmation = false
    @State private var showAlert = false

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

            VStack(spacing: 30) {
                // Cancel button
                HStack {
                    Spacer()
                    Button("Cancel") {
                        returnToWeeklyTracker()
                    }
                    .foregroundColor(.white)
                    .padding()
                }

                Text("Track Spending")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)

                // Category Picker
                VStack(alignment: .leading, spacing: 16) {
                    Text("What did you spend money on?")
                        .foregroundColor(.white)
                        .font(.headline)

                    Picker("Select Category", selection: $selectedCategory) {
                        // Show all categories EXCEPT "OTHER"
                        ForEach(model.categories.map { $0.name }.filter { $0.uppercased() != "OTHER" }, id: \.self) { name in
                            Text(name).tag(name)
                        }

                        // Append a single "Other" manually
                        Text("Other").tag("Other")
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 100)
                    .clipped()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)
                }

                // Amount Entry
                VStack(alignment: .leading, spacing: 16) {
                    Text("How much did you spend?")
                        .foregroundColor(.white)
                        .font(.headline)

                    TextField("Enter amount", text: $amountSpent)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white.opacity(0.4)))
                }

                // MARK: - Record Button (LIFESPACE Style)
                Button {
                    guard let amount = Double(amountSpent.trimmingCharacters(in: .whitespaces)), amount > 0 else {
                        showAlert = true
                        return
                    }
                    showConfirmation = true
                } label: {
                    Text("Record Spending")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .padding(.horizontal, 40)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.36, green: 0.96, blue: 0.90),
                                    Color(red: 0.22, green: 0.65, blue: 0.70)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(color: Color.white.opacity(0.3), radius: 6, x: 0, y: 0)
                        .scaleEffect((selectedCategory.isEmpty || amountSpent.isEmpty) ? 1.0 : 1.03)
                        .animation(.easeInOut(duration: 0.4), value: selectedCategory)
                        .animation(.easeInOut(duration: 0.4), value: amountSpent)
                }
                .disabled(selectedCategory.isEmpty || amountSpent.isEmpty)
                .opacity((selectedCategory.isEmpty || amountSpent.isEmpty) ? 0.4 : 1.0)
                .padding(.top, 20)

                Spacer()
            }
            .padding(.horizontal)
        }
        .onAppear {
            if selectedCategory.isEmpty, let first = model.categories.first?.name {
                selectedCategory = first
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Invalid Amount"),
                message: Text("Please enter a valid number greater than 0."),
                dismissButton: .default(Text("OK"))
            )
        }
        .alert(isPresented: $showConfirmation) {
            Alert(
                title: Text("Confirm Spending"),
                message: Text("Confirm you spent $\(amountSpent) on \(selectedCategory)?"),
                primaryButton: .default(Text("Yes")) {
                    saveConfirmedSpending()
                },
                secondaryButton: .cancel(Text("No"))
            )
        }
    }

    // MARK: - Save Logic
    private func saveConfirmedSpending() {
        guard let amount = Double(amountSpent), amount > 0 else { return }
        let week = model.getCurrentWeekOfMonth()

        if selectedCategory == "Other" {
            // Handle OTHER category
            if let index = model.categories.firstIndex(where: { $0.name.uppercased() == "OTHER" }) {
                model.categories[index].weeklySpending[week, default: 0] += amount
                model.categories[index].currentAmount -= amount
            } else {
                var newOther = BudgetCategory(name: "OTHER", amount: 0)
                newOther.weeklySpending[week] = amount
                newOther.currentAmount = -amount
                model.categories.append(newOther)
            }
        } else {
            // ✅ Regular category spending
            if let index = model.categories.firstIndex(where: { $0.name == selectedCategory }) {
                model.categories[index].weeklySpending[week, default: 0] += amount
                model.categories[index].currentAmount -= amount
            }
        }

        model.objectWillChange.send()
        model.save()

        returnToWeeklyTracker()
    }

    // MARK: - Transition to Landscape View
    private func returnToWeeklyTracker() {
        presentWeeklyTrackerView(
            navModel: navModel,
            userProfile: userProfile,
            lifespaceLogModel: lifespaceLogModel,
            budgetModel: model
        )
    }
}

