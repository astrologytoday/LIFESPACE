import SwiftUI

struct MeetupsProfileView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var userProfile: UserProfileModel

    @State private var username: String = ""
    @State private var intent: String = ""

    // Pulse animation
    @State private var pulse = false

    private var canSearch: Bool {
        !username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !intent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

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

            VStack(spacing: 30) {
                // Title
                Text("LIFESPACE Meetups")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top)

                // Two-column layout
                HStack(alignment: .top, spacing: 24) {

                    // LEFT: Inputs
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Username")
                            .font(.headline)
                            .foregroundColor(.white)

                        TextField("Enter username...", text: $username)
                            .padding(10)
                            .background(Color.white.opacity(0.15))
                            .cornerRadius(10)
                            .foregroundColor(.white)

                        Text("What do you want to do?")
                            .font(.headline)
                            .foregroundColor(.white)

                        TextField("Go for coffee", text: $intent)
                            .padding(10)
                            .background(Color.white.opacity(0.15))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)

                    // RIGHT: User Profile Summary
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Your Profile")
                            .font(.headline)
                            .foregroundColor(.white)

                        profileItem("Gender", userProfile.gender)
                        profileItem("Age", "\(userProfile.age)")
                        profileItem("Height", "\(userProfile.height) cm")
                        profileItem("Weight", "\(userProfile.weight) kg")
                        profileItem("Drinks/Week", "\(userProfile.drinksPerWeek)")
                        profileItem("Smoker", userProfile.smokingStatus)
                        profileItem("Fitness Goals", userProfile.fitnessOptions.joined(separator: ", "))
                        profileItem("Activities", (userProfile.activityOptions + [userProfile.customActivity].compactMap { $0 }).joined(separator: ", "))
                        profileItem("Creative Outlet", (userProfile.expressionOptions + [userProfile.customExpression].compactMap { $0 }).joined(separator: ", "))
                        profileItem("Inner Work", (userProfile.innerWorkOptions + [userProfile.customInnerWork].compactMap { $0 }).joined(separator: ", "))
                        profileItem("Purpose", userProfile.purposeOptions.joined(separator: ", "))
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)
                .padding(.top)

                Spacer()

                // SEARCH FOR MEETUPS (disabled until both fields filled)
                Button(action: {
                    guard canSearch else { return }
                    withAnimation(.easeInOut(duration: 0.4)) {
                        navModel.meetupUsername = username
                        navModel.meetupIntent = intent
                        navModel.push("MeetupsView")
                    }
                }) {
                    Text("SEARCH FOR MEETUPS")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(
                            canSearch
                            ? Color(red: 0.10, green: 0.45, blue: 0.45)
                            : Color.white.opacity(0.45)
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            Group {
                                if canSearch {
                                    // ✅ "Lights on"
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(Color.white)
                                        .shadow(color: Color.yellow.opacity(0.18), radius: 18, x: 0, y: 0) // soft glow
                                        .shadow(color: Color.black.opacity(0.22), radius: 10, x: 0, y: 6)   // lift
                                } else {
                                    // ✅ "Lights off" (clearly disabled)
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(Color.black.opacity(0.16))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 14)
                                                .stroke(Color.white.opacity(0.18), lineWidth: 1)
                                        )
                                }
                            }
                        )
                        .scaleEffect(canSearch ? (pulse ? 1.04 : 1.0) : 1.0)
                        .animation(
                            canSearch
                            ? .easeInOut(duration: 0.9).repeatForever(autoreverses: true)
                            : .default,
                            value: pulse
                        )
                }
                .buttonStyle(.plain)
                .disabled(!canSearch)
                .padding(.horizontal, 30)
                .onChange(of: canSearch) { newValue in
                    if newValue {
                        pulse = false
                        DispatchQueue.main.async {
                            withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) {
                                pulse = true
                            }
                        }
                    } else {
                        pulse = false
                    }
                }


                // RETURN TO TIPS (new)
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        navModel.push("TipsView")
                    }
                }) {
                    Text("RETURN TO TIPS")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white.opacity(0.18))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.white.opacity(0.35), lineWidth: 1)
                        )
                        .cornerRadius(14)
                        .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 5)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            pulse = true
        }
        .onChange(of: canSearch) { newValue in
            // Start/stop pulsing cleanly
            pulse = newValue
        }
    }

    @ViewBuilder
    func profileItem(_ label: String, _ value: String) -> some View {
        HStack {
            Text("\(label):")
                .font(.custom("Avenir", size: 16))
                .foregroundColor(.white)
            Spacer()
            Text(value)
                .font(.custom("Avenir", size: 16))
                .foregroundColor(.white.opacity(0.9))
        }
    }
}
