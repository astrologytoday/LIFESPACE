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

            ScrollView(showsIndicators: true) {
                VStack(spacing: 30) {
                    HStack {
                        Spacer()
                        Button("Cancel") {
                            returnToWeeklyTracker()
                        }
                        .foregroundColor(.white)
                        .padding()
                        .lineLimit(1)
                    }

                    Text("Track Spending")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity)

                    VStack(alignment: .leading, spacing: 16) {
                        Text("What did you spend money on?")
                            .foregroundColor(.white)
                            .font(.headline)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)

                        Picker("Select Category", selection: $selectedCategory) {
                            ForEach(model.categories.map { $0.name }.filter { $0.uppercased() != "OTHER" }, id: \.self) { name in
                                Text(name).tag(name)
                            }

                            Text("Other").tag("Other")
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(height: 100)
                        .clipped()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    VStack(alignment: .leading, spacing: 16) {
                        Text("How much did you spend?")
                            .foregroundColor(.white)
                            .font(.headline)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)

                        TextField("Enter amount", text: $amountSpent)
                            .keyboardType(.decimalPad)
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white.opacity(0.4)))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

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
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
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
                }
                .padding(.horizontal)
                .padding(.top, 10)
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            if selectedCategory.isEmpty {
                selectedCategory = model.categories.first(where: { $0.name.uppercased() != "OTHER" })?.name ?? "Other"
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

    private func saveConfirmedSpending() {
        guard let amount = Double(amountSpent), amount > 0 else { return }
        let week = model.getCurrentWeekOfMonth()

        if selectedCategory == "Other" {
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
            if let index = model.categories.firstIndex(where: { $0.name == selectedCategory }) {
                model.categories[index].weeklySpending[week, default: 0] += amount
                model.categories[index].currentAmount -= amount
            }
        }

        model.objectWillChange.send()
        model.save()

        returnToWeeklyTracker()
    }

    private func returnToWeeklyTracker() {
        presentWeeklyTrackerView(
            navModel: navModel,
            userProfile: userProfile,
            lifespaceLogModel: lifespaceLogModel,
            budgetModel: model
        )
    }
}