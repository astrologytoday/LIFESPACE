import SwiftUI

struct ExpressionCheckView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var userProfile: UserProfileModel
    @EnvironmentObject var lifespaceLog: LifespaceLogModel

    @State private var expressionSelected: Bool? = nil

    var expressionTitle: String {
        userProfile.expressionOptions.first ?? "EXPRESSION"
    }

    var body: some View {
        ZStack {
            // Teal background
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

            VStack(spacing: 40) {
                Spacer().frame(height: 60)

                Text(expressionTitle.uppercased())
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                Text("Have you expressed yourself creatively in the last 7 days?")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                HStack(spacing: 30) {
                    Button(action: {
                        expressionSelected = true
                    }) {
                        Text("Yes")
                            .padding(.horizontal, 30)
                            .padding(.vertical, 12)
                            .background(expressionSelected == true ? Color.white : Color.white.opacity(0.3))
                            .foregroundColor(.black)
                            .cornerRadius(12)
                    }

                    Button(action: {
                        expressionSelected = false
                    }) {
                        Text("No")
                            .padding(.horizontal, 30)
                            .padding(.vertical, 12)
                            .background(expressionSelected == false ? Color.white : Color.white.opacity(0.3))
                            .foregroundColor(.black)
                            .cornerRadius(12)
                    }
                }

                Spacer()

                Button(action: {
                    guard let result = expressionSelected else { return }

                    // ✅ Log expression check
                    lifespaceLog.addEntry(
                        LifespaceLogEntry(
                            type: .lifespace,
                            module: .expression,
                            questionCount: 1,
                            yesCount: result ? 1 : 0
                        )
                    )

                    // ✅ STOP NOTIFICATION FOR TODAY
                    NotificationManager.shared.suppressDailyCheckForToday()

                    // ✅ Navigate to loading
                    navModel.push("LoadingView")

                }) {
                    Text("Finish")
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                }
                .disabled(expressionSelected == nil)
                .opacity(expressionSelected != nil ? 1 : 0.5)
            }
        }
    }
}

