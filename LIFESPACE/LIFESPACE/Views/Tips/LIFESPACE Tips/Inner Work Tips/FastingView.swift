import SwiftUI

struct FastingView: View {
    @EnvironmentObject var navModel: NavigationModel

    @State private var showContent = false
    @State private var breathe = false
    @State private var auroraShift = false

    var body: some View {
        ZStack {
            // Base teal
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
                VStack(spacing: 22) {

                    // ✅ Header (NO big circles)
                    VStack(spacing: 10) {
                        Text("FASTING")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(color: .white.opacity(0.28), radius: 10, x: 0, y: 0) // mystical glow
                            .shadow(color: .black.opacity(0.30), radius: 3, x: 0, y: 2)  // depth
                            .shadow(color: .white.opacity(0.7), radius: 10)              // your original title glow (optional)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(.top, 28)
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : -12)
                    .animation(.easeInOut(duration: 0.9).delay(0.05), value: showContent)

                    // Section cards
                    SectionCard(
                        icon: "heart.text.square.fill",
                        title: "Mental & Emotional",
                        bullets: [
                            Bullet("Discipline and emotional control", "Fasting builds discipline as you learn to deny yourself when temptations arrive."),
                            Bullet("Calmer nervous system", "Intentional fasting slows the day down and reduces reactive habits.")
                        ]
                    )
                    .appearStyle(showContent, delay: 0.20)

                    SectionCard(
                        icon: "brain.head.profile",
                        title: "Cognitive",
                        bullets: [
                            Bullet("Sharper focus", "Many people experience cleaner attention and fewer mental distractions."),
                            Bullet("Adaptive brain support", "Fasting is linked with repair processes that may protect long-term cognition.")
                        ]
                    )
                    .appearStyle(showContent, delay: 0.30)

                    SectionCard(
                        icon: "moon.stars.fill",
                        title: "Spiritual",
                        bullets: [
                            Bullet("Presence and self-awareness", "Less stimulation reveals what your mind reaches for."),
                            Bullet("Deeper inner work", "Prayer, meditation, and gratitude can feel louder in the quiet."),
                            Bullet("Relationship to desire", "Fasting highlights attachment, then builds resilience.")
                        ]
                    )
                    .appearStyle(showContent, delay: 0.40)

                    // Ritual card
                    RitualCard(breathe: breathe)
                        .appearStyle(showContent, delay: 0.50)

                    // Bottom-only back button (only visible when you scroll down)
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
                    .appearStyle(showContent, delay: 0.60)
                }
                .padding(.horizontal, 18)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.9)) {
                showContent = true
            }
            withAnimation(.easeInOut(duration: 2.6).repeatForever(autoreverses: true)) {
                breathe.toggle()
            }
            withAnimation(.easeInOut(duration: 7.5).repeatForever(autoreverses: true)) {
                auroraShift.toggle()
            }
        }
    }
}

// MARK: - Components

private extension View {
    func appearStyle(_ show: Bool, delay: Double) -> some View {
        self
            .opacity(show ? 1 : 0)
            .offset(y: show ? 0 : 14)
            .animation(.easeInOut(duration: 0.7).delay(delay), value: show)
    }
}

private struct Bullet: Identifiable {
    let id = UUID()
    let title: String
    let body: String
    init(_ title: String, _ body: String) {
        self.title = title
        self.body = body
    }
}

private struct SectionCard: View {
    let icon: String
    let title: String
    let bullets: [Bullet]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {

            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.16))
                        .frame(width: 34, height: 34)
                        .overlay(Circle().stroke(Color.white.opacity(0.18), lineWidth: 1))

                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                }

                Text(title)
                    .font(.system(size: 20, weight: .heavy))
                    .foregroundColor(.white)

                Spacer()
            }

            VStack(alignment: .leading, spacing: 12) {
                ForEach(bullets) { bullet in
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white.opacity(0.80))
                            .padding(.top, 3)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(bullet.title)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)

                            Text(bullet.body)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white.opacity(0.92))
                                .lineSpacing(3)
                        }
                    }
                }
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.white.opacity(0.12))
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(Color.white.opacity(0.16), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.22), radius: 18, x: 0, y: 12)
    }
}

private struct RitualCard: View {
    let breathe: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.14))
                        .frame(width: 34, height: 34)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.18), lineWidth: 1))

                    Image(systemName: "flame.fill")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .scaleEffect(breathe ? 1.06 : 0.96)
                        .opacity(breathe ? 0.95 : 0.80)
                }

                Text("Spiritual Integration")
                    .font(.system(size: 20, weight: .heavy))
                    .foregroundColor(.white)

                Spacer()
            }

            VStack(alignment: .leading, spacing: 10) {
                RitualRow(step: "1", text: "Read a religious text and feel the words filling your stomach.")
                RitualRow(step: "2", text: "Practice prayer and speaking to God or your higher power.")
                RitualRow(step: "3", text: "Sit in stillness and meditate while in the fasted state.")
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.14),
                            Color.white.opacity(0.10),
                            Color.white.opacity(0.12)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(Color.white.opacity(0.18), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.20), radius: 18, x: 0, y: 12)
    }
}

private struct RitualRow: View {
    let step: String
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Text(step)
                .font(.system(size: 13, weight: .heavy))
                .foregroundColor(.white)
                .frame(width: 22, height: 22)
                .background(Color.white.opacity(0.18))
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white.opacity(0.20), lineWidth: 1))

            Text(text)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white.opacity(0.92))
                .lineSpacing(3)

            Spacer(minLength: 0)
        }
    }
}

// MARK: - Background

