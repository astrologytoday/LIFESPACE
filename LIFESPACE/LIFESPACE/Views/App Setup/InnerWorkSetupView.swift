import SwiftUI

struct InnerWorkSetupView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var userProfile: UserProfileModel
    @AppStorage("returnToConfirmation") private var returnToConfirmation: Bool = false

    @State private var showTitle = false
    @State private var showOptions = false
    @State private var showArrow = false
    @State private var selectedOptions: Set<String> = []

    // MARK: - Reactive options list
    var options: [String] {
        let baseOptions = [
            "Yoga", "Prayer", "Meditation", "Mirror Work", "To-Do Lists", "Psychotherapy",
            "Decluttering", "Journaling", "Breathwork", "Tarot", "Hypnotherapy", "Self-Care",
            "Sound Baths", "Nature Walks", "Shadow Work", "Singing", "Ancient Texts", "Fasting",
            "Aromatherapy", "Cold Shower", "Astrology", "Massage", "Candle Work", "Tai Chi",
            "Vision Board", "Sunbathing"
        ]

        let custom = userProfile.pendingCustomInnerWork ?? userProfile.customInnerWork
        if let custom = custom?.trimmingCharacters(in: .whitespacesAndNewlines), !custom.isEmpty {
            return baseOptions + [custom]
        } else {
            return baseOptions + ["Custom Inner Work"]
        }
    }

    var body: some View {
        ZStack {
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
                Text("Choose Your Inner Work")
                    .font(Font.custom("Avenir", size: 26).weight(.bold))
                    .foregroundColor(.white)
                    .padding(.top, 60)
                    .opacity(showTitle ? 1 : 0)
                    .animation(.easeInOut(duration: 1), value: showTitle)

                if showOptions {
                    ScrollView {
                        optionGrid
                    }
                    .transition(.opacity)
                }

                Spacer()
            }
            .padding(.horizontal)

            if showArrow {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            // Save only selected options, excluding the placeholder
                            let filtered = selectedOptions.filter { $0 != "Custom Inner Work" }
                            userProfile.innerWorkOptions = Array(filtered)

                            // Commit or clear custom inner work
                            if let pending = userProfile.pendingCustomInnerWork,
                               !pending.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                userProfile.customInnerWork = pending
                                userProfile.pendingCustomInnerWork = nil
                            } else {
                                if let existing = userProfile.customInnerWork,
                                   !filtered.contains(existing) {
                                    userProfile.customInnerWork = nil
                                }
                            }

                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                if returnToConfirmation {
                                    returnToConfirmation = false
                                    navModel.push("SetupConfirmationView")
                                } else {
                                    navModel.push("PurposeSetupView")
                                }
                            }
                        }) {
                            Image(systemName: "arrow.right.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.white)
                                .shadow(radius: 5)
                                .padding()
                        }
                        .opacity(showArrow ? 1 : 0)
                        .animation(.easeInOut(duration: 0.5), value: showArrow)
                    }
                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if !showOptions {
                withAnimation(.easeInOut(duration: 0.6)) {
                    showOptions = true
                    showArrow = true
                }
            }
        }
        .onAppear {
            withAnimation { showTitle = true }

            if returnToConfirmation {
                returnToConfirmation = false
            }

            if !userProfile.pendingInnerWorkSelections.isEmpty {
                selectedOptions = Set(userProfile.pendingInnerWorkSelections)
                userProfile.pendingInnerWorkSelections = []
            } else {
                selectedOptions = Set(userProfile.innerWorkOptions)
            }
        }
    }

    var optionGrid: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 90), spacing: 20)], spacing: 14) {
            ForEach(options, id: \.self) { option in
                CircleOption(title: option, isSelected: selectedOptions.contains(option)) {
                    toggleSelection(option)
                    if option == "Custom Inner Work" {
                        userProfile.pendingInnerWorkSelections = Array(selectedOptions)
                        navModel.push("CustomInnerWorkView")
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 100)
    }

    struct CircleOption: View {
        let title: String
        let isSelected: Bool
        let action: () -> Void

        var body: some View {
            Button(action: action) {
                Text(title)
                    .font(.system(size: fontSize(for: title), weight: .medium))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                    .frame(width: circleSize(for: title), height: circleSize(for: title))
                    .background(isSelected ? Color.white.opacity(0.3) : Color.white.opacity(0.15))
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(isSelected ? Color.white : Color.clear, lineWidth: 2)
                    )
            }
        }

        func fontSize(for title: String) -> CGFloat {
            switch title.count {
            case 0...6: return 16
            case 7...12: return 14
            default: return 12
            }
        }

        func circleSize(for title: String) -> CGFloat {
            switch title.count {
            case 0...6: return 90
            case 7...12: return 110
            default: return 130
            }
        }
    }

    func toggleSelection(_ option: String) {
        if selectedOptions.contains(option) {
            selectedOptions.remove(option)
        } else {
            selectedOptions.insert(option)
        }
    }
}

