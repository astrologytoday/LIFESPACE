import SwiftUI

struct SensoryCheckView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var lifespaceLog: LifespaceLogModel

    @State private var showTitle = false
    @State private var showered: Bool? = nil
    @State private var houseClean: Bool? = nil

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

                Text("SENSORY")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .opacity(showTitle ? 1 : 0)
                    .animation(.easeIn(duration: 1), value: showTitle)

                VStack(spacing: 30) {
                    QuestionToggle(
                        question: "Have you showered today?",
                        selection: $showered
                    )

                    QuestionToggle(
                        question: "Is your house clean?",
                        selection: $houseClean
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
        .onChange(of: showered) { _ in checkCompletion() }
        .onChange(of: houseClean) { _ in checkCompletion() }
    }

    private func checkCompletion() {
        guard let clean = houseClean, let washed = showered else { return }

        let yesCount = [clean, washed].filter { $0 }.count

        lifespaceLog.addEntry(
            LifespaceLogEntry(
                type: .lifespace,
                module: .sensory,
                questionCount: 2,
                yesCount: yesCount
            )
        )

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            navModel.push("PurposeCheckView")
        }
    }
}
