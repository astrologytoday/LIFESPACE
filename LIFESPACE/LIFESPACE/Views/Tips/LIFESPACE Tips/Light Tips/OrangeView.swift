import SwiftUI

struct OrangeView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var isPulsing = false

    // Easier to reuse consistent darker orange throughout
    private let darkOrange = Color(red: 0.8, green: 0.4, blue: 0.0)

    var body: some View {
        ZStack {
            // 🟠 Orange gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.orange.opacity(0.9),
                    Color(red: 0.90, green: 0.45, blue: 0.05)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    // MARK: - Title
                    VStack(spacing: 4) {
                        Text("The Psychological Effects of")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)

                        Text("ORANGE")
                            .font(.system(size: 40, weight: .heavy))
                            .foregroundColor(darkOrange)
                            .lineLimit(1)
                            .minimumScaleFactor(0.75)
                            .scaleEffect(isPulsing ? 1.08 : 1.0)
                            .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: isPulsing)
                            .onAppear {
                                isPulsing = true
                            }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 24)

                    // MARK: - What Does Orange Do to the Body?
                    sectionHeader(
                        prefix: "What Does ",
                        colorWord: "Orange",
                        suffix: " Do to the Body?",
                        color: darkOrange
                    )

                    VStack(alignment: .leading, spacing: 10) {
                        bulletView(
                            Text("Stimulates creativity and self-expression. ").bold()
                            + Text("It can help you think freely and explore new ideas.")
                        )
                        bulletView(
                            Text("Boosts energy and optimism. ").bold()
                            + Text("Orange is a natural mood enhancer and can help combat feelings of depression or lethargy.")
                        )
                        bulletView(
                            Text("Encourages social interaction. ").bold()
                            + Text("It creates a sense of warmth and openness that draws people together.")
                        )
                    }
                    .foregroundColor(.white)
                    .font(.body)

                    // MARK: - Associations Table
                    associationsTable

                    // MARK: - The Color Orange and Mood
                    sectionHeader(
                        prefix: "The Color ",
                        colorWord: "Orange",
                        suffix: " and Mood",
                        color: darkOrange
                    )

                    VStack(alignment: .leading, spacing: 14) {
                        Text("Orange blends the energy of red with the optimism of yellow, creating a color that radiates warmth, creativity, and enthusiasm.")

                        Text("It’s the color of sunrise and signals new beginnings, vitality, and social connection. Orange awakens the spirit and encourages self-expression while reducing feelings of inhibition or fear.")
                    }
                    .foregroundColor(.white)
                    .font(.body)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)

                    // MARK: - Where to Use Orange
                    sectionHeader(
                        prefix: "Where to Use ",
                        colorWord: "Orange",
                        suffix: "",
                        color: darkOrange
                    )

                    Text("Use orange for spaces that need energy and connection, but not the intensity of red.")
                        .foregroundColor(.white)
                        .font(.body)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)

                    VStack(alignment: .leading, spacing: 10) {
                        bulletView(Text("Living Rooms"))
                        bulletView(Text("Kitchens or Dining Areas"))
                        bulletView(Text("Studios or Offices"))
                        bulletView(Text("Activity Spaces"))
                        bulletView(Text("Entryways"))
                    }
                    .foregroundColor(.white)
                    .font(.body)

                    Spacer(minLength: 40)

                    // MARK: - Bottom Back Button
                    Button(action: {
                        navModel.push("LightTipsView")
                    }) {
                        Text("← Back to Light Tips")
                            .foregroundColor(.white)
                            .font(.body)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.15))
                            .cornerRadius(12)
                    }
                    .padding(.bottom, 60)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
    }

    // MARK: - Section Header
    private func sectionHeader(prefix: String, colorWord: String, suffix: String, color: Color) -> some View {
        (
            Text(prefix).foregroundColor(.white)
            + Text(colorWord).foregroundColor(color).bold()
            + Text(suffix).foregroundColor(.white)
        )
        .font(.title3)
        .fontWeight(.semibold)
        .lineLimit(nil)
        .fixedSize(horizontal: false, vertical: true)
    }

    // MARK: - Bullet View
    private func bulletView(_ text: Text) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
                .foregroundColor(.white)
                .padding(.top, 2)
            text
                .foregroundColor(.white)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    // MARK: - Associations Table
    private var associationsTable: some View {
        VStack(spacing: 10) {

            // Title (Bigger + Bold + Centered)
            Text("Emotional and Psychological Associations")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity)

            // Underline
            Rectangle()
                .fill(Color.white.opacity(0.6))
                .frame(height: 1)
                .padding(.horizontal, 50)
                .padding(.bottom, 4)

            // Associations (Centered + Raised)
            VStack(spacing: 6) {
                Text("Joy and Creativity")
                Text("Warmth and Sociability")
                Text("Courage and Confidence")
                Text("Playfulness")
            }
            .font(.system(size: 17, weight: .regular))
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity)
            .padding(.top, 2)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 16)
        .background(Color.black.opacity(0.2))
        .cornerRadius(18)
    }
}
