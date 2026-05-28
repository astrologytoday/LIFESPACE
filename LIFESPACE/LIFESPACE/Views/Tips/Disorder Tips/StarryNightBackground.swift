import SwiftUI

struct TwinkleStar: Identifiable {
    let id = UUID()
    let position: CGPoint
    let size: CGFloat
    let color: Color
}

struct StarryNightBackground: View {

    let starCount: Int = 40

    let starColors: [Color] = [
        Color(red: 0.02, green: 0.38, blue: 0.42),
        Color(red: 0.20, green: 0.82, blue: 0.50),
        Color(red: 0.34, green: 1.00, blue: 1.00),
        Color(red: 0.08, green: 0.56, blue: 0.60),
        Color(red: 0.94, green: 0.40, blue: 0.45),
        Color(red: 0.40, green: 1.00, blue: 1.00),
        Color(red: 0.10, green: 0.62, blue: 0.66),
        Color(red: 0.46, green: 0.48, blue: 0.82),
        Color(red: 0.42, green: 1.00, blue: 1.00),
        Color(red: 0.00, green: 0.34, blue: 0.38),
        Color(red: 0.92, green: 0.76, blue: 0.22),
        Color(red: 0.40, green: 1.00, blue: 1.00),
        Color(red: 0.00, green: 0.32, blue: 0.36),
        Color(red: 0.14, green: 0.80, blue: 0.50),
        Color(red: 0.36, green: 1.00, blue: 1.00),
        Color(red: 0.00, green: 0.28, blue: 0.32),
        Color(red: 0.78, green: 0.30, blue: 0.78),
        Color(red: 0.32, green: 0.94, blue: 1.00)
    ]

    // Generate stars once — prevents flickering positions
    @State private var stars: [TwinkleStar] = []
    @State private var twinkle: Bool = false

    var body: some View {
        GeometryReader { geo in
            ZStack {

                // Background image
                Image("starry_background")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
                    .ignoresSafeArea()

                // Gentle gradient overlay for contrast
                LinearGradient(
                    colors: [Color.black.opacity(0.25), Color.clear],
                    startPoint: .top, endPoint: .bottom
                )
                .ignoresSafeArea()

                // Twinkling stars
                ForEach(stars) { star in
                    Circle()
                        .fill(star.color)
                        .frame(width: star.size, height: star.size)
                        .position(star.position)
                        .opacity(twinkle ?
                                 Double.random(in: 0.15...1.0) :
                                 Double.random(in: 0.15...1.0))
                        .scaleEffect(twinkle ?
                                      CGFloat.random(in: 0.8...1.25) :
                                      CGFloat.random(in: 0.8...1.25))
                        .animation(
                            .easeInOut(duration: Double.random(in: 1.2...2.6))
                            .repeatForever(),
                            value: twinkle
                        )
                }
            }
            .onAppear {
                // Generate static stars ONCE
                if stars.isEmpty {
                    for _ in 0..<starCount {
                        let position = CGPoint(
                            x: CGFloat.random(in: 0...geo.size.width),
                            y: CGFloat.random(in: 0...geo.size.height)
                        )
                        let size = CGFloat.random(in: 2...4.7)
                        let color = starColors.randomElement() ?? .white

                        stars.append(TwinkleStar(
                            position: position,
                            size: size,
                            color: color
                        ))
                    }
                }

                // Start twinkling animation
                DispatchQueue.main.async {
                    twinkle = true
                }
            }
        }
        .ignoresSafeArea()
    }
}
