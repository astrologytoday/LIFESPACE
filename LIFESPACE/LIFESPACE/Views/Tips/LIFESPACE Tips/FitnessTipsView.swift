import SwiftUI

struct FitnessTipsView: View {
    @EnvironmentObject var navModel: NavigationModel

    @State private var appeared = false
    @State private var pulseGoal = false

    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let horizontalPadding = max(20, screenWidth * 0.055)
            let footerHeight: CGFloat = 104

            ZStack(alignment: .topLeading) {
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

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Fitness Tips")
                            .font(.system(size: min(40, screenWidth * 0.105), weight: .bold))
                            .foregroundColor(.white)
                            .shadow(radius: 4)
                            .padding(.top, 12)

                        Text("To remind you that you are capable")
                            .font(.system(size: min(22, screenWidth * 0.055)))
                            .italic()
                            .foregroundColor(.white.opacity(0.95))
                            .fixedSize(horizontal: false, vertical: true)

                        howToUseCard(screenWidth: screenWidth)

                        goalBubble(screenWidth: screenWidth)
                            .padding(.top, 16)
                    }
                    .padding(.horizontal, horizontalPadding)
                    .padding(.top, 48)
                    .padding(.bottom, footerHeight + 90)
                    .opacity(appeared ? 1 : 0)
                    .animation(.easeInOut(duration: 0.6), value: appeared)
                }

                BackButtonView(customTarget: "TipsView")
                    .padding(.top, 12)
                    .padding(.leading, horizontalPadding)

                VStack {
                    Spacer()

                    footerButtons(screenWidth: screenWidth)
                        .frame(height: footerHeight)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.10, green: 0.45, blue: 0.45).opacity(0.0),
                                    Color(red: 0.10, green: 0.45, blue: 0.45).opacity(0.95)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .ignoresSafeArea(edges: .bottom)
                        )
                }
                .ignoresSafeArea(edges: .bottom)
            }
            .onAppear {
                appeared = true
                withAnimation(.easeInOut(duration: 1.05).repeatForever(autoreverses: true)) {
                    pulseGoal = true
                }
            }
            .transition(.opacity)
        }
    }

    private func howToUseCard(screenWidth: CGFloat) -> some View {
        let bubbleSize = min(154, screenWidth * 0.37)
        let bubbleTopOffset: CGFloat = 185

        return sectionCardBase {
            ZStack(alignment: .topTrailing) {
                workoutGroupsCircle(screenWidth: screenWidth)
                    .frame(width: bubbleSize, height: bubbleSize)
                    .padding(.top, bubbleTopOffset)
                    .padding(.trailing, -4) // moves bubble slightly right

                VStack(alignment: .leading, spacing: 17) {
                    Text("How to Use the Fitness Space")
                        .font(.system(size: min(22, screenWidth * 0.058), weight: .bold))
                        .foregroundColor(.white)
                        .fixedSize(horizontal: false, vertical: true)

                    bullet("Try out different exercises by browsing workouts for different muscle groups.", screenWidth: screenWidth)

                    bullet("Create dedicated workout plans by assigning muscle groups to each day in the Workout Planner.", screenWidth: screenWidth)
                        .padding(.trailing, bubbleSize * 0.78)

                    bullet("Track weight every day using the Weight Tracker.", screenWidth: screenWidth)
                        .padding(.trailing, bubbleSize * 0.98)

                    bullet("Take photos after workouts and track your progress.", screenWidth: screenWidth)
                        .padding(.trailing, bubbleSize * 0.96)

                    bullet("Create a meal plan that aligns with your fitness goals using the Meal Planner.", screenWidth: screenWidth)
                }
                .padding(.vertical, 22)
                .padding(.horizontal, max(18, screenWidth * 0.045))
            }
        }
    }

    private func workoutGroupsCircle(screenWidth: CGFloat) -> some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.16))
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.42), lineWidth: 2)
                )
                .shadow(color: .black.opacity(0.16), radius: 10, x: 0, y: 6)

            VStack(spacing: 7) {
                Text("Group\nWorkouts")
                    .font(.system(size: min(15, screenWidth * 0.037), weight: .heavy))
                    .underline()
                    .multilineTextAlignment(.center)

                Text("Back + Biceps\nChest + Triceps\nShoulders + Legs")
                    .font(.system(size: min(12.5, screenWidth * 0.032), weight: .bold))
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
            }
            .foregroundColor(.white)
            .padding(15)
            .offset(y: -8)
        }
        .allowsHitTesting(false)
    }

    // MARK: - Footer Buttons

    private func footerButtons(screenWidth: CGFloat) -> some View {
        let buttonSize = min(64, screenWidth * 0.16)
        let spacing = max(14, screenWidth * 0.045)

        return HStack(spacing: spacing) {
            FooterIconButton(systemName: "figure.strengthtraining.traditional", size: buttonSize) {
                navModel.push("FitnessSpaceView")
            }

            FooterIconButton(systemName: "calendar", size: buttonSize) {
                navModel.push("WorkoutPlannerView")
            }

            FooterIconButton(systemName: "fork.knife", size: buttonSize) {
                navModel.push("MealPlannerView")
            }

            FooterIconButton(systemName: "chart.bar", size: buttonSize) {
                UserDefaults.standard.set("Weight", forKey: "analyticsStartTab")
                navModel.push("AnalyticsView")
            }
        }
        .padding(.top, 12)
        .padding(.bottom, 28)
        .frame(maxWidth: .infinity)
    }

    // MARK: - Section Card Base

    private func sectionCardBase(@ViewBuilder content: () -> some View) -> some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white.opacity(0.18))

            content()
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Bullet

    private func bullet(_ text: String, screenWidth: CGFloat) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Text("•")
                .font(.system(size: min(18, screenWidth * 0.048), weight: .bold))
                .foregroundColor(.white.opacity(0.95))
                .padding(.top, 1)

            Text(text)
                .font(.system(size: min(16, screenWidth * 0.043), weight: .semibold))
                .foregroundColor(.white.opacity(0.92))
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    // MARK: - Goal Bubble

    private func goalBubble(screenWidth: CGFloat) -> some View {
        let corner: CGFloat = 26

        return ZStack {
            RoundedRectangle(cornerRadius: corner, style: .continuous)
                .fill(Color.white.opacity(0.16))

            RoundedRectangle(cornerRadius: corner, style: .continuous)
                .stroke(Color.white.opacity(pulseGoal ? 0.95 : 0.55), lineWidth: pulseGoal ? 4 : 2)
                .shadow(color: .white.opacity(pulseGoal ? 0.70 : 0.30), radius: pulseGoal ? 18 : 10)
                .shadow(color: .white.opacity(pulseGoal ? 0.45 : 0.18), radius: pulseGoal ? 30 : 18)

            RoundedRectangle(cornerRadius: corner, style: .continuous)
                .stroke(Color.white.opacity(pulseGoal ? 0.22 : 0.10), lineWidth: 14)
                .blur(radius: 6)

            VStack(spacing: 10) {
                Text("LIFESPACE Fitness Goal:")
                    .font(.system(size: min(20, screenWidth * 0.052), weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                Text("5 minutes of intense exercise every day!")
                    .font(.system(size: min(22, screenWidth * 0.058), weight: .heavy))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 8)
            }
            .padding(.vertical, 26)
            .padding(.horizontal, 18)
        }
        .frame(maxWidth: .infinity)
        .scaleEffect(pulseGoal ? 1.015 : 1.0)
        .shadow(color: .black.opacity(0.14), radius: 10, x: 0, y: 8)
        .animation(.easeInOut(duration: 1.05).repeatForever(autoreverses: true), value: pulseGoal)
    }
}

// MARK: - Footer Button

private struct FooterIconButton: View {
    let systemName: String
    let size: CGFloat
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Circle()
                .fill(Color.white.opacity(0.25))
                .frame(width: size, height: size)
                .overlay(
                    Image(systemName: systemName)
                        .font(.system(size: size * 0.42, weight: .bold))
                        .foregroundColor(.white)
                )
        }
        .buttonStyle(.plain)
    }
}
