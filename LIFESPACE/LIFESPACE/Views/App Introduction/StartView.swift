import SwiftUI

struct StartView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var pulse = false
    @AppStorage("hasSeenStartView") private var hasSeenStartView: Bool = false

    var body: some View {
        ZStack {
            // Teal gradient background
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

            VStack {
                Spacer().frame(height: UIScreen.main.bounds.height * 0.30)

                Button(action: {
                    withAnimation(.easeInOut(duration: 0.6)) {
                        navModel.selectedScreen = "StatsSetupView"
                    }
                }) {
                    Text("START BRAIN OPTIMIZATION")
                        .font(Font.custom("Avenir", size: 22).weight(.bold))
                        .foregroundColor(Color(red: 0.12, green: 0.49, blue: 0.45))
                        .padding()
                        .frame(width: 375, height: 93.75)
                        .background(Color.white)
                        .cornerRadius(25)
                        .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 4)
                        .scaleEffect(pulse ? 1.04 : 1.0)
                        .animation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true), value: pulse)
                }

                Spacer()
            }
        }
        .onAppear {
            pulse = true
            hasSeenStartView = true
        }
    }
}

