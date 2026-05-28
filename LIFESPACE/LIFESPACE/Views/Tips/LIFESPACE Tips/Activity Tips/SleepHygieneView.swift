//
//  SleepHygieneView.swift
//  LIFESPACE
//

import SwiftUI

struct SleepHygieneView: View {
    @EnvironmentObject var navModel: NavigationModel

    @AppStorage("sleepHygieneChecklistJSON") private var checklistJSON: String = ""

    @State private var appeared = false
    @State private var states: [String: Bool] = [:]
    @State private var midnightTimer: Timer?

    private let items: [String] = [
        "I am going to bed the same time as last night",
        "I did not spend time in bed today other than to sleep",
        "I exercised earlier in the day",
        "I did not have a heavy meal after 7PM",
        "I did not use any screens 1 hour before bed",
        "I did not drink any liquids 1 hour before bed",
        "I did not drink alcohol or caffeine after 6PM",
        "I did not consume nicotine after 6PM",
        "My bedroom is under 21°C",
        "My bedroom is quiet",
        "My bedroom is dark"
    ]

    var body: some View {
        ZStack(alignment: .topLeading) {

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

            ScrollView(showsIndicators: true) {
                VStack(spacing: 14) {

                    // Top bar: Back + Info + Home
                    HStack {
                        Button(action: { navModel.pop() }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color.black.opacity(0.22))
                                .clipShape(Circle())
                        }

                        Spacer()

                        HStack(spacing: 10) {
                            Button(action: { navModel.push("SleepHygieneInfoView") }) {
                                Image(systemName: "info")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Color.black.opacity(0.22))
                                    .clipShape(Circle())
                            }

                            Button(action: { navModel.push("HomeView") }) {
                                Image(systemName: "house.fill")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Color.black.opacity(0.22))
                                    .clipShape(Circle())
                            }
                        }
                    }
                    .padding(.horizontal, 18)
                    .padding(.top, 14)

                    VStack(spacing: 6) {
                        Text("Sleep Hygiene Checklist")
                            .font(.system(size: 31, weight: .heavy))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .minimumScaleFactor(0.72)
                            .allowsTightening(true)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .shadow(radius: 4)
                            .opacity(appeared ? 1 : 0)
                            .offset(y: appeared ? 0 : -10)
                            .animation(.easeInOut(duration: 0.4), value: appeared)

                        Text("Tap to check off what you did tonight.")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(.horizontal, 18)

                    VStack(spacing: 10) {
                        ForEach(items, id: \.self) { item in
                            Button {
                                toggle(item)
                            } label: {
                                ChecklistRow(
                                    text: item,
                                    isChecked: states[item] ?? false
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 22)
                            .fill(Color.black.opacity(0.22))
                            .overlay(
                                RoundedRectangle(cornerRadius: 22)
                                    .stroke(Color.white.opacity(0.18), lineWidth: 1)
                            )
                    )
                    .shadow(radius: 14)
                    .padding(.horizontal, 18)
                    .padding(.top, 4)
                    .padding(.bottom, 28)
                }
            }
        }
        .onAppear {
            appeared = true
            loadAndResetIfNeeded()
            scheduleMidnightReset()
        }
        .onDisappear {
            midnightTimer?.invalidate()
            midnightTimer = nil
        }
    }

    private func toggle(_ item: String) {
        loadAndResetIfNeeded()
        states[item] = !(states[item] ?? false)
        save()
    }

    private func loadAndResetIfNeeded() {
        let todayStamp = dayStamp(for: Date())

        if let saved = decode(checklistJSON) {
            if saved.dayStamp != todayStamp {
                states = [:]
                checklistJSON = encode(PersistedChecklist(dayStamp: todayStamp, states: [:])) ?? ""
            } else {
                states = saved.states
            }
        } else {
            states = [:]
            checklistJSON = encode(PersistedChecklist(dayStamp: todayStamp, states: [:])) ?? ""
        }
    }

    private func save() {
        let stamp = dayStamp(for: Date())
        checklistJSON = encode(PersistedChecklist(dayStamp: stamp, states: states)) ?? ""
    }

    private func scheduleMidnightReset() {
        midnightTimer?.invalidate()

        let cal = Calendar.current
        let startOfToday = cal.startOfDay(for: Date())
        guard let startOfTomorrow = cal.date(byAdding: .day, value: 1, to: startOfToday) else { return }

        let interval = startOfTomorrow.timeIntervalSinceNow
        guard interval > 0 else { return }

        midnightTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { _ in
            states = [:]
            save()
            scheduleMidnightReset()
        }
    }

    private func dayStamp(for date: Date) -> String {
        let cal = Calendar.current
        let sod = cal.startOfDay(for: date)
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withFullDate]
        return f.string(from: sod)
    }

    private struct PersistedChecklist: Codable {
        let dayStamp: String
        let states: [String: Bool]
    }

    private func decode(_ json: String) -> PersistedChecklist? {
        guard !json.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return nil }
        guard let data = json.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(PersistedChecklist.self, from: data)
    }

    private func encode(_ value: PersistedChecklist) -> String? {
        guard let data = try? JSONEncoder().encode(value) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

private struct ChecklistRow: View {
    let text: String
    let isChecked: Bool

    private let fillGreen = Color(red: 0.72, green: 0.95, blue: 0.86)
    private let checkGreen = Color(red: 0.06, green: 0.30, blue: 0.26)

    var body: some View {
        HStack(alignment: .top, spacing: 12) {

            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(isChecked ? fillGreen : Color.white.opacity(0.16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.white.opacity(0.26), lineWidth: 1)
                    )
                    .frame(width: 26, height: 26)

                if isChecked {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .heavy))
                        .foregroundColor(checkGreen)
                }
            }
            .padding(.top, 1)

            Text(text)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(nil)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.10))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.14), lineWidth: 1)
                )
        )
        .shadow(radius: 8)
        .opacity(isChecked ? 0.92 : 1.0)
    }
}