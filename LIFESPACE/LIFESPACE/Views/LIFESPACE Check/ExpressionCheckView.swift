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
                ScrollView(showsIndicators: true) {
                    VStack(spacing: 34) {
                        Text(expressionTitle.uppercased())
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 22)
                            .lineLimit(3)
                            .minimumScaleFactor(0.65)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.top, 54)

                        Text("Have you expressed yourself creatively in the last 7 days?")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)

                        HStack(spacing: 22) {
                            selectionButton(title: "Yes", selected: expressionSelected == true) {
                                expressionSelected = true
                            }

                            selectionButton(title: "No", selected: expressionSelected == false) {
                                expressionSelected = false
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 110)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: geo.size.height)
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            Button(action: finishTapped) {
                Text(didFinish ? "Finishing..." : "Finish")
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 52)
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(12)
            }
            .buttonStyle(.plain)
            .disabled(expressionSelected == nil || didFinish)
            .opacity((expressionSelected != nil && !didFinish) ? 1 : 0.5)
            .padding(.horizontal, 18)
            .padding(.top, 10)
            .padding(.bottom, 8)
            .background(.ultraThinMaterial.opacity(0.20))
        }
    }

    private func selectionButton(title: String, selected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .frame(maxWidth: .infinity, minHeight: 48)
                .background(selected ? Color.white : Color.white.opacity(0.3))
                .foregroundColor(.black)
                .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }

    private func finishTapped() {
        guard !didFinish else { return }
        guard let result = expressionSelected else { return }
        didFinish = true

        lifespaceLog.addEntry(
            LifespaceLogEntry(
                type: .lifespace,
                module: .expression,
                questionCount: 1,
                yesCount: result ? 1 : 0
            )
        )

        NotificationManager.shared.suppressDailyCheckForToday()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.easeInOut(duration: 0.4)) {
                navModel.push("LoadingView")
            }
        }
    }
}