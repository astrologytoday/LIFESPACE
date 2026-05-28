import SwiftUI

struct CandleWorkView: View {
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

            // Warm glow drift
            RadialGradient(
                gradient: Gradient(colors: [
                    Color.yellow.opacity(0.18),
                    Color.white.opacity(0.00)
                ]),
                center: glowPhase ? .topLeading : .bottomTrailing,
                startRadius: 40,
                endRadius: 620
            )
            .ignoresSafeArea()
            .blendMode(.screen)
            .animation(.easeInOut(duration: 5.4).repeatForever(autoreverses: true), value: glowPhase)

            // Subtle shimmer sweep
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(glowPhase ? 0.10 : 0.04),
                    Color.white.opacity(0.00),
                    Color.orange.opacity(glowPhase ? 0.06 : 0.02)
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

                    // Title
                    Text("CANDLE WORK")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                        .shadow(color: .white.opacity(0.28), radius: 10, x: 0, y: 0)
                        .shadow(color: .black.opacity(0.30), radius: 3, x: 0, y: 2)
                        .shadow(color: .white.opacity(0.7), radius: 10)
                        .frame(maxWidth: .infinity, alignment: .center)

                    // Intro
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white.opacity(0.92))
                            .padding(.top, 2)

                        Text("Candle gazing is a sacred practice found in yoga, mysticism, and ancient spiritual traditions. It calms the mind, activates inner light, and deepens intuitive awareness.")
                            .font(.system(size: 17))
                            .foregroundColor(.white.opacity(0.95))
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .layoutPriority(1)

                        Spacer(minLength: 0)
                    }

                    CandleCard {
                        CandleHeader(title: "Biophotons and Inner Light", symbol: "sparkles")
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Candlelight produces a natural, organic spectrum of light that your eyes and body respond to in a way that is more relaxing than artificial lighting.")
                            Text("Gazing at a flame can stimulate pineal gland activity. The pineal gland emits biophotons, light particles emitted by your cells, and candlelight can awaken these inner processes, affecting melatonin, serotonin, and circadian rhythm.")
                        }
                        .font(.system(size: 17))
                        .foregroundColor(.white.opacity(0.93))
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 6)
                    }

                    CandleCard {
                        CandleHeader(title: "Neural Entrainment", symbol: "waveform")
                        VStack(alignment: .leading, spacing: 10) {
                            Text("The rhythmic flicker of a candle naturally syncs the brain into alpha and theta waves. These states are associated with meditation, inner stillness, and healing.")
                            Text("This entrainment increases mental coherence, creating a state that many describe as peaceful, intuitive, or visionary.")
                        }
                        .font(.system(size: 17))
                        .foregroundColor(.white.opacity(0.93))
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 6)
                    }

                    CandleCard {
                        CandleHeader(title: "Trataka and Third-Eye Activation", symbol: "eye.fill")
                        VStack(alignment: .leading, spacing: 10) {
                            Text("In yogic practice, Trataka is focused candle gazing. It sharpens concentration, purifies attention, and can lead to experiences of inner light or subtle vision.")
                            Text("Scientifically, this correlates with gamma brainwave states, deep nervous system coherence, and possibly increased endogenous DMT release in the pineal gland.")
                        }
                        .font(.system(size: 17))
                        .foregroundColor(.white.opacity(0.93))
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 6)
                    }

                    CandleCard {
                        CandleHeader(title: "Breath, Stillness, and the Nervous System", symbol: "lungs.fill")
                        VStack(alignment: .leading, spacing: 10) {
                            Text("During candle gazing, most people breathe more slowly and deeply without noticing. This quiets the autonomic nervous system and increases heart rate variability, a sign of emotional resilience.")
                            Text("Inner stillness enhances electromagnetic coherence in the heart field, which ancient traditions recognized as a rise in vibration or consciousness.")
                        }
                        .font(.system(size: 17))
                        .foregroundColor(.white.opacity(0.93))
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 6)
                    }

                    CandleCard {
                        CandleHeader(title: "Why Candle Gazing Raises Your Vibration", symbol: "arrow.up.circle.fill")

                        // ✅ NOW LEFT-ALIGNED
                        VStack(alignment: .leading, spacing: 10) {
                            CandleSingleBullet(text: "Activates inner biophoton emission")
                            CandleSingleBullet(text: "Syncs the brain to healing alpha and theta waves")
                            CandleSingleBullet(text: "Induces mental stillness and clarity")
                            CandleSingleBullet(text: "Deepens intuitive and symbolic perception")
                            CandleSingleBullet(text: "Shifts the body from stress to healing mode")
                        }
                        .padding(.top, 10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    CandleCard {
                        CandleHeader(title: "Reflection", symbol: "moon.stars.fill")
                        Text("Light a single candle in a quiet room. Allow your gaze to soften. Let the flame still your thoughts and awaken what is already inside you.")
                            .font(.system(size: 17))
                            .foregroundColor(.white.opacity(0.93))
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.top, 6)
                    }

                    // Back button
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
                    .padding(.bottom, 44)
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

// MARK: - Card UI Pieces

private struct CandleCard<Content: View>: View {
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

private struct CandleHeader: View {
    let title: String
    let symbol: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
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
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .layoutPriority(1)

            Spacer(minLength: 0)
        }
    }
}

// MARK: - Bullet Style (now LEFT-aligned)

private struct CandleSingleBullet: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            CandleBulletDot()
                .padding(.top, 7)

            Text(text)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .shadow(color: .white.opacity(0.12), radius: 10, x: 0, y: 0)
                .shadow(color: .black.opacity(0.22), radius: 3, x: 0, y: 2)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .layoutPriority(1)

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct CandleBulletDot: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.85))
                .frame(width: 6, height: 6)

            Circle()
                .fill(Color.white.opacity(0.18))
                .frame(width: 18, height: 18)
                .blur(radius: 2)
        }
        .frame(width: 18, height: 18)
    }
}
