import SwiftUI

struct EatingTipsView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var appeared = false

    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            let safeBottom = geometry.safeAreaInsets.bottom
            let horizontalPadding = max(20, screenWidth * 0.06)
            let footerHeight: CGFloat = max(80, screenHeight * 0.11)
            let footerBottomPadding: CGFloat = max(20, safeBottom + 10)

            ZStack(alignment: .topLeading) {
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
                    VStack(alignment: .leading, spacing: max(16, screenHeight * 0.02)) {
                        Text("Eating Tips")
                            .font(.system(size: min(42, screenWidth * 0.105), weight: .bold))
                            .foregroundColor(.white)
                            .shadow(radius: 4)
                            .padding(.top, 8)

                        Text("To give your mind and body the fuel that it needs")
                            .font(.system(size: min(20, screenWidth * 0.052)))
                            .italic()
                            .foregroundColor(Color.white.opacity(0.95))
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)

                        DictionaryCard(
                            headword: "Orthomolecular Diet",
                            partOfSpeech: "noun",
                            definition: "1: a pattern of nutrition based on providing optimal amounts of natural substances to the body to support physical and mental health at the molecular level.",
                            screenWidth: screenWidth
                        )

                        // Improved Brain/Burger diagram section
                        HStack {
                            Spacer()
                            BrainWithBubbles(screenWidth: screenWidth, screenHeight: screenHeight)
                            Spacer()
                        }
                        .padding(.vertical, max(12, screenHeight * 0.015))
                    }
                    .padding(.horizontal, horizontalPadding)
                    .padding(.top, 68)
                    .padding(.bottom, footerHeight + footerBottomPadding + 70)
                    .opacity(appeared ? 1 : 0)
                    .animation(.easeInOut(duration: 0.6), value: appeared)
                }

                BackButtonView(customTarget: "TipsView")
                    .padding(.top, 12)
                    .padding(.leading, horizontalPadding)

                VStack {
                    Spacer()
                    footerButtons(screenWidth: screenWidth, bottomPadding: footerBottomPadding)
                        .frame(height: footerHeight + footerBottomPadding)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.10, green: 0.45, blue: 0.45).opacity(0.0),
                                    Color(red: 0.10, green: 0.45, blue: 0.45).opacity(0.92)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                }
            }
            .onAppear { appeared = true }
            .transition(.opacity)
        }
    }

    private func footerButtons(screenWidth: CGFloat, bottomPadding: CGFloat) -> some View {
        let buttonSize = max(52, min(68, screenWidth * 0.155))
        let spacing = max(12, screenWidth * 0.04)

        return HStack(spacing: spacing) {
            FooterIconButton(systemName: "info.circle", size: buttonSize) {
                navModel.push("EatingInformationView")
            }
            FooterIconButton(systemName: "magnifyingglass", size: buttonSize) {
                navModel.push("RecipeIndexView")
            }
            FooterIconButton(systemName: "note.text", size: buttonSize) {
                navModel.push("MyRecipesView")
            }
            FooterIconButton(systemName: "heart.fill", size: buttonSize) {
                navModel.push("FavoriteRecipesView")
            }
        }
        .padding(.horizontal, 8)
        .padding(.top, 8)
        .padding(.bottom, bottomPadding)
        .frame(maxWidth: .infinity)
    }
}

// MARK: - BrainWithBubbles (now more responsive)
private struct BrainWithBubbles: View {
    @EnvironmentObject var navModel: NavigationModel
    
    let screenWidth: CGFloat
    let screenHeight: CGFloat

    private var diagramSize: CGFloat {
        min(310, screenWidth * 0.78, screenHeight * 0.38)
    }

    private var scale: CGFloat {
        diagramSize / 310
    }

    var body: some View {
        ZStack {
            Image("brain_diagram")  // or whatever your burger image is named
                .resizable()
                .scaledToFit()
                .frame(width: diagramSize * 1.65, height: diagramSize * 1.65)
                .offset(x: -diagramSize * 0.20)

            // Bubbles with tighter positioning and smaller sizes on narrow screens
            PulsingLinkBubble(title: "EPINEPHRINE", width: 118 * scale, height: 34 * scale, fontSize: 12.5 * scale) {
                navModel.push("EpinephrineView")
            }
            .offset(x: 108 * scale, y: -108 * scale)

            PulsingLinkBubble(title: "ACETYLCHOLINE", width: 124 * scale, height: 36 * scale, fontSize: 12.5 * scale) {
                navModel.push("AcetylcholineView")
            }
            .offset(x: 125 * scale, y: -52 * scale)

            PulsingLinkBubble(title: "GABA", width: 94 * scale, height: 30 * scale, fontSize: 12 * scale) {
                navModel.push("GABAView")
            }
            .offset(x: 142 * scale, y: 6 * scale)

            PulsingLinkBubble(title: "DOPAMINE", width: 104 * scale, height: 34 * scale, fontSize: 12.5 * scale) {
                navModel.push("DopamineView")
            }
            .offset(x: 144 * scale, y: 64 * scale)

            PulsingLinkBubble(title: "SEROTONIN", width: 116 * scale, height: 34 * scale, fontSize: 12.5 * scale) {
                navModel.push("SerotoninView")
            }
            .offset(x: 119 * scale, y: 118 * scale)
        }
        .frame(width: diagramSize, height: diagramSize * 1.05)  // slight extra height for bubbles
    }
}

// MARK: - PulsingLinkBubble (minor tweaks for small screens)
private struct PulsingLinkBubble: View {
    let title: String
    let width: CGFloat
    let height: CGFloat
    let fontSize: CGFloat
    let action: () -> Void

    @State private var pulsing = false

    var body: some View {
        Button(action: action) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.18))
                .frame(width: width, height: height)
                .overlay(
                    Text(title)
                        .font(.system(size: fontSize, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.65)
                        .padding(.horizontal, 6)
                )
                .scaleEffect(pulsing ? 1.04 : 1.00)
                .animation(.easeInOut(duration: 1.35).repeatForever(autoreverses: true), value: pulsing)
        }
        .buttonStyle(.plain)
        .onAppear { pulsing = true }
    }
}

// FooterIconButton and DictionaryCard remain mostly the same, but here's a tweaked DictionaryCard for better small-screen behavior:

private struct DictionaryCard: View {
    let headword: String
    let partOfSpeech: String
    let definition: String
    let screenWidth: CGFloat

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.18))

            VStack(alignment: .leading, spacing: 10) {
                Text(headword)
                    .font(.system(size: min(27, screenWidth * 0.068), weight: .semibold, design: .serif))
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                    .fixedSize(horizontal: false, vertical: true)

                Text(partOfSpeech)
                    .font(.system(size: min(15.5, screenWidth * 0.04), weight: .semibold, design: .serif))
                    .foregroundColor(Color.white.opacity(0.85))

                Text(definition)
                    .font(.system(size: min(17, screenWidth * 0.044), design: .serif))
                    .foregroundColor(Color.white.opacity(0.95))
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(22)
        }
        .frame(maxWidth: .infinity)
    }
}
// MARK: - Footer Button

private struct FooterIconButton: View {
    let systemName: String
    let size: CGFloat
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Circle()
                .fill(Color.white.opacity(0.25))
                .frame(width: size, height: size)
                .overlay(
                    Image(systemName: systemName)
                        .font(.system(size: size * 0.42, weight: .bold))
                        .foregroundColor(.white)
                )
        }
        .buttonStyle(.plain)
    }
}
