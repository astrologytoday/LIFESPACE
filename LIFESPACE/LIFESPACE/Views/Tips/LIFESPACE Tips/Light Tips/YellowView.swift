import SwiftUI

struct YellowView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var isPulsing = false

    // Darker yellow for visibility
    private let darkYellow = Color(red: 0.80, green: 0.70, blue: 0.05)

    var body: some View {
        ZStack {
            // 🟡 Yellow gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 1.0, green: 0.9, blue: 0.4),
                    Color(red: 1.0, green: 0.8, blue: 0.1)
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
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)

                        Text("YELLOW")
                            .font(.system(size: 40, weight: .heavy))
                            .foregroundColor(darkYellow)
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

                    // MARK: - What Does Yellow Do to the Body?
                    sectionHeader(
                        prefix: "What Does ",
                        colorWord: "Yellow",
                        suffix: " Do to the Body?",
                        color: darkYellow
                    )

                    VStack(alignment: .leading, spacing: 10) {
                        bulletView(
                            Text("Increases concentration and alertness. ").bold()
                            + Text("Ideal for learning or creative thinking.")
                        )
                        bulletView(
                            Text("Stimulates appetite and positivity. ").bold()
                            + Text("Can reduce fatigue and mild depression.")
                        )
                        bulletView(
                            Text("Encourages communication and sociability. ").bold()
                            + Text("It opens people up emotionally and mentally.")
                        )
                    }
                    .foregroundColor(.black)
                    .font(.body)

                    // MARK: - Associations Table
                    associationsTable

                    // MARK: - The Color Yellow and Mood
                    sectionHeader(
                        prefix: "The Color ",
                        colorWord: "Yellow",
                        suffix: " and Mood",
                        color: darkYellow
                    )

                    VStack(alignment: .leading, spacing: 14) {
                        Text("Yellow is one of the most emotionally charged colors: bright, magnetic, and deeply expressive.")

                        Text("It evokes high energy and cheerfulness, drawing attention wherever it appears. Yellow invites joy and connection, often creating an uplifting, sociable atmosphere.")

                        Text("But its intensity can also have a downside. In excess, yellow may feel abrasive, frustrating, or even agitating, especially in highly saturated tones. For example, babies are more likely to cry in yellow rooms than any other color.")

                        Text("Ultimately, yellow is a color best used mindfully, and in doses that enhance clarity without overpowering peace.")
                    }
                    .foregroundColor(.black)
                    .font(.body)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)

                    // MARK: - Where to Use Yellow
                    sectionHeader(
                        prefix: "Where to Use ",
                        colorWord: "Yellow",
                        suffix: "",
                        color: darkYellow
                    )

                    Text("Yellow is the color that reflects the most light and is also the most visible color. It can be fatiguing to the eye due to the high amount of light that it reflects. With that said, yellow stimulates appetite and is also effective for spaces associated with learning.")
                        .foregroundColor(.black)
                        .font(.body)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)

                    VStack(alignment: .leading, spacing: 10) {
                        bulletView(Text("Kitchens or Dining Areas"))
                        bulletView(Text("Classrooms or Study Halls"))
                        bulletView(Text("Activity Spaces"))
                        bulletView(Text("Entryways"))
                    }
                    .foregroundColor(.black)
                    .font(.body)

                    Spacer(minLength: 40)

                    // MARK: - Bottom Back Button
                    Button(action: {
                        navModel.push("LightTipsView")
                    }) {
                        Text("← Back to Light Tips")
                            .foregroundColor(.black)
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
            Text(prefix).foregroundColor(.black)
            + Text(colorWord).foregroundColor(color).bold()
            + Text(suffix).foregroundColor(.black)
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
                .foregroundColor(.black)
                .padding(.top, 2)
            text
                .foregroundColor(.black)
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
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity)

            // Underline
            Rectangle()
                .fill(Color.black.opacity(0.6))
                .frame(height: 1)
                .padding(.horizontal, 50)
                .padding(.bottom, 4)

            // Associations (Centered + Raised)
            VStack(spacing: 6) {
                Text("Cheerfulness")
                Text("Warmth and Sociability")
                Text("High Energy")
                Text("Attention Grabbing")
            }
            .font(.system(size: 17, weight: .regular))
            .foregroundColor(.black)
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
