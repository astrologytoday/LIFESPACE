import SwiftUI

struct BlueView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var isPulsing = false
    
    // Darker blue for readability
    private let darkBlue = Color(red: 0.1, green: 0.3, blue: 0.7)
    
    var body: some View {
        ZStack {
            // 🔵 Blue gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.4, green: 0.7, blue: 1.0),
                    Color(red: 0.15, green: 0.4, blue: 0.8)
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
                        
                        Text("BLUE")
                            .font(.system(size: 40, weight: .heavy))
                            .foregroundColor(darkBlue)
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
                    
                    // MARK: - What Does Blue Do to the Body?
                    sectionHeader(
                        prefix: "What Does ",
                        colorWord: "Blue",
                        suffix: " Do to the Body?",
                        color: darkBlue
                    )
                    
                    VStack(alignment: .leading, spacing: 10) {
                        bulletView(
                            Text("Cools down emotional intensity. ").bold()
                            + Text("Can be effective for calming manic episodes.")
                        )
                        bulletView(
                            Text("Reduces stress and promotes concentration. ").bold()
                            + Text("Ideal for study or creative flow.")
                        )
                        bulletView(
                            Text("Lowers blood pressure and heart rate. ").bold()
                            + Text("Useful for easing tension and anxiety.")
                        )
                    }
                    .foregroundColor(.white)
                    .font(.body)
                    
                    // MARK: - Associations Table
                    associationsTable
                    
                    // MARK: - The Color Blue and Mood
                    sectionHeader(
                        prefix: "The Color ",
                        colorWord: "Blue",
                        suffix: " and Mood",
                        color: darkBlue
                    )
                    
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Blue is the color of emotional intelligence and is the energy center of communication and honesty. Many have made the association with melancholy or “feeling blue” because of its tendency to make us feel emotions at a greater intensity.")
                        
                        Text("Blue also promotes peace and inner stillness. It slows the pulse, cools excited emotions (such as anger), and brings the nervous system into a state of calm focus.")
                        
                        Text("Psychologically, blue helps quiet the mind, reduce stress, and support concentration. When we’re surrounded by blue, our breathing deepens and our body naturally relaxes. It is equally suited for meditation and deep work.")
                    }
                    .foregroundColor(.white)
                    .font(.body)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    
                    // MARK: - Where to Use Blue
                    sectionHeader(
                        prefix: "Where to Use ",
                        colorWord: "Blue",
                        suffix: "",
                        color: darkBlue
                    )
                    
                    Text("Because of its ability to calm the nervous system and lower blood pressure, this can be a good color used in the bedroom. On the contrary, because it lowers blood pressure, this is not a good color to be used in rooms associated with sexual activity. Blue is perfect anywhere you need clarity, tranquility, or emotional grounding.")
                        .foregroundColor(.white)
                        .font(.body)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        bulletView(Text("Bedrooms"))
                        bulletView(Text("Bathrooms"))
                        bulletView(Text("Living Rooms"))
                        bulletView(Text("Meditation Spaces"))
                        bulletView(Text("Creative Spaces"))
                        bulletView(Text("Study Rooms"))
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
    // MARK: - Associations Table (UPDATED)
    // MARK: - Associations Table (REFINED)
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
            
            // Associations (Raised + Clean)
            VStack(spacing: 6) {
                Text("Emotional Intelligence")
                Text("Clarity")
                Text("Peace and Calmness")
                Text("Good For Sleep")
            }
            .font(.system(size: 17, weight: .regular)) // NOT bold
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity)
            .padding(.top, 2) // subtle lift upward
        }
        .padding(.vertical, 16) // tighter card
        .padding(.horizontal, 16)
        .background(Color.black.opacity(0.2))
        .cornerRadius(18)
    }
}
