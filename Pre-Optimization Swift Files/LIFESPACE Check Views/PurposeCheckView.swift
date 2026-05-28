import SwiftUI

struct PurposeCheckView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var userProfile: UserProfileModel
    @EnvironmentObject var lifespaceLog: LifespaceLogModel

    @State private var showTitle = false
    @State private var selection: Bool? = nil

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
                Spacer()

                Text(purposeTitle())
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .opacity(showTitle ? 1 : 0)
                    .animation(.easeIn(duration: 1), value: showTitle)

                Text("Have you been working towards your life's purpose today?")
                    .font(.headline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                HStack(spacing: 30) {
                    AnswerButton(
                        label: "Yes",
                        isSelected: selection == true
                    ) {
                        selectAndContinue(result: true)
                    }

                    AnswerButton(
                        label: "No",
                        isSelected: selection == false
                    ) {
                        selectAndContinue(result: false)
                    }
                }

                Spacer()
            }
            .padding()
        }
        .onAppear {
            withAnimation {
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
        selection = result

        lifespaceLog.addEntry(
            LifespaceLogEntry(
                type: .lifespace,
                module: .purpose,
                questionCount: 1,
                yesCount: result ? 1 : 0
            )
        )

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            navModel.push("ActivityCheckView")
        }
    }
}

