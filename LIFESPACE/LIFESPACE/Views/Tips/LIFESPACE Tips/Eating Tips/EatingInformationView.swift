import SwiftUI

struct EatingInformationView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var appeared = false

    // Define topics with icons for visual interest
    let topics: [(label: String, target: String, icon: String)] = [
        ("The Gut-Brain Connection", "GutBrainView", "brain.head.profile"),
        ("Orthomolecular Diet", "OrthomolecularView", "pills"),
        ("Circadian Rhythm", "CircadianRhythmView", "sun.max"),
        ("Meal Prepping", "MealPrepView", "fork.knife")
    ]

    var body: some View {
        ZStack {
            // 🌊 Background with subtle overlay for depth
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
            .overlay(Color.black.opacity(0.05))

            VStack(spacing: 0) {
                // Title
                Text("Explore Topics")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.15),
                                Color.white.opacity(0.05)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .cornerRadius(14)
                    .padding(.top, 36)
                    .padding(.horizontal, 14)
                    .scaleEffect(appeared ? 1.0 : 0.95)
                    .opacity(appeared ? 1 : 0)
                    .animation(.easeOut(duration: 0.6), value: appeared)

                // ScrollView
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        ForEach(topics.indices, id: \.self) { index in
                            neurotransmitterButton(
                                topics[index].label,
                                target: topics[index].target,
                                icon: topics[index].icon
                            )
                            .opacity(appeared ? 1 : 0)
                            .offset(y: appeared ? 0 : 20)
                            .animation(
                                .easeOut(duration: 0.4).delay(Double(index) * 0.1),
                                value: appeared
                            )
                        }
                    }
                    .padding(.horizontal, 18)
                    .padding(.top, 24)
                    .padding(.bottom, 120) // ✅ space so content doesn’t hide behind bottom buttons
                }

                // ✅ Bottom buttons (bigger back + home)
                HStack(spacing: 18) {
                    Button {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            navModel.pop()
                        }
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 72, height: 72)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.25), radius: 6, x: 0, y: 4)
                    }

                    Button {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            navModel.selectedScreen = "HomeView"
                        }
                    } label: {
                        Image(systemName: "house.fill")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 72, height: 72)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.25), radius: 6, x: 0, y: 4)
                    }
                }
                .padding(.bottom, 22)
                .padding(.top, 10)
            }
        }
        .onAppear { appeared = true }
        .transition(.opacity)
    }

    // MARK: - Enhanced Button Builder with Icon and Press Effect
    private func neurotransmitterButton(_ label: String, target: String, icon: String) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.4)) {
                navModel.push(target)
            }
        } label: {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(Color(red: 0.10, green: 0.45, blue: 0.45))

                Text(label)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color(red: 0.10, green: 0.45, blue: 0.45))
                    .frame(maxWidth: .infinity, alignment: .leading)

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(red: 0.10, green: 0.45, blue: 0.45).opacity(0.6))
            }
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.white.opacity(0.95),
                        Color.white.opacity(0.85)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 4)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Custom Button Style for Press Feedback
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
