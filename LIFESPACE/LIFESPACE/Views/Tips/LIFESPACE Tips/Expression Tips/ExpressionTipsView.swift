import SwiftUI

struct ExpressionTipsView: View {
    @EnvironmentObject var navModel: NavigationModel

    // ✅ Add these so we can call the landscape presenter
    @EnvironmentObject var userProfile: UserProfileModel
    @EnvironmentObject var lifespaceLogModel: LifespaceLogModel
    @EnvironmentObject var budgetModel: BudgetModel

    @State private var appeared = false
    @State private var gridItemOpacities: [Double] = Array(repeating: 0.0, count: 8) // For staggered grid animation

    var body: some View {
        ZStack(alignment: .topTrailing) {

            // 🌊 LIFESPACE gradient background
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
                VStack(alignment: .leading, spacing: 18) {

                    // Header
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Expression Tips")
                            .font(.system(size: 40, weight: .heavy))
                            .foregroundColor(.white)
                            .shadow(radius: 4)
                            .opacity(appeared ? 1 : 0)
                            .offset(y: appeared ? 0 : -10)
                            .animation(.easeInOut(duration: 0.4), value: appeared)

                        // ✅ NEW subtitle (LIFESPACE format)
                        Text("To drive innovation")
                            .font(.title3)
                            .italic()
                            .foregroundColor(Color.white.opacity(0.95))
                            .fixedSize(horizontal: false, vertical: true)
                            .opacity(appeared ? 1 : 0)
                            .animation(.easeInOut(duration: 0.6).delay(0.05), value: appeared)

                        Spacer()

                        Text("""
Creative expression is one of the most effective ways to support mental health. Research shows that creating activates neural circuits linked to emotional regulation, problem-solving, and reward. When you express yourself, the brain increases dopamine, serotonin, and endorphin production, which can reduce anxiety and improve mood.
""")
                        .font(.custom("Avenir", size: 17))
                        .foregroundColor(.white.opacity(0.95))
                        .opacity(appeared ? 1 : 0)
                        .animation(.easeInOut(duration: 0.6).delay(0.1), value: appeared)

                        // Grid section with enhanced styling and staggered animation
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 10) {
                                Text("🎨")
                                    .font(.system(size: 26))
                                Text("Creative Paths")
                                    .font(.system(size: 22, weight: .heavy))
                                    .foregroundColor(.white)
                                    .shadow(color: .white.opacity(0.4), radius: 3)
                            }

                            Text("Sublimate your feelings.")
                                .font(.custom("Avenir", size: 16))
                                .foregroundColor(.white.opacity(0.9))

                            ExpressionGrid { route in
                                // ✅ Special-case Music so it opens in your landscape window
                                if route == "MusicCreativeView" {
                                    presentMusicCreativeView(
                                        navModel: navModel,
                                        userProfile: userProfile,
                                        lifespaceLogModel: lifespaceLogModel,
                                        budgetModel: budgetModel
                                    )
                                } else {
                                    navModel.push(route)
                                }
                            }
                            .onAppear {
                                // Staggered animation for grid items
                                for i in 0..<gridItemOpacities.count {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.1) {
                                        withAnimation(.easeInOut(duration: 0.5)) {
                                            gridItemOpacities[i] = 1.0
                                        }
                                    }
                                }
                            }
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 22)
                                .fill(Color.black.opacity(0.20))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 22)
                                        .stroke(Color.white.opacity(0.18), lineWidth: 1)
                                )
                                .shadow(color: .black.opacity(0.3), radius: 14, x: 0, y: 4)
                        )
                        .padding(.top, 6)

                        Spacer(minLength: 60)
                    }
                    .padding(.horizontal, 18)
                    .padding(.top, 70) // ✅ leaves room for the fixed top-right buttons
                }
            }

            // ✅ Fixed top-right buttons (does NOT scroll)
            HStack(spacing: 10) {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        navModel.push("TipsView")
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .bold))
                        .padding(10)
                        .background(Color.black.opacity(0.22))
                        .clipShape(Circle())
                }

                Button(action: { navModel.push("HomeView") }) {
                    Image(systemName: "house.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .bold))
                        .padding(10)
                        .background(Color.black.opacity(0.22))
                        .clipShape(Circle())
                }
            }
            .padding(.top, 14)
            .padding(.trailing, 14)
        }
        .onAppear { appeared = true }
    }

    // MARK: - Grid

    private struct ExpressionGrid: View {

        let onTap: (String) -> Void

        private let items: [(icon: String, title: String, subtitle: String, route: String)] = [
            ("fork.knife", "Cooking", "Create flavor and vibe.", "CookingCreativeView"),
            ("music.note", "Music", "Play, write, record.", "MusicCreativeView"),
            ("figure.dance", "Dance", "Move emotion through.", "DanceCreativeView"),
            ("paintpalette.fill", "Art", "Draw, paint, collage.", "ArtCreativeView"),
            ("pencil.tip", "Writing", "Journals, scripts, poetry.", "WritingCreativeView"),
            ("tshirt.fill", "Fashion", "What's your style?", "FashionCreativeView"),
            ("camera.fill", "Photos", "Capture moments.", "PhotographyCreativeView"),
            ("square.grid.2x2.fill", "Design", "Logos, layouts, UI.", "MoodBoardView")
        ]

        private let columns: [GridItem] = [
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12)
        ]

        var body: some View {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(items.indices, id: \.self) { i in
                    let it = items[i]

                    ExpressionCard(
                        icon: it.icon,
                        title: it.title,
                        subtitle: it.subtitle
                    ) {
                        onTap(it.route)
                    }
                }
            }
            .padding(.top, 6)
        }
    }

    private struct ExpressionCard: View {
        let icon: String
        let title: String
        let subtitle: String
        let action: () -> Void

        var body: some View {
            Button(action: action) {
                VStack(alignment: .leading, spacing: 8) {

                    HStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.white.opacity(0.2),
                                            Color.white.opacity(0.1)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 34, height: 34)
                                .shadow(color: .white.opacity(0.3), radius: 2)

                            Image(systemName: icon)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                        }

                        Text(title)
                            .font(.system(size: 18, weight: .heavy))
                            .foregroundColor(.white)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: true, vertical: false) // 👈 prevents word breaking
                            .minimumScaleFactor(0.85)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white.opacity(0.9))
                    }

                    Text(subtitle)
                        .font(.custom("Avenir", size: 15))
                        .foregroundColor(.white.opacity(0.9))
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)

                    Spacer(minLength: 0)
                }
                .padding(14)
                .frame(maxWidth: .infinity, minHeight: 118, alignment: .topLeading)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0.15),
                                    Color.white.opacity(0.08)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(Color.white.opacity(0.22), lineWidth: 1)
                        )
                )
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 4)
                .contentShape(RoundedRectangle(cornerRadius: 18))
            }
            .buttonStyle(PressScaleButtonStyle())
        }
    }

    private struct PressScaleButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
        }
    }
}
