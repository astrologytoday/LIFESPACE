import SwiftUI

struct AquariusView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var contentOpacity: Double = 0.0

    private let topBlue = Color(red: 0.10, green: 0.20, blue: 0.35)
    private let bottomBlue = Color(red: 0.05, green: 0.10, blue: 0.20)

    var body: some View {
        GeometryReader { geo in
            let screenWidth = geo.size.width
            let isCompact = screenWidth < 390
            let chartSize = min(screenWidth * 0.44, 190)
            let symbolSize = min(screenWidth * 0.34, 150)
            let horizontalPadding = max(20, screenWidth * 0.07)

            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [topBlue, bottomBlue]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: isCompact ? 16 : 20) {
                        Image("aquarius-chart")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .scaledToFit()
                            .frame(width: chartSize)
                            .shadow(radius: 12)
                            .padding(.top, 28)

                        Text("January 20 – February 18")
                            .font(.system(size: isCompact ? 18 : 20, weight: .medium))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .minimumScaleFactor(0.8)
                            .lineLimit(1)
                            .padding(.horizontal, horizontalPadding)

                        if isCompact {
                            VStack(spacing: 18) {
                                infoSection(fontSize: 16)

                                Image("aquarius-symbol")
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

                                Image("aquarius-symbol")
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
                        Aquarius is inventive, unconventional, and wired for big-picture thinking. Ruled by both Uranus and Saturn, Aquarians challenge norms while staying committed to their ideals. They often see the world through a unique mental lens, blending logic, innovation, and a deep concern for humanity.

                        Known for their individuality and intellectual depth, they’re natural problem-solvers with a gift for forward-thinking ideas. Though they may seem emotionally detached at times, they care deeply about collective progress and meaningful connection. Aquarius thrives in community, especially when they're helping shape the future.
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
            infoRow(label: "Symbol:", value: "Water Bearer", fontSize: fontSize)
            infoRow(label: "Ruling Planet:", value: "Saturn ♄", fontSize: fontSize)
            infoRow(label: "Element:", value: "Air 🜁", fontSize: fontSize)
            infoRow(label: "Mode:", value: "Fixed", fontSize: fontSize)
            infoRow(label: "Keyword:", value: "Network", fontSize: fontSize)
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
