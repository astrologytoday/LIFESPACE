import SwiftUI

struct TipsView: View {
    @EnvironmentObject var navModel: NavigationModel

    @State private var pulse = false
    @State private var showContent = false
    @State private var selectedTab = 0

    // 🔍 SEARCH STATE
    @State private var searchText = ""
    @State private var showSuggestions = false

    private let tealGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 0.35, green: 0.80, blue: 0.75),
            Color(red: 0.20, green: 0.65, blue: 0.60),
            Color(red: 0.10, green: 0.45, blue: 0.45)
        ]),
        startPoint: .top,
        endPoint: .bottom
    )

    let modules: [(title: String, screen: String, icon: String)] = [
        ("Light",        "LightTipsView",       "sun.max.fill"),
        ("Inner Work",   "InnerWorkTipsView",   "brain.head.profile"),
        ("Fitness",      "FitnessTipsView",     "figure.run"),
        ("Eating",       "EatingTipsView",      "fork.knife"),
        ("Sensory",      "SensoryTipsView",     "eye.fill"),
        ("Purpose",      "PurposeTipsView",     "target"),
        ("Activity",     "ActivityTipsView",    "gamecontroller.fill"),
        ("Community",    "CommunityTipsView",   "person.3.fill"),
        ("Expression",   "ExpressionTipsView",  "paintbrush.fill")
    ]

    let disorders = [
        ("Anxiety",     "AnxietyTipsView",     "cloud.rain.fill"),
        ("Depression",  "DepressionTipsView",  "cloud.fog.fill"),
        ("ADHD",        "ADHDTipsView",        "bolt.fill"),
        ("Autism",      "AutismTipsView",      "puzzlepiece.fill"),
        ("BPD",         "BPDTipsView",         "heart.text.square.fill"),
        ("Psychosis",   "PsychosisTipsView",   "moon.stars.fill"),
        ("PSSD",        "PSSDTipsView",        "pills.fill"),
        ("C-PTSD",      "CPTSDTipsView",       "shield.lefthalf.filled")
    ]

    // 🔎 FILTERED SEARCH RESULTS
    private var filteredResults: [SearchItem] {
        guard !searchText.isEmpty else { return [] }
        let query = searchText.lowercased()

        return SearchIndex.items.filter {
            $0.title.lowercased().contains(query) ||
            $0.keywords.contains(where: { $0.lowercased().contains(query) })
        }
    }

    var body: some View {
        ZStack {
            tealGradient.ignoresSafeArea()

            VStack(spacing: 0) {

                // HEADER
                VStack(spacing: 20) {
                    Text("LIFESPACE Tips")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(radius: 8)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : -30)
                        .animation(.easeOut(duration: 0.5), value: showContent)

                    Picker("Section", selection: $selectedTab) {
                        Text("Modules").tag(0)
                        Text("Disorders").tag(1)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 40)
                }
                .padding(.top, 50)

                Group {
                    if selectedTab == 0 {
                        modulesTab
                    } else {
                        disordersTab
                    }
                }
                .animation(.easeInOut(duration: 0.25), value: selectedTab)

                Spacer()
                bottomDock.padding(.bottom, 20)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2)) { showContent = true }
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) { pulse = true }
        }
    }

    // -------------------------------------------------------------------------
    // MARK: MODULES TAB
    // -------------------------------------------------------------------------

    private var modulesTab: some View {
        VStack {
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 3),
                spacing: 22
            ) {
                ForEach(modules, id: \.title) { module in
                    Button {
                        HapticFeedback.play()
                        navModel.push(module.screen)
                    } label: {
                        VStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(
                                        RadialGradient(
                                            colors: [.white.opacity(0.30), .clear],
                                            center: .center,
                                            startRadius: 8,
                                            endRadius: 45
                                        )
                                    )
                                    .frame(width: 90, height: 90)

                                Image(systemName: module.icon)
                                    .font(.system(size: 46))
                                    .foregroundColor(.white)
                            }
                            .offset(y: -6)
                            .scaleEffect(pulse ? 1.10 : 0.95)

                            Text(module.title)
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white.opacity(0.95))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 145)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 18)
            .padding(.top, 20)
        }
    }

    // -------------------------------------------------------------------------
    // MARK: DISORDERS TAB + SEARCH
    // -------------------------------------------------------------------------

    private var disordersTab: some View {
        VStack(spacing: 12) {

            // SEARCH BAR
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white.opacity(0.7))

                TextField("Search tips, symptoms, or resets…", text: $searchText)
                    .foregroundColor(.white)
                    .onChange(of: searchText) { _ in
                        showSuggestions = !searchText.isEmpty
                    }

                Spacer()
            }
            .padding()
            .background(Color.white.opacity(0.15))
            .cornerRadius(16)
            .padding(.horizontal, 28)

            // 🔽 SEARCH DROPDOWN
            if showSuggestions && !filteredResults.isEmpty {
                VStack(spacing: 0) {
                    ForEach(Array(filteredResults.prefix(6).enumerated()), id: \.element.id) { index, item in
                        VStack(spacing: 0) {
                            Button {
                                HapticFeedback.play()
                                searchText = ""
                                showSuggestions = false
                                navModel.push(item.screen)
                            } label: {
                                HStack {
                                    Text(item.title)
                                        .foregroundColor(.white)
                                        .padding(.vertical, 12)
                                    Spacer()
                                }
                                .padding(.horizontal)
                            }
                            .background(Color.white.opacity(0.18))

                            // 🔹 Subtle separator (not after last item)
                            if index < filteredResults.prefix(6).count - 1 {
                                Rectangle()
                                    .fill(Color.white.opacity(0.12))
                                    .frame(height: 0.6)
                                    .padding(.horizontal, 12)
                            }
                        }
                    }
                }
                .cornerRadius(14)
                .padding(.horizontal, 28)
                .transition(.opacity)
            }

            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 18)], spacing: 18) {
                    ForEach(disorders, id: \.0) { disorder in
                        Button {
                            HapticFeedback.play()
                            navModel.push(disorder.1)
                        } label: {
                            VStack(spacing: 12) {
                                Image(systemName: disorder.2)
                                    .font(.system(size: 36))
                                    .foregroundColor(.white)

                                Text(disorder.0)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            .frame(height: 120)
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.18))
                            .cornerRadius(20)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 10)
            }
        }
    }

    // -------------------------------------------------------------------------
    // MARK: BOTTOM DOCK
    // -------------------------------------------------------------------------

    private var bottomDock: some View {
        HStack(spacing: 50) {

            Button {
                HapticFeedback.play()
                navModel.selectedScreen = "ResultsView"
            } label: {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.35))
                        .frame(width: 75, height: 75)
                        .blur(radius: 18)

                    Image(systemName: "chevron.left")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .buttonStyle(.plain)

            Button {
                HapticFeedback.play()
                navModel.push("PyramidView")
            } label: {
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Color.cyan.opacity(0.9), Color.teal.opacity(0.6)],
                                center: .center,
                                startRadius: 12,
                                endRadius: 90
                            )
                        )
                        .frame(width: 140, height: 140)
                        .blur(radius: 28)

                    Image("maslow_pyramid")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120)
                }
                .scaleEffect(pulse ? 1.07 : 0.97)
            }
            .buttonStyle(.plain)
        }
    }
}

struct HapticFeedback {
    static func play() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
}

struct TipsView_Previews: PreviewProvider {
    static var previews: some View {
        TipsView().environmentObject(NavigationModel())
    }
}
