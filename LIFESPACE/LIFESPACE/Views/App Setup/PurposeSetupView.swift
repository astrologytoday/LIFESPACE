import SwiftUI

struct PurposeSetupView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var userProfile: UserProfileModel
    @AppStorage("returnToConfirmation") private var returnToConfirmation: Bool = false

    @State private var showOptions = false
    @State private var selectedPurpose: String?
    @State private var showTitle = false

    let purposes = [
        "TECHNOLOGY",
        "BUSINESS MANAGEMENT",
        "ETHICS",
        "ENTERTAINMENT",
        "HEALTH",
        "INFRASTRUCTURE",
        "EDUCATION",
        "COMMUNICATIONS",
        "SECURITY",
        "LOGISTICS"
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
                Text("Choose Your Purpose")
                    .font(Font.custom("Avenir", size: 26).weight(.bold))
                    .foregroundColor(.white)
                    .padding(.top, 60)
                    .opacity(showTitle ? 1 : 0)
                    .animation(.easeInOut(duration: 1), value: showTitle)

                if showOptions {
                    VStack(spacing: 20) {
                        ForEach(purposes, id: \.self) { purpose in
                            Button(action: {
                                withAnimation {
                                    selectedPurpose = purpose
                                    userProfile.purposeOptions = [purpose]

                                    if returnToConfirmation {
                                        returnToConfirmation = false
                                        navModel.push("SetupConfirmationView")
                                    } else {
                                        navModel.push("SetupConfirmationView")
                                    }
                                }
                            }) {
                                Text(purpose)
                                    .font(Font.custom("Avenir", size: 18).weight(.medium))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.white.opacity(0.15))
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(selectedPurpose == purpose ? Color.white : Color.clear, lineWidth: 2)
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

            // Restore previous purpose selection if editing
            selectedPurpose = userProfile.purposeOptions.first
        }
    }
}

