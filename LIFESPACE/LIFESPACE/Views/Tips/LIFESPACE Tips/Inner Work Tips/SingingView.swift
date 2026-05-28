import SwiftUI

struct SingingView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var showContent = false

    var body: some View {
        ZStack {

            // Teal Gradient Background
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

            // Subtle floating particles background
            ParticlesBackground()
                .opacity(0.3)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 32) {

                    Text("SINGING")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .white.opacity(0.28), radius: 10, x: 0, y: 0)
                        .shadow(color: .black.opacity(0.30), radius: 3, x: 0, y: 2)
                        .shadow(color: .white.opacity(0.7), radius: 10)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : -30)
                        .animation(.easeOut(duration: 0.8).delay(0.2), value: showContent)

                    BenefitSection(
                        title: "Mental & Emotional Benefits",
                        benefits: [
                            ("Reduces stress and anxiety", "Singing calms the nervous system by slowing your breathing and activating the vagus nerve. It lowers cortisol and releases endorphins, creating emotional relief."),
                            ("Improves mood and emotional release", "Whether you're singing something sad or joyful, you're allowing emotion to move through your body. This creates psychological catharsis."),
                            ("Supports emotional regulation", "The breathwork behind singing soothes the emotional centers of the brain, helping you feel your feelings without being overwhelmed.")
                        ],
                        icon: "music.note",
                        delay: 0.4
                    )

                    CustomDivider()

                    BenefitSection(
                        title: "Neurological & Cognitive Benefits",
                        benefits: [
                            ("Stimulates both sides of the brain", "Singing engages language, melody, memory, and motor control, activating both hemispheres of the brain and enhancing coordination."),
                            ("Boosts memory and cognitive clarity", "Learning lyrics and melodies builds strong neural pathways. Singing has helped people regain speech after stroke or trauma."),
                            ("Enhances brain plasticity", "Regular singing sharpens rhythm, timing, attention, and adaptability, improving mental flexibility and focus.")
                        ],
                        icon: "brain",
                        delay: 0.6
                    )

                    // ✅ Static back button at bottom of scroll content (only visible when you reach bottom)
                    HStack {
                        Spacer()

                        Button {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                navModel.pop()
                            }
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 26, weight: .heavy))
                                .foregroundColor(.white)
                                .frame(width: 74, height: 74)
                                .background(Color.white.opacity(0.18))
                                .clipShape(Circle())
                                .overlay(
                                    Circle().stroke(Color.white.opacity(0.22), lineWidth: 1)
                                )
                                .shadow(color: .black.opacity(0.28), radius: 14, x: 0, y: 10)
                        }
                        .buttonStyle(.plain)

                        Spacer()
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 34)
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 16)
                    .animation(.easeOut(duration: 0.7).delay(0.95), value: showContent)
                }
                .padding(.horizontal, 20)
                .padding(.top, 22)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                showContent = true
            }
        }
    }

    // MARK: - Nested components

    private struct BenefitSection: View {
        let title: String
        let benefits: [(String, String)]
        let icon: String
        let delay: Double

        @State private var appear = false

        var body: some View {
            VStack(alignment: .leading, spacing: 20) {
                Text(title)
                    .font(.title2.bold())
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)

                ForEach(benefits.indices, id: \.self) { index in
                    HStack(alignment: .top, spacing: 14) {
                        Image(systemName: icon)
                            .foregroundColor(.white.opacity(0.8))
                            .font(.title3)
                            .offset(y: 2)
                            .scaleEffect(appear ? 1 : 0.5)
                            .opacity(appear ? 1 : 0)
                            .animation(
                                .spring(response: 0.6, dampingFraction: 0.7)
                                    .delay(delay + Double(index) * 0.15),
                                value: appear
                            )

                        VStack(alignment: .leading, spacing: 6) {
                            Text(benefits[index].0)
                                .font(.headline)
                                .foregroundColor(.white)

                            Text(benefits[index].1)
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.92))
                                .lineSpacing(4)
                        }
                    }
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(Color.white.opacity(0.3), lineWidth: 1)
                    )
            )
            .shadow(color: .black.opacity(0.25), radius: 15, x: 0, y: 8)
            .opacity(appear ? 1 : 0)
            .offset(y: appear ? 0 : 30)
            .onAppear {
                withAnimation(.easeOut(duration: 0.9).delay(delay)) {
                    appear = true
                }
            }
        }
    }

    private struct CustomDivider: View {
        var body: some View {
            HStack {
                Rectangle()
                    .fill(Color.white.opacity(0.2))
                    .frame(height: 1)

                Image(systemName: "sparkles")
                    .foregroundColor(.white)
                    .font(.title3)
                    .shadow(color: .white, radius: 8)

                Rectangle()
                    .fill(Color.white.opacity(0.2))
                    .frame(height: 1)
            }
            .padding(.vertical, 8)
        }
    }

    private struct ParticlesBackground: View {
        var body: some View {
            GeometryReader { proxy in
                ZStack {
                    ForEach(0..<8) { i in
                        Circle()
                            .fill(Color.white.opacity(0.15))
                            .frame(width: CGFloat.random(in: 4...12))
                            .offset(
                                x: CGFloat.random(in: -proxy.size.width/2...proxy.size.width/2),
                                y: CGFloat.random(in: -proxy.size.height...proxy.size.height)
                            )
                            .animation(
                                Animation.easeInOut(duration: Double.random(in: 10...20))
                                    .repeatForever(autoreverses: true),
                                value: UUID()
                            )
                            .offset(y: sin(Double(i) * 0.5) * 30)
                    }
                }
            }
        }
    }
}
