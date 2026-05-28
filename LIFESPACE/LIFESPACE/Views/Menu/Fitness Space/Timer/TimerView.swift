import SwiftUI
import AVFoundation
import UserNotifications

struct TimerView: View {
    @EnvironmentObject var navModel: NavigationModel
    @Environment(\.scenePhase) private var scenePhase

    // Timer state
    @State private var totalTime: Int = 300
    @State private var timeRemaining: Int = 300
    @State private var timerRunning: Bool = false
    @State private var timer: Timer?
    @State private var endDate: Date? = nil

    // Picker state
    @State private var showPicker: Bool = false
    @State private var selectedMinutes: Int = 5
    @State private var selectedSeconds: Int = 0

    // Sound
    @State private var player: AVAudioPlayer?

    // UI
    @State private var isVisible = true
    @State private var isExiting = false

    private let notificationID = "LIFESPACE_TIMER_DONE"
    private let timerSoundFileName = "timer_complete.wav"

    var body: some View {
        ZStack {
            // 🌊 Teal Gradient Background
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
                Text("TIMER")
                    .font(.custom("Avenir-Heavy", size: 36))
                    .foregroundColor(.white)
                    .padding(.top, 20)

                Text(timeString)
                    .font(.custom("Avenir-Heavy", size: 72))
                    .foregroundColor(.white)
                    .monospacedDigit()
                    .padding()

                if showPicker {
                    HStack(spacing: 20) {
                        Picker(selection: $selectedMinutes, label: Text("Minutes")) {
                            ForEach(0..<60) { minute in
                                Text("\(minute) min")
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 120)
                        .clipped()

                        Picker(selection: $selectedSeconds, label: Text("Seconds")) {
                            ForEach(0..<60) { second in
                                Text("\(second) sec")
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 120)
                        .clipped()
                    }
                }

                HStack(spacing: 30) {
                    Button(action: toggleTimer) {
                        Text(timerRunning ? "PAUSE" : "START")
                            .font(.custom("Avenir-Heavy", size: 20))
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 120)
                            .background(Color.black.opacity(0.2))
                            .cornerRadius(15)
                    }

                    Button(action: resetTimer) {
                        Text("RESET")
                            .font(.custom("Avenir-Heavy", size: 20))
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 120)
                            .background(Color.black.opacity(0.2))
                            .cornerRadius(15)
                    }
                }

                Button(action: {
                    showPicker.toggle()
                    stopSound()
                }) {
                    Text(showPicker ? "HIDE TIME" : "SET TIME")
                        .font(.custom("Avenir", size: 16))
                        .foregroundColor(.white)
                        .padding(.top, 10)
                }

                Spacer(minLength: 160)
            }
            .padding()

            // ✅ Single Centered Floating Back Button
            VStack {
                Spacer()

                Button(action: {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        isVisible = false
                        isExiting = true
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        navModel.pop()
                    }
                }) {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.85, green: 1.0, blue: 0.9),
                                    Color(red: 0.4, green: 0.9, blue: 0.8)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 65, height: 65)
                        .overlay(
                            Image(systemName: "chevron.left")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.black)
                        )
                }
                .opacity(isExiting ? 0 : 1)
                .transition(.opacity)
                .padding(.bottom, 20)
            }
        }
        .opacity(isVisible ? 1 : 0)
        .onChange(of: selectedMinutes) { _ in
            if !timerRunning {
                syncTimeFromPicker()
            }
        }
        .onChange(of: selectedSeconds) { _ in
            if !timerRunning {
                syncTimeFromPicker()
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .active {
                refreshRemainingFromEndDate()
            }
        }
        .onAppear {
            requestNotificationPermission()
            syncTimeFromPicker()
        }
        .onDisappear {
            timer?.invalidate()
            timer = nil
            stopSound()

            // IMPORTANT:
            // Do NOT cancel the notification if the timer is still running.
            // This allows the timer alert to beep when the iPhone sleeps,
            // locks, or the user leaves this screen.
            if !timerRunning {
                cancelTimerNotification()
            }
        }
    }

    private var timeString: String {
        let minutes = max(0, timeRemaining) / 60
        let seconds = max(0, timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    // MARK: - Core Timer Logic

    private func toggleTimer() {
        if timerRunning {
            pauseTimer()
        } else {
            startTimer()
        }
    }

    private func startTimer() {
        stopSound()

        if timeRemaining <= 0 {
            syncTimeFromPicker()
        }

        guard timeRemaining > 0 else { return }

        endDate = Date().addingTimeInterval(TimeInterval(timeRemaining))

        scheduleTimerNotification(secondsFromNow: TimeInterval(timeRemaining))

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            tick()
        }

        timerRunning = true
    }

    private func pauseTimer() {
        timer?.invalidate()
        timer = nil

        refreshRemainingFromEndDate()
        endDate = nil

        cancelTimerNotification()
        stopSound()

        timerRunning = false
    }

    private func tick() {
        guard let endDate else { return }

        let remaining = Int(endDate.timeIntervalSinceNow.rounded(.down))

        if remaining > 0 {
            timeRemaining = remaining
        } else {
            completeTimer()
        }
    }

    private func completeTimer() {
        timer?.invalidate()
        timer = nil

        timerRunning = false
        endDate = nil
        timeRemaining = 0

        cancelTimerNotification()
        playSound()
    }

    private func resetTimer() {
        timer?.invalidate()
        timer = nil

        cancelTimerNotification()
        stopSound()

        timerRunning = false
        endDate = nil

        syncTimeFromPicker()
    }

    private func syncTimeFromPicker() {
        let total = (selectedMinutes * 60) + selectedSeconds
        totalTime = total
        timeRemaining = total
    }

    private func refreshRemainingFromEndDate() {
        guard let endDate else { return }

        timeRemaining = max(0, Int(endDate.timeIntervalSinceNow.rounded(.down)))

        if timeRemaining == 0 && timerRunning {
            completeTimer()
        }
    }

    // MARK: - Sound

    private func playSound() {
        guard let url = Bundle.main.url(forResource: "timer_complete", withExtension: "wav") else {
            print("Sound file not found: \(timerSoundFileName)")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.volume = 1.0
            player?.numberOfLoops = 0
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("Failed to play timer sound: \(error)")
        }
    }

    private func stopSound() {
        player?.stop()
        player = nil
    }

    // MARK: - Local Notifications

    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error {
                print("Notification permission error: \(error)")
            }

            if !granted {
                print("Notification permission was not granted.")
            }
        }
    }

    private func scheduleTimerNotification(secondsFromNow: TimeInterval) {
        cancelTimerNotification()

        let content = UNMutableNotificationContent()
        content.title = "Timer Complete"
        content.body = "Your timer finished."

        // This is the important fix:
        // The notification sound is what can beep when the phone is asleep/locked.
        content.sound = UNNotificationSound(
            named: UNNotificationSoundName(rawValue: timerSoundFileName)
        )

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: max(1, secondsFromNow),
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: notificationID,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error {
                print("Failed to schedule timer notification: \(error)")
            }
        }
    }

    private func cancelTimerNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [notificationID])
        center.removeDeliveredNotifications(withIdentifiers: [notificationID])
    }
}
