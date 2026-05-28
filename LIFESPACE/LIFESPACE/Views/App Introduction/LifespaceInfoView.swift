import SwiftUI

struct LifespaceInfoView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var glow = false
    @State private var goToHierarchy = false
    @State private var goToMenuTutorial = false

    @AppStorage("hasSeenLifespaceInfo") private var hasSeenLifespaceInfo: Bool = false

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

            if !goToHierarchy && !goToMenuTutorial {
                ScrollView {
                    VStack(alignment: .leading, spacing: 28) {
                        Text("What is LIFESPACE?")
                            .font(Font.custom("Avenir", size: 28).weight(.bold))
                            .foregroundColor(.white)
                            .padding(.top)

                        Text("""
LIFESPACE is a brain optimization app and a comprehensive guide to personal wellness. This can be a tool to help you align your daily habits with a more balanced, meaningful, and optimized life.

At its core, LIFESPACE is a self-check-in system built around 9 key areas of well-being:
""")
                            .font(Font.custom("Avenir", size: 16))
                            .foregroundColor(.white)

                        HStack(alignment: .top, spacing: 20) {
                            VStack(alignment: .leading, spacing: 6) {
                                ForEach([
                                    "Light", "Inner Work", "Fitness", "Eating Healthy", "Sensory Health",
                                    "Purpose", "Activity", "Community", "Expression"
                                ], id: \.self) { word in
                                    HStack(spacing: 0) {
                                        Text(String(word.prefix(1)))
                                            .font(Font.custom("Avenir", size: 18).weight(.bold))
                                            .foregroundColor(.white)
                                            .shadow(color: Color.white.opacity(glow ? 1.0 : 0.4),
                                                    radius: glow ? 12 : 4)
                                            .scaleEffect(glow ? 1.4 : 1.0)
                                            .animation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true), value: glow)
                                            .onAppear { glow = true }

                                        Text(" " + String(word.dropFirst()))
                                            .font(Font.custom("Avenir", size: 18))
                                            .foregroundColor(.white)
                                            .lineLimit(1)
                                    }
                                }
                            }
                            .fixedSize(horizontal: true, vertical: false)

                            Spacer()

                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.6)) {
                                    goToHierarchy = true
                                }
                            }) {
                                Image("maslow")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: 300, maxHeight: 300)
                                    .cornerRadius(12)
                                    .shadow(radius: 8)
                            }
                        }

                        Text("The goal is to achieve Self-Actualization by reaching the top of Maslow's Hierarchy of Needs.")
                            .font(Font.custom("Avenir", size: 16))
                            .foregroundColor(.white)

                        Text("The LIFESPACE Model is meant to offer steps that will get you there faster.")
                            .font(Font.custom("Avenir", size: 16))
                            .foregroundColor(.white)

                        HStack {
                            Spacer()
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.6)) {
                                    hasSeenLifespaceInfo = true   // ✅ Only when user proceeds
                                    goToMenuTutorial = true
                                }
                            }) {
                                Image(systemName: "arrow.right.circle.fill")
                                    .resizable()
                                    .frame(width: 66, height: 66)
                                    .foregroundColor(.white)
                                    .shadow(radius: 5)
                            }
                            .padding(.bottom)
                            Spacer()
                        }
                    }
                    .padding(.horizontal)
                }
                .transition(.opacity)
            }

            if goToHierarchy {
                HierarchyInfoView()
                    .environmentObject(navModel)
                    .transition(.opacity)
            }

            if goToMenuTutorial {
                MenuTutorialView()
                    .environmentObject(navModel)
                    .transition(.opacity)
            }
        }
    }
}
