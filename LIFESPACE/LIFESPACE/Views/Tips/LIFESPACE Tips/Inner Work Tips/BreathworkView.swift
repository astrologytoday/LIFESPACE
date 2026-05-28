import SwiftUI

struct BreathworkView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var contentOpacity: Double = 0.0
    @State private var glowPhase: Bool = false

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
                    Text("BREATHWORK")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .white.opacity(0.28), radius: 10, x: 0, y: 0) // mystical glow
                        .shadow(color: .black.opacity(0.30), radius: 3, x: 0, y: 2)  // depth
                        .shadow(color: .white.opacity(0.7), radius: 10)              // your original title glow (optional)
                        .frame(maxWidth: .infinity, alignment: .center)

                    // Timeline flow (same style as MirrorWorkView)
                    TimelineSection(title: "What Breathwork Is", icon: "wind") {
                        Text("Breathwork is the practice of consciously controlling your breath to influence your physical, mental, and emotional states. It’s one of the most direct ways to access calm, focus, energy, and even spiritual insight.")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.95))
                            .fixedSize(horizontal: false, vertical: true)

                        Text("Your breath is the bridge between your body and mind. Through slow, intentional breathing, you can reduce stress, balance your nervous system, and shift your emotional state in just minutes.")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.95))
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.top, 6)

                        HStack(spacing: 10) {
                            TagPill(text: "Calm", icon: "moon.stars.fill")
                            TagPill(text: "Focus", icon: "scope")
                            TagPill(text: "Energy", icon: "bolt.fill")
                        }
                        .padding(.top, 6)
                    }

                    TimelineSection(title: "Science of Breath", icon: "brain.head.profile") {
                        BulletRow(text: "Breath controls the autonomic nervous system")
                        BulletRow(text: "Inhales stimulate alertness; exhales activate calm")
                        BulletRow(text: "Slow breathing can reduce heart rate and cortisol")
                        BulletRow(text: "Improves heart rate variability (HRV)")
                    }

                    TimelineSection(title: "Why It Works", icon: "waveform.path.ecg") {
                        Text("Breath bypasses the thinking mind. When you breathe consciously, you give the body a new rhythm, which signals safety, peace, or strength. Breath can shift brainwaves, release tension, and unlock stuck emotion.")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.95))
                            .fixedSize(horizontal: false, vertical: true)

                        SubtleCallout(text: "When you change your breath, you change your state.")
                            .padding(.top, 6)
                    }

                    TimelineSection(title: "Try These Techniques", icon: "sparkles") {
                        VStack(spacing: 12) {
                            TechniqueRow(
                                title: "Box Breathing",
                                pattern: "4 • 4 • 4 • 4",
                                description: "Inhale for 4 seconds, hold 4, exhale 4, hold 4. Calms nerves and boosts focus."
                            )

                            TechniqueRow(
                                title: "4-7-8 Breathing",
                                pattern: "4 • 7 • 8",
                                description: "Inhale 4, hold 7, exhale 8. Helps you fall asleep."
                            )

                            TechniqueRow(
                                title: "Deep Belly Breathing",
                                pattern: "Slow + deep",
                                description: "Breathe into your belly slowly. Grounding and stress-reducing."
                            )

                            TechniqueRow(
                                title: "Breath of Fire",
                                pattern: "Fast exhales",
                                description: "Quick nasal exhales. Energizing and cleansing."
                            )
                        }
                        .padding(.top, 4)
                    }

                    // Timer button (same primary feel)
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            navModel.push("TimerView")
                        }
                    }) {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(Color.white.opacity(0.16))
                                    .frame(width: 44, height: 44)
                                    .overlay(Circle().stroke(Color.white.opacity(0.20), lineWidth: 1))
                                Image(systemName: "timer")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white.opacity(0.95))
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Start Breathwork Timer")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)

                                Text("Pick a technique and begin")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.75))
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white.opacity(0.75))
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.18))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.20), lineWidth: 1)
                        )
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.12), radius: 10, x: 0, y: 6)
                        .padding(.horizontal)
                    }
                    .padding(.top, 4)

                    // Back Button
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

// MARK: - Timeline Components (same pattern as MirrorWorkView)

private struct TimelineSection<Content: View>: View {
    let title: String
    let icon: String
    var isLast: Bool = false
    var centerTitle: Bool = false
    var compactLeading: Bool = false

    let content: Content

    init(
        title: String,
        icon: String,
        isLast: Bool = false,
        centerTitle: Bool = false,
        compactLeading: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.icon = icon
        self.isLast = isLast
        self.centerTitle = centerTitle
        self.compactLeading = compactLeading
        self.content = content()
    }

    var body: some View {
        HStack(alignment: .top, spacing: compactLeading ? 10 : 14) {

            if !compactLeading {
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
                            .fixedSize(horizontal: false, vertical: true)

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
                            .fixedSize(horizontal: false, vertical: true)

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

private struct TagPill: View {
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

private struct SubtleCallout: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "quote.opening")
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.white.opacity(0.85))

            Text(text)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white.opacity(0.92))
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

private struct BulletRow: View {
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

private struct TechniqueRow: View {
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
                        Capsule()
                            .stroke(Color.white.opacity(0.14), lineWidth: 1)
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
