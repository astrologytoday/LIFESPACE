import SwiftUI
import UIKit

struct SmoothAnimatedGradientText: View {
    let text: String
    let gradients: [[Color]]

    @State private var startDate = Date()
    private let cycleDuration: Double = 3.5

    var body: some View {
        TimelineView(.animation) { timeline in
            let elapsed = timeline.date.timeIntervalSince(startDate)
            let phase = elapsed / cycleDuration
            let index = floor(phase).truncatingRemainder(dividingBy: Double(gradients.count))

            let currentIndex = (Int(index) + gradients.count) % gradients.count
            let nextIndex = (currentIndex + 1) % gradients.count
            let blend = phase - floor(phase)

            let blendedColors = zip(gradients[currentIndex], gradients[nextIndex]).map { c1, c2 in
                Color(
                    red:   c1.components.red   + (c2.components.red   - c1.components.red)   * blend,
                    green: c1.components.green + (c2.components.green - c1.components.green) * blend,
                    blue:  c1.components.blue  + (c2.components.blue  - c1.components.blue)  * blend
                )
            }

            Text(text)
                .font(.system(size: 22, weight: .heavy))
                .foregroundStyle(
                    LinearGradient(
                        colors: blendedColors,
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
        }
    }
}

extension Color {
    var components: (red: Double, green: Double, blue: Double, opacity: Double) {
        #if os(iOS)
        let ui = UIColor(self)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var o: CGFloat = 0
        ui.getRed(&r, green: &g, blue: &b, alpha: &o)
        return (Double(r), Double(g), Double(b), Double(o))
        #else
        return (1,1,1,1)
        #endif
    }
}

// ---------------------------------------------------------
// LEFT-ALIGNED HEADERS
// ---------------------------------------------------------
struct DisorderSectionHeaderBubble: View {
    let title: String
    let gradients: [[Color]]

    var body: some View {
        HStack {
            SmoothAnimatedGradientText(text: title, gradients: gradients)
                .padding(.vertical, 12)
                .padding(.horizontal, 30)
                .background(
                    Capsule()
                        .fill(Color.black.opacity(0.35))
                        .overlay(
                            Capsule()
                                .stroke(Color.white.opacity(0.35), lineWidth: 1.2)
                        )
                )
            Spacer()
        }
        .padding(.top, 6)
    }
}

// ---------------------------------------------------------
// MAIN VIEW
// ---------------------------------------------------------
struct BPDTwentyFiveView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var expandedIndex: Int? = nil
    @State private var pulse = false
    @State private var localPulse = false

    let barGradients: [[Color]] = [
        [
            Color(red: 0.22, green: 0.78, blue: 0.84),
            Color(red: 0.58, green: 0.60, blue: 0.92),
            Color(red: 0.80, green: 1.00, blue: 1.00)
        ],
        [
            Color(red: 0.20, green: 0.60, blue: 0.62),
            Color(red: 1.00, green: 0.92, blue: 0.45),
            Color(red: 0.80, green: 1.00, blue: 1.00)
        ],
        [
            Color(red: 0.18, green: 0.70, blue: 0.62),
            Color(red: 0.40, green: 0.92, blue: 0.60),
            Color(red: 0.80, green: 1.00, blue: 1.00)
        ],
        [
            Color(red: 0.50, green: 0.30, blue: 0.80),
            Color(red: 1.00, green: 0.50, blue: 1.00),
            Color(red: 0.80, green: 1.00, blue: 1.00)
        ]
    ]

    // ---------------------------------------------------------
    // FULL TIPS ARRAY
    // ---------------------------------------------------------
    let tips: [(title: String, description: String)] = [
        ("Spend Time Outside",
         "Regular sunlight boosts vitamin D, balances circadian rhythms, and improves mood stability. Just a few minutes outdoors each day can help regulate emotions and energy levels."),
        ("Dim Lights In The Evening",
         "Make space for yourself by lowering stimulation and reducing movement in the evening to stabilize and regulate emotions."),
        ("Avoid Harsh Fluorescent Lighting",
         "Fluorescent flicker overstimulates the nervous system and can trigger irritability, dissociation, or emotional overload in sensitive individuals."),
        ("Replace White/Blue LEDs With Softer Colours",
         "Warm gold, peach, and soft red light are biologically calming and reduce impulsive behavior in the evening."),

        ("Practice Breathing Exercises",
         "The 4-4-4 Breathing Technique (also known as 'Box Breathing') helps ease anxiety and tension. To do this, inhale for 4 seconds, hold your breath for 4 seconds, and exhale slowly for 4 seconds. Alternatively, the 4-7-8 method requires you to inhale through your nose for 7 seconds, hold for 4 seconds, and exhale through your mouth for 8 seconds."),
        ("Practice Daily Yoga or Prayer Meditation",
         "Daily yoga or meditative prayer works by changing your brain, lowering cortisol and calming the nervous system so emotional regulation can improve."),
        ("Keep A Journal",
         "Journaling helps you process emotions, track patterns, and clarify thoughts. Writing regularly is shown to reduce emotional intensity and support self-awareness and healing."),
        ("Practice Shadow Work",
         "Shadow Work is a method developed by Carl Jung which involves noticing emotions or traits you tend to avoid or judge. Reflect on your reactions, journal honestly, and integrate these hidden parts to support healing."),

        ("Do An Intense Exercise",
         "A good workout releases endorphins, improves circulation, and lowers stress hormones, all of which can rapidly reduce emotional overwhelm and impulsivity in BPD."),
        ("Track Your Fitness Progress",
         "Logging your workouts reinforces identity. Progress tracking builds motivation, reveals patterns, and strengthens self-image through measurable, consistent action."),
        ("Use Exercise As Your Cognitive Reset",
         "When you feel overwhelmed or like you're spiraling, a quick workout interrupts the loop."),
        ("Build A Fitness Plan",
         "A structured plan reduces decision fatigue and builds behavioral consistency. Define your goal, schedule realistic workouts, and include fallback options."),

        ("Eat An Orthomolecular Diet",
         "Prioritize nutrient-dense, whole foods rich in vitamins, minerals, and healthy fats. Orthomolecular nutrition supports brain chemistry, balances mood, and is linked to lower emotional instability in BPD."),
        ("Give Up Artificial Sweeteners",
         "Artificial sweeteners such as aspartame or sucralose can disrupt gut health and mood stability. Cutting them out supports healthier brain chemistry and has been linked to reduced anxiety and emotional swings in BPD."),
        ("Eat BPD-Specific Nutrients",
         "Create a shopping list and develop a meal plan that targets the main neurotransmitters that affect people with BPD. See the 'Nutrient Recommendations' section on the previous BPD Tips page for more information."),
        ("Take Vitamins That Support Brain Health",
         "Supplementing key nutrients with vitamins can help restore biochemical balance. Load up on choline, GABA, and vitamin D, as well as B-vitamins and omega-3 fatty acids for serotonin production."),

        ("Keep Your Space Clean & Decluttered",
         "Schedule a monthly decluttering session. Empty one drawer, shelf, or closet at a time, toss trash, donate what you don’t use, and put everything else back with intention. Removing clutter reduces background stress and makes your space feel calmer and easier to think in."),
        ("Try Hz-Based Vibrational Audio Therapy",
         "Binaural beats regulate brainwaves. Listening to specific frequencies such as 432Hz for grounding or 528Hz for mood elevation can reduce agitation, enhance focus, and induce calm."),
        ("Weighted Pressure & Deep Touch",
         "Weighted blankets, compression gear, or firm hugs calm the vagus nerve and reduce instability during emotional activation."),
        ("Epsom Salt Baths",
         "Warm Epsom salt baths relax the muscles through magnesium absorption. Add calming oils like lavender or chamomile and keep lights dim to lower cortisol."),

        ("Develop a Self-Anchor",
         "Create a short sentence that grounds your identity: 'I am learning.' 'I have a purpose.' 'I am becoming.' This builds inner continuity."),
        ("Set Goals For Yourself",
         "Setting goals raises motivation and provides a sense direction. Start with **SMART goals:** make them *Specific, Measurable, Achievable, Relevant,* and *Time-bound.* Breaking larger dreams into small, realistic steps helps you see progress and prevents overwhelm. Alongside daily or weekly goals, consider building a **5-Year Plan.** This long-term roadmap gives purpose and a sense of forward motion, even when the path feels uncertain."),
        ("Create Space Before Big Decisions",
         "Wait at least 24 hours before major decisions. A big decision creates an emotional peak, and emotional peaks distort long-term judgment."),
        ("Get A Plant",
         "Caring for a plant provides a gentle, reliable form of connection and responsibility that is free from judgment or conflict. The daily act of tending to a living thing can help build self-trust and reinforce a sense of stability. Noticing small changes and growth in your plant can also support positive identity and offer moments of grounding when emotions feel intense or unpredictable."),

        ("Stabilize Through Routine",
         "Predictability brings safety. Simple anchors like a morning ritual, consistent sleep, or regular meal schedule can help regulate emotional depth."),
        ("Learn What Coping Strategy Works For You",
         "Remind yourself that healing takes time and is possible. When urges to self-sabotage arise, pause and reach for a safe coping skill instead. Your safety and well-being should always come first."),
        ("Embrace Your Hobbies",
         "Find a hobby you enjoy and embrace it. Whether it’s cooking, gardening, gaming, painting, or collecting something meaningful, hobbies create structure, identity, and small daily wins. They anchor your attention, reduce impulsive urges, and just make you feel good overall."),
        ("Read For Pleasure",
         "Reading shifts your mind into a calmer, more imaginative state, and is shown to increase intelligence. Books can transport you mentally and help you settle instead of spiral."),

        ("Build Connections",
         "Introducing yourself to someone you don’t know opens the door to new experiences and connection. Even a short, friendly exchange can boost your mood and remind you that positive social moments are always possible."),
        ("Never Put All Your Eggs In One Basket",
         "Balance your time, money, and relationships. Relying on just one person or pursuit can intensify emotional swings and lead to disappointment. Diversifying means supporting your stability and resilience in everyday life."),
        ("Avoid Assumptions About What Others Are Thinking",
         "Fear of abandonment distorts perception. Pause before believing the worst-case scenario."),
        ("Repair After Rupture",
         "If you react intensely, come back gently: 'I felt scared. I’m sorry I withdrew or panicked.' Repair builds trust and an apology for acting badly can go a long way."),

        ("Write Down Who You Are",
         "Write down values, preferences, and the things that identify you. Emotional intensity can blur identity. Write your story so you don't forget who you are."),
        ("Learn An Instrument",
         "Music engages both hemispheres of the brain, improving emotional processing, focus, and self-expression. It is a great way to relax and also builds confidence as your skills grow over time."),
        ("Get Creative With Your Cooking",
         "Make a list of foods that help with BPD, such as those that support serotonin production, and create new recipes that are all your own."),
        ("Write Stream of Consciousness Poetry",
         "Poetry lets you express emotional storms without needing to “make sense.” The act of translating feeling into language using automatic writing often reduces intensity and builds emotional clarity.")
    ]

    // ---------------------------------------------------------
    // CATEGORY COLORS
    // ---------------------------------------------------------
    func tipCategoryColor(for i: Int) -> Color {
        switch i {
        case 0...3: return .red
        case 4...7: return .orange
        case 8...11: return .yellow
        case 12...15: return .green
        case 16...19: return .teal
        case 20...23: return .blue
        case 24...27: return .indigo
        case 28...31: return .purple
        case 32...35: return .pink
        default: return .white
        }
    }

    // ---------------------------------------------------------
    // MARKDOWN (Reliable bold/italic parsing)
    // ---------------------------------------------------------
    private func markdownText(_ string: String) -> Text {
        if let attributed = try? AttributedString(
            markdown: string,
            options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .full)
        ) {
            return Text(attributed)
        } else {
            return Text(string)
        }
    }

    // ---------------------------------------------------------
    // BODY
    // ---------------------------------------------------------
    var body: some View {
        ZStack {
            StarryNightBackground()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    Text("BPD Tips")
                        .font(.system(size: 46, weight: .black))
                        .foregroundColor(.white)
                        .scaleEffect(pulse ? 1.08 : 1.0)
                        .animation(.easeInOut(duration: 1.8).repeatForever(), value: pulse)
                        .onAppear { pulse = true }
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .padding(.top, 40)
                        .padding(.bottom, 10)

                    DisorderSectionHeaderBubble(title: "L", gradients: barGradients)
                    ForEach(0...3, id: \.self) { tipBox($0) }

                    DisorderSectionHeaderBubble(title: "I", gradients: barGradients)
                    ForEach(4...7, id: \.self) { tipBox($0) }

                    DisorderSectionHeaderBubble(title: "F", gradients: barGradients)
                    ForEach(8...11, id: \.self) { tipBox($0) }

                    DisorderSectionHeaderBubble(title: "E", gradients: barGradients)
                    ForEach(12...15, id: \.self) { tipBox($0) }

                    DisorderSectionHeaderBubble(title: "S", gradients: barGradients)
                    ForEach(16...19, id: \.self) { tipBox($0) }

                    DisorderSectionHeaderBubble(title: "P", gradients: barGradients)
                    ForEach(20...23, id: \.self) { tipBox($0) }

                    DisorderSectionHeaderBubble(title: "A", gradients: barGradients)
                    ForEach(24...27, id: \.self) { tipBox($0) }

                    DisorderSectionHeaderBubble(title: "C", gradients: barGradients)
                    ForEach(28...31, id: \.self) { tipBox($0) }

                    DisorderSectionHeaderBubble(title: "E", gradients: barGradients)
                    ForEach(32...35, id: \.self) { tipBox($0) }

                    Spacer(minLength: 60)

                    HStack {
                        Spacer()
                        Button { navModel.pop() } label: {
                            ZStack {
                                Circle()
                                    .fill(Color.white.opacity(0.15))
                                    .frame(width: 80, height: 80)

                                Image(systemName: "chevron.left")
                                    .font(.system(size: 34, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                        Spacer()
                    }
                    .padding(.bottom, 50)
                }
                .padding(.horizontal, 22)
            }
        }
    }

    // ---------------------------------------------------------
    // TIP BUTTON LOGIC
    // ---------------------------------------------------------
    func tipHasButtons(_ i: Int) -> Bool {
        switch i {
        case 4, 6, 7, 8, 9, 11, 14, 15, 17, 21, 24, 28, 32:
            return true
        default:
            return false
        }
    }

    // ---------------------------------------------------------
    // TIP CARD VIEW (MARKDOWN ENABLED)
    // ---------------------------------------------------------
    func tipBox(_ i: Int) -> some View {
        VStack(alignment: .leading, spacing: 12) {

            // TITLE + CHEVRON
            HStack {
                Text(tips[i].title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(tipCategoryColor(for: i))
                Spacer()
                Image(systemName: expandedIndex == i ? "chevron.up" : "chevron.down")
                    .foregroundColor(tipCategoryColor(for: i))
                    .font(.system(size: 20, weight: .semibold))
            }
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.35)) {
                    expandedIndex = expandedIndex == i ? nil : i
                }
            }

            // EXPANDED CONTENT
            if expandedIndex == i {

                markdownText(tips[i].description)
                    .font(.custom("Avenir", size: 17))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .transition(.opacity.combined(with: .move(edge: .top)))

                if tipHasButtons(i) {
                    Spacer().frame(height: 2)

                    VStack(alignment: .leading, spacing: 14) {
                        switch i {
                        case 4:
                            bubbleButton("Learn Breathing Techniques") { navModel.push("BreathworkView") }

                        case 6:
                            bubbleButton("Open Journal") {
                                let created = UserDefaults.standard.bool(forKey: "dreamPasswordCreated")
                                navModel.push(created ? "DreamPasswordView" : "CreateDreamPasswordView")
                            }

                        case 7:
                            bubbleButton("Start Shadow Work") { navModel.push("ShadowWorkView") }

                        case 8:
                            bubbleButton("Open Fitness Space") { navModel.push("FitnessSpaceView") }

                        case 9:
                                bubbleButton("Take A Selfie") {
                                navModel.openProgressCameraOnAppear = true
                                navModel.push("FitnessSpaceView") }

                        case 11:
                            bubbleButton("Plan A Workout Routine") { navModel.push("WorkoutPlannerView") }

                        case 14:
                            bubbleButton("Open BPD Tips") { navModel.push("BPDTipsView") }

                        case 15:
                            bubbleButton("Buy Vitamins") {
                                if let url = URL(string: "https://www.hardynutritionals.com") {
                                    UIApplication.shared.open(url)
                                }
                            }

                        case 17:
                            bubbleButton("Start Audio Therapy") { navModel.push("SoundBathView") }

                        case 21:
                            bubbleButton("Open Goals") { navModel.push("GoalsView") }

                        case 24:
                            bubbleButton("Open Day Planner") { navModel.push("DayPlannerView") }

                        case 28:
                            bubbleButton("Meet Someone New") { navModel.push("CommunityTipsView") }

                        case 32:
                            bubbleButton("Open Journal") {
                                let created = UserDefaults.standard.bool(forKey: "dreamPasswordCreated")
                                navModel.push(created ? "DreamPasswordView" : "CreateDreamPasswordView")
                            }

                        default:
                            EmptyView()
                        }
                    }
                    .padding(.top, 2)
                }
            }
        }
        .padding(16)
        .background(Color.black.opacity(0.28))
        .cornerRadius(16)
    }

    // ---------------------------------------------------------
    // BUBBLE BUTTON
    // ---------------------------------------------------------
    func bubbleButton(_ label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label.uppercased())
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.white)
                .lineLimit(1)
                .padding(.vertical, 12)
                .padding(.horizontal, 26)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.14, green: 0.42, blue: 0.45),
                            Color(red: 0.09, green: 0.30, blue: 0.33)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(8)
        }
        .frame(maxWidth: .infinity)
        .shadow(color: Color.white.opacity(0.55), radius: 8)
        .scaleEffect(localPulse ? 1.04 : 1.0)
        .animation(.easeInOut(duration: 1.2).repeatForever(), value: localPulse)
        .onAppear { localPulse = true }
        .padding(.bottom, 10)
    }
}
