import SwiftUI

struct LightCheckView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var lifespaceLog: LifespaceLogModel

    @State private var blindsOpened: Bool? = nil
    @State private var wentOutside: Bool? = nil
    @State private var showTitle = false

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

                Text("LIGHT")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .opacity(showTitle ? 1 : 0)
                    .animation(.easeIn(duration: 1), value: showTitle)

                VStack(spacing: 30) {
                    QuestionToggle(
                        question: "Have you opened your blinds?",
                        selection: $blindsOpened
                    )

                    QuestionToggle(
                        question: "Have you gone outside in the last 24 hours?",
                        selection: $wentOutside
                    )
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
        .onChange(of: blindsOpened) { _ in checkCompletion() }
        .onChange(of: wentOutside) { _ in checkCompletion() }
    }

    private func checkCompletion() {
        guard let blinds = blindsOpened, let outside = wentOutside else { return }

        let yesCount = [blinds, outside].filter { $0 }.count

        lifespaceLog.addEntry(
            LifespaceLogEntry(
                type: .lifespace,
                module: .light,
                questionCount: 2,
                yesCount: yesCount
            )
        )

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            navModel.push("InnerWorkCheckView")
        }
    }
}

