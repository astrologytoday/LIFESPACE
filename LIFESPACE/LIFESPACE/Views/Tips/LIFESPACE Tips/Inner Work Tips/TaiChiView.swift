import SwiftUI

struct TaiChiView: View {
    @EnvironmentObject var navModel: NavigationModel

    @State private var contentOpacity: Double = 0.0
    @State private var glowPhase: Bool = false
    @State private var breathe: Bool = false

    let taiChiLinks: [(title: String, url: String)] = [
        ("Module 01", "https://www.youtube.com/watch?v=cEOS2zoyQw4"),
        ("Module 02", "https://www.youtube.com/watch?v=enk0bOv-gF8"),
        ("Module 03", "https://www.youtube.com/watch?v=X1dyl_yHA84"),
        ("Module 04", "https://www.youtube.com/watch?v=RoIqYtiTLFI")
    ]

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

            // Soft glow drift
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

            // Subtle sheen sweep
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

                    // Title
                    Text("TAI CHI")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .white.opacity(0.28), radius: 10, x: 0, y: 0)
                        .shadow(color: .black.opacity(0.30), radius: 3, x: 0, y: 2)
                        .shadow(color: .white.opacity(0.7), radius: 10)
                        .frame(maxWidth: .infinity, alignment: .center)

                    // Intro
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "wind")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white.opacity(0.92))
                            .padding(.top, 2)

                        Text("Tai Chi is a gentle, flowing movement practice that harmonizes body and mind. Originally developed as a martial art, it is now widely practiced for balance, healing, and internal energy cultivation.")
                            .font(.system(size: 17))
                            .foregroundColor(.white.opacity(0.95))
                            .fixedSize(horizontal: false, vertical: true)

                        Spacer(minLength: 0)
                    }

                    // ✅ Benefits (glass case BACK)
                    TaiChiCard {
                        TaiChiHeader(title: "The Benefits of Tai Chi", symbol: "bolt.heart.fill")

                        VStack(alignment: .leading, spacing: 10) {
                            TaiChiBullet(text: "Improves balance and coordination")
                            TaiChiBullet(text: "Reduces stress and anxiety")
                            TaiChiBullet(text: "Increases body awareness and presence")
                            TaiChiBullet(text: "Strengthens the lower body and core")
                            TaiChiBullet(text: "Supports energy flow and internal vitality")
                        }
                        .padding(.top, 10)
                    }

                    TaiChiCard {
                        TaiChiHeader(title: "Chi and Internal Harmony", symbol: "sparkles")
                        Text("Tai Chi emphasizes smooth, intentional movement to balance the flow of Chi, the vital life force, through the body. By releasing tension and moving with awareness, energy can circulate more freely.")
                            .font(.system(size: 17))
                            .foregroundColor(.white.opacity(0.93))
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.top, 6)
                    }

                    TaiChiCard {
                        TaiChiHeader(title: "Meditative Movement", symbol: "waveform")
                        Text("Every Tai Chi form is a moving meditation. Breath, awareness, and posture become one continuous stream. The mind slows, the breath deepens, and the nervous system relaxes.")
                            .font(.system(size: 17))
                            .foregroundColor(.white.opacity(0.93))
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.top, 6)
                    }

                    TaiChiCard {
                        TaiChiHeader(title: "Connection with Nature", symbol: "leaf.fill")
                        Text("Tai Chi is often practiced outdoors to sync with the elements: air, earth, sun, and wind. Movements mirror the flow of water, the rootedness of trees, and the grace of animals.")
                            .font(.system(size: 17))
                            .foregroundColor(.white.opacity(0.93))
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.top, 6)
                    }

                    // ✅ Modules title (CENTERED)
                    TryTaiChiHeader()

                    VStack(spacing: 14) {
                        ForEach(taiChiLinks, id: \.url) { item in
                            TaiChiLinkRow(title: item.title, url: item.url)
                        }
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

// MARK: - Card UI Pieces

private struct TaiChiCard<Content: View>: View {
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

private struct TaiChiHeader: View {
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

// MARK: - Bullet style (SoundBathView look, left-aligned)

private struct TaiChiBullet: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            TaiChiBulletDot()
                .padding(.top, 7)

            Text(text)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .shadow(color: .white.opacity(0.12), radius: 10, x: 0, y: 0)
                .shadow(color: .black.opacity(0.22), radius: 3, x: 0, y: 2)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct TaiChiBulletDot: View {
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

// MARK: - Links Header + Rows

private struct TryTaiChiHeader: View {
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 12) {
                Spacer(minLength: 0)

                Image(systemName: "play.circle.fill")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white.opacity(0.92))

                Text("Try These Tai Chi Modules")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .white.opacity(0.16), radius: 10, x: 0, y: 0)
                    .shadow(color: .black.opacity(0.22), radius: 3, x: 0, y: 2)

                Image(systemName: "wind")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white.opacity(0.90))

                Spacer(minLength: 0)
            }

            HStack(spacing: 8) {
                Circle().fill(Color.white.opacity(0.30)).frame(width: 6, height: 6)
                Circle().fill(Color.white.opacity(0.50)).frame(width: 7, height: 7)
                Circle().fill(Color.white.opacity(0.70)).frame(width: 8, height: 8)
                Circle().fill(Color.white.opacity(0.50)).frame(width: 7, height: 7)
                Circle().fill(Color.white.opacity(0.30)).frame(width: 6, height: 6)
            }
            .shadow(color: .white.opacity(0.12), radius: 10, x: 0, y: 0)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.top, 6)
    }
}

private struct TaiChiLinkRow: View {
    let title: String
    let url: String

    var body: some View {
        Link(destination: URL(string: url)!) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.16))
                        .frame(width: 38, height: 38)
                        .overlay(Circle().stroke(Color.white.opacity(0.18), lineWidth: 1))

                    Image(systemName: "play.fill")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white.opacity(0.92))
                }

                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer()

                Image(systemName: "arrow.up.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white.opacity(0.75))
            }
            .padding(14)
            .frame(maxWidth: .infinity)
            .background(Color.white.opacity(0.14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.white.opacity(0.16), lineWidth: 1)
            )
            .cornerRadius(14)
        }
    }
}
