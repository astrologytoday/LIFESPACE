import SwiftUI

struct RedView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var isPulsing = false

    var body: some View {
        ZStack {
            // 🔴 Red gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.75, green: 0.10, blue: 10/255),
                    Color(red: 0.35, green: 0.00, blue: 0.00)
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

                        Text("RED")
                            .font(.system(size: 40, weight: .heavy))
                            .foregroundColor(.red)
                            .scaleEffect(isPulsing ? 1.08 : 1.0)
                            .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: isPulsing)
                            .onAppear {
                                isPulsing = true
                            }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 24)

                    
                    // MARK: - What Does Red Do to the Body?
                    sectionHeader(
                        prefix: "What Does ",
                        colorWord: "Red",
                        suffix: " Do to the Body?",
                        color: .red
                    )

                    VStack(alignment: .leading, spacing: 10) {
                        bulletView(
                            Text("Increases energy and alertness. ").bold()
                            + Text("Red stimulates the sympathetic nervous system, boosting blood flow and physical arousal.")
                        )

                        bulletView(
                            Text("Raises heart rate and blood pressure. ").bold()
                            + Text("In moderate doses, this can create excitement and motivation. In excess, it can create tension or aggression.")
                        )

                        bulletView(
                            Text("Enhances performance in short bursts. ").bold()
                            + Text("Studies show athletes surrounded by red perform with more intensity, but tire faster.")
                        )
                    }
                    .foregroundColor(.white)
                    .font(.body)


                    // MARK: - Emotional & Psychological Associations Table
                    associationsTable


                    // MARK: - The Color Red and Mood
                    sectionHeader(
                        prefix: "The Color ",
                        colorWord: "Red",
                        suffix: " and Mood",
                        color: .red
                    )

                    VStack(alignment: .leading, spacing: 14) {

                        Text("Red represents the lowest energy visible wavelength, meaning it penetrates deeply but gently.")

                        (
                            Text("At night, ")
                            + Text("soft red").bold().underline()
                            + Text(" is the least likely to suppress melatonin, making it ideal for soft night lighting or pre-sleep routines.")
                        )

                        (
                            Text("However, during the day, ")
                            + Text("bright red").bold().underline()
                            + Text(" can overstimulate or create a sense of heat or urgency.")
                        )
                    }
                    .foregroundColor(.white)
                    .font(.body)
                    .fixedSize(horizontal: false, vertical: true)


                    // MARK: - Where to Use Red
                    sectionHeader(
                        prefix: "Where to Use ",
                        colorWord: "Red",
                        suffix: "",
                        color: .red
                    )

                    Text("Where you use the color Red will depend on the shade. Bright red tones should not be used in places where you need rest and relaxation.")
                        .foregroundColor(.white)
                        .font(.body)

                    VStack(alignment: .leading, spacing: 10) {
                        bulletView(Text("Dining areas"))
                        bulletView(Text("Gyms or active zones"))
                        bulletView(Text("Work or creative studios"))
                        bulletView(Text("Bedrooms ").foregroundColor(.white) + Text("(dark red)").italic())
                        bulletView(Text("Meditation or therapy spaces ").foregroundColor(.white) + Text("(dark red)").italic())
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
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.15))
                            .cornerRadius(12)
                    }
                    .padding(.bottom, 60)

                }
                .padding(.horizontal, 24)
            }
        }
    }


    // MARK: - Section Header Helper
    private func sectionHeader(prefix: String, colorWord: String, suffix: String, color: Color) -> some View {
        (
            Text(prefix).foregroundColor(.white)
            + Text(colorWord).foregroundColor(color).bold()
            + Text(suffix).foregroundColor(.white)
        )
        .font(.title3)
        .fontWeight(.semibold)
    }

    // MARK: - Bullet Helper
    private func bulletView(_ text: Text) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
                .foregroundColor(.white)
                .padding(.top, 2)

            text
                .foregroundColor(.white)
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
                .frame(maxWidth: .infinity)

            // Underline
            Rectangle()
                .fill(Color.white.opacity(0.6))
                .frame(height: 1)
                .padding(.horizontal, 50)
                .padding(.bottom, 4)

            // Associations (Centered + Raised)
            VStack(spacing: 6) {
                Text("Sex and Romance")
                Text("Courage and Confidence")
                Text("Strength and Leadership")
                Text("Vitality and Warmth")
            }
            .font(.system(size: 17, weight: .regular))
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .padding(.top, 2)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 16)
        .background(Color.black.opacity(0.2))
        .cornerRadius(18)
    }
}

