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

            ScrollView(showsIndicators: true) {
                VStack(spacing: 20) {
                    HStack {
                        Text("Income:")
                            .font(.headline)
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .layoutPriority(1)

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
                        HStack(alignment: .center, spacing: 10) {
                            Text(category.name)
                                .foregroundColor(.white)
                                .lineLimit(2)
                                .fixedSize(horizontal: false, vertical: true)
                                .layoutPriority(1)

                            Spacer(minLength: 8)

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

                    HStack(alignment: .center, spacing: 10) {
                        TextField("Spending Category", text: $newCategoryName)
                            .padding(8)
                            .background(Color.white.opacity(0.2))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .focused($focusedField, equals: .name)
                            .layoutPriority(1)

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
                            .lineLimit(1)

                        Spacer()

                        Text("$\(Int(model.savings))")
                            .font(.headline)
                            .foregroundColor(.green)
                            .lineLimit(1)
                    }
                    .padding(.horizontal)
                }
                .padding(.top)
                .padding(.bottom, 120)
            }
        }
        .safeAreaInset(edge: .bottom) {
            bottomBar
        }
        .onAppear {
            AppDelegate.orientationLock = .portrait
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        }
    }

    private var bottomBar: some View {
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
            .lineLimit(1)
            .layoutPriority(1)

            Spacer(minLength: 12)

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
        .padding(.top, 10)
        .padding(.bottom, 8)
        .background(Color(red: 0.10, green: 0.45, blue: 0.45))
    }
}