import SwiftUI

struct SoundBathView: View {
    @EnvironmentObject var navModel: NavigationModel

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

            // Subtle glow (STATIC — no animation)
            RadialGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(0.14),
                    Color.white.opacity(0.00)
                ]),
                center: .topLeading,
                startRadius: 30,
                endRadius: 560
            )
            .ignoresSafeArea()
            .blendMode(.screen)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    Spacer(minLength: 20)

                    // Title (standard Inner Work styling)
                    Text("SOUND BATHS")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .white.opacity(0.28), radius: 10, x: 0, y: 0) // mystical glow
                        .shadow(color: .black.opacity(0.30), radius: 3, x: 0, y: 2)  // depth
                        .shadow(color: .white.opacity(0.7), radius: 10)              // original title glow (optional)
                        .frame(maxWidth: .infinity, alignment: .center)

                    // Body (same paragraph structure, upgraded atmosphere)
                    VStack(alignment: .leading, spacing: 14) {
                        ResonanceParagraph(
                            symbol: "waveform.circle.fill",
                            text: "A sound bath is a meditative healing experience where you are “bathed” in soothing sound frequencies."
                        )

                        ResonanceParagraph(
                            symbol: "guitars.fill",
                            text: "Crystal singing bowls, gongs, chimes, and harmonic instruments create layers of vibration that can feel like the body is being gently re-tuned. Many people notice the nervous system soften, emotions loosen, and the mind drop into a quieter inner space."
                        )

                        ResonanceParagraph(
                            symbol: "circle.grid.cross.fill",
                            text: "Sound is vibration, and each chakra in your body responds to different frequencies. By exposing the body to specific tones, sound baths can help to:"
                        )

                        // ✅ SAME bullet LOOK as BulletDot, but LEFT aligned and ONLY one bullet (left side)
                        VStack(alignment: .trailing, spacing: 10) {
                            SingleBullet(text: "Unblock stuck energy")
                            SingleBullet(text: "Balance your emotional state")
                            SingleBullet(text: "Activate spiritual centers")
                            SingleBullet(text: "Restore harmony between\nmind, body, and spirit")
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.horizontal)

                    // Chakra list (colored circles + background circles, STATIC — no animation/rings)
                    VStack(alignment: .leading, spacing: 12) {
                        SectionHeader(icon: "circle.grid.cross.fill", title: "Chakras and What They Govern")

                        ZStack {
                            // Soft “sound rings” behind the rows (static)
                            Circle()
                                .fill(Color.white.opacity(0.06))
                                .frame(width: 260, height: 260)
                                .blur(radius: 2)
                                .offset(x: 160, y: -10)

                            Circle()
                                .fill(Color.white.opacity(0.05))
                                .frame(width: 190, height: 190)
                                .blur(radius: 2)
                                .offset(x: 120, y: 140)

                            VStack(alignment: .leading, spacing: 14) {
                                ChakraRow(name: "Crown - 963 Hz", color: .purple, description: "Spirituality & higher self")
                                ChakraRow(name: "Third Eye - 852 Hz", color: .indigo, description: "Intuition, perception")
                                ChakraRow(name: "Throat - 741 Hz", color: .blue, description: "Expression, communication")
                                ChakraRow(name: "Heart - 639 Hz", color: .green, description: "Love, compassion")
                                ChakraRow(name: "Solar Plexus - 528 Hz", color: .yellow, description: "Confidence, willpower")
                                ChakraRow(name: "Sacral - 432 Hz", color: .orange, description: "Drive, sexuality")
                                ChakraRow(name: "Root - 396 Hz", color: .red, description: "Grounding, survival")
                            }
                        }
                    }
                    .padding(.horizontal)

                    // Links
                    TrySoundBathsHeader()
                        .padding(.horizontal)

                    VStack(spacing: 14) {
                        SoundLinkRow(title: "Crown Chakra Sound Bath", url: "https://www.youtube.com/watch?v=jZ9cHKtsJE8")
                        SoundLinkRow(title: "Sacral Chakra Sound Bath", url: "https://www.youtube.com/watch?v=33PiPmTtf2Q&t=188s")
                        SoundLinkRow(title: "Third Eye Chakra Sound Bath", url: "https://www.youtube.com/watch?v=5UmLBQkb9mo")
                        SoundLinkRow(title: "Heart Chakra Sound Bath", url: "https://www.youtube.com/watch?v=5Q6z8QrywP8")
                    }
                    .padding(.horizontal)

                    // Back button
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
            }
        }
    }
}

// MARK: - Components

private struct SectionHeader: View {
    let icon: String
    let title: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white.opacity(0.92))

            Text(title)
                .font(.headline)
                .foregroundColor(.white)

            Spacer()
        }
    }
}

private struct ChakraRow: View {
    let name: String
    let color: Color
    let description: String

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(color.opacity(0.82))
                .frame(width: 28, height: 28)
                .shadow(color: color.opacity(0.45), radius: 10, x: 0, y: 0)

            VStack(alignment: .leading, spacing: 3) {
                Text(name)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.white)

                Text(description)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.82))
            }

            Spacer()
        }
    }
}

private struct SoundLinkRow: View {
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

                    Image(systemName: "speaker.wave.2.fill")
                        .font(.system(size: 16, weight: .bold))
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

private struct ResonanceParagraph: View {
    let symbol: String
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Capsule()
                    .fill(Color.white.opacity(0.10))
                    .frame(width: 34, height: 6)
                    .offset(y: 11)

                Capsule()
                    .fill(Color.white.opacity(0.14))
                    .frame(width: 26, height: 6)

                Capsule()
                    .fill(Color.white.opacity(0.10))
                    .frame(width: 34, height: 6)
                    .offset(y: -11)

                Circle()
                    .fill(Color.white.opacity(0.14))
                    .frame(width: 34, height: 34)
                    .overlay(Circle().stroke(Color.white.opacity(0.18), lineWidth: 1))
                    .shadow(color: .white.opacity(0.18), radius: 10, x: 0, y: 0)

                Image(systemName: symbol)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white.opacity(0.92))
            }
            .frame(width: 42)

            Text(text)
                .foregroundColor(.white)
                .shadow(color: .white.opacity(0.14), radius: 10, x: 0, y: 0)
                .shadow(color: .black.opacity(0.22), radius: 3, x: 0, y: 2)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 0)
        }
    }
}

private struct SingleBullet: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Spacer(minLength: 0)

            Text(text)
                .foregroundColor(.white)
                .multilineTextAlignment(.trailing)
                .shadow(color: .white.opacity(0.12), radius: 10, x: 0, y: 0)
                .shadow(color: .black.opacity(0.22), radius: 3, x: 0, y: 2)
                .fixedSize(horizontal: false, vertical: true)

            BulletDot()
                .padding(.top, 7)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

private struct BulletDot: View {
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

private struct TrySoundBathsHeader: View {
    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Capsule()
                    .fill(Color.white.opacity(0.12))
                    .overlay(
                        Capsule()
                            .stroke(Color.white.opacity(0.18), lineWidth: 1)
                    )
                    .shadow(color: .white.opacity(0.14), radius: 12, x: 0, y: 0)
                    .shadow(color: .black.opacity(0.22), radius: 4, x: 0, y: 3)

                HStack(spacing: 12) {
                    Image(systemName: "speaker.wave.3.fill")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white.opacity(0.92))

                    Text("Try These Sound Baths")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)

                    Image(systemName: "headphones")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white.opacity(0.90))
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
            }
            .frame(maxWidth: .infinity)

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
        .padding(.top, 2)
    }
}
