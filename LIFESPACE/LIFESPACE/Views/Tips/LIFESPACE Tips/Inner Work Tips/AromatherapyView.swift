import SwiftUI

struct AromatherapyView: View {
    @EnvironmentObject var navModel: NavigationModel

    @State private var contentOpacity: Double = 0.0
    @State private var glowPhase: Bool = false
    @State private var breathe: Bool = false

    var body: some View {
        ZStack {
            // Background Gradient
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

            // Subtle animated glow
            RadialGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(0.14),
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
                VStack(alignment: .leading, spacing: 18) {
                    Spacer(minLength: 20)

                    // Title
                    Text("AROMATHERAPY")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .white.opacity(0.28), radius: 10, x: 0, y: 0)
                        .shadow(color: .black.opacity(0.30), radius: 3, x: 0, y: 2)
                        .shadow(color: .white.opacity(0.7), radius: 10)
                        .frame(maxWidth: .infinity, alignment: .center)

                    AromatherapyTimelineSection(title: "What Aromatherapy Is", icon: "leaf.fill") {
                        Text("Aromatherapy uses natural scents (essential oils, resins, herbs, and incense) to influence your mood, nervous system, and sense of wellbeing. Because smell is processed quickly by the brain, it can shift your state fast.")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.95))
                            .fixedSize(horizontal: false, vertical: true)

                        Text("Think of it like an atmosphere upgrade. A few minutes of the right scent can support calm, focus, sleep, or a more grounded emotional tone.")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.95))
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.top, 6)

                        HStack(spacing: 10) {
                            AromatherapyTagPill(text: "Calm", icon: "moon.stars.fill")
                            AromatherapyTagPill(text: "Clarity", icon: "scope")
                            AromatherapyTagPill(text: "Sleep", icon: "bed.double.fill")
                        }
                        .padding(.top, 6)
                    }

                    AromatherapyTimelineSection(title: "Science of Scent", icon: "brain.head.profile") {
                        AromatherapyBulletRow(text: "Smell signals travel quickly to emotion + memory centers")
                        AromatherapyBulletRow(text: "Scent can shift arousal (calming or energizing)")
                        AromatherapyBulletRow(text: "Breathing + scent pairing can strengthen relaxation cues")
                        AromatherapyBulletRow(text: "Ritual + repetition trains the body to settle faster")
                    }

                    // ✅ No line + no top/bottom dots for this section
                    AromatherapyTimelineSection(title: "Try These Methods", icon: "sparkles", showTimeline: false) {
                        VStack(spacing: 12) {
                            AromatherapyTechniqueRow(
                                title: "Diffuser",
                                pattern: "15–45 min",
                                description: "Add water + a few essential oil drops and run it while you work, wind down, or meditate. Keep the room ventilated and start small."
                            )

                            AromatherapyTechniqueRow(
                                title: "Steam Inhalation",
                                pattern: "3–5 min",
                                description: "Add 1–2 drops of essential oils to hot water, lean over the bowl, and breathe gently."
                            )

                            AromatherapyTechniqueRow(
                                title: "Aromatic Bath",
                                pattern: "10–20 min",
                                description: "Mix essential oils into a carrier oil (e.g. jojoba or coconut), then add to bath and soak. Great for a full-body relaxation reset."
                            )

                            AromatherapyTechniqueRow(
                                title: "Incense",
                                pattern: "5–30 min",
                                description: "Use high-quality incense for an instant mood shift. Good for calm, focus, or ritual."
                            )

                            AromatherapyTechniqueRow(
                                title: "Dhoop Cones",
                                pattern: "5–20 min",
                                description: "A deeper, smokier option often used in spiritual practices."
                            )

                            AromatherapyTechniqueRow(
                                title: "Pulse-Point Roll-On",
                                pattern: "On-the-go",
                                description: "A pre-diluted roll-on on wrists or neck can be a quick grounding cue. Avoid eyes and sensitive skin."
                            )
                        }
                        .padding(.top, 4)
                    }

                    // ✅ Remove left-side headline dot + remove boxed list items
                    AromatherapyTimelineSection(title: "Safety Basics", icon: "checkmark.shield.fill", isLast: true, showTimeline: false) {
                        VStack(alignment: .leading, spacing: 14) {
                            AromatherapySafetyBullet(
                                title: "Dilute first",
                                detail: "Use a carrier oil for skin application. Undiluted oils can irritate or burn."
                            )

                            AromatherapySafetyBullet(
                                title: "Start small",
                                detail: "A little goes a long way. Too much scent can feel overstimulating fast."
                            )

                            AromatherapySafetyBullet(
                                title: "Ventilation matters",
                                detail: "Especially with incense or dhoop. Keep airflow moving and avoid heavy smoke."
                            )

                            AromatherapySafetyBullet(
                                title: "Respect sensitivities",
                                detail: "Be cautious with asthma, migraines, pregnancy, or strong fragrance reactions."
                            )

                            AromatherapySafetyBullet(
                                title: "Pets + kids",
                                detail: "Store safely and be mindful that some oils are unsafe for animals even at low exposure."
                            )

                            AromatherapySafetyBullet(
                                title: "No ingestion",
                                detail: "Do not ingest oils unless directed by a qualified professional."
                            )
                        }
                        .padding(.top, 2)
                    }

                    // FastingView-style back button
                    VStack(spacing: 12) {
                        Button {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                navModel.pop()
                            }
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 82, height: 82)
                                    .overlay(
                                        Circle().stroke(Color.white.opacity(0.22), lineWidth: 1)
                                    )
                                    .shadow(color: .black.opacity(0.28), radius: 16, x: 0, y: 10)

                                Circle()
                                    .fill(Color.white.opacity(0.10))
                                    .frame(width: 92, height: 92)
                                    .blur(radius: 0.4)
                                    .scaleEffect(breathe ? 1.06 : 0.92)
                                    .opacity(breathe ? 0.70 : 0.35)

                                Image(systemName: "chevron.left")
                                    .font(.system(size: 28, weight: .heavy))
                                    .foregroundColor(.white)
                                    .shadow(color: .white.opacity(0.22), radius: 10, x: 0, y: 0)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 6)
                    .padding(.bottom, 38)
                }
                .opacity(contentOpacity)
                .onAppear {
                    glowPhase = true
                    withAnimation(.easeInOut(duration: 0.6)) {
                        contentOpacity = 1.0
                    }
                    withAnimation(.easeInOut(duration: 2.6).repeatForever(autoreverses: true)) {
                        breathe.toggle()
                    }
                }
            }
        }
    }
}

// MARK: - Helpers (prefixed to avoid conflicts)

private struct AromatherapyTimelineSection<Content: View>: View {
    let title: String
    let icon: String
    var isLast: Bool = false
    var centerTitle: Bool = false
    var showTimeline: Bool = true

    let content: Content

    init(
        title: String,
        icon: String,
        isLast: Bool = false,
        centerTitle: Bool = false,
        showTimeline: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.icon = icon
        self.isLast = isLast
        self.centerTitle = centerTitle
        self.showTimeline = showTimeline
        self.content = content()
    }

    var body: some View {
        HStack(alignment: .top, spacing: showTimeline ? 14 : 0) {

            if showTimeline {
                VStack(spacing: 0) {
                    Circle()
                        .fill(Color.white.opacity(0.88))
                        .frame(width: 10, height: 10)
                        .shadow(color: .white.opacity(0.35), radius: 6, x: 0, y: 0)

                    if !isLast {
                        Rectangle()
                            .fill(Color.white.opacity(0.20))
                            .frame(width: 2)
                            .frame(maxHeight: .infinity)
                            .padding(.top, 10)
                    } else {
                        Spacer(minLength: 0)
                    }
                }
                .frame(width: 18)
            }

            VStack(alignment: .leading, spacing: 10) {
                if centerTitle {
                    HStack(spacing: 10) {
                        Image(systemName: icon)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white.opacity(0.95))
                            .padding(.top, 1)

                        Text(title)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)

                        Image(systemName: icon)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white.opacity(0.95))
                            .padding(.top, 1)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: icon)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white.opacity(0.95))
                            .padding(.top, 1)

                        Text(title)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)

                        Spacer(minLength: 0)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                content
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 6)
    }
}

private struct AromatherapyTagPill: View {
    let text: String
    let icon: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white.opacity(0.90))
            Text(text)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white.opacity(0.95))
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.white.opacity(0.10))
        .overlay(Capsule().stroke(Color.white.opacity(0.16), lineWidth: 1))
        .cornerRadius(999)
    }
}

private struct AromatherapyBulletRow: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Circle()
                .fill(Color.white.opacity(0.85))
                .frame(width: 6, height: 6)
                .padding(.top, 7)

            Text(text)
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.95))
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 0)
        }
    }
}

private struct AromatherapyTechniqueRow: View {
    let title: String
    let pattern: String
    let description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 10) {
                Text(title)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)

                Spacer()

                Text(pattern)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.vertical, 6)
                    .padding(.horizontal, 10)
                    .background(Color.white.opacity(0.10))
                    .overlay(
                        Capsule().stroke(Color.white.opacity(0.14), lineWidth: 1)
                    )
                    .cornerRadius(999)
            }

            Text(description)
                .font(.system(size: 15))
                .foregroundColor(.white.opacity(0.95))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .background(Color.white.opacity(0.08))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.white.opacity(0.14), lineWidth: 1)
        )
        .cornerRadius(14)
    }
}

private struct AromatherapySafetyBullet: View {
    let title: String
    let detail: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            AromatherapyBulletDot()
                .padding(.top, 6)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)

                Text(detail)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.92))
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)
        }
    }
}

private struct AromatherapyBulletDot: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.9))
                .frame(width: 7, height: 7)

            Circle()
                .fill(Color.white.opacity(0.18))
                .frame(width: 18, height: 18)
                .blur(radius: 2)
        }
        .frame(width: 18, height: 18)
    }
}
