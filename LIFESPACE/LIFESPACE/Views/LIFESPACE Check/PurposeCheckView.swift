import SwiftUI

struct PurposeCheckView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var userProfile: UserProfileModel
    @EnvironmentObject var lifespaceLog: LifespaceLogModel

    @State private var showTitle = false
    @State private var selection: Bool? = nil
    @State private var didLogAndAdvance = false

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
                    VStack(spacing: 32) {
                        Text(purposeTitle())
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                            .opacity(showTitle ? 1 : 0)
                            .animation(.easeIn(duration: 1), value: showTitle)
                            .lineLimit(3)
                            .minimumScaleFactor(0.62)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.top, 52)

                        Text("Have you been working towards your life's purpose today?")
                            .font(.headline)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)

                        HStack(spacing: 18) {
                            AnswerButton(label: "Yes", isSelected: selection == true) {
                                selectAndContinue(result: true)
                            }

                            AnswerButton(label: "No", isSelected: selection == false) {
                                selectAndContinue(result: false)
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 44)
                    }
                    .padding(.vertical, 18)
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: geo.size.height)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.4)) {
                showTitle = true
            }
        }
    }

    private func purposeTitle() -> String {
        let title = userProfile.purposeOptions.first ?? "PURPOSE"
        return title.uppercased()
    }

    private func selectAndContinue(result: Bool) {
        guard selection == nil else { return }
        guard !didLogAndAdvance else { return }

        selection = result
        didLogAndAdvance = true

        lifespaceLog.addEntry(
            LifespaceLogEntry(
                type: .lifespace,
                module: .purpose,
                questionCount: 1,
                yesCount: result ? 1 : 0
            )
        )

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeInOut(duration: 0.4)) {
                navModel.push("ActivityCheckView")
            }
        }
    }
}