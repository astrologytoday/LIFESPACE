import SwiftUI

struct TypingDotsView: View {
    @State private var dotCount: Int = 0
    private let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

    var body: some View {
        Text("Thinking" + String(repeating: ".", count: dotCount))
            .foregroundColor(.white)
            .font(.custom("Avenir", size: 16))
            .lineLimit(1)
            .minimumScaleFactor(0.75)
            .onReceive(timer) { _ in
                dotCount = (dotCount + 1) % 4
            }
    }
}

struct ResultsView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var lifespaceLogModel: LifespaceLogModel
    @EnvironmentObject var userProfile: UserProfileModel
    @EnvironmentObject var lifespaceSyncModel: LifespaceSyncModel

    @State private var showBars = false
    @State private var showText = false
    @State private var selectedBarIndex: Int? = nil
    @State private var barCenters: [CGFloat] = Array(repeating: 0, count: 9)
    @State private var barAnimationPhase: Int = 0
    @State private var pulse = false

    let barGradients: [[Color]] = [
        [Color(red: 0.02, green: 0.38, blue: 0.42), Color(red: 0.20, green: 0.82, blue: 0.50), Color(red: 0.34, green: 1.00, blue: 1.00)],
        [Color(red: 0.08, green: 0.56, blue: 0.60), Color(red: 0.94, green: 0.40, blue: 0.45), Color(red: 0.40, green: 1.00, blue: 1.00)],
        [Color(red: 0.10, green: 0.62, blue: 0.66), Color(red: 0.46, green: 0.48, blue: 0.82), Color(red: 0.42, green: 1.00, blue: 1.00)],
        [Color(red: 0.00, green: 0.34, blue: 0.38), Color(red: 0.92, green: 0.76, blue: 0.22), Color(red: 0.40, green: 1.00, blue: 1.00)],
        [Color(red: 0.00, green: 0.32, blue: 0.36), Color(red: 0.14, green: 0.80, blue: 0.50), Color(red: 0.36, green: 1.00, blue: 1.00)],
        [Color(red: 0.00, green: 0.28, blue: 0.32), Color(red: 0.78, green: 0.30, blue: 0.78), Color(red: 0.32, green: 0.94, blue: 1.00)]
    ]

    let numPhases = 6

    let modules: [LifespaceModule] = [
        .light, .innerWork, .fitness, .eating, .sensory,
        .purpose, .activity, .community, .expression
    ]

    let moduleLabels = Array("LIFESPACE")
    private let darkTeal = Color(red: 0.05, green: 0.35, blue: 0.38)

    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            let maxBarHeight = screenHeight * 0.30
            let lowerMinHeight = max(360, screenHeight * 0.46)

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

                VStack(spacing: 0) {
                    scoreBubble(screenWidth: screenWidth)
                        .frame(height: selectedBarIndex == nil ? 0 : 40)
                        .padding(.top, selectedBarIndex == nil ? 0 : 6)

                    chartArea(screenWidth: screenWidth, maxBarHeight: maxBarHeight)
                        .frame(height: screenHeight * 0.34)

                    if showText {
                        ScrollView(showsIndicators: true) {
                            prescriptionContent(screenWidth: screenWidth)
                                .padding(20)
                                .frame(maxWidth: .infinity, minHeight: lowerMinHeight, alignment: .top)
                                .background(Color.white.opacity(0.13))
                                .cornerRadius(28)
                                .padding(.horizontal, 16)
                                .padding(.top, 12)
                                .padding(.bottom, 110)
                        }
                    } else {
                        VStack {
                            Spacer()
                            TypingDotsView()
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, minHeight: lowerMinHeight)
                        .padding(.bottom, 110)
                    }
                }
                .padding(.top, 18)
            }
            .coordinateSpace(name: "chartSpace")
            .safeAreaInset(edge: .bottom) {
                bottomButtonBar
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 0.4)) { showBars = true }

                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation(.easeIn(duration: 0.8)) { showText = true }
                }

                Timer.scheduledTimer(withTimeInterval: 3.50, repeats: true) { _ in
                    withAnimation(.easeInOut(duration: 3.40)) {
                        barAnimationPhase = (barAnimationPhase + 1) % numPhases
                    }
                }

                lifespaceSyncModel.uploadSharedLifespaceData(
                    lifespaceLogModel: lifespaceLogModel,
                    userProfile: userProfile
                )
            }
        }
    }

    @ViewBuilder
    private func scoreBubble(screenWidth: CGFloat) -> some View {
        ZStack {
            if let index = selectedBarIndex {
                let module = modules[index]
                let score = lifespaceLogModel.score(for: module)

                VStack(spacing: 2) {
                    Text(title(for: module))
                        .font(.caption)
                        .bold()
                        .foregroundColor(darkTeal)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)

                    Text("\(Int(score.rounded()))%")
                        .font(.caption)
                        .bold()
                        .foregroundColor(darkTeal)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.white)
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                .offset(x: bubbleXOffset(for: index, totalWidth: screenWidth))
            }
        }
    }

    private func chartArea(screenWidth: CGFloat, maxBarHeight: CGFloat) -> some View {
        ZStack(alignment: .bottomLeading) {
            VStack(spacing: 0) {
                ForEach([100, 75, 50, 25, 0], id: \.self) { tick in
                    HStack(spacing: 4) {
                        Text("\(tick)")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.9))
                            .frame(width: 30, alignment: .trailing)

                        Rectangle()
                            .fill(Color.white.opacity(tick == 0 ? 0.55 : 0.35))
                            .frame(height: tick == 0 ? 2 : 1)
                    }
                    .frame(height: maxBarHeight / 4)
                }
            }
            .padding(.top, 10)
            .padding(.bottom, 18)

            VStack(spacing: 0) {
                let isIPad = UIDevice.current.userInterfaceIdiom == .pad
                let baseBarWidth = max(18, min(24, screenWidth * 0.055))
                let barWidth = isIPad ? baseBarWidth * 3 : baseBarWidth
                let circleSize = max(26, min(30, screenWidth * 0.068))

                HStack(alignment: .bottom, spacing: 0) {
                    ForEach(modules.indices, id: \.self) { i in
                        let module = modules[i]
                        let height = barHeight(for: module, maxHeight: maxBarHeight)
                        let phase = (barAnimationPhase + i) % numPhases

                        VStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: barGradients[phase]),
                                        startPoint: .bottom,
                                        endPoint: .top
                                    )
                                )
                                .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 4)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(.white.opacity(0.25), lineWidth: 1)
                                )
                                .frame(width: barWidth, height: showBars ? height : 0)
                                .background(
                                    GeometryReader { geo in
                                        Color.clear.onAppear {
                                            barCenters[i] = geo.frame(in: .named("chartSpace")).midX
                                        }
                                    }
                                )
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.25)) {
                                        selectedBarIndex = selectedBarIndex == i ? nil : i
                                    }
                                }

                            Circle()
                                .fill(Color.white.opacity(0.95))
                                .frame(width: circleSize, height: circleSize)
                                .overlay(
                                    Text(String(moduleLabels[i]))
                                        .font(.caption2)
                                        .bold()
                                        .foregroundColor(darkTeal)
                                )
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.25)) {
                                        selectedBarIndex = selectedBarIndex == i ? nil : i
                                    }
                                }
                        }

                        if i != modules.indices.last {
                            Spacer(minLength: 0)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.leading, 50)
                .padding(.trailing, 22)
                .padding(.bottom, 18)
            }
        }
    }

    @ViewBuilder
    private func prescriptionContent(screenWidth: CGFloat) -> some View {
        if allModulesAbove80() {
            VStack(spacing: 18) {
                ZStack {
                    FireworksView()
                        .frame(height: 220)
                        .cornerRadius(18)

                    Text("Your LIFESPACE is looking great!")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                        .minimumScaleFactor(0.7)
                        .frame(maxWidth: .infinity)
                        .shadow(radius: 10)
                        .scaleEffect(pulse ? 1.03 : 0.97)
                        .animation(.easeInOut(duration: 1.1).repeatForever(autoreverses: true), value: pulse)
                }
                .frame(maxWidth: .infinity)
                .onAppear { pulse = true }

                Text("Keep doing what you're doing. You're maintaining a strong mind–body–soul balance.")
                    .font(.custom("Avenir", size: 16))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity)
            }
        } else {
            let recs = recommendedModules()

            VStack(alignment: .leading, spacing: 22) {
                Text("LIFESPACE Prescription")
                    .font(.custom("AvenirNext-Heavy", size: min(30, screenWidth * 0.073)))
                    .textCase(.uppercase)
                    .tracking(1.1)
                    .lineLimit(1)
                    .minimumScaleFactor(0.55)
                    .allowsTightening(true)
                    .foregroundColor(.clear)
                    .overlay(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.96),
                                Color(red: 0.40, green: 1.00, blue: 1.00),
                                Color(red: 0.92, green: 0.76, blue: 0.22)
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .mask(
                            Text("LIFESPACE Prescription")
                                .font(.custom("AvenirNext-Heavy", size: min(30, screenWidth * 0.073)))
                                .textCase(.uppercase)
                                .tracking(1.1)
                                .lineLimit(1)
                                .minimumScaleFactor(0.55)
                                .allowsTightening(true)
                        )
                    )
                    .padding(.vertical, 10)
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(
                        Capsule()
                            .fill(Color.white.opacity(0.12))
                            .overlay(Capsule().stroke(Color.white.opacity(0.35), lineWidth: 1))
                    )
                    .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 6)

                if recs.isEmpty {
                    Text("Everything looks good today! Keep reinforcing the habits that are working.")
                        .font(.custom("Avenir", size: 16))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    Text("Focus on these top priorities in the following week.")
                        .font(.custom("Avenir", size: min(17, screenWidth * 0.043)))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 12)

                    ForEach(Array(recs.prefix(3).enumerated()), id: \.offset) { idx, module in
                        prescriptionBubble(index: idx + 1, module: module, screenWidth: screenWidth)
                    }
                }

                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
    }

    private var bottomButtonBar: some View {
        HStack(spacing: 16) {
            Button { navModel.push("TipsView") } label: {
                HStack {
                    Image(systemName: "star.fill")
                    Text("TIPS").bold()
                }
                .font(.headline)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity, minHeight: 52)
                .background(Color(red: 0.35, green: 0.70, blue: 0.67))
                .cornerRadius(14)
            }

            Button { navModel.push("AnalyticsView") } label: {
                HStack {
                    Image(systemName: "chart.bar.xaxis")
                    Text("ANALYTICS").bold()
                }
                .font(.headline)
                .lineLimit(1)
                .minimumScaleFactor(0.65)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity, minHeight: 52)
                .background(Color(red: 0.35, green: 0.70, blue: 0.67))
                .cornerRadius(14)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 10)
        .padding(.bottom, 8)
        .background(Color(red: 0.10, green: 0.45, blue: 0.45))
    }

    private func bubbleXOffset(for index: Int, totalWidth: CGFloat) -> CGFloat {
        guard barCenters[index] != 0 else { return 0 }
        return barCenters[index] - (totalWidth / 2) - 4
    }

    private func barHeight(for module: LifespaceModule, maxHeight: CGFloat) -> CGFloat {
        CGFloat(lifespaceLogModel.score(for: module) / 100.0) * maxHeight
    }

    private func recommendedModules() -> [LifespaceModule] {
        let sorted = modules.sorted { lifespaceLogModel.score(for: $0) < lifespaceLogModel.score(for: $1) }
        return sorted.filter { lifespaceLogModel.score(for: $0) < 80 }
    }

    private func allModulesAbove80() -> Bool {
        for module in modules {
            if lifespaceLogModel.score(for: module) < 80 { return false }
        }
        return true
    }

    private func title(for module: LifespaceModule) -> String {
        switch module {
        case .light: return "Sunlight"
        case .innerWork: return "Inner Work"
        case .fitness: return "Fitness"
        case .eating: return "Healthy Eating"
        case .sensory: return "Sensory Health"
        case .purpose: return "Purpose"
        case .activity: return "Activity"
        case .community: return "Community"
        case .expression: return "Expression"
        }
    }

    private func description(for module: LifespaceModule) -> String {
        switch module {
        case .light: return "Get at least 15 minutes of sunlight per day."
        case .innerWork: return "Aim for at least 15 minutes of meditation per day to regulate the limbic system."
        case .fitness: return "Try and work in at least 5 minutes of daily vigorous exercise."
        case .eating: return "Cook healthy meals and minimize junk food consumption."
        case .sensory: return "Keep your living space clean."
        case .purpose: return "Work toward meaningful goals that support your life's purpose."
        case .activity: return "Make sure you're getting at least 7 hours of sleep. Find time to do something fun."
        case .community: return "Meet someone new in your community or spend time with friends and family."
        case .expression: return "Take time to do something creative."
        }
    }

    private func prescriptionBubble(index: Int, module: LifespaceModule, screenWidth: CGFloat) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(index).")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 54, height: 54)
                .background(Color.white.opacity(0.20))
                .clipShape(Circle())
                .layoutPriority(0)

            VStack(alignment: .leading, spacing: 6) {
                Text(title(for: module))
                    .font(.custom("Avenir-Heavy", size: 17))
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .layoutPriority(2)

                Text(description(for: module))
                    .font(.custom("Avenir", size: 16))
                    .foregroundColor(.white)
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .layoutPriority(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .layoutPriority(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 6)
    }
}

fileprivate struct FireworkParticle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var velocity: CGVector
    var color: Color
    var size: CGFloat
    var life: Double
    var maxLife: Double
}

struct FireworksView: View {
    @State private var particles: [FireworkParticle] = []
    @State private var lastUpdate: Date = Date()
    @State private var timeSinceLastBurst: Double = 0

    private let gravity: CGFloat = 80.0
    private let drag: CGFloat = 0.18

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let now = timeline.date
                let dt = now.timeIntervalSince(lastUpdate)

                DispatchQueue.main.async {
                    updateParticles(dt: dt, size: size)
                    lastUpdate = now
                }

                for particle in particles {
                    let progress = max(min(particle.life / particle.maxLife, 1.0), 0.0)
                    let baseOpacity = progress
                    let shimmer = 0.6 + 0.4 * sin(progress * 15.0)
                    let opacity = baseOpacity * shimmer

                    let rect = CGRect(
                        x: particle.position.x - particle.size / 2,
                        y: particle.position.y - particle.size / 2,
                        width: particle.size,
                        height: particle.size
                    )

                    context.fill(Path(ellipseIn: rect), with: .color(particle.color.opacity(opacity)))

                    let glowRect = rect.insetBy(dx: -particle.size * 0.6, dy: -particle.size * 0.6)
                    context.fill(Path(ellipseIn: glowRect), with: .color(particle.color.opacity(opacity * 0.25)))
                }
            }
            .blendMode(.screen)
            .clipped()
        }
        .allowsHitTesting(false)
        .onAppear { lastUpdate = Date() }
    }

    private func updateParticles(dt: TimeInterval, size: CGSize) {
        guard dt > 0 else { return }
        let dtf = CGFloat(dt)
        timeSinceLastBurst += dt

        if timeSinceLastBurst > 0.85 {
            spawnBurst(in: size)
            timeSinceLastBurst = 0
        }

        var updated: [FireworkParticle] = []
        updated.reserveCapacity(particles.count)

        for var particle in particles {
            particle.velocity.dy += gravity * dtf
            particle.velocity.dx *= (1 - drag * dtf)
            particle.velocity.dy *= (1 - drag * dtf)
            particle.position.x += particle.velocity.dx * dtf
            particle.position.y += particle.velocity.dy * dtf
            particle.life -= dt

            if particle.life > 0 { updated.append(particle) }
        }

        particles = updated
    }

    private func spawnBurst(in size: CGSize) {
        let origin = CGPoint(
            x: CGFloat.random(in: size.width * 0.15 ... size.width * 0.85),
            y: CGFloat.random(in: size.height * 0.15 ... size.height * 0.55)
        )

        let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple, .pink, .white]
        var newParticles: [FireworkParticle] = []
        let count = Int.random(in: 40...80)

        for _ in 0..<count {
            let angle = CGFloat.random(in: 0...(2 * .pi))
            let speed = CGFloat.random(in: 100...260)
            let velocity = CGVector(dx: cos(angle) * speed, dy: sin(angle) * speed)
            let life = Double.random(in: 1.0...1.8)
            let sizeVal = CGFloat.random(in: 4...10)
            let color = colors.randomElement() ?? .white
            let particle = FireworkParticle(position: origin, velocity: velocity, color: color, size: sizeVal, life: life, maxLife: life)
            newParticles.append(particle)
        }

        particles.append(contentsOf: newParticles)
    }
}
