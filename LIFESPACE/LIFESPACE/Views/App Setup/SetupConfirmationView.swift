import SwiftUI

struct SetupConfirmationView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var userProfile: UserProfileModel
    @AppStorage("isSetupComplete") private var isSetupComplete: Bool = false

    @State private var showTitle = false

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

            VStack(alignment: .leading, spacing: 20) {
                Text("Review Your Profile")
                    .font(Font.custom("Avenir", size: 24).weight(.bold))
                    .foregroundColor(.white)
                    .padding(.top, 40)
                    .opacity(showTitle ? 1 : 0)
                    .animation(.easeInOut(duration: 1), value: showTitle)

                ScrollView {
                    VStack(spacing: 12) {
                        profileRow("Gender", userProfile.gender.isEmpty ? "Not set" : userProfile.gender)
                        profileRow("Age", userProfile.age.isEmpty ? "Not set" : userProfile.age)
                        profileRow("Height", userProfile.height.isEmpty ? "Not set" : userProfile.height)
                        profileRow("Weight", userProfile.weight == "0" || userProfile.weight.isEmpty ? "Not set" : "\(userProfile.weight) lbs")
                        profileRow("Drinks Per Week", userProfile.drinksPerWeek.isEmpty ? "Not set" : userProfile.drinksPerWeek)
                        profileRow("Smoking Status", userProfile.smokingStatus.isEmpty ? "Not set" : userProfile.smokingStatus)

                        profileRow("Fitness Goal", userProfile.fitnessOptions.first ?? "Not set")
                        profileRow("Activities", userProfile.activityOptions.isEmpty ? "Not set" : userProfile.activityOptions.joined(separator: ", "))
                        profileRow("Creative Outlet", userProfile.expressionOptions.first ?? "Not set")
                        profileRow("Inner Work", userProfile.innerWorkOptions.isEmpty ? "Not set" : userProfile.innerWorkOptions.joined(separator: ", "))
                        profileRow("Purpose", userProfile.purposeOptions.first ?? "Not set")
                    }
                    .padding(.bottom, 10)
                }

                Spacer()

                VStack(spacing: 16) {
                    Button(action: {
                        if isSetupComplete {
                            navModel.selectedScreen = "HomeView"
                        } else {
                            isSetupComplete = true
                            navModel.selectedScreen = "SetupCompletionView"
                        }
                    }) {
                        Text("Yes, everything looks good")
                            .font(Font.custom("Avenir", size: 18).weight(.medium))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green.opacity(0.25))
                            .cornerRadius(12)
                    }

                    Button(action: {
                        navModel.push("SetupConfirmationView2")
                    }) {
                        Text("No, I need to make changes")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.black.opacity(0.3))
                            .cornerRadius(14)
                            .padding(.horizontal)
                    }
                }
                .padding(.bottom, 40)
            }
            .padding(.horizontal)
        }
        .onAppear {
            withAnimation {
                showTitle = true
            }
        }
    }

    // MARK: - Profile Row Builder
    func profileRow(_ label: String, _ value: String) -> some View {
        HStack(alignment: .top) {
            Text("\(label):")
                .font(Font.custom("Avenir", size: 16).weight(.bold))
                .foregroundColor(.white)
            Spacer(minLength: 16)
            Text(value)
                .font(Font.custom("Avenir", size: 16))
                .foregroundColor(.white)
                .multilineTextAlignment(.trailing)
        }
    }
}

