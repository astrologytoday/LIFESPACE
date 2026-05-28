import SwiftUI

struct GeminiView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var contentOpacity: Double = 0.0

    var body: some View {
        ZStack {
            // Background Gradient (Airy Blue / Cosmic)
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.13, green: 0.20, blue: 0.40),
                    Color(red: 0.05, green: 0.10, blue: 0.25)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    Spacer(minLength: 20)

                    // Gemini Zodiac Chart
                    Image("gemini-chart")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .scaledToFit()
                        .frame(width: 180)
                        .shadow(radius: 12)
                        .padding(.top, 10)

                    Text("May 21 – June 20")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.horizontal)

                    // Info Section + Gemini Symbol
                    HStack(alignment: .top, spacing: 16) {
                        VStack(alignment: .leading, spacing: 14) {
                            infoRow(label: "Symbol:", value: "Twins")
                            infoRow(label: "Ruling Planet:", value: "Mercury ☿")
                            infoRow(label: "Element:", value: "Air 🜁")
                            infoRow(label: "Mode:", value: "Mutable")
                            infoRow(label: "Keyword:", value: "Communicate")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                        .layoutPriority(1)

                        // Gemini Symbol Image
                        Image("gemini-symbol")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .scaledToFit()
                            .frame(maxWidth: 150, maxHeight: 150)
                            .padding(.trailing, 20)
                            .shadow(radius: 10)
                    }

                    Divider()
                        .background(.white)
                        .padding(.horizontal)

                    // ORIGINAL GEMINI DESCRIPTION
                    Text("""
                    Gemini is linked to communication, mental activity, and the realm of conscious thought. As a sign of duality, Gemini energy is quick, flexible, and always processing something new. People born under this sign are often bright, curious, expressive, and skilled at using language. They enjoy exploring ideas, meeting new people, and understanding the world through conversation.

                    Their minds move quickly, and they can shift between perspectives with ease, sometimes juggling different interests or moods at the same time. Gemini can be restless and easily distracted, but their versatility and sharp intellect make them engaging, witty, and endlessly fascinated by life.
                    """)
                    .foregroundColor(.white)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal)

                    // Back Button
                    HStack {
                        Spacer()
                        Button(action: {
                            navModel.pop()
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
                    .padding(.bottom, 44)
                }
                .opacity(contentOpacity)
                .onAppear {
                    withAnimation(.easeInOut(duration: 0.6)) {
                        contentOpacity = 1.0
                    }
                }
            }
        }
    }

    // MARK: - Info Row Builder
    func infoRow(label: String, value: String) -> some View {
        HStack(alignment: .top, spacing: 6) {
            Text("• \(label)")
                .foregroundColor(.white)
                .font(.system(size: 18, weight: .medium))
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)

            Text(value)
                .foregroundColor(.white)
                .font(.system(size: 18, weight: .medium))
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 0)
        }
    }
}
