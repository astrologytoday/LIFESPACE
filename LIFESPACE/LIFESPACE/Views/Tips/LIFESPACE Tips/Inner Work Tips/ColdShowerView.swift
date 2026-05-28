import SwiftUI

struct ColdShowerView: View {
    @EnvironmentObject var navModel: NavigationModel

    @State private var contentOpacity: Double = 0.0
    @State private var glowPhase: Bool = false
    @State private var breathe: Bool = false

    var body: some View {
        ZStack {
            // Background Gradient (unchanged)
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

            // Frosty glow drift
            RadialGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(0.16),
                    Color.white.opacity(0.00)
                ]),
                center: glowPhase ? .topLeading : .bottomTrailing,
                startRadius: 40,
                endRadius: 620
            )
            .ignoresSafeArea()
            .blendMode(.screen)
            .animation(.easeInOut(duration: 5.4).repeatForever(autoreverses: true), value: glowPhase)

            // Subtle “ice sheen” sweep
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(glowPhase ? 0.10 : 0.04),
                    Color.white.opacity(0.00),
                    Color.white.opacity(glowPhase ? 0.06 : 0.02)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .blendMode(.overlay)
            .opacity(0.55)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    Spacer(minLength: 20)

                    // Title (KEEP UNCHANGED)
                    Text("COLD SHOWERS")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .white.opacity(0.28), radius: 10, x: 0, y: 0)
                        .shadow(color: .black.opacity(0.30), radius: 3, x: 0, y: 2)
                        .shadow(color: .white.opacity(0.7), radius: 10)
                        .frame(maxWidth: .infinity, alignment: .center)

                    // New UI: Frost cards (copy unchanged)
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "snowflake")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white.opacity(0.92))
                                .padding(.top, 2)

                            Text("Cold showers have been used for centuries to invigorate the body, sharpen the mind, and strengthen the will...")
                                .font(.system(size: 17))
                                .foregroundColor(.white.opacity(0.95))
                                .fixedSize(horizontal: false, vertical: true)

                            Spacer(minLength: 0)
                        }

                    FrostCard {
                        FrostHeader(title: "Nervous System Reset", symbol: "waveform.path.ecg")
                        Text("Exposure to cold water activates the sympathetic nervous system and increases endorphin production. Once the body adapts, a rebound parasympathetic effect occurs, leading to a calmer, more regulated state.")
                            .font(.system(size: 17))
                            .foregroundColor(.white.opacity(0.93))
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.top, 6)
                    }

                    FrostCard {
                        FrostHeader(title: "Mood Boost", symbol: "bolt.heart.fill")
                        Text("Cold exposure increases levels of dopamine and norepinephrine. These are neurotransmitters linked to motivation, focus, and a sense of well-being. Many users report an immediate improvement in mood after a cold shower.")
                            .font(.system(size: 17))
                            .foregroundColor(.white.opacity(0.93))
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.top, 6)
                    }

                    FrostCard {
                        FrostHeader(title: "Anti-Inflammatory Effects", symbol: "drop.triangle.fill")
                        Text("Cold water constricts blood vessels and reduces inflammation. It also improves circulation when followed by warming the body naturally, encouraging lymphatic flow and detoxification.")
                            .font(.system(size: 17))
                            .foregroundColor(.white.opacity(0.93))
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.top, 6)
                    }

                    FrostCard {
                        FrostHeader(title: "Willpower Training", symbol: "shield.lefthalf.filled")
                        Text("The decision to step into cold water builds resilience, mental discipline, and self-control. Over time, it conditions you to face discomfort with strength and clarity.")
                            .font(.system(size: 17))
                            .foregroundColor(.white.opacity(0.93))
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.top, 6)
                    }

                    // Back button (KEEP UNCHANGED)
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
                    .padding(.top, 10)
                    .padding(.bottom, 38)
                }
                .padding(.horizontal, 20)
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

// MARK: - Frost UI Pieces

private struct FrostCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            content
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.12))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.white.opacity(0.16), lineWidth: 1)
                )
        )
        .overlay(
            // top “ice edge”
            RoundedRectangle(cornerRadius: 18)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.22),
                            Color.white.opacity(0.00),
                            Color.white.opacity(0.10)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: Color.black.opacity(0.10), radius: 10, x: 0, y: 6)
    }
}

private struct FrostHeader: View {
    let title: String
    let symbol: String

    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.14))
                    .frame(width: 34, height: 34)
                    .overlay(Circle().stroke(Color.white.opacity(0.16), lineWidth: 1))

                Image(systemName: symbol)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white.opacity(0.95))
            }

            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)

            Spacer(minLength: 0)
        }
    }
}
