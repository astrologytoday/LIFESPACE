import SwiftUI

struct PiscesView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var contentOpacity: Double = 0.0

    var body: some View {
        ZStack {
            // Mystical, ocean-like gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.08, green: 0.12, blue: 0.30),
                    Color(red: 0.02, green: 0.05, blue: 0.15)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    Spacer(minLength: 20)

                    Image("pisces-chart")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .scaledToFit()
                        .frame(width: 180)
                        .shadow(radius: 12)
                        .padding(.top, 10)

                    Text("February 19 – March 20")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .center)

                    HStack(alignment: .top, spacing: 16) {
                        VStack(alignment: .leading, spacing: 14) {
                            infoRow(label: "Symbol:", value: "Two Fish")
                            infoRow(label: "Ruling Planet:", value: "Jupiter ♃")
                            infoRow(label: "Element:", value: "Water 🜄")
                            infoRow(label: "Mode:", value: "Mutable")
                            infoRow(label: "Keyword:", value: "Intuition")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)

                        Image("pisces-symbol")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .padding(.trailing, 20)
                            .shadow(radius: 10)
                    }

                    Divider()
                        .background(.white)
                        .padding(.horizontal)

                    Text("""
                    Pisces is sensitive, soulful, and very creative. As the final sign of the zodiac, Pisceans are often considered the final stage of spiritual evolution: Intuition. Drawn to unseen realms, symbolic meanings, and the emotional undercurrents of life, they’re imaginative, empathic, and often absorb the energy around them like a sponge.

                    They may drift between reality and fantasy, finding beauty in places others overlook. While their compassion makes them incredibly kind and likable, their sensitivity can leave them vulnerable to overwhelm. Pisces feels most at home in creative, spiritual, or emotionally rich spaces where they can fully express what words cannot.
                    """)
                    .foregroundColor(.white)
                    .padding(.horizontal)

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
                    .padding(.bottom, 30)
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
        HStack(spacing: 6) {
            Text("• \(label)")
                .foregroundColor(.white)
                .font(.system(size: 18, weight: .medium))

            Text(value)
                .foregroundColor(.white)
                .font(.system(size: 18, weight: .medium))
                .fixedSize()

            Spacer()
        }
        .fixedSize(horizontal: true, vertical: false)
    }
}

