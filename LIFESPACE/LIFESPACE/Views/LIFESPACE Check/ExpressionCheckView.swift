import SwiftUI

struct ExpressionCheckView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var userProfile: UserProfileModel
    @EnvironmentObject var lifespaceLog: LifespaceLogModel

    @State private var expressionSelected: Bool? = nil
    @State private var didFinish = false

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

            GeometryReader { geo in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 40) {
                        Spacer(minLength: 0)

                        Text(expressionTitle.uppercased())
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .lineLimit(2)
                            .minimumScaleFactor(0.75)

                        Text("Have you expressed yourself creatively in the last 7 days?")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)

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
                            .buttonStyle(.plain)

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
                            .buttonStyle(.plain)
                        }

                        Button(action: finishTapped) {
                            Text(didFinish ? "Finishing..." : "Finish")
                                .fontWeight(.bold)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .foregroundColor(.black)
                                .cornerRadius(12)
                                .padding(.horizontal)
                                .padding(.bottom, 30)
                        }
                        .buttonStyle(.plain)
                        .disabled(expressionSelected == nil || didFinish)
                        .opacity((expressionSelected != nil && !didFinish) ? 1 : 0.5)

                        Spacer(minLength: 0)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    // ✅ Keeps your layout centered on normal phones, but scrolls on smaller ones
                    .frame(minHeight: geo.size.height)
                }
            }
        }
    }

    private func finishTapped() {
        guard !didFinish else { return }
        guard let result = expressionSelected else { return }
        didFinish = true

        // ✅ Log expression check (once)
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.easeInOut(duration: 0.4)) {
                navModel.push("LoadingView")
            }
        }
    }
}
