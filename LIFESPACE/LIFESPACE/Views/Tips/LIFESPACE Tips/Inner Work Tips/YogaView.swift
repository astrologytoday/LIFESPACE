import SwiftUI

struct YogaView: View {
    @EnvironmentObject var navModel: NavigationModel

    @State private var contentOpacity: Double = 0.0
    @State private var glowPhase: Bool = false

    let meditationLinks: [(title: String, url: String)] = [
        ("Expand Your Magnetic Field", "https://www.youtube.com/watch?v=-nPDeMjXeBk&list=PLlw25IwAnDXjjJhMCeG4H7Ie_DlzqSg0u&index=10"),
        ("Yoga to Reduce Stress", "https://www.youtube.com/watch?v=ElO8z-FgCGg&list=PLlw25IwAnDXjjJhMCeG4H7Ie_DlzqSg0u&index=25"),
        ("Chakra Boost Meditation", "https://www.youtube.com/watch?v=tq06IZk3xBk"),
        ("Yoga for Before Bedtime", "https://www.youtube.com/watch?v=wJ_XUXqbblA")
    ]

    var body: some View {
        ZStack {
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

            // ✨ Subtle animated glow overlay
            RadialGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(0.18),
                    Color.white.opacity(0.00)
                ]),
                center: glowPhase ? .topLeading : .bottomTrailing,
                startRadius: 30,
                endRadius: 560
            )
            .ignoresSafeArea()
            .blendMode(.screen)
            .animation(.easeInOut(duration: 5.0).repeatForever(autoreverses: true), value: glowPhase)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {

                    Spacer(minLength: 20)

                    // ✅ Title restored (left alone)
                    Text("YOGA")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .white.opacity(0.28), radius: 10, x: 0, y: 0) // mystical glow
                        .shadow(color: .black.opacity(0.30), radius: 3, x: 0, y: 2)  // depth
                        .shadow(color: .white.opacity(0.7), radius: 10)              // your original title glow (optional)
                        .frame(maxWidth: .infinity, alignment: .center)

                    // What Yoga Is (fixes the big blank space)
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 10) {
                                Image(systemName: "figure.yoga")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.95))

                                Text("What Yoga Is")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                            }

                            Text("Yoga means \"union\" and points to the communion of the smaller self with the greater Divine Self and with God. It is a practice that harmonizes body, mind, and soul.")
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.95))
                                .fixedSize(horizontal: false, vertical: true)

                            AdaptiveChips(chips: [
                                ("Nervous system", "waveform.path.ecg"),
                                ("Breath + focus", "lungs.fill"),
                                ("Spiritual awareness", "sparkles")
                            ])
                            .padding(.top, 2)
                        }
                    }
                    .padding(.horizontal)

                    // ✅ Benefits card now expands full-width (no shrinking)
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 10) {
                                Image(systemName: "checkmark.seal.fill")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.95))
                                Text("The Benefits of Yoga")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                            }

                            IconBullet(text: "Enhances flexibility and strength", systemName: "figure.strengthtraining.traditional")
                            IconBullet(text: "Improves mental clarity and focus", systemName: "brain.head.profile")
                            IconBullet(text: "Balances the nervous system", systemName: "waveform.path.ecg")
                            IconBullet(text: "Reduces stress through conscious breath", systemName: "lungs.fill")
                            IconBullet(text: "Awakens spiritual awareness", systemName: "sparkles")
                        }
                    }
                    .padding(.horizontal)

                    // Two-up mini cards
                    HStack(spacing: 12) {
                        MiniCard(
                            title: "Practice Flow",
                            icon: "arrow.triangle.2.circlepath",
                            lines: ["Posture", "Breath", "Awareness", "Integration"]
                        )

                        MiniCard(
                            title: "Aim",
                            icon: "target",
                            lines: ["Alignment", "Stillness", "Presence", "Union"]
                        )
                    }
                    .padding(.horizontal)

                    // Yogic Breathing
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 10) {
                                Image(systemName: "lungs.fill")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.95))
                                Text("Yogic Breathing")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                            }

                            Text("The ultimate goal is the alignment of the entire being with the soul, transcending mere physical practice. One of the names of God is \"Eheieh,\" a name often likened to the sacred rhythm of breath, the inhale and exhale of the divine.")
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.95))
                                .fixedSize(horizontal: false, vertical: true)

                            QuoteCard(text: "Breath is the bridge between body and spirit. Inhalation brings prana, the vital life force, while exhalation releases tension and ego.")
                        }
                    }
                    .padding(.horizontal)

                    // Kundalini
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 10) {
                                Image(systemName: "bolt.heart.fill")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.95))
                                Text("Kundalini Energy")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                            }

                            Text("Kundalini is the coiled energy at the base of the spine. When awakened through yoga, breath, and mantra, it rises through the chakras, leading to expanded awareness and enhanced intuition.")
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.95))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .padding(.horizontal)

                    // ✅ Power of AUM centered + full width
                    GlassCard {
                        VStack(alignment: .center, spacing: 12) {
                            HStack(spacing: 10) {
                                Image(systemName: "waveform")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.95))
                                Text("The Power of AUM (ॐ)")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity, alignment: .center)

                            Text("AUM is the primordial sound of the universe. Chanting it during yoga practice activates vibration throughout the body, calming the mind and reconnecting with the Source.")
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.95))
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)

                            HStack(spacing: 10) {
                                Pill(tag: "A")
                                Pill(tag: "U")
                                Pill(tag: "M")
                                Pill(tag: "Silence")
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 2)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(.horizontal)

                    // ✅ Center this heading
                    Text("🧘 Try These Yoga Meditations")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                        .padding(.top, 8)
                        .padding(.horizontal)

                    // Links
                    VStack(spacing: 12) {
                        ForEach(meditationLinks, id: \.url) { item in
                            Link(destination: URL(string: item.url)!) {
                                HStack(spacing: 12) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.white.opacity(0.14))
                                            .frame(width: 44, height: 44)
                                            .overlay(
                                                Circle().stroke(Color.white.opacity(0.18), lineWidth: 1)
                                            )

                                        Image(systemName: "play.fill")
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(.white.opacity(0.95))
                                            .offset(x: 1)
                                    }

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(item.title)
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.white)

                                        Text("Tap to open video")
                                            .font(.system(size: 13, weight: .medium))
                                            .foregroundColor(.white.opacity(0.75))
                                    }

                                    Spacer()

                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white.opacity(0.70))
                                }
                                .padding(14)
                                .frame(maxWidth: .infinity)
                                .background(Color.white.opacity(0.14))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.white.opacity(0.18), lineWidth: 1)
                                )
                                .cornerRadius(16)
                                .shadow(color: Color.black.opacity(0.10), radius: 10, x: 0, y: 6)
                                .padding(.horizontal)
                            }
                        }
                    }

                    // ✅ Keep your back button at the bottom
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                navModel.pop()
                            }
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 28, weight: .medium))
                                .foregroundColor(.white)
                                .padding(24)
                                .background(Color.white.opacity(0.2))
                                .clipShape(Circle())
                                .shadow(radius: 8)
                        }
                        Spacer()
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 30)
                }
                .opacity(contentOpacity)
                .onAppear {
                    glowPhase = true
                    withAnimation(.easeInOut(duration: 0.6)) {
                        contentOpacity = 1.0
                    }
                }
            }
        }
    }
}

// MARK: - UI Pieces

private struct GlassCard<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) { self.content = content() }

    var body: some View {
        content
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading) // ✅ makes cards fill available width
            .background(Color.white.opacity(0.14))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.white.opacity(0.18), lineWidth: 1)
            )
            .cornerRadius(18)
            .shadow(color: Color.black.opacity(0.10), radius: 12, x: 0, y: 8)
    }
}

private struct IconBullet: View {
    let text: String
    let systemName: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: systemName)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white.opacity(0.92))
                .frame(width: 22)
                .padding(.top, 1)

            Text(text)
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.95))
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

private struct QuoteCard: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "quote.opening")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white.opacity(0.85))

            Text(text)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.white.opacity(0.92))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.10))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.white.opacity(0.16), lineWidth: 1)
        )
        .cornerRadius(14)
    }
}

private struct MiniCard: View {
    let title: String
    let icon: String
    let lines: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white.opacity(0.95))
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 6) {
                ForEach(lines, id: \.self) { line in
                    HStack(spacing: 8) {
                        Circle()
                            .fill(Color.white.opacity(0.85))
                            .frame(width: 5, height: 5)
                        Text(line)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.92))
                    }
                }
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.14))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.18), lineWidth: 1)
        )
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.10), radius: 10, x: 0, y: 6)
    }
}

private struct AdaptiveChips: View {
    let chips: [(String, String)]
    private let cols = [GridItem(.adaptive(minimum: 140), spacing: 10, alignment: .leading)]

    var body: some View {
        LazyVGrid(columns: cols, alignment: .leading, spacing: 10) {
            ForEach(chips.indices, id: \.self) { idx in
                let chip = chips[idx]
                HStack(spacing: 8) {
                    Image(systemName: chip.1)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white.opacity(0.90))
                    Text(chip.0)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white.opacity(0.95))
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(Color.white.opacity(0.12))
                .overlay(
                    Capsule().stroke(Color.white.opacity(0.16), lineWidth: 1)
                )
                .cornerRadius(999)
            }
        }
    }
}

private struct Pill: View {
    let tag: String

    var body: some View {
        Text(tag)
            .font(.system(size: 13, weight: .bold))
            .foregroundColor(.white.opacity(0.95))
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(Color.white.opacity(0.12))
            .overlay(Capsule().stroke(Color.white.opacity(0.16), lineWidth: 1))
            .cornerRadius(999)
    }
}
