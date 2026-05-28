import SwiftUI

struct ActivitySetupView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var userProfile: UserProfileModel

    @State private var selectedActivities: [String] = []
    @State private var showOptions = false
    @State private var showTitle = false
    @AppStorage("returnToConfirmation") private var returnToConfirmation: Bool = false
    @State private var canNavigate = true

    // Reactive: reflects latest input from userProfile
    var fullActivityList: [String] {
        var base = [
            "SPORTS", "GAMES", "ANIMALS", "MUSIC/DANCE",
            "TV/MOVIES", "READING", "OUTDOORS", "ARTS/CRAFTS"
        ]

        let custom = userProfile.customActivity?.trimmingCharacters(in: .whitespacesAndNewlines)
        if let custom = custom, !custom.isEmpty {
            base.append(custom)
        } else {
            base.append("CUSTOM ACTIVITY")
        }

        return base
    }

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
                Text("Choose 3 Activities")
                    .font(Font.custom("Avenir", size: 26).weight(.bold))
                    .foregroundColor(.white)
                    .padding(.top, 60)
                    .opacity(showTitle ? 1 : 0)
                    .animation(.easeInOut(duration: 1), value: showTitle)

                if showOptions {
                    VStack(spacing: 16) {
                        ForEach(fullActivityList, id: \.self) { activity in
                            Button(action: {
                                handleSelection(activity)
                            }) {
                                Text(activity)
                                    .font(Font.custom("Avenir", size: 18).weight(.medium))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(selectedActivities.contains(activity) ? Color.white.opacity(0.3) : Color.white.opacity(0.15))
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(selectedActivities.contains(activity) ? Color.white : Color.clear, lineWidth: 2)
                                    )
                            }
                            .disabled(selectedActivities.count >= 3 && !selectedActivities.contains(activity))
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

            // ✅ Flag reset handled *after* navigation to avoid race conditions
            selectedActivities = userProfile.activityOptions
        }
        .onChange(of: userProfile.customActivity) { _ in
            selectedActivities = userProfile.activityOptions
        }
    }

    func handleSelection(_ activity: String) {
        if activity == "CUSTOM ACTIVITY" && userProfile.customActivity == nil {
            navModel.push("CustomActivityView")
            return
        }

        if selectedActivities.contains(activity) {
            selectedActivities.removeAll { $0 == activity }
        } else if selectedActivities.count < 3 {
            selectedActivities.append(activity)
        }

        if selectedActivities.count == 3 && canNavigate {
            canNavigate = false
            userProfile.activityOptions = selectedActivities

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                if returnToConfirmation {
                    navModel.push("SetupConfirmationView")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        returnToConfirmation = false
                    }
                } else {
                    navModel.push("ExpressionSetupView")
                }
            }
        }
    }
}

