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
                    VStack(spacing: 28) {
                        Text("ACTIVITY")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                            .opacity(showTitle ? 1 : 0)
                            .animation(.easeIn(duration: 1), value: showTitle)
                            .padding(.top, 48)

                        VStack(spacing: 15) {
                            Text("How long did you sleep last night?")
                                .foregroundColor(.white)
                                .font(.headline)
                                .multilineTextAlignment(.center)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.horizontal, 24)

                            Text(sleepHoursLabel)
                                .foregroundColor(.white)
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.horizontal, 24)

                            Slider(
                                value: Binding(
                                    get: { sleepHours ?? 0 },
                                    set: { newValue in
                                        sleepHours = newValue
                                        checkCompletion()
                                    }
                                ),
                                in: 0...10,
                                step: 0.5
                            )
                            .accentColor(.white)
                            .padding(.horizontal, 28)
                        }

                        VStack(spacing: 14) {
                            Text("Have you made time for any of these recently?")
                                .foregroundColor(.white)
                                .font(.headline)
                                .multilineTextAlignment(.center)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.horizontal, 24)

                            Text(activityListDisplay())
                                .foregroundColor(.white)
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.horizontal, 24)

                            HStack(spacing: 18) {
                                AnswerButton(label: "Yes", isSelected: didActivity == true) {
                                    didActivity = true
                                    checkCompletion()
                                }

                                AnswerButton(label: "No", isSelected: didActivity == false) {
                                    didActivity = false
                                    checkCompletion()
                                }
                            }
                            .padding(.horizontal, 24)
                        }
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

    private var sleepHoursLabel: String {
        if let hours = sleepHours {
            return String(format: "%.1f hours", hours)
        } else {
            return "Move the slider to select hours"
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
            withAnimation(.easeInOut(duration: 0.4)) {
                navModel.push("CommunityCheckView")
            }
        }
    }
}