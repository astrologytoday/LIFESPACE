import SwiftUI

struct MirrorWorkView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var contentOpacity: Double = 0.0
    @State private var glowPhase: Bool = false

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

            // Subtle animated glow
            RadialGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(0.16),
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

                    // Title (unchanged)
                    Text("MIRROR WORK")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .white.opacity(0.28), radius: 10, x: 0, y: 0) // mystical glow
                        .shadow(color: .black.opacity(0.30), radius: 3, x: 0, y: 2)  // depth
                        .shadow(color: .white.opacity(0.7), radius: 10)              // your original title glow (optional)
                        .frame(maxWidth: .infinity, alignment: .center)

                    TimelineSection(title: "What Mirror Work Is", icon: "eye.fill") {
                        Text("Mirror work is the practice of gazing into your own eyes (typically in a calm, meditative state) while observing the thoughts, emotions, and sensations that arise. When done with candlelight, the environment becomes even more introspective, creating a sacred or altered state of consciousness.")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.95))
                            .fixedSize(horizontal: false, vertical: true)

                        HStack(spacing: 10) {
                            TagPill(text: "Presence", icon: "sparkles")
                            TagPill(text: "Emotion", icon: "heart.fill")
                            TagPill(text: "Embody", icon: "figure.stand")
                        }
                        .padding(.top, 6)
                    }

                    TimelineSection(
                        title: "Self-Facing Activates the Default Mode Network (DMN)",
                        icon: "brain.head.profile"
                    ) {
                        Text("Looking into your own eyes engages the Default Mode Network, a brain system involved in self-referential processing, daydreaming, and autobiographical memory. Studies using fMRI have shown that gazing at one’s own face activates areas related to identity, memory retrieval, and emotional integration.")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.95))
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    TimelineSection(title: "Limbic Regulation", icon: "waveform.path.ecg") {
                        Text("Eye contact, yes, even with yourself, triggers activity in the limbic system, the brain’s emotional center. Normally, eye contact with others regulates emotions via oxytocin release and social bonding. In mirror work, this can self-regulate emotions like shame, grief, or unworthiness by allowing them to be witnessed by you.")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.95))
                            .fixedSize(horizontal: false, vertical: true)

                        SubtleCallout(text: "You’re not trying to “fix” what comes up. You’re learning to stay present with it.")
                            .padding(.top, 6)
                    }

                    TimelineSection(title: "Somatic Awareness", icon: "lungs.fill") {
                        Text("Holding eye contact with yourself increases interoceptive awareness (your ability to feel internal bodily sensations). Combined with slow breathing and stillness, this enhances your connection between mind and body.")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.95))
                            .fixedSize(horizontal: false, vertical: true)

                        Text("The result? A deeper sense of presence, embodiment, and self-acceptance.")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white.opacity(0.95))
                            .italic()
                            .padding(.top, 6)
                    }

                    // ✅ No final dot, shifted left, centered header, sparkles on BOTH sides
                    TimelineSection(
                        title: "Try it for yourself!",
                        icon: "sparkles",
                        isLast: true,
                        centerTitle: true,
                        compactLeading: true
                    ) {
                        VStack(spacing: 10) {
                            StepRow(number: "1", text: "Stand or sit comfortably. Keep your shoulders relaxed.")
                            StepRow(number: "2", text: "Look into your own eyes gently, without forcing intensity.")
                            StepRow(number: "3", text: "Slow your breath. Let thoughts come and go.")
                            StepRow(number: "4", text: "Notice sensations in the body. Stay curious.")
                            StepRow(number: "5", text: "End with one kind sentence to yourself.")
                        }
                        .padding(.top, 2)
                    }

                    // Back Button
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                navModel.pop()
                            }
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

// MARK: - Option A Components (Timeline)

private struct TimelineSection<Content: View>: View {
    let title: String
    let icon: String
    var isLast: Bool = false
    var centerTitle: Bool = false
    var compactLeading: Bool = false

    let content: Content

    init(
        title: String,
        icon: String,
        isLast: Bool = false,
        centerTitle: Bool = false,
        compactLeading: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.icon = icon
        self.isLast = isLast
        self.centerTitle = centerTitle
        self.compactLeading = compactLeading
        self.content = content()
    }

    var body: some View {
        HStack(alignment: .top, spacing: compactLeading ? 10 : 14) {

            // Left spine (optional)
            if !compactLeading {
                VStack(spacing: 0) {
                    Circle()
                        .fill(Color.white.opacity(0.88))
                        .frame(width: 10, height: 10)
                        .shadow(color: .white.opacity(0.35), radius: 6, x: 0, y: 0)

                    if !isLast {
                        Rectangle()
                            .fill(Color.white.opacity(0.20))
                            .frame(width: 2)
                            .frame(maxHeight: .infinity)
                            .padding(.top, 10)
                    } else {
                        Spacer(minLength: 0)
                    }
                }
                .frame(width: 18)
            }

            // Content
            VStack(alignment: .leading, spacing: 10) {

                if centerTitle {
                    // ✅ Sparkles on both sides when centered
                    HStack(spacing: 10) {
                        Image(systemName: icon)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white.opacity(0.95))
                            .padding(.top, 1)

                        Text(title)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .fixedSize(horizontal: false, vertical: true)

                        Image(systemName: icon)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white.opacity(0.95))
                            .padding(.top, 1)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: icon)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white.opacity(0.95))
                            .padding(.top, 1)

                        Text(title)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .fixedSize(horizontal: false, vertical: true)

                        Spacer(minLength: 0)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                content
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 6)
    }
}

private struct TagPill: View {
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
        .background(Color.white.opacity(0.10))
        .overlay(Capsule().stroke(Color.white.opacity(0.16), lineWidth: 1))
        .cornerRadius(999)
    }
}

private struct SubtleCallout: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "quote.opening")
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.white.opacity(0.85))

            Text(text)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white.opacity(0.92))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .background(Color.white.opacity(0.08))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.white.opacity(0.14), lineWidth: 1)
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
