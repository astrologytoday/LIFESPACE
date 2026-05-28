import SwiftUI

struct BudgetPlannerView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var model: BudgetModel
    @EnvironmentObject var userProfile: UserProfileModel
    @EnvironmentObject var lifespaceLogModel: LifespaceLogModel

    @State private var newCategoryName = ""
    @State private var newCategoryAmount = ""

    enum BudgetFocusField {
        case name, amount
    }

    @FocusState private var focusedField: BudgetFocusField?

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

            VStack(spacing: 20) {

                HStack {
                    Text("Income:")
                        .font(.headline)
                        .foregroundColor(.white)

                    TextField("0", value: $model.income, formatter: NumberFormatter())
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .frame(width: 120)
                        .onChange(of: model.income) { _ in
                            model.updateIncome(model.income)
                        }
                }

                ForEach(model.categories.filter { $0.name.uppercased() != "OTHER" }) { category in
                    HStack {
                        Text(category.name)
                            .foregroundColor(.white)

                        Spacer()

                        TextField("0", value: Binding(
                            get: { category.originalAmount },
                            set: { newValue in
                                model.updateCategoryAmount(id: category.id, amount: newValue)
                            }
                        ), formatter: NumberFormatter())
                        .keyboardType(.decimalPad)
                        .padding(6)
                        .background(Color.white.opacity(0.2))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .frame(width: 80)

                        Button {
                            model.removeCategory(id: category.id)
                        } label: {
                            Image(systemName: "minus.circle")
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.horizontal)
                }

                HStack {
                    TextField("Spending Category", text: $newCategoryName)
                        .padding(8)
                        .background(Color.white.opacity(0.2))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .focused($focusedField, equals: .name)

                    TextField("Amount", text: $newCategoryAmount)
                        .keyboardType(.decimalPad)
                        .padding(8)
                        .background(Color.white.opacity(0.2))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .frame(width: 100)
                        .focused($focusedField, equals: .amount)

                    Button {
                        if let amount = Double(newCategoryAmount) {
                            model.addCategory(name: newCategoryName, amount: amount)
                            newCategoryName = ""
                            newCategoryAmount = ""
                            focusedField = .name
                        }
                    } label: {
                        Image(systemName: "plus.circle")
                            .foregroundColor(.white)
                            .font(.title2)
                    }
                }
                .padding(.horizontal)

                HStack {
                    Text("Savings:")
                        .font(.headline)
                        .foregroundColor(.white)

                    Spacer()

                    Text("$\(Int(model.savings))")
                        .font(.headline)
                        .foregroundColor(.green)
                }
                .padding(.horizontal)

                Spacer()

                HStack {
                    Button("Weekly Tracker") {
                        presentWeeklyTrackerView(
                            navModel: navModel,
                            userProfile: userProfile,
                            lifespaceLogModel: lifespaceLogModel,
                            budgetModel: model
                        )
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(12)

                    Spacer()

                    HStack(spacing: 14) {
                        Button {
                            navModel.pop()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.title2.bold())
                                .foregroundColor(.white)
                                .padding()
                        }

                        Button {
                            navModel.push("HomeView")
                        } label: {
                            Image(systemName: "house.fill")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .padding(.top)
        }
        .onAppear {
            AppDelegate.orientationLock = .portrait
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        }
    }
}
