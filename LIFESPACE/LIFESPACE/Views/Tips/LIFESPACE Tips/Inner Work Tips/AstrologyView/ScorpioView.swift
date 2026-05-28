import SwiftUI

struct ScorpioView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var contentOpacity: Double = 0.0

    private let topPurple = Color(red: 0.08, green: 0.05, blue: 0.20)
    private let bottomPurple = Color(red: 0.02, green: 0.00, blue: 0.10)

    var body: some View {
        GeometryReader { geo in
            let screenWidth = geo.size.width
            let isCompact = screenWidth < 390
            let imageSize = min(screenWidth * 0.44, 190)
            let symbolSize = min(screenWidth * 0.34, 150)
            let horizontalPadding = max(20, screenWidth * 0.07)

            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [topPurple, bottomPurple]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: isCompact ? 16 : 20) {

                        Image("scorpio-chart")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .scaledToFit()
                            .frame(width: imageSize)
                            .shadow(radius: 12)
                            .padding(.top, 28)

                        Text("October 23 – November 21")
                            .font(.system(size: isCompact ? 18 : 20, weight: .medium))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .minimumScaleFactor(0.8)
                            .lineLimit(1)
                            .padding(.horizontal, horizontalPadding)

                        if isCompact {
                            VStack(spacing: 18) {
                                infoSection(fontSize: 16)

                                Image("scorpio-symbol")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(.white)
                                    .scaledToFit()
                                    .frame(width: symbolSize, height: symbolSize)
                                    .shadow(radius: 10)
                            }
                            .padding(.horizontal, horizontalPadding)
                        } else {
                            HStack(alignment: .center, spacing: 18) {
                                infoSection(fontSize: screenWidth > 700 ? 21 : 18)

                                Image("scorpio-symbol")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(.white)
                                    .scaledToFit()
                                    .frame(width: symbolSize, height: symbolSize)
                                    .shadow(radius: 10)
                            }
                            .padding(.horizontal, horizontalPadding)
                        }

                        Divider()
                            .background(Color.white.opacity(0.8))
                            .padding(.horizontal, horizontalPadding)

                        Text("""
                        Scorpio energy is intense, private, and emotionally profound. Those born under this sign feel things deeply and are often drawn to the hidden layers of life, mystery, transformation, and personal power. Ruled by both Pluto and Mars, Scorpio is connected to sexuality, rebirth, and the inner drive to evolve.

                        They possess strong willpower, magnetic presence, and the ability to influence others without saying much. When focused, they can cut through illusion and uncover truth like no other sign. Scorpio’s strength lies in their depth. They don’t fear the dark, because they’re built to transform through it.
                        """)
                        .font(.system(size: screenWidth > 700 ? 22 : 17))
                        .foregroundColor(.white)
                        .lineSpacing(5)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, horizontalPadding)

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
                        .padding(.top, 8)
                        .padding(.bottom, 36)
                    }
                    .frame(maxWidth: 760)
                    .frame(maxWidth: .infinity)
                    .opacity(contentOpacity)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.6)) {
                            contentOpacity = 1.0
                        }
                    }
                }
            }
        }
    }

    private func infoSection(fontSize: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            infoRow(label: "Symbol:", value: "Scorpion", fontSize: fontSize)
            infoRow(label: "Ruling Planet:", value: "Mars ♂", fontSize: fontSize)
            infoRow(label: "Element:", value: "Water 🜄", fontSize: fontSize)
            infoRow(label: "Mode:", value: "Fixed", fontSize: fontSize)
            infoRow(label: "Keyword:", value: "Transform", fontSize: fontSize)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func infoRow(label: String, value: String, fontSize: CGFloat) -> some View {
        HStack(alignment: .top, spacing: 6) {
            Text("• \(label)")
                .font(.system(size: fontSize, weight: .semibold))
                .foregroundColor(.white)
                .layoutPriority(1)

            Text(value)
                .font(.system(size: fontSize, weight: .medium))
                .foregroundColor(.white)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 0)
        }
    }
}
