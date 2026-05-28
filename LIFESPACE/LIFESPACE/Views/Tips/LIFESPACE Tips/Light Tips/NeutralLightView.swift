import SwiftUI

struct NeutralLightView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var lightModel: LightModel

    @State private var fadeInTop = false
    @State private var fadeInIs = false
    @State private var fadeInWarm = false
    @State private var pulse = false

    private var kelvinText: String {
        if let k = lightModel.selectedKelvin { return "\(k)K" }
        return "—"
    }

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

            VStack(spacing: 0) {
                // Top ZStack with back button and centered text
                ZStack {
                    // Center-aligned Kelvin text
                    VStack(spacing: 12) {
                        Text(kelvinText)
                            .font(.system(size: 52, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .opacity(fadeInTop ? 1 : 0)
                            .transition(.opacity)

                        Text("is")
                            .font(.system(size: 22, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.9))
                            .opacity(fadeInIs ? 1 : 0)
                            .transition(.opacity)

                        Text("NEUTRAL LIGHT")
                            .font(.system(size: 40, weight: .heavy, design: .rounded))
                            .kerning(2)
                            .foregroundColor(.white)
                            .shadow(color: Color(red: 1.0, green: 0.55, blue: 0.20).opacity(0.8), radius: 12)
                            .shadow(color: Color(red: 1.0, green: 0.65, blue: 0.30).opacity(0.6), radius: 24)
                            .shadow(color: Color(red: 1.0, green: 0.75, blue: 0.40).opacity(0.4), radius: 40)
                            .scaleEffect(pulse ? 1.06 : 0.98)
                            .opacity(fadeInWarm ? 1 : 0)
                            .animation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true), value: pulse)
                            .transition(.opacity)
                    }
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)

                    // Back button floating overtop
                    HStack {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                navModel.pop()
                            }
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .medium))
                                .padding(8)
                                .background(Color.white.opacity(0.15))
                                .clipShape(Circle())
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                }
                .frame(height: 200) // 🔧 Adjust this to fine-tune spacing

                // Scrollable info content
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        Group {
                            Text("The Effects of Neutral Light")
                                .font(.title3.bold())
                                .foregroundColor(.white)

                            Text("Neutral light, sometimes called soft white or natural white, offers a balance between warm and cool tones. It closely resembles daylight, promoting both focus and comfort. Neutral light helps reduce eye strain, improve visibility, and maintain alertness without the harshness associated with cool light.")
                                .foregroundColor(.white.opacity(0.9))
                        }

                        Group {
                            Text("Where Should I Use Neutral Light?")
                                .font(.title3.bold())
                                .foregroundColor(.white)

                            Text("Neutral light is ideal for functional living spaces. It supports productivity while maintaining a natural, inviting tone.")
                                .foregroundColor(.white.opacity(0.9))
                            
                            Text("Try using Neutral Light in:")
                                .bold()
                                .foregroundColor(.white.opacity(0.9))

                            VStack(alignment: .leading, spacing: 8) {
                                Text("• Kitchens")
                                Text("• Bathrooms")
                                Text("• Hallways")
                                Text("• Laundry Rooms")
                            }
                            .foregroundColor(.white.opacity(0.9))
                            .font(.body)
                            .padding(.top, -10)
                        }

                        Group {
                            Text("What Lightbulbs Provide Neutral Light?")
                                .font(.title3.bold())
                                .foregroundColor(.white)

                            Text("LEDs and CFLs labeled 3000K–3999K, often described as 'bright white' or 'natural white,' provide neutral light. These bulbs emit a crisp, clear glow without veering too yellow or too blue. When shopping, look for bulbs in the 3500K range to achieve a balanced, neutral lighting effect.")
                                .foregroundColor(.white.opacity(0.9))
                        }
                    }
                    .multilineTextAlignment(.leading)
                    .padding(.top, 24)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.4)) { fadeInTop = true }
            withAnimation(.easeInOut(duration: 0.4).delay(0.15)) { fadeInIs = true }
            withAnimation(.easeInOut(duration: 0.4).delay(0.30)) { fadeInWarm = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                pulse = true
            }
        }
    }
}


