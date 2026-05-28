import SwiftUI

struct InnerWorkInfoView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var tapCount = 0
    @State private var showText: [Bool] = Array(repeating: false, count: 6)
    @State private var pulse = false
    @State private var showTitle = false
    @State private var showCircle = false
    @State private var showArrow = false

    let bulletPoints = [
        "Making to-do lists",
        "Dream journaling",
        "Sunbathing",
        "Nature walks",
        "Stargazing",
        "Can you think of others?"
    ]

    var body: some View {
        ZStack {
            // Background
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

            VStack(spacing: 30) {
                Text("What Is Inner Work?")
                    .font(Font.custom("Avenir", size: 26).weight(.bold))
                    .foregroundColor(.white)
                    .padding(.top, 60)
                    .opacity(showTitle ? 1 : 0)
                    .animation(.easeInOut(duration: 1), value: showTitle)

                // Glowing Circle and Paragraph
                if showCircle {
                    ZStack {
                        Circle()
                            .fill(Color.yellow.opacity(0.2))
                            .frame(width: 320, height: 320)
                            .shadow(color: .yellow, radius: 15)
                            .overlay(
                                Circle()
                                    .stroke(Color.yellow.opacity(0.6), lineWidth: 2)
                                    .scaleEffect(pulse ? 1.1 : 1)
                                    .opacity(pulse ? 1 : 0.7)
                                    .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: pulse)
                            )
                            .onAppear { pulse = true }

                        GlowingParagraph(pulse: $pulse)
                    }
                    .transition(.opacity)
                }

                // Bullet points
                if tapCount >= 2 {
                    VStack(spacing: 12) {
                        ForEach(0..<bulletPoints.count, id: \.self) { index in
                            if showText[index] {
                                HStack {
                                    Text("•")
                                        .font(.system(size: 18))
                                        .foregroundColor(.white)
                                    Text(bulletPoints[index])
                                        .font(Font.custom("Avenir", size: 18))
                                        .foregroundColor(.white)
                                }
                                .transition(.opacity)
                            }
                        }
                    }
                    .padding(.top, 10)
                }

                Spacer()
            }
            .padding(.horizontal, 30)

            // Right arrow
            if showArrow {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            navModel.push("InnerWorkSetupView")
                        }) {
                            Image(systemName: "arrow.right.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.white)
                                .shadow(radius: 5)
                                .padding()
                                .opacity(showArrow ? 1 : 0)
                                .animation(.easeInOut(duration: 0.5), value: showArrow)
                        }
                    }
                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            guard tapCount <= bulletPoints.count + 1 else { return }

            withAnimation {
                tapCount += 1

                if tapCount == 1 {
                    showCircle = true
                }

                if tapCount >= 2 && tapCount <= bulletPoints.count + 1 {
                    showText[tapCount - 2] = true
                }

                if tapCount == bulletPoints.count + 1 {
                    showArrow = true
                }
            }
        }
        .onAppear {
            withAnimation {
                showTitle = true
            }
        }
    }
}

// MARK: - Glowing Paragraph
struct GlowingParagraph: View {
    @Binding var pulse: Bool

    var body: some View {
        VStack(spacing: 8) {
            Text("Inner Work is a task we all do as humans to develop something called")
                .font(Font.custom("Avenir", size: 16))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            Text("Mind Power")
                .font(Font.custom("Avenir", size: 16).weight(.medium))
                .foregroundColor(.white)
                .scaleEffect(pulse ? 1.05 : 1)
                .opacity(pulse ? 1 : 0.8)
                .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: pulse)

            Text("This helps us gain clarity and become centered in our minds. Inner Work is commonly done using the combined technique of")
                .font(Font.custom("Avenir", size: 16))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            Text("prayer + meditation")
                .font(Font.custom("Avenir", size: 16).weight(.bold))
                .foregroundColor(.white)

            Text("but other ways to gain Mind Power can include...")
                .font(Font.custom("Avenir", size: 16))
                .foregroundColor(.white)
        }
        .multilineTextAlignment(.center)
        .padding()
    }
}

