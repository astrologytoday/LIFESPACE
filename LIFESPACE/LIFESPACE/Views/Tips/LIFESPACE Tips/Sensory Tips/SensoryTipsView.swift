import SwiftUI

struct SensoryTipsView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var lifespaceLogModel: LifespaceLogModel

    @State private var appeared = false

    // Persist all number-dot values as JSON so they restore when user comes back
    @AppStorage("sensoryAssessmentValuesJSON") private var sensoryJSON: String = "{}"
    @State private var values: [String: Double] = [:]

    // ✅ Replace-on-resubmit (prevents stacking)
    @AppStorage("sensoryAssessment_logEntryID") private var sensoryAssessmentLogEntryID: String = ""

    // ✅ Persist last submission display
    @AppStorage("sensoryAssessment_lastLoggedQuestions") private var lastLoggedQuestionsStored: Int = 0
    @AppStorage("sensoryAssessment_lastYes") private var lastYesStored: Int = 0

    @State private var showResultCard: Bool = false
    @State private var lastLoggedQuestions: Int = 0
    @State private var lastYes: Int = 0
    @State private var lastNeutralMessage: String = ""

    // 15 question keys
    private let assessmentKeys: [String] = [
        // SIGHT
        "sight_decor",
        "sight_appearance",
        "sight_fengshui",
        "sight_messy",
        "sight_lighting",

        // SOUND
        "sound_pollution",
        "sound_music",
        "sound_silence",

        // TOUCH
        "touch_furniture",
        "touch_clothes",
        "touch_clean",
        "touch_temp",

        // SMELL
        "smell_freshair",
        "smell_scent",
        "smell_teeth"
    ]

    var body: some View {
        GeometryReader { geometry in
            let safeBottom = geometry.safeAreaInsets.bottom
            let homeBottomPadding = max(22, safeBottom + 12)

            ZStack(alignment: .topLeading) {

                // 🌊 LIFESPACE gradient background
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
                    VStack(alignment: .leading, spacing: 20) {

                        // 🧠 Header
                        Text("Sensory Tips")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(radius: 4)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)

                        Text("To improve the efficiency of your environment")
                            .font(.title3)
                            .italic()
                            .foregroundColor(Color.white.opacity(0.95))
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)

                        // 📘 Dictionary
                        DictionaryCard(
                            headword: "Sensory Health",
                            partOfSpeech: "noun",
                            definition: "1: the quality of your direct sensory experience: what you see, hear, feel, and smell throughout the day."
                        )

                        // ✅ Assessment Title
                        assessmentHeader()

                        // 👁️ SIGHT
                        assessmentSection(title: "SIGHT") {
                            numberQuestion(key: "sight_decor", text: "Is your home decor to your liking?")
                            numberQuestion(key: "sight_appearance", text: "Do you like how you look?")
                            fengShuiLinkedNumberQuestion(
                                key: "sight_fengshui",
                                prefix: "Does your home follow the laws of ",
                                linkText: "Feng Shui",
                                suffix: "?"
                            )
                            numberQuestion(key: "sight_messy", text: "Is your home clean? Are your dishes washed?")
                            numberQuestion(key: "sight_lighting", text: "Is your lighting warm or does it feel sterile?")
                        }

                        // 👂 SOUND
                        assessmentSection(title: "SOUND") {
                            numberQuestion(key: "sound_pollution", text: "Is your space free from noise pollution?")
                            numberQuestion(key: "sound_music", text: "Do you listen to music?")
                            numberQuestion(key: "sound_silence", text: "Do you have access to silence if you need it?")
                        }

                        // ✋ TOUCH
                        assessmentSection(title: "TOUCH") {
                            numberQuestion(key: "touch_furniture", text: "Is your furniture comfortable and ergonomic?")
                            numberQuestion(key: "touch_clothes", text: "Are your clothes comfortable?")
                            numberQuestion(key: "touch_clean", text: "Are you clean and showered?")
                            numberQuestion(key: "touch_temp", text: "Is your temperature regulated?")
                        }

                        // 👃 SMELL
                        assessmentSection(title: "SMELL") {
                            numberQuestion(key: "smell_freshair", text: "Does your space get fresh air?")
                            numberQuestion(key: "smell_scent", text: "Does your space have a good scent?")
                            numberQuestion(key: "smell_teeth", text: "How does your breath smell?")
                        }

                        // ✅ Submit Button
                        Button(action: submitAssessment) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .fill(Color.white.opacity(0.18))
                                    .shadow(color: .black.opacity(0.18), radius: 10, x: 0, y: 8)

                                Text("SUBMIT ASSESSMENT")
                                    .font(.system(size: 18, weight: .heavy))
                                    .foregroundColor(.white)
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.75)
                                    .multilineTextAlignment(.center)
                                    .padding(.vertical, 16)
                                    .padding(.horizontal, 12)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .padding(.top, 8)

                        // ✅ Result Card
                        if showResultCard {
                            resultCard()
                                .transition(.opacity)
                                .padding(.top, 10)
                        }

                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 40)
                    .padding(.bottom, 160 + homeBottomPadding)
                    .opacity(appeared ? 1 : 0)
                    .animation(.easeInOut(duration: 0.6), value: appeared)
                }

                VStack {
                    HStack {
                        Spacer()
                        BackButtonView(customTarget: "TipsView")
                    }
                    Spacer()
                }
                .padding(.top, 12)
                .padding(.trailing, 22)

                // 🏠 Home Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            navModel.push("HomeView")
                        }) {
                            ZStack {
                                Circle()
                                    .fill(LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.white.opacity(0.9),
                                            Color.white.opacity(0.6)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ))
                                    .frame(width: 60, height: 60)
                                    .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 6)

                                Image(systemName: "house.fill")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(Color(red: 0.10, green: 0.45, blue: 0.45))
                            }
                        }
                        .padding(.trailing, 22)
                        .padding(.bottom, homeBottomPadding)
                    }
                }
            }
            .onAppear {
                appeared = true
                loadValues()

                lastLoggedQuestions = lastLoggedQuestionsStored
                lastYes = lastYesStored

                showResultCard = (!sensoryAssessmentLogEntryID.isEmpty) || (lastLoggedQuestionsStored > 0)
            }
            .transition(.opacity)
        }
    }

    // MARK: - Header

    private func assessmentHeader() -> some View {
        VStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color.white.opacity(0.10))
                    .shadow(color: .black.opacity(0.18), radius: 10, x: 0, y: 8)

                VStack(spacing: 8) {
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white.opacity(0.95))
                            .padding(.top, 5)

                        Text("Sensory Assessment")
                            .font(.system(size: 28, weight: .heavy))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .minimumScaleFactor(0.75)
                            .fixedSize(horizontal: false, vertical: true)
                            .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 4)

                        Image(systemName: "sparkles")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white.opacity(0.95))
                            .padding(.top, 5)
                    }

                    Text("Tap a number from 1–10 for each area.")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.vertical, 14)
                .padding(.horizontal, 18)
            }
        }
        .padding(.top, 6)
        .frame(maxWidth: .infinity)
    }

    // MARK: - Result Card

    private func resultCard() -> some View {
        let percent: Int = {
            guard lastLoggedQuestions > 0 else { return 0 }
            return Int(((Double(lastYes) / Double(lastLoggedQuestions)) * 100.0).rounded())
        }()

        return ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white.opacity(0.14))
                .overlay(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .stroke(Color.white.opacity(0.14), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.18), radius: 12, x: 0, y: 10)

            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top) {
                    Text("Assessment Result")
                        .font(.system(size: 28, weight: .heavy))
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .minimumScaleFactor(0.75)
                        .fixedSize(horizontal: false, vertical: true)

                    Spacer()

                    if lastLoggedQuestions > 0 {
                        Text("\(percent)%")
                            .font(.system(size: 28, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.75)
                            .shadow(color: Color.white.opacity(0.95), radius: 10, x: 0, y: 0)
                            .shadow(color: Color.white.opacity(0.55), radius: 22, x: 0, y: 0)
                    }
                }

                if lastLoggedQuestions == 0 {
                    Text(lastNeutralMessage.isEmpty ? "Nothing was logged yet." : lastNeutralMessage)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white.opacity(0.9))
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                } else {
                    Text("\(lastYes) out of \(lastLoggedQuestions) logged sensory areas scored 7 or higher.")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white.opacity(0.9))
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(18)
        }
    }

    // MARK: - Submit Logic

    private func submitAssessment() {
        lastNeutralMessage = ""

        var loggedQuestions = 0
        var yesCount = 0

        for key in assessmentKeys {
            let v = Int(values[key] ?? 5)

            if v >= 7 {
                loggedQuestions += 1
                yesCount += 1
            } else if v <= 4 {
                loggedQuestions += 1
            } else {
                // 5–6 ignored
            }
        }

        // Remove the previous assessment entry so re-submits replace instead of stack
        if let oldUUID = UUID(uuidString: sensoryAssessmentLogEntryID),
           let idx = lifespaceLogModel.entries.firstIndex(where: { $0.id == oldUUID }) {
            lifespaceLogModel.entries.remove(at: idx)
        }

        // If nothing qualifies, don’t log anything
        if loggedQuestions == 0 {
            sensoryAssessmentLogEntryID = ""
            lastLoggedQuestions = 0
            lastYes = 0
            lastLoggedQuestionsStored = 0
            lastYesStored = 0
            lastNeutralMessage = "Nothing was logged because all answers were 5–6."

            withAnimation(.easeInOut(duration: 0.35)) {
                showResultCard = true
            }
            return
        }

        let entry = LifespaceLogEntry(
            type: .lifestyleSurvey,
            module: .sensory,
            questionCount: loggedQuestions,
            yesCount: yesCount
        )

        lifespaceLogModel.addEntry(entry)
        sensoryAssessmentLogEntryID = entry.id.uuidString

        lastLoggedQuestions = loggedQuestions
        lastYes = yesCount
        lastLoggedQuestionsStored = loggedQuestions
        lastYesStored = yesCount

        withAnimation(.easeInOut(duration: 0.35)) {
            showResultCard = true
        }
    }

    // MARK: - Section Wrapper

    private func assessmentSection(title: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .font(.system(size: 20, weight: .heavy))
                .foregroundColor(.white)
                .padding(.top, 6)

            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.white.opacity(0.14))

                VStack(alignment: .leading, spacing: 18) {
                    content()
                }
                .padding(18)
            }
        }
    }

    // MARK: - Number Question

    private func numberQuestion(key: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(text)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)

            numberDotGrid(for: key)
        }
    }

    // MARK: - Feng Shui linked question

    private func fengShuiLinkedNumberQuestion(key: String, prefix: String, linkText: String, suffix: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {

            Text(fengShuiAttributed(prefix: prefix, linkText: linkText, suffix: suffix))
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .environment(\.openURL, OpenURLAction { url in
                    if url.scheme == "lifespace", url.host == "fengshui" {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            navModel.push("FengShuiView")
                        }
                        return .handled
                    }
                    return .systemAction
                })

            numberDotGrid(for: key)
        }
    }

    private func numberDotGrid(for key: String) -> some View {
        let selectedValue = Int(values[key] ?? 5)

        let columns: [GridItem] = Array(
            repeating: GridItem(.flexible(), spacing: 8),
            count: 5
        )

        return LazyVGrid(columns: columns, spacing: 10) {
            ForEach(1...10, id: \.self) { number in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.18)) {
                        values[key] = Double(number)
                        saveValues()
                    }
                }) {
                    ZStack {
                        Circle()
                            .fill(
                                selectedValue == number
                                ? Color.white.opacity(0.92)
                                : Color.white.opacity(0.14)
                            )
                            .frame(width: 38, height: 38)
                            .overlay(
                                Circle()
                                    .stroke(
                                        selectedValue == number
                                        ? Color.white.opacity(1.0)
                                        : Color.white.opacity(0.28),
                                        lineWidth: selectedValue == number ? 2 : 1
                                    )
                            )
                            .shadow(
                                color: selectedValue == number ? Color.white.opacity(0.75) : Color.clear,
                                radius: selectedValue == number ? 10 : 0,
                                x: 0,
                                y: 0
                            )

                        Text("\(number)")
                            .font(.system(size: 15, weight: .heavy, design: .rounded))
                            .foregroundColor(
                                selectedValue == number
                                ? Color(red: 0.10, green: 0.45, blue: 0.45)
                                : Color.white.opacity(0.95)
                            )
                    }
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Rate \(number) out of 10")
            }
        }
        .padding(.top, 2)
    }

    private func fengShuiAttributed(prefix: String, linkText: String, suffix: String) -> AttributedString {
        var full = AttributedString(prefix + linkText + suffix)

        if let range = full.range(of: linkText) {
            full[range].link = URL(string: "lifespace://fengshui")
            full[range].underlineStyle = .single
            full[range].foregroundColor = .white
        }

        return full
    }

    // MARK: - Persistence

    private func loadValues() {
        guard let data = sensoryJSON.data(using: .utf8),
              let decoded = try? JSONDecoder().decode([String: Double].self, from: data) else {
            values = [:]
            return
        }

        values = decoded
    }

    private func saveValues() {
        guard let data = try? JSONEncoder().encode(values),
              let json = String(data: data, encoding: .utf8) else { return }

        sensoryJSON = json
    }
}

// MARK: - Dictionary Card

private struct DictionaryCard: View {
    let headword: String
    let partOfSpeech: String
    let definition: String

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.12))
                .blur(radius: 16)

            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.18))
                .overlay(
                    HStack(spacing: 0) {
                        Rectangle()
                            .fill(Color.white.opacity(0.55))
                            .frame(width: 3)
                            .padding(.vertical, 18)
                            .padding(.leading, 16)
                        Spacer()
                    }
                )
                .shadow(color: .black.opacity(0.18), radius: 12, x: 0, y: 8)

            VStack(alignment: .leading, spacing: 8) {
                Text(headword)
                    .font(.system(size: 28, weight: .semibold, design: .serif))
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                    .fixedSize(horizontal: false, vertical: true)

                Text(partOfSpeech)
                    .font(.system(size: 16, weight: .semibold, design: .serif))
                    .foregroundColor(Color.white.opacity(0.85))
                    .textCase(.lowercase)
                    .padding(.bottom, 6)

                Text(definition)
                    .font(.system(size: 18, weight: .regular, design: .serif))
                    .foregroundColor(Color.white.opacity(0.95))
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 26)
        }
    }
}
