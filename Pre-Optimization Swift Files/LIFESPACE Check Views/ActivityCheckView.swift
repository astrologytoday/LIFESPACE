import SwiftUI

struct ActivityCheckView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var userProfile: UserProfileModel
    @EnvironmentObject var lifespaceLog: LifespaceLogModel

    @State private var showTitle = false
    @State private var sleepHours: Double? = nil
    @State private var didActivity: Bool? = nil
    @State private var selectionMade = false

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

                Text("ACTIVITY")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .opacity(showTitle ? 1 : 0)
                    .animation(.easeIn(duration: 1), value: showTitle)

                // Sleep Section
                VStack(spacing: 15) {
                    Text("How long did you sleep last night?")
                        .foregroundColor(.white)
                        .font(.headline)

                    if let hours = sleepHours {
                        Text(String(format: "%.1f hours", hours))
                            .foregroundColor(.white)
                            .font(.subheadline)
                    }

                    Slider(
                        value: Binding(
                            get: { sleepHours ?? 0 },
                            set: { sleepHours = $0; checkCompletion() }
                        ),
                        in: 0...10,
                        step: 0.5
                    )
                    .accentColor(.white)
                    .padding(.horizontal)
                }

                // Activity Section
                VStack(spacing: 12) {
                    Text("Have you made time for any of these recently?")
                        .foregroundColor(.white)
                        .font(.headline)

                    Text(activityListDisplay())
                        .foregroundColor(.white)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    HStack(spacing: 30) {
                        AnswerButton(
                            label: "Yes",
                            isSelected: didActivity == true
                        ) {
                            didActivity = true
                            checkCompletion()
                        }

                        AnswerButton(
                            label: "No",
                            isSelected: didActivity == false
                        ) {
                            didActivity = false
                            checkCompletion()
                        }
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

    private func activityListDisplay() -> String {
        let list = userProfile.activityOptions
        return list.isEmpty ? "No activities selected" : list.joined(separator: ", ")
    }

    private func checkCompletion() {
        guard let hours = sleepHours, let activity = didActivity else { return }
        guard !selectionMade else { return }
        selectionMade = true

        let sleepYes = hours >= 6 ? 1 : 0
        let activityYes = activity ? 1 : 0
        let yesCount = sleepYes + activityYes

        lifespaceLog.addEntry(
            LifespaceLogEntry(
                type: .lifespace,
                module: .activity,
                questionCount: 2,
                yesCount: yesCount
            )
        )

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            navModel.push("CommunityCheckView")
        }
    }
}

