import SwiftUI

struct DreamJournalView: View {
    @EnvironmentObject var navModel: NavigationModel

    var body: some View {
        ZStack {
            // Background Gradient
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
                VStack(spacing: 6) {

                    Text("DREAM JOURNAL")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .white.opacity(0.28), radius: 10, x: 0, y: 0)
                        .shadow(color: .black.opacity(0.30), radius: 3, x: 0, y: 2)
                        .shadow(color: .white.opacity(0.7), radius: 10)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 18)
                        .padding(.bottom, 12)

                    // Body Card
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Start recording your dreams today!")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.bottom, 2)

                        Text("Even if you've never done it before, it might be worth it to try keeping a dream journal for introspection, or a greater connection with the spiritual.")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white.opacity(0.95))

                        Text("Each morning when you wake up, record anything you can recall from your dreams. And if nothing comes to mind, that's completely fine - just write down, \"I did not recall any dreams today.\"")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.92))
                            .lineSpacing(4)

                        Text("In the beginning, you might only remember a brief image, emotion, or single event. But with consistent practice, you'll start remembering more and more, and within a few weeks, you will have trouble keeping your entries to less than one page.")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.92))
                            .lineSpacing(4)

                        Text("Tracking your dreams over time can reveal powerful insights, as shifts in your dream content often reflect growth and transformation in your waking life.")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.92))
                            .lineSpacing(4)
                    }
                    .padding(18)
                    .background(
                        ZStack {
                            RoundedRectangle(cornerRadius: 18)
                                .fill(Color.white.opacity(0.12))

                            RoundedRectangle(cornerRadius: 18)
                                .stroke(Color.white.opacity(0.16), lineWidth: 1)
                        }
                    )
                    .shadow(color: .black.opacity(0.18), radius: 10, x: 0, y: 6)
                    .padding(.horizontal)
                    .padding(.bottom, 0)

                    // ✅ Center this row by giving it full width + centering,
                    // then nudge slightly right to match your eye-test.
                    HStack(alignment: .center, spacing: 14) {
                        // Back button (left)
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                navModel.pop()
                            }
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 32, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(34)
                                .background(Color.white.opacity(0.20))
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 6)
                        }

                        // Journal image (right) - routes based on password created
                        Button(action: {
                            let created = UserDefaults.standard.bool(forKey: "dreamPasswordCreated")
                            withAnimation(.easeInOut(duration: 0.4)) {
                                navModel.push(created ? "DreamPasswordView" : "CreateDreamPasswordView")
                            }
                        }) {
                            Image("dream_journal")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 240)
                                .shadow(color: .black.opacity(0.18), radius: 10, x: 0, y: 6)
                        }
                        .buttonStyle(.plain)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .offset(x: 10)          // ✅ small right shift to visually center the pair
                    .padding(.horizontal)
                    .padding(.top, -30)
                    .padding(.bottom, 10)
                }
            }
        }
    }
}
