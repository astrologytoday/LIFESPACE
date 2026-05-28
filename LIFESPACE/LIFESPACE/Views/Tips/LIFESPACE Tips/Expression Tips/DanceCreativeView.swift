import SwiftUI

struct DanceCreativeView: View {
    @EnvironmentObject var navModel: NavigationModel
    @Environment(\.openURL) private var openURL

    @State private var isVisible = false
    @State private var pulseSpotify = false

    private var lifescapeButtonGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.85, green: 1.0, blue: 0.9),
                Color(red: 0.4, green: 0.9, blue: 0.8)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private func topIconButton(systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Circle()
                .fill(lifescapeButtonGradient)
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: systemName)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                )
        }
        .buttonStyle(.plain)
    }

    var body: some View {
        ZStack {
            // 🌊 Teal Gradient Background
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

            VStack(spacing: 16) {

                // ✅ Only back button (no title, no home)
                HStack {
                    topIconButton(systemName: "chevron.left") {
                        fadeOutThen { navModel.pop() }
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 10)

                // ✅ Tips bubble (match CookingCreativeView style)
                VStack(alignment: .leading, spacing: 14) {
                    Text("Dance Ideas..")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.bottom, 2)

                    VStack(alignment: .leading, spacing: 14) {
                        tipRow("Move freely for 30 seconds without choreography.")
                        tipRow("Let emotion guide your movement.")
                        tipRow("Dance in low light to reduce self-consciousness.")
                        tipRow("Sync movement with your breath.")
                    }
                }
                .padding(18)
                .background(
                    RoundedRectangle(cornerRadius: 26)
                        .fill(Color.white.opacity(0.12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 26)
                                .stroke(Color.white.opacity(0.20), lineWidth: 1.2)
                        )
                        .shadow(color: .black.opacity(0.18), radius: 12, x: 0, y: 8)
                )
                .padding(.horizontal)
                .padding(.top, 28) // keeps the bubble lower like CookingCreativeView

                // ✅ Bigger space between bubble and Spotify button
                Spacer().frame(height: 26)

                // ✅ Big glowing pulsating Spotify button (centered)
                Button {
                    openSpotify()
                } label: {
                    ZStack {
                        // Outer glow ring
                        Circle()
                            .stroke(Color.white.opacity(0.95), lineWidth: 6)
                            .frame(width: 150, height: 150)
                            .shadow(color: Color.white.opacity(pulseSpotify ? 0.95 : 0.55),
                                    radius: pulseSpotify ? 26 : 14, x: 0, y: 0)
                            .shadow(color: Color.white.opacity(pulseSpotify ? 0.45 : 0.20),
                                    radius: pulseSpotify ? 52 : 26, x: 0, y: 0)

                        // Main face
                        Circle()
                            .fill(lifescapeButtonGradient)
                            .frame(width: 132, height: 132)
                            .shadow(color: .black.opacity(0.18), radius: 10, x: 0, y: 6)
                            .overlay(
                                Circle()
                                    .stroke(Color.white.opacity(0.22), lineWidth: 1.2)
                            )

                        VStack(spacing: 8) {
                            Image(systemName: "music.note")
                                .font(.system(size: 30, weight: .heavy))
                                .foregroundColor(.black)

                            Text("SPOTIFY")
                                .font(Font.custom("Avenir-Heavy", size: 16))
                                .foregroundColor(.black)
                        }
                    }
                    .scaleEffect(pulseSpotify ? 1.06 : 1.0)
                    .animation(.easeInOut(duration: 1.15).repeatForever(autoreverses: true),
                               value: pulseSpotify)
                    .contentShape(Circle())
                    .accessibilityLabel("Open Spotify")
                }
                .buttonStyle(.plain)

                Spacer()
            }
            .opacity(isVisible ? 1 : 0)
            .animation(.easeInOut(duration: 0.6), value: isVisible)
            .onAppear {
                withAnimation { isVisible = true }
                pulseSpotify = true
            }
        }
    }

    private func tipRow(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(Color.white.opacity(0.95))
                .frame(width: 9, height: 9)
                .padding(.top, 7)

            Text(text)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func fadeOutThen(_ action: @escaping () -> Void) {
        withAnimation(.easeInOut(duration: 0.5)) {
            isVisible = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            action()
        }
    }

    private func openSpotify() {
        let spotifyURL = URL(string: "spotify://")!
        let webURL = URL(string: "https://open.spotify.com")!

        openURL(spotifyURL) { accepted in
            if !accepted {
                openURL(webURL)
            }
        }
    }
}
