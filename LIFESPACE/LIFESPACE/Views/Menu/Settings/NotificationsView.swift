import SwiftUI
import UserNotifications
import UIKit

struct NotificationsView: View {
    @AppStorage("mealtimeNotifications") private var mealtimeEnabled: Bool = false
    @AppStorage("dailyCheckNotification") private var dailyCheckEnabled: Bool = false
    @AppStorage("diagnosticNotifications") private var diagnosticNotificationsEnabled: Bool = true

    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var lifespaceLogModel: LifespaceLogModel
    @EnvironmentObject var userProfile: UserProfileModel
    @EnvironmentObject var lifespaceSyncModel: LifespaceSyncModel

    @AppStorage("isSetupComplete") private var isSetupComplete: Bool = true

    @State private var showAlert = false
    @State private var showResetPopup = false
    @State private var showCopiedMessage = false

    let diagnosticTestNames = ["Depression", "Anxiety", "ADHD", "Autism", "BPD", "PSSD", "Psychosis"]

    var body: some View {
        ZStack(alignment: .top) {
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

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 28) {
                    Text("Settings")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.top, 80)

                    Toggle("Mealtime Notifications", isOn: $mealtimeEnabled)
                        .onChange(of: mealtimeEnabled) { newValue in
                            checkPermissionThen {
                                NotificationManager.shared.scheduleMealtimeNotifications(enabled: newValue)
                            } onDenied: {
                                mealtimeEnabled = false
                            }
                        }

                    Toggle("LIFESPACE Check Reminder", isOn: $dailyCheckEnabled)
                        .onChange(of: dailyCheckEnabled) { newValue in
                            checkPermissionThen {
                                NotificationManager.shared.scheduleDailyCheckNotification(
                                    enabled: newValue,
                                    lifespaceLogModel: lifespaceLogModel
                                )
                            } onDenied: {
                                dailyCheckEnabled = false
                            }
                        }

                    Toggle("Risk Assessment Reminders", isOn: $diagnosticNotificationsEnabled)
                        .onChange(of: diagnosticNotificationsEnabled) { newValue in
                            checkPermissionThen {
                                if newValue {
                                    print("✅ Diagnostic Test reminders enabled.")
                                } else {
                                    for testName in diagnosticTestNames {
                                        NotificationManager.shared.cancelSixMonthRetestNotification(for: testName)
                                    }
                                    print("🔕 Diagnostic Test reminders disabled, all pending retest notifications cancelled.")
                                }
                            } onDenied: {
                                diagnosticNotificationsEnabled = false
                            }
                        }

                    sharingCard

                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            showResetPopup = true
                        }
                    }) {
                        Text("Reset Profile")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red.opacity(0.25))
                            .cornerRadius(14)
                    }
                    .padding(.top, 4)

                    Spacer(minLength: 90)
                }
                .padding(.horizontal)
                .toggleStyle(LifespaceToggleStyle())
                .foregroundColor(.white)
                .font(.headline)
            }

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        navModel.push("HomeView")
                    }) {
                        Image(systemName: "house.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                    }
                }
            }

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
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .zIndex(10)
            }
        }
        .onAppear {
            lifespaceSyncModel.generateShareCodeIfNeeded()

            NotificationManager.shared.requestPermission()

            UNUserNotificationCenter.current().getNotificationSettings { settings in
                DispatchQueue.main.async {
                    if settings.authorizationStatus == .denied {
                        showAlert = true
                    }
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Notifications Disabled"),
                message: Text("To enable notifications, go to Settings → Notifications → LIFESPACE."),
                primaryButton: .default(Text("Go to Settings"), action: {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }),
                secondaryButton: .cancel()
            )
        }
    }

    private var sharingCard: some View {
        VStack(spacing: 14) {
            Text("LIFESPACE Data Sharing")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)

            Text("Use this code to connect your analytics to a therapist app or LIFESPACE web dashboard.")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white.opacity(0.88))
                .multilineTextAlignment(.center)

            Toggle(isOn: Binding(
                get: { lifespaceSyncModel.sharingEnabled },
                set: { lifespaceSyncModel.setSharingEnabled($0) }
            )) {
                Text("Share Analytics")
                    .foregroundColor(.white)
            }

            VStack(spacing: 8) {
                Text("Your Code")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white.opacity(0.8))

                Text(lifespaceSyncModel.userShareCode)
                    .font(.system(size: 27, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .tracking(2)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.15))
                    .cornerRadius(14)

                Button {
                    UIPasteboard.general.string = lifespaceSyncModel.userShareCode

                    withAnimation(.easeInOut(duration: 0.25)) {
                        showCopiedMessage = true
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            showCopiedMessage = false
                        }
                    }
                } label: {
                    Text(showCopiedMessage ? "Copied!" : "Copy Code")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.18))
                        .cornerRadius(12)
                }
            }
        }
        .padding(18)
        .background(Color.white.opacity(0.12))
        .cornerRadius(24)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.white.opacity(0.22), lineWidth: 1)
        )
        .padding(.top, 8)
    }

    func checkPermissionThen(_ onGranted: @escaping () -> Void, onDenied: @escaping () -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                if settings.authorizationStatus == .authorized {
                    onGranted()
                } else {
                    showAlert = true
                    onDenied()
                }
            }
        }
    }
}

private struct LifespaceToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 16) {
            configuration.label
                .foregroundColor(.white)

            Spacer()

            Button {
                withAnimation(.easeInOut(duration: 0.18)) {
                    configuration.isOn.toggle()
                }
            } label: {
                ZStack(alignment: configuration.isOn ? .trailing : .leading) {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(configuration.isOn ? 0.32 : 0.12),
                                    Color.white.opacity(configuration.isOn ? 0.16 : 0.06)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .stroke(
                                    Color.white.opacity(configuration.isOn ? 0.35 : 0.22),
                                    lineWidth: 1.2
                                )
                        )
                        .shadow(color: .black.opacity(0.18), radius: 6, y: 3)

                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0.98),
                                    Color.white.opacity(0.78)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            Circle().stroke(Color.black.opacity(0.10), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.25), radius: 5, y: 2)
                        .padding(3.5)
                }
                .frame(width: 58, height: 32)
            }
            .buttonStyle(.plain)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.18)) {
                configuration.isOn.toggle()
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

            Text("Your user profile will be reset but your LIFESPACE scores will remain the same.")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white.opacity(0.92))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 10)

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
        .padding(18)
        .frame(maxWidth: 360)
        .frame(height: 190)
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
