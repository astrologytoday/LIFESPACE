import SwiftUI

struct SetupConfirmationView2: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var userProfile: UserProfileModel
    @AppStorage("returnToConfirmation") var returnToConfirmation: Bool = false

    @State private var showOptions = false

    // Change targets
    let changes: [(label: String, target: String)] = [
        ("GENDER", "StatsSetupView"),
        ("AGE", "StatsSetupView"),
        ("HEIGHT", "StatsSetupView"),
        ("WEIGHT", "StatsSetupView"),
        ("DRINKS PER WEEK", "StatsSetupView"),
        ("SMOKING STATUS", "StatsSetupView"),
        ("FITNESS GOAL", "FitnessSetupView"),
        ("ACTIVITIES", "ActivitySetupView"),
        ("CREATIVE OUTLET", "ExpressionSetupView"),
        ("INNER WORK", "InnerWorkSetupView"),
        ("PURPOSE", "PurposeSetupView")
    ]

    var body: some View {
        ZStack {
            // Teal gradient background
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

            VStack(spacing: 20) {
                // Title
                Text("What do you need to change?")
                    .font(Font.custom("Avenir", size: 24).weight(.bold))
                    .foregroundColor(.white)
                    .padding(.top, 40)
                    .opacity(showOptions ? 1 : 0)
                    .animation(.easeInOut(duration: 1), value: showOptions)

                // Option list
                if showOptions {
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(changes, id: \.label) { item in
                            Button(action: {
                                returnToConfirmation = true

                                switch item.label {
                                case "ACTIVITIES":
                                    userProfile.activityOptions = []
                                    userProfile.customActivity = nil
                                case "CREATIVE OUTLET":
                                    userProfile.expressionOptions = []
                                    userProfile.customExpression = nil
                                case "INNER WORK":
                                    userProfile.innerWorkOptions = []
                                    userProfile.customInnerWork = nil
                                    userProfile.pendingCustomInnerWork = nil
                                default:
                                    break
                                }

                                navModel.push(item.target)
                            }) {
                                Text(item.label)
                                    .font(Font.custom("Avenir", size: 18))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                                    .background(Color.white.opacity(0.12))
                                    .cornerRadius(12)
                                    .transition(.opacity)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .animation(.easeInOut(duration: 0.5), value: showOptions)
                }

                Spacer()
            }
            .padding(.top, 10)
            .onAppear {
                withAnimation {
                    showOptions = true
                }
            }
        }
    }
}

