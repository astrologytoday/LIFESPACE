import SwiftUI

struct LifespacePyramidView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var contentOpacity: Double = 0.0

    var body: some View {
        ZStack {
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

            ScrollView {
                VStack(spacing: 30) {
                    Spacer(minLength: 24)

                    // 🔷 TITLE (MATCHES PyramidView)
                    Text("The LIFESPACE\nHierarchy of Needs")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .shadow(color: .black.opacity(0.45), radius: 6, x: 0, y: 3)
                        .padding(.bottom, 2)
                        .opacity(contentOpacity)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 0.8)) {
                                contentOpacity = 1.0
                            }
                        }

                    // Maslow Blurb
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Understanding Maslow's Hierarchy of Needs")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.white)
                        Text("""
Maslow’s Hierarchy of Needs is a classic psychological model that helps us understand human motivation and growth. At its foundation are basic physiological needs (like food, water, and safety), followed by social needs, esteem, and—at the very top—Self-Actualization. Only when our foundational needs are met can we move toward realizing our full creative and personal potential.
""")
                            .font(.system(size: 17))
                            .foregroundColor(.white.opacity(0.96))
                    }
                    .padding(.horizontal, 10)

                    // Maslow Pyramid Image
                    Button {
                        navModel.push("BigMaslowPyramidView")
                    } label: {
                        Image("maslow2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 250)
                            .shadow(radius: 16)
                            .padding(.vertical, 4)
                            .opacity(contentOpacity)
                    }

                    // Self-Actualization Blurb
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Self-Actualization and Creative Power")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                        Text("""
At the peak of Maslow’s pyramid is Self-Actualization: the state where you become your most authentic self and unlock your highest creative abilities. Here, you begin to operate from a place of inner fulfillment and can direct your energy toward meaningful projects, relationships, and contributions.
""")
                            .font(.system(size: 17))
                            .foregroundColor(.white.opacity(0.96))
                    }
                    .padding(.horizontal, 10)

                    // LIFESPACE Explanation
                    VStack(alignment: .leading, spacing: 10) {
                        Text("The LIFESPACE Pyramid: A Practical Guide")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                        Text("""
Like Maslow’s model, the LIFESPACE Pyramid leads you step by step toward Self-Actualization. LIFESPACE gives you a practical daily map: by meeting each need in the sequence, you build a foundation for true creative expression and holistic well-being. Climbing the LIFESPACE Pyramid is about nurturing every part of your life so your potential can fully unfold.
""")
                            .font(.system(size: 17))
                            .foregroundColor(.white.opacity(0.96))
                    }
                    .padding(.horizontal, 10)
                    .padding(.top, 2)

                    // LIFESPACE Pyramid Image
                    Button {
                        navModel.push("BigLifespacePyramidView")
                    } label: {
                        Image("lifespace_pyramid")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 230)
                            .shadow(radius: 18)
                            .padding(.bottom, 12)
                    }

                    // 🔷 BACK BUTTON (MATCHES PyramidView)
                    Button {
                        navModel.selectedScreen = "PyramidView"
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56)
                            .background(Color.white.opacity(0.18))
                            .clipShape(Circle())
                            .shadow(radius: 6)
                    }
                    .padding(.bottom, 40)
                }
                .padding(.horizontal, 8)
                .frame(maxWidth: 540)
                .animation(.easeInOut(duration: 0.45), value: contentOpacity)
            }
        }
    }
}
