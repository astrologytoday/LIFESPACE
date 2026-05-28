import SwiftUI

struct AstrologyView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var contentOpacity: Double = 0.0

    @State private var glowPulse: Bool = false
    @State private var glowPulse2: Bool = false

    // MARK: - Types
    enum Modality: String, CaseIterable {
        case cardinal = "CARDINAL"
        case fixed = "FIXED"
        case mutable = "MUTABLE"
    }

    enum Element: String, CaseIterable {
        case fire = "FIRE"
        case water = "WATER"
        case earth = "EARTH"
        case air = "AIR"
    }

    enum HighlightSelection: Equatable {
        case modality(Modality)
        case element(Element)
    }

    struct ZodiacSign: Identifiable {
        let id = UUID()
        let name: String
        let destination: String
        let modality: Modality
        let element: Element
    }

    // MARK: - Data
    private let zodiacSigns: [ZodiacSign] = [
        .init(name: "Aries",       destination: "AriesView",       modality: .cardinal, element: .fire),
        .init(name: "Taurus",      destination: "TaurusView",      modality: .fixed,    element: .earth),
        .init(name: "Gemini",      destination: "GeminiView",      modality: .mutable,  element: .air),
        .init(name: "Cancer",      destination: "CancerView",      modality: .cardinal, element: .water),
        .init(name: "Leo",         destination: "LeoView",         modality: .fixed,    element: .fire),
        .init(name: "Virgo",       destination: "VirgoView",       modality: .mutable,  element: .earth),
        .init(name: "Libra",       destination: "LibraView",       modality: .cardinal, element: .air),
        .init(name: "Scorpio",     destination: "ScorpioView",     modality: .fixed,    element: .water),
        .init(name: "Sagittarius", destination: "SagittariusView", modality: .mutable,  element: .fire),
        .init(name: "Capricorn",   destination: "CapricornView",   modality: .cardinal, element: .earth),
        .init(name: "Aquarius",    destination: "AquariusView",    modality: .fixed,    element: .air),
        .init(name: "Pisces",      destination: "PiscesView",      modality: .mutable,  element: .water)
    ]

    // MARK: - State
    @State private var selection: HighlightSelection? = nil

    // MARK: - Highlight Helpers
    private func elementTint(_ element: Element) -> Color {
        switch element {
        case .fire:  return .red
        case .water: return .blue
        case .earth: return .green
        case .air:   return .white
        }
    }

    private func signIsHighlighted(_ sign: ZodiacSign) -> Bool {
        switch selection {
        case .modality(let mod):
            return sign.modality == mod
        case .element(let el):
            return sign.element == el
        case .none:
            return false
        }
    }

    private func highlightColorForSign(_ sign: ZodiacSign) -> Color {
        switch selection {
        case .modality:
            return .yellow
        case .element(let el):
            return elementTint(el)
        case .none:
            return .clear
        }
    }

    private func isSelected(_ mod: Modality) -> Bool {
        selection == .modality(mod)
    }

    private func isSelected(_ el: Element) -> Bool {
        selection == .element(el)
    }

    // ✅ Double-tap off switch
    private func toggleSelection(_ newSelection: HighlightSelection) {
        withAnimation(.easeInOut(duration: 0.32)) {
            if selection == newSelection {
                selection = nil
            } else {
                selection = newSelection
            }
        }
    }

    // MARK: - 2–3 Shadow Glow (stacked)
    private struct MultiGlow: ViewModifier {
        let color: Color
        let isOn: Bool
        let pulse1: Bool
        let pulse2: Bool

        func body(content: Content) -> some View {
            let coreOpacity: Double = isOn ? (pulse1 ? 0.72 : 0.22) : 0
            let coreRadius: CGFloat = isOn ? (pulse1 ? 22 : 9) : 0

            let midOpacity: Double = isOn ? (pulse2 ? 0.36 : 0.10) : 0
            let midRadius: CGFloat = isOn ? (pulse2 ? 38 : 18) : 0

            let haloOpacity: Double = isOn ? 0.10 : 0
            let haloRadius: CGFloat = isOn ? 64 : 0

            return content
                .shadow(color: color.opacity(coreOpacity), radius: coreRadius, x: 0, y: 0)
                .shadow(color: color.opacity(midOpacity), radius: midRadius, x: 0, y: 0)
                .shadow(color: color.opacity(haloOpacity), radius: haloRadius, x: 0, y: 0)
        }
    }

    private func glow(_ color: Color, on: Bool) -> some ViewModifier {
        MultiGlow(color: color, isOn: on, pulse1: glowPulse, pulse2: glowPulse2)
    }

    // MARK: - UI Pieces
    private func pillButton(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 44)
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 999)
                            .fill(Color.white.opacity(0.18))

                        RoundedRectangle(cornerRadius: 999)
                            .fill(Color.yellow.opacity(0.26))
                            .opacity(isSelected ? 1 : 0)
                    }
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 999)
                        .stroke(isSelected ? Color.yellow.opacity(0.05) : Color.white.opacity(0.22), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.18), radius: 6, x: 0, y: 3)
                .modifier(glow(.yellow, on: isSelected))
                .animation(.easeInOut(duration: 0.32), value: isSelected)
        }
        .buttonStyle(.plain)
    }

    // ✅ (Fire/Water outline intensity lowered via outlineOpacitySelected)
    private func elementSquare(
        title: String,
        tint: Color,
        isSelected: Bool,
        outlineOpacitySelected: Double = 0.05,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 74)
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.18))

                        RoundedRectangle(cornerRadius: 10)
                            .fill(tint.opacity(tint == .white ? 0.22 : 0.26))
                            .opacity(isSelected ? 1 : 0)
                    }
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isSelected ? tint.opacity(outlineOpacitySelected) : Color.white.opacity(0.22), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.16), radius: 6, x: 0, y: 3)
                .modifier(glow(tint, on: isSelected))
                .animation(.easeInOut(duration: 0.32), value: isSelected)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Body
    var body: some View {
        ZStack {
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
                Spacer(minLength: 10)

                Text("ASTROLOGY")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .white.opacity(0.28), radius: 10, x: 0, y: 0)
                    .shadow(color: .black.opacity(0.30), radius: 3, x: 0, y: 2)
                    .shadow(color: .white.opacity(0.7), radius: 10)
                    .frame(maxWidth: .infinity, alignment: .center)

                Text("Tap your sign to explore your archetype, personality traits, and cosmic insights.")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.bottom, 18) // ✅ more space before signs

                LazyVGrid(
                    columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 3),
                    spacing: 16
                ) {
                    ForEach(zodiacSigns) { sign in
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                navModel.push(sign.destination)
                            }
                        }) {
                            let highlighted = signIsHighlighted(sign)
                            let tint = highlightColorForSign(sign)

                            Text(sign.name.uppercased())
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, minHeight: 60)
                                .background(
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.white.opacity(0.20))

                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(tint.opacity(tint == .white ? 0.20 : 0.26))
                                            .opacity(highlighted ? 1 : 0)
                                    }
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(highlighted ? tint.opacity(0.05) : Color.white.opacity(0.18), lineWidth: 1)
                                )
                                .shadow(color: .black.opacity(0.18), radius: 6, x: 0, y: 3)
                                .modifier(glow(tint, on: highlighted)) // ✅ stacked glow on signs
                                .animation(.easeInOut(duration: 0.32), value: highlighted)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 18) // ✅ more space before divider

                Rectangle()
                    .fill(Color.white.opacity(0.28))
                    .frame(height: 1)
                    .padding(.horizontal)
                    .padding(.bottom, 22) // ✅ more space before control buttons

                HStack(alignment: .top, spacing: 16) {
                    VStack(spacing: 14) {
                        pillButton(
                            title: Modality.cardinal.rawValue,
                            isSelected: isSelected(.cardinal),
                            action: { toggleSelection(.modality(.cardinal)) }
                        )

                        pillButton(
                            title: Modality.fixed.rawValue,
                            isSelected: isSelected(.fixed),
                            action: { toggleSelection(.modality(.fixed)) }
                        )

                        pillButton(
                            title: Modality.mutable.rawValue,
                            isSelected: isSelected(.mutable),
                            action: { toggleSelection(.modality(.mutable)) }
                        )
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    VStack(spacing: 12) {
                        HStack(spacing: 12) {
                            elementSquare(
                                title: Element.fire.rawValue,
                                tint: elementTint(.fire),
                                isSelected: isSelected(.fire),
                                outlineOpacitySelected: 0.05, // ✅ softer red outline
                                action: { toggleSelection(.element(.fire)) }
                            )
                            elementSquare(
                                title: Element.water.rawValue,
                                tint: elementTint(.water),
                                isSelected: isSelected(.water),
                                outlineOpacitySelected: 0.05, // ✅ softer blue outline
                                action: { toggleSelection(.element(.water)) }
                            )
                        }
                        HStack(spacing: 12) {
                            elementSquare(
                                title: Element.earth.rawValue,
                                tint: elementTint(.earth),
                                isSelected: isSelected(.earth),
                                outlineOpacitySelected: 0.05,
                                action: { toggleSelection(.element(.earth)) }
                            )
                            elementSquare(
                                title: Element.air.rawValue,
                                tint: elementTint(.air),
                                isSelected: isSelected(.air),
                                outlineOpacitySelected: 0.05,
                                action: { toggleSelection(.element(.air)) }
                            )
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.horizontal)
                .padding(.top, 2)

                Spacer(minLength: 10)

                Button(action: {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        navModel.pop()
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 34, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(30)
                        .background(Color.white.opacity(0.20))
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 6)
                }
                .padding(.bottom, 28)
            }
            .opacity(contentOpacity)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.6)) {
                    contentOpacity = 1.0
                }

                withAnimation(.easeInOut(duration: 0.75).repeatForever(autoreverses: true)) {
                    glowPulse = true
                }
                withAnimation(.easeInOut(duration: 1.35).repeatForever(autoreverses: true)) {
                    glowPulse2 = true
                }
            }
        }
    }
}
