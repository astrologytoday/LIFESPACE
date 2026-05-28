import SwiftUI

struct InnerWorkTipsView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var appeared = false

    private let options: [String] = [
        "Yoga", "Prayer", "Mirror Work",
        "Journaling", "Breathwork",
        "Sound Baths", "Nature Walks", "Shadow Work", "Singing",
        "Fasting", "Aromatherapy", "Cold Shower",
        "Astrology", "Candle Work", "Tai Chi"
    ]

    private let destinations: [String: String] = [
        "Yoga": "YogaView",
        "Prayer": "PrayerView",
        "Mirror Work": "MirrorWorkView",
        "Journaling": "DreamJournalView",
        "Breathwork": "BreathworkView",
        "Sound Baths": "SoundBathView",
        "Nature Walks": "NatureWalkView",
        "Shadow Work": "ShadowWorkView",
        "Singing": "SingingView",
        "Fasting": "FastingView",
        "Aromatherapy": "AromatherapyView",
        "Cold Shower": "ColdShowerView",
        "Astrology": "AstrologyView",
        "Candle Work": "CandleWorkView",
        "Tai Chi": "TaiChiView"
    ]

    var body: some View {
        GeometryReader { geometry in
            let safeBottom = geometry.safeAreaInsets.bottom
            let bottomPadding = max(24, safeBottom + 12)

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

                VStack(spacing: 20) {
                    header
                    scrollContainer
                    bottomButtons(bottomPadding: bottomPadding)
                }
            }
            .onAppear { appeared = true }
            .transition(.opacity)
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .center, spacing: 10) {
            Text("Inner Work Tips")
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.white)
                .shadow(radius: 4)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)

            Text("To raise your vibrational energy\nand enrich your soul")
                .font(.title2)
                .italic()
                .multilineTextAlignment(.center)
                .foregroundColor(Color.white.opacity(0.95))
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 14)
        .padding(.top, 18)
        .opacity(appeared ? 1 : 0)
        .animation(.easeInOut(duration: 0.6), value: appeared)
    }

    // MARK: - Scroll Container

    private var scrollContainer: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 90), spacing: 20)], spacing: 14) {
                ForEach(options, id: \.self) { option in
                    CircleOption(title: option) {
                        openTip(for: option)
                    }
                }
            }
            .padding(18)
            .padding(.bottom, 10)
            .opacity(appeared ? 1 : 0)
            .animation(.easeInOut(duration: 0.6), value: appeared)
        }
        .background(Color.white.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
        .padding(.horizontal)
        .padding(.bottom, 6)
    }

    // MARK: - Bottom Buttons

    private func bottomButtons(bottomPadding: CGFloat) -> some View {
        HStack(spacing: 40) {
            Button {
                withAnimation(.easeInOut(duration: 0.4)) {
                    navModel.selectedScreen = "TipsView"
                }
            } label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
                    .shadow(radius: 4)
            }

            Button {
                withAnimation(.easeInOut(duration: 0.4)) {
                    navModel.selectedScreen = "HomeView"
                }
            } label: {
                Image(systemName: "house.fill")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
                    .shadow(radius: 4)
            }
        }
        .padding(.bottom, bottomPadding)
    }

    // MARK: - Navigation

    private func openTip(for option: String) {
        guard let destination = destinations[option] else { return }
        withAnimation(.easeInOut(duration: 0.4)) {
            navModel.push(destination)
        }
    }

    // MARK: - Bubble

    private struct CircleOption: View {
        let title: String
        let action: () -> Void

        var body: some View {
            Button(action: action) {
                Text(title)
                    .font(.system(size: fontSize(for: title), weight: .medium))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.6)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 8)
                    .frame(width: circleSize(for: title), height: circleSize(for: title))
                    .background(Color.white.opacity(0.15))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }

        private func fontSize(for title: String) -> CGFloat {
            switch title.count {
            case 0...6: return 16
            case 7...12: return 14
            default: return 12
            }
        }

        private func circleSize(for title: String) -> CGFloat {
            switch title.count {
            case 0...6: return 90
            case 7...12: return 110
            default: return 130
            }
        }
    }
}
