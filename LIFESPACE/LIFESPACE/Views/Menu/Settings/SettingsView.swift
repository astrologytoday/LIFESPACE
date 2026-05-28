import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var userProfile: UserProfileModel
    @AppStorage("isSetupComplete") var isSetupComplete: Bool = true

    @State private var showResetPopup = false

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

            VStack(spacing: 40) {
                Text("Settings")
                    .font(Font.custom("Avenir", size: 26).weight(.bold))
                    .foregroundColor(.white)
                    .padding(.top, 60)

                Button(action: {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        showResetPopup = true
                    }
                }) {
                    Text("Reset Profile")
                        .font(Font.custom("Avenir", size: 18).weight(.medium))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red.opacity(0.25))
                        .cornerRadius(12)
                        .padding(.horizontal, 30)
                }

                Spacer()
            }

            // ✅ LIFESPACE-style popup overlay (GoalPlannerView style)
            if showResetPopup {
                ZStack {
                    Color.black.opacity(0.45)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                showResetPopup = false
                            }
                        }

                    LifespaceResetPopup(
                        onConfirm: {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                showResetPopup = false
                            }

                            // Reset user profile and app state (scores remain unchanged)
                            userProfile.reset()
                            isSetupComplete = false
                            navModel.selectedScreen = "HomeView"
                        },
                        onCancel: {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                showResetPopup = false
                            }
                        }
                    )
                    .transition(.scale.combined(with: .opacity))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity) // ✅ centers regardless of parent alignment
                .zIndex(10)
            }
        }
    }
}

private struct LifespaceResetPopup: View {
    var onConfirm: () -> Void
    var onCancel: () -> Void

    var body: some View {
        VStack(spacing: 14) {
            Text("Are you sure?")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
                .shadow(radius: 3)

            Text("Your user profile will be reset but LIFESPACE scores remain the same.")
                .font(.system(size: 15.5, weight: .semibold))
                .foregroundColor(.white.opacity(0.92))
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .allowsTightening(false)
                .padding(.horizontal, 12)

            HStack(spacing: 12) {
                Button(action: onCancel) {
                    Text("CANCEL")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.14))
                        .cornerRadius(16)
                }

                Button(action: onConfirm) {
                    Text("RESET")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(Color.red.opacity(0.55))
                        .cornerRadius(16)
                }
            }
        }
        .padding(.vertical, 22)
        .padding(.horizontal, 18)
        .frame(maxWidth: 360)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .stroke(Color.white.opacity(0.22), lineWidth: 1.3)
        )
        .shadow(color: .black.opacity(0.18), radius: 18, y: 6)
        .padding(.horizontal, 24)
    }
}
