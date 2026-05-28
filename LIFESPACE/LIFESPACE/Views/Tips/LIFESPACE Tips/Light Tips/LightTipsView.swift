import SwiftUI

struct LightTipsView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var appeared = false

    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let horizontalPadding = max(26, screenWidth * 0.075)

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
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Light Tips")
                            .font(.system(size: min(40, screenWidth * 0.105), weight: .bold))
                            .foregroundColor(.white)
                            .shadow(radius: 4)
                            .padding(.top, 12)

                        Text("To make your world brighter, warmer,\nand more welcoming")
                            .font(.system(size: min(22, screenWidth * 0.055)))
                            .italic()
                            .foregroundColor(Color.white.opacity(0.95))
                            .fixedSize(horizontal: false, vertical: true)

                        DictionaryCard(
                            headword: "Spectrum Health",
                            partOfSpeech: "noun",
                            definition: "1: the state of physical, emotional, and cognitive well-being as influenced by the quality, intensity, and wavelength of light in a given environment.",
                            screenWidth: screenWidth
                        )

                        HStack(alignment: .top, spacing: max(18, screenWidth * 0.06)) {
                            KelvinModule(moduleSize: min(150, screenWidth * 0.36))
                                .frame(maxWidth: .infinity)

                            ColorWheelModule(size: min(150, screenWidth * 0.36))
                                .frame(maxWidth: .infinity)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 18)
                    }
                    .padding(.horizontal, horizontalPadding)
                    .padding(.top, 72)
                    .padding(.bottom, 160)
                    .opacity(appeared ? 1 : 0)
                    .animation(.easeInOut(duration: 0.6), value: appeared)
                }

                BackButtonView(customTarget: "TipsView")
                    .padding(.top, 12)
                    .padding(.leading, horizontalPadding)

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            navModel.push("HomeView")
                        }) {
                            ZStack {
                                Circle()
                                    .fill(LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.white.opacity(0.9),
                                            Color.white.opacity(0.6)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ))
                                    .frame(width: 60, height: 60)
                                    .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 6)

                                Image(systemName: "house.fill")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(Color(red: 0.10, green: 0.45, blue: 0.45))
                            }
                        }
                        .padding(.trailing, horizontalPadding)
                        .padding(.bottom, 22)
                    }
                }
            }
            .onAppear { appeared = true }
            .transition(.opacity)
        }
    }
}

// MARK: - Dictionary Card

private struct DictionaryCard: View {
    let headword: String
    let partOfSpeech: String
    let definition: String
    let screenWidth: CGFloat

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.12))
                .blur(radius: 16)

            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.18))
                .overlay(
                    HStack(spacing: 0) {
                        Rectangle()
                            .fill(Color.white.opacity(0.55))
                            .frame(width: 3)
                            .padding(.vertical, 18)
                            .padding(.leading, 16)
                        Spacer()
                    }
                )
                .shadow(color: .black.opacity(0.18), radius: 12, x: 0, y: 8)

            VStack(alignment: .leading, spacing: 8) {
                Text(headword)
                    .font(.system(size: min(28, screenWidth * 0.07), weight: .semibold, design: .serif))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                Text(partOfSpeech)
                    .font(.system(size: min(16, screenWidth * 0.042), weight: .semibold, design: .serif))
                    .foregroundColor(Color.white.opacity(0.85))
                    .textCase(.lowercase)
                    .padding(.bottom, 6)

                Text(definition)
                    .font(.system(size: min(18, screenWidth * 0.046), weight: .regular, design: .serif))
                    .foregroundColor(Color.white.opacity(0.95))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.vertical, 20)
            .padding(.leading, 30)
            .padding(.trailing, 22)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Kelvin Module

private struct KelvinModule: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var lightModel: LightModel

    @State private var kelvin: Double = 3500

    let moduleSize: CGFloat
    let imageName = "lightbulb_outline"

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(glowColor(for: kelvin))
                    .frame(width: moduleSize * 1.3, height: moduleSize * 1.3)
                    .blur(radius: 30)
                    .opacity(0.85)

                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: moduleSize, height: moduleSize)
                    .overlay {
                        Text("\(Int(kelvin))K")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundColor(.black)
                            .offset(y: -4)
                    }
            }

            VStack(spacing: 6) {
                Slider(value: $kelvin, in: 0...5500, step: 1, onEditingChanged: { editing in
                    if !editing {
                        let intKelvin = Int(kelvin)
                        lightModel.selectedKelvin = intKelvin

                        withAnimation(.easeInOut(duration: 0.4)) {
                            if kelvin <= 3000 {
                                navModel.push("WarmLightView")
                            } else if kelvin <= 3999 {
                                navModel.push("NeutralLightView")
                            } else {
                                navModel.push("CoolLightView")
                            }
                        }
                    }
                })
                .tint(.white)
                .frame(width: moduleSize)

                HStack {
                    Text("0K")
                    Spacer()
                    Text("5500K")
                }
                .font(.caption)
                .foregroundColor(.white.opacity(0.9))
                .frame(width: moduleSize)
            }
            .padding(.top, 4)
        }
    }

    private func glowColor(for kelvin: Double) -> Color {
        let k = max(2700, min(kelvin, 5500))

        let colorStops: [(kelvin: Double, color: Color)] = [
            (2700, Color(red: 1.0, green: 0.835, blue: 0.5)),
            (3000, Color(red: 1.0, green: 0.937, blue: 0.835)),
            (3500, Color(red: 0.97, green: 0.97, blue: 0.97)),
            (4000, Color(red: 0.95, green: 0.96, blue: 1.0)),
            (5000, Color.white)
        ]

        for i in 0..<colorStops.count - 1 {
            let lower = colorStops[i]
            let upper = colorStops[i + 1]

            if k >= lower.kelvin && k <= upper.kelvin {
                let t = (k - lower.kelvin) / (upper.kelvin - lower.kelvin)
                return interpolateColor(from: lower.color, to: upper.color, fraction: t)
            }
        }

        return Color.white
    }

    private func interpolateColor(from: Color, to: Color, fraction: Double) -> Color {
        let fromComponents = UIColor(from).cgColor.components ?? [1, 1, 1]
        let toComponents = UIColor(to).cgColor.components ?? [1, 1, 1]

        let r = fromComponents[0] + (toComponents[0] - fromComponents[0]) * fraction
        let g = fromComponents[1] + (toComponents[1] - fromComponents[1]) * fraction
        let b = fromComponents[2] + (toComponents[2] - fromComponents[2]) * fraction

        return Color(red: r, green: g, blue: b)
    }
}

// MARK: - Color Wheel Module

private struct ColorWheelModule: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var hue: CGFloat = 0.0
    @State private var dragPoint: CGPoint?

    let size: CGFloat

    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(Color.black.opacity(0.08), lineWidth: 1)
                .background(
                    Circle().fill(AngularGradient(
                        gradient: Gradient(colors: [
                            .red, .orange, .yellow, .green, .blue, .indigo, .purple, .red
                        ]),
                        center: .center
                    ))
                )
                .frame(width: size, height: size)
                .gesture(dragGesture)

            if let point = dragPoint {
                Circle()
                    .stroke(Color.white, lineWidth: 3)
                    .frame(width: 20, height: 20)
                    .position(point)
                    .shadow(radius: 2)
            }
        }
        .frame(width: size, height: size + 30)
    }

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                let center = CGPoint(x: size / 2, y: size / 2)
                let dx = value.location.x - center.x
                let dy = value.location.y - center.y
                let angle = atan2(dy, dx)
                let deg = (angle < 0 ? angle + 2 * .pi : angle) * 180 / .pi
                hue = CGFloat(deg / 360)

                let dist = max(1, sqrt(dx * dx + dy * dy))
                let maxR = size / 2
                let clamped = min(dist, maxR)
                let ux = dx / dist
                let uy = dy / dist
                dragPoint = CGPoint(x: center.x + clamped * ux, y: center.y + clamped * uy)
            }
            .onEnded { _ in
                routeForHue(hue)
            }
    }

    private func routeForHue(_ h: CGFloat) {
        let deg = Double(h * 360)

        switch deg {
        case 330..<360, 0..<26:
            navModel.push("RedView")
        case 26..<77:
            navModel.push("OrangeView")
        case 77..<128:
            navModel.push("YellowView")
        case 128..<179:
            navModel.push("GreenView")
        case 179..<230:
            navModel.push("BlueView")
        case 230..<281:
            navModel.push("IndigoView")
        default:
            navModel.push("VioletView")
        }
    }
}
