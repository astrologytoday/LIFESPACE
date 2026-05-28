import SwiftUI

struct GreenView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var isPulsing = false
    
    // Darker green for text visibility
    private let darkGreen = Color(red: 0.0, green: 0.5, blue: 0.2)
    
    var body: some View {
        ZStack {
            // 🌿 Green gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.5, green: 0.85, blue: 0.5),
                    Color(red: 0.2, green: 0.5, blue: 0.2)
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
                        
                        Text("GREEN")
                            .font(.system(size: 40, weight: .heavy))
                            .foregroundColor(darkGreen)
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
                    
                    // MARK: - What Does Green Do to the Body?
                    sectionHeader(
                        prefix: "What Does ",
                        colorWord: "Green",
                        suffix: " Do to the Body?",
                        color: darkGreen
                    )
                    
                    VStack(alignment: .leading, spacing: 10) {
                        bulletView(
                            Text("Calms the nervous system. ").bold()
                            + Text("Green is often associated with balance and can calm mood swings.")
                        )
                        bulletView(
                            Text("Improves circadian rhythm. ").bold()
                            + Text("This is good for regulating sleep cycles and appetite.")
                        )
                        bulletView(
                            Text("Encourages self-development. ").bold()
                            + Text("It is associated with growth and renewal.")
                        )
                    }
                    .foregroundColor(.white)
                    .font(.body)
                    
                    // MARK: - Associations Table
                    associationsTable
                    
                    // MARK: - The Color Green and Mood
                    sectionHeader(
                        prefix: "The Color ",
                        colorWord: "Green",
                        suffix: " and Mood",
                        color: darkGreen
                    )
                    
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Green is the color of balance. It evokes a sense of healing, prosperity, and peace, reminding us of forests, renewal, and life's steady rhythm.")
                        
                        Text("Green calms the nervous system, supports emotional regulation, and fosters personal growth.")
                        
                        Text("In excess, it invites luck and opportunity, but it can also awaken greed or jealousy in emotionally charged environments.")
                        
                        Text("Ultimately, green is the color of natural alignment: most powerful when used to restore harmony, invite abundance, and reconnect us to the living world.")
                    }
                    .foregroundColor(.white)
                    .font(.body)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    
                    // MARK: - Where to Use Green
                    sectionHeader(
                        prefix: "Where to Use ",
                        colorWord: "Green",
                        suffix: "",
                        color: darkGreen
                    )
                    
                    Text("Because of its strong ties to nature, the color green is best used in rooms that have vegetation or that aim to facilitate the circadian rhythm, such as bedrooms or bathrooms.")
                        .foregroundColor(.white)
                        .font(.body)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        bulletView(Text("Bedrooms"))
                        bulletView(Text("Bathrooms"))
                        bulletView(Text("Living Rooms"))
                        bulletView(Text("Meditation Spaces"))
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
                Text("Healing")
                Text("Prosperity")
                Text("Luck and Opportunity")
                Text("Nature")
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
