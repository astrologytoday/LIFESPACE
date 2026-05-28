import SwiftUI

struct IndigoView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var isPulsing = false
    
    // Darker indigo for legibility
    private let darkIndigo = Color(red: 0.2, green: 0.15, blue: 0.5)
    
    var body: some View {
        ZStack {
            // 🌀 Indigo gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.5, green: 0.4, blue: 0.8),
                    Color(red: 0.1, green: 0.05, blue: 0.3)
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
                        
                        Text("PURPLE")
                            .font(.system(size: 40, weight: .heavy))
                            .foregroundColor(darkIndigo)
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
                    
                    // MARK: - What Does Indigo Do to the Body?
                    sectionHeader(
                        prefix: "What Does ",
                        colorWord: "Purple",
                        suffix: " Do to the Body?",
                        color: darkIndigo
                    )
                    
                    VStack(alignment: .leading, spacing: 10) {
                        bulletView(
                            Text("Slows overactive thoughts. ").bold()
                            + Text("Can be good for people who find themselves thinking too much before bed.")
                        )
                        bulletView(
                            Text("Enhances intuition and imagination. ").bold()
                            + Text("Purple quiets the analytical mind making it a very “right-brained” color.")
                        )
                        bulletView(
                            Text("Supports meditation, hypnosis, and dreamwork.").bold()
                        )
                        bulletView(
                            Text("Lowers blood pressure and heart rate. ").bold()
                            + Text("This is most effective when used under soft, ambient light before sleep.")
                        )
                    }
                    .foregroundColor(.white)
                    .font(.body)
                    
                    // MARK: - Associations Table
                    associationsTable
                    
                    // MARK: - The Color Indigo and Mood
                    sectionHeader(
                        prefix: "The Color ",
                        colorWord: "Purple",
                        suffix: " and Mood",
                        color: darkIndigo
                    )
                    
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Purple is the color most associated with intuition, imagination, spiritual insight, and perception beyond logic. It has long been used in spiritual, religious, and mystical traditions to invoke calm, depth, and connection to higher knowledge.")
                        
                        Text("Psychologically, purple stimulates the pineal gland and is believed to enhance inner vision and creative consciousness. It invites imagination and inward reflection, often making it a preferred color in meditation and introspective environments.")
                        
                        Text("Its hypnotic and trance-inducing qualities can open the door to visionary thinking, but also to escapism or addictive behaviors in certain psychological states.")
                    }
                    .foregroundColor(.white)
                    .font(.body)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    
                    // MARK: - Where to Use Indigo
                    sectionHeader(
                        prefix: "Where to Use ",
                        colorWord: "Purple",
                        suffix: "",
                        color: darkIndigo
                    )
                    
                    Text("Purple is best suited for spaces of reflection, prayer, and dreams.")
                        .foregroundColor(.white)
                        .font(.body)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        bulletView(Text("Bedrooms"))
                        bulletView(Text("Therapeutic Spaces"))
                        bulletView(Text("Creative Studios"))
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
    
    // MARK: - Associations Table (UPDATED)
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
                Text("Imagination")
                Text("Intuition")
                Text("Spiritual Wisdom")
                Text("Calming")
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
