import SwiftUI

struct FitnessSetupView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var userProfile: UserProfileModel
    @AppStorage("returnToConfirmation") private var returnToConfirmation: Bool = false

    @State private var showOptions = false
    @State private var selectedGoal: String?
    @State private var showTitle = false

    let fitnessOptions = [
        "WEIGHT LOSS",
        "MUSCLE GAIN",
        "MAINTAIN BODY"
    ]

    var body: some View {
        ZStack {
            // Background
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

            VStack(spacing: 30) {
                // Fading title
                Text("Choose Your Fitness Goal")
                    .font(Font.custom("Avenir", size: 26).weight(.bold))
                    .foregroundColor(.white)
                    .padding(.top, 60)
                    .opacity(showTitle ? 1 : 0)
                    .animation(.easeInOut(duration: 1), value: showTitle)

                Spacer().frame(height: 50)

                if showOptions {
                    VStack(spacing: 50) {
                        ForEach(fitnessOptions, id: \.self) { goal in
                            Button(action: {
                                selectedGoal = goal
                                userProfile.fitnessOptions = [goal]

                                // Add a short delay for animation polish
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    if returnToConfirmation {
                                        returnToConfirmation = false
                                        navModel.push("SetupConfirmationView")
                                    } else {
                                        navModel.push("ActivitySetupView")
                                    }
                                }
                            }) {
                                Text(goal)
                                    .font(Font.custom("Avenir", size: 18).weight(.medium))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.white.opacity(0.15))
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(selectedGoal == goal ? Color.white : Color.clear, lineWidth: 2)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal)
                    .transition(.opacity)
                }

                Spacer()
            }
            .padding(.bottom, 40)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if !showOptions {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showOptions = true
                }
            }
        }
        .onAppear {
            withAnimation {
                showTitle = true
            }

            // Pre-select previous choice if editing from confirmation
            if let savedGoal = userProfile.fitnessOptions.first {
                selectedGoal = savedGoal
            }
        }
    }
}

