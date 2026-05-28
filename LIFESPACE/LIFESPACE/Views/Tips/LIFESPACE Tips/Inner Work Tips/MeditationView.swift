import SwiftUI

struct AffirmationItem: Hashable {
    let category: String
    let affirmation: String
}

struct MeditationView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var contentOpacity: Double = 0.0
    @State private var glowPhase: Bool = false

    // MARK: - Affirmations (2-column grid)
    let affirmations: [AffirmationItem] = [
        AffirmationItem(category: "Career", affirmation: "I am thriving in my dream job."),
        AffirmationItem(category: "Abundance", affirmation: "Money flows to me easily."),
        AffirmationItem(category: "Love", affirmation: "I am deeply loved and supported."),
        AffirmationItem(category: "Health", affirmation: "I am vibrant and full of energy."),
        AffirmationItem(category: "Growth", affirmation: "Every day I evolve and improve."),
        AffirmationItem(category: "Spirit", affirmation: "I walk in alignment with my higher self.")
    ]

    private let gridColumns: [GridItem] = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]

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

            // ✨ Subtle animated glow overlay
            RadialGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(0.18),
                    Color.white.opacity(0.00)
                ]),
                center: glowPhase ? .topLeading : .bottomTrailing,
                startRadius: 30,
                endRadius: 560
            )
            .ignoresSafeArea()
            .blendMode(.screen)
            .animation(.easeInOut(duration: 5.0).repeatForever(autoreverses: true), value: glowPhase)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {

                    Spacer(minLength: 20)

                    // Title (kept consistent with your style)
                    Text("MEDITATION")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .white.opacity(0.28), radius: 10, x: 0, y: 0) // mystical glow
                        .shadow(color: .black.opacity(0.30), radius: 3, x: 0, y: 2)  // depth
                        .shadow(color: .white.opacity(0.7), radius: 10)              // your original title glow (optional)
                        .frame(maxWidth: .infinity, alignment: .center)

                    // Intro (clean, but with a small accent row)
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 10) {
                                ZStack {
                                    Circle()
                                        .fill(Color.white.opacity(0.14))
                                        .frame(width: 40, height: 40)
                                        .overlay(Circle().stroke(Color.white.opacity(0.18), lineWidth: 1))
                                    Image(systemName: "sparkles")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white.opacity(0.95))
                                }

                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Tune Inward")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.white)

                                    Text("Still the mind. Align the self.")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(.white.opacity(0.78))
                                }

                                Spacer()
                            }

                            Text("Meditation is the art of tuning inward, calming the mind, stilling the breath, and aligning with your higher self. The Law of Assumption teaches that what you assume to be true begins to manifest in your life.")
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.95))
                                .fixedSize(horizontal: false, vertical: true)

                            HStack(spacing: 10) {
                                Chip(text: "Breath", icon: "lungs.fill")
                                Chip(text: "Imagination", icon: "wand.and.stars")
                                Chip(text: "Assumption", icon: "checkmark.circle.fill")
                            }
                            .padding(.top, 2)
                        }
                    }
                    .padding(.horizontal)

                    // Law of Assumption
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader(title: "The Law of Assumption", icon: "eye.fill")

                            Text("The Law of Assumption states that what you believe to be true becomes your reality. When your emotions, imagination, and assumptions align, your subconscious begins to reshape the world around you.")
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.95))
                                .fixedSize(horizontal: false, vertical: true)

                            QuoteCard(text: "Assume the feeling of the wish fulfilled, and the world will begin to mirror it back.")
                        }
                    }
                    .padding(.horizontal)

                    // How to Practice (spiced-up steps)
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader(title: "How to Practice the Law of Assumption", icon: "list.bullet.rectangle.portrait.fill")

                            VStack(spacing: 10) {
                                StepRow(number: "1", text: "Clarity on what you want.")
                                StepRow(number: "2", text: "Assume the end result is already yours.")
                                StepRow(number: "3", text: "Feel the emotions of fulfillment.")
                                StepRow(number: "4", text: "Persist in your assumption.")
                                StepRow(number: "5", text: "Release doubt and resistance.")
                                StepRow(number: "6", text: "Visualize and affirm daily.")
                                StepRow(number: "7", text: "Live in the end.")
                                StepRow(number: "8", text: "Trust the process.")
                            }
                        }
                    }
                    .padding(.horizontal)

                    // Ideal Times (more visual)
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader(title: "Ideal Times for Manifestation Practice", icon: "clock.fill")

                            HStack(spacing: 12) {
                                TimePill(title: "After Waking", subtitle: "First 10 minutes", icon: "sun.max.fill")
                                TimePill(title: "Before Sleep", subtitle: "Last 10 minutes", icon: "moon.stars.fill")
                            }

                            Text("These are moments when your subconscious mind is most open to suggestion. Use them to visualize the life you want to create.")
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.95))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .padding(.horizontal)

                    // Affirmations Grid
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader(title: "Affirmations by Focus Area", icon: "square.grid.2x2.fill")

                            LazyVGrid(columns: gridColumns, spacing: 14) {
                                ForEach(affirmations, id: \.self) { item in
                                    AffirmationCard(category: item.category, affirmation: item.affirmation)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)

                    // Timer Button (more “primary”)
                    Button(action: {
                        navModel.push("TimerView")
                    }) {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(Color.white.opacity(0.16))
                                    .frame(width: 44, height: 44)
                                    .overlay(Circle().stroke(Color.white.opacity(0.20), lineWidth: 1))
                                Image(systemName: "timer")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white.opacity(0.95))
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Start Meditation Timer")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)

                                Text("Choose a duration and begin")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.75))
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white.opacity(0.75))
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.18))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.20), lineWidth: 1)
                        )
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.12), radius: 10, x: 0, y: 6)
                        .padding(.horizontal)
                    }
                    .padding(.top, 2)

                    // Back Button (kept as-is behavior)
                    HStack {
                        Spacer()
                        Button(action: {
                            navModel.push("InnerWorkTipsView")
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 28, weight: .medium))
                                .foregroundColor(.white)
                                .padding(24)
                                .background(Color.white.opacity(0.2))
                                .clipShape(Circle())
                                .shadow(radius: 8)
                        }
                        Spacer()
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 30)
                }
                .opacity(contentOpacity)
                .onAppear {
                    glowPhase = true
                    withAnimation(.easeInOut(duration: 0.6)) {
                        contentOpacity = 1.0
                    }
                }
            }
        }
    }
}

// MARK: - Components

private struct GlassCard<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) { self.content = content() }

    var body: some View {
        content
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white.opacity(0.14))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.white.opacity(0.18), lineWidth: 1)
            )
            .cornerRadius(18)
            .shadow(color: Color.black.opacity(0.10), radius: 12, x: 0, y: 8)
    }
}

private struct SectionHeader: View {
    let title: String
    let icon: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white.opacity(0.95))
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
            Spacer()
        }
    }
}

private struct QuoteCard: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "quote.opening")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white.opacity(0.85))

            Text(text)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.white.opacity(0.92))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.10))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.white.opacity(0.16), lineWidth: 1)
        )
        .cornerRadius(14)
    }
}

private struct StepRow: View {
    let number: String
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.18))
                    .frame(width: 30, height: 30)
                    .overlay(Circle().stroke(Color.white.opacity(0.20), lineWidth: 1))

                Text(number)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white.opacity(0.95))
            }

            Text(text)
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.95))
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 0)
        }
        .padding(.vertical, 2)
    }
}

private struct Chip: View {
    let text: String
    let icon: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white.opacity(0.90))
            Text(text)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white.opacity(0.95))
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.white.opacity(0.12))
        .overlay(Capsule().stroke(Color.white.opacity(0.16), lineWidth: 1))
        .cornerRadius(999)
    }
}

private struct TimePill: View {
    let title: String
    let subtitle: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.95))
                Text(title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
            }

            Text(subtitle)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white.opacity(0.78))
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.10))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.white.opacity(0.16), lineWidth: 1)
        )
        .cornerRadius(14)
    }
}

private struct AffirmationCard: View {
    let category: String
    let affirmation: String

    private var iconName: String {
        switch category.lowercased() {
        case "career": return "briefcase.fill"
        case "abundance": return "dollarsign.circle.fill"
        case "love": return "heart.fill"
        case "health": return "cross.fill"
        case "growth": return "leaf.fill"
        case "spirit": return "sparkles"
        default: return "star.fill"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: iconName)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.95))

                Text(category)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)

                Spacer()
            }

            Text(affirmation)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.white.opacity(0.95))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.10))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.white.opacity(0.16), lineWidth: 1)
        )
        .cornerRadius(14)
    }
}
