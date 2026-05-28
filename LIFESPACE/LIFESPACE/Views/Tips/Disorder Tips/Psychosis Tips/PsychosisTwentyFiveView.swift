import SwiftUI
// ---------------------------------------------------------
// MAIN VIEW
// ---------------------------------------------------------
struct PsychosisTwentyFiveView: View {
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
    // FULL TIPS ARRAY — UNCHANGED
    // ---------------------------------------------------------
    let tips: [(title: String, description: String)] = [
        // (UNCHANGED — keeping all your original text)
        ("Spend Time Outside",
         "Regular sunlight boosts vitamin D, balances circadian rhythms, and improves mood stability. Just a few minutes outdoors each day can help regulate emotions and energy levels."),
        ("Avoid Harsh Fluorescent Lighting",
         "Fluorescent flicker overstimulates the nervous system and can trigger irritability, dissociation, or emotional overload in sensitive individuals."),
        ("Replace White/Blue LEDs With Softer Colours",
         "Warm gold, peach, and soft red light are biologically calming and reduce impulsive behavior in the evening."),
        ("Avoid Screens Before Bed",
         "Sleep hygiene is critical for reducing psychosis risk, and late-night screen use can disrupt it. Blue light from phones, TVs, and computers delays melatonin release, keeps the brain in a hyper-alert state, and increases sensory overstimulation that can disturb your sleep. To protect your sleep cycle, minimize screen exposure **at least one hour before bed.** Consider downloading a blue-light–filtering tool to your computer, or activating *Night Shift* in your iOS settings."),
        
        ("Practice Breathing Exercises",
         "The 4-4-4 Breathing Technique (also known as 'Box Breathing') helps ease anxiety and tension. To do this, inhale for 4 seconds, hold your breath for 4 seconds, and exhale slowly for 4 seconds. Alternatively, the 4-7-8 method requires you to inhale through your nose for 7 seconds, hold for 4 seconds, and exhale through your mouth for 8 seconds."),
        ("Daily Yoga Meditation",
         "Regular yoga and meditation help stabilize the nervous system, reduce cortisol, and quiet the sensory overload that can fuel psychosis. Even 10-20 minutes a day can reduce agitation, improve sleep quality, and create a buffer against intrusive thoughts."),
        ("Label Internal Voices or Images Neutrally",
         "When you experience voices or images, try to label them in a calm, neutral way. Identify the voices you hear as internal voices which are fragmented parts of your subconscious mind. Acknowledging it as an internal event creates distance, lowers fear, and restores a sense of control. Neutral labeling turns the experience into information rather than danger, helping you stay grounded and regulated in the moment."),
        ("Connect With Your Higher Power",
         "Prayer can provide grounding, safety, and emotional regulation during periods of distress. Try and speak to your higher power through structured prayer or simple heartfelt conversation. Connecting spiritually reminds you that God will always love you and be there for you, and you’re not facing your experiences alone."),
        
        ("Do An Intense Exercise",
         "A good workout releases endorphins, improves circulation, and lowers stress hormones, all of which can rapidly reduce emotional overwhelm."),
        ("Track Your Fitness Progress",
         "Logging your workouts reinforces identity. Progress tracking builds motivation, reveals patterns, and strengthens self-image through measurable, consistent action."),
        ("Use Exercise As Your Cognitive Reset",
         "When you feel overwhelmed or like you're spiraling, a quick workout interrupts the loop."),
        ("Build A Fitness Plan",
         "A structured plan reduces decision fatigue and builds behavioral consistency. Define your goal, schedule realistic workouts, and include fallback options."),
        
        ("Eat An Orthomolecular Diet",
         "Orthomolecular nutrition is a concept developed by **Linus Pauling**, and focuses on restoring optimal brain function by supplying the body with the precise nutrients required for neurotransmitter balance. Pauling viewed schizophrenia as a biochemical imbalance that could often be corrected through targeted nutrients. To begin, create a shopping list and develop a meal plan that targets the main neurotransmitters involved in anxiety and psychosis. Reduce foods that overstimulate **dopamine** and **serotonin**, which can intensify sensory distortion, and increase foods that support **GABA** and **acetylcholine**, which promote calm, clarity, and cognitive regulation. Prioritize nutrients such as magnesium, B-vitamins, choline, amino acids, omega-3 fatty acids, and mineral-rich whole foods. See the *Nutrient Recommendations* section on the previous Psychosis Tips page for more detailed guidance. Building a dedicated neurotransmitter-focused meal plan is a powerful step toward stabilizing thought patterns and strengthening mental resilience."),
        ("Regulate Blood Sugar",
         "Blood sugar crashes often mimic or worsen anxiety, agitation, and cognitive fog. Avoid artificial sweeteners such as aspartame and sucralose. These additives can disrupt gut health, interfere with neurotransmitter balance, and have been linked to increased mood instability. Removing them from your diet supports clearer thinking, calmer emotions, and more stable brain chemistry overall."
        ),
        ("Cut Out Trans-Fats and Inflammatory Foods",
         "Inflammation plays a major role in brain function, and emerging research suggests that **inflammatory pathways are a main contributor to the intensity of symptoms in schizophrenia.** Diets high in trans-fats, seed oils, refined sugars, and ultra-processed foods can increase systemic inflammation, oxidative stress, and neuroinflammatory signaling. Removing trans-fats and minimizing inflammatory foods supports a clearer, calmer baseline. Focus instead on whole foods, omega-3 fatty acids, mineral-rich vegetables, clean proteins, and healthy fats that nourish the brain and reduce inflammatory pressure."),
        ("Hydrate and Add Electrolytes",
         "Aim for steady water intake throughout the day, and include electrolytes like magnesium, potassium, and sodium to support nerve signaling and balanced brain chemistry. Electrolytes help regulate electrical activity in the brain, stabilize mood, and prevent the fatigue or lightheadedness that can trigger mental overwhelm."),
        
        ("Keep Your Space Clean & Decluttered",
         "Schedule a monthly decluttering session. Empty one drawer, shelf, or closet at a time, toss trash, donate what you don’t use, and put everything else back with intention. Removing clutter reduces background stress and makes your space feel calmer and easier to think in."),
        ("Orient To Your Surroundings",
         "Look around and name 5 objects you see. Say where you are, what time it is, and what day it is. Orientation restores cognitive footing."),
        ("Put On Some Music",
         "Music can act as a stabilizing anchor when internal voices feel intrusive or overwhelming. Rhythm and melody help organize attention, regulate breathing, and shift the mind away from distressing internal noise. Choose something that makes you feel safe, then use it as a grounding tool whenever the internal volume becomes too loud."),
        ("Shower & Maintain Hygeine",
         "Regular hygiene is very paramount to avoiding episodes of psychosis. Warm water calms the nervous system, reduces muscle tension, and can interrupt cycles of agitation or withdrawal that sometimes accompany psychosis. Brushing your teeth and changing clothes reinforces structure, dignity, and self-connection. These simple acts signal safety to the brain and can gently lift motivation, helping you feel more grounded and clear."),
        
        ("Develop a Self-Anchor",
         "Create a short sentence that grounds your identity: 'I am learning.' 'I have a purpose.' 'I am becoming.' This builds inner continuity."),
        ("Set Goals For Yourself",
         "Setting goals raises motivation and provides a sense direction. Start with **SMART goals:** make them *Specific, Measurable, Achievable, Relevant,* and *Time-bound.* Breaking larger dreams into small, realistic steps helps you see progress and prevents overwhelm. Alongside daily or weekly goals, consider building a **5-Year Plan.** This long-term roadmap gives purpose and a sense of forward motion, even when the path feels uncertain."),
        ("Create Space Before Big Decisions",
         "Wait at least 24 hours before major decisions. A big decision creates an emotional peak, and emotional peaks distort long-term judgment."),
        ("Set Digital Boundaries",
         "Declutter your digital environment by limiting exposure to chaotic media, overstimulating conversations, and content that fuels anxiety or cognitive overload. Curate your online world so it supports clarit. Avoid opinion-based videos, conspiracy theories, or anything that blurs the line between imagination and reality."),
        
        ("Stabilize Through Routine",
         "Predictability brings safety. Simple anchors like a morning ritual, consistent sleep, or regular meal schedule can help regulate emotional depth."),
        ("Learn What Coping Strategy Works For You",
         "If you find something that works and that helps you, hold on to that and keep building onto it. Remind yourself that healing takes time and is possible. When urges to self-sabotage arise, pause and reach for a safe coping skill instead."),
        ("Practice Sleep Hygiene",
         "Protect your sleep at all costs. Keep your room dark, cool, and quiet, and maintain a predictable bedtime. Create an evening wind-down ritual: dim the lights, take a warm shower, drink calming tea, or play gentle music. Predictable cues signal to the brain that the day is ending, reducing nighttime spiraling and sensory overstimulation. Avoid sleep deprivation triggers such as caffeine after noon, heavy meals late at night, or emotionally intense conversations close to bedtime."),
        ("Don't Do Drugs",
         "Dopamine overstimulation is a main contributor to psychosis. This includes not only illegal narcotics, but also **coffee, nicotine, energy drinks, pre-workouts, and other stimulants**. Hallucinogens and cannabis also carry significant risk for psychosis relapse. Your mind recovers best when it isn’t fighting against chemical overstimulation."),
        
        ("Reality Check With Someone You Trust",
         "When your mind feels distorted or overwhelming, connect with someone who is calm, grounded, and emotionally steady. Share what you’re experiencing and ask them what they’re perceiving. Using an external reference point helps clarify what’s internal versus what’s actually happening around you. A grounded friend or family member can gently reality-check your interpretations, reduce spiraling, and remind your brain that you are safe."),
        ("Avoid Isolation",
         "Avoid Isolation during extreme states. Being alone for too long amplifies intrusive thoughts, sensory distortions, and emotional overwhelm. The mind has fewer external cues to anchor to, making internal experiences feel louder and more convincing. Stay connected to safe, grounded people whether through conversation, shared space, or gentle social activity."),
        ("Avoid Assumptions About What Others Are Thinking",
         "Fear of abandonment distorts perception. Pause before believing the worst-case scenario."),
        ("Repair After Rupture",
         "If you react intensely, come back gently: 'I felt scared. I’m sorry I panicked.' Repair builds trust and an apology for acting badly can go a long way."),
        
        ("Speak Thoughts Aloud",
         "Putting your thoughts into spoken words helps organize them and reduces their intensity. When everything stays internal, ideas can feel tangled, amplified, or overwhelming. Use a calm, steady voice to externalize your thoughts and improve clarity."),
        ("Make Multimedia Art",
         "Creating multimedia art can channel overwhelming sensations into something tangible and grounded. Combine materials such as paint, markers, magazine cutouts, photos, fabric, or small objects you’ve found, and glue them into a single piece. This hands-on process engages multiple senses at once, helping to organize internal intensity and redirect your focus outward."),
        ("Get Creative With Your Cooking",
         "Make a list of foods that help with psychosis, such as those that support GABA and acetylcholine production, and create new recipes that are all your own."),
        ("Paint A Picture",
         "The act of choosing colors, making shapes, and focusing on your hands engages the sensory system in a calming, organized way. Even a simple painting can reduce internal pressure, slow racing thoughts, and bring you back to feeling like yourself again."),
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
    // BODY
    // ---------------------------------------------------------
    var body: some View {
        ZStack {
            StarryNightBackground()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    Text("Psychosis Tips")
                        .font(.system(size: 46, weight: .black))
                        .foregroundColor(.white)
                        .scaleEffect(pulse ? 1.08 : 1.0)
                        .animation(.easeInOut(duration: 1.8).repeatForever(),
                                   value: pulse)
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
    // TIP CARD VIEW (MODIFIED)
    // ---------------------------------------------------------
    @ViewBuilder
    
    func tipHasButtons(_ i: Int) -> Bool {
        switch i {
        case 3, 4, 5, 7, 8, 9, 11, 12, 18, 21, 24, 26:
            return true
        default:
            return false
        }
    }
    
    func tipBox(_ i: Int) -> some View {
        VStack(alignment: .leading, spacing: 12) {

            //-----------------------------------------------------
            // TITLE + CHEVRON
            //-----------------------------------------------------
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

            //-----------------------------------------------------
            // EXPANDED CONTENT
            //-----------------------------------------------------
            if expandedIndex == i {

                //-------------------------------
                // PARAGRAPH TEXT
                //-------------------------------
                if let attributed = try? AttributedString(markdown: tips[i].description) {
                    Text(attributed)
                        .font(.custom("Avenir", size: 17))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                } else {
                    Text(tips[i].description)
                        .font(.custom("Avenir", size: 17))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }

                if tipHasButtons(i) {
                    Spacer().frame(height: 2)

                    VStack(alignment: .leading, spacing: 14) {
                        switch i {
                        case 3:
                            bubbleButton("Open iOS Settings") {
                                if let url = URL(string: UIApplication.openSettingsURLString) {
                                    UIApplication.shared.open(url)
                                }
                            }
                            
                            case 4:
                                bubbleButton("Learn Breathing Techniques") {
                                    navModel.push("BreathworkView")
                                }
                            
                            case 5:
                            bubbleButton("Try Yoga Techniques") {
                                navModel.push("YogaView")
                            }
                            
                            case 7:
                                bubbleButton("Start Prayer") {
                                    navModel.push("PrayerView")
                                }

                            case 8:
                                bubbleButton("Open Fitness Space") {
                                    navModel.push("FitnessSpaceView")
                                }
                            case 9:
                            bubbleButton("Take A Selfie") {
                                navModel.openProgressCameraOnAppear = true
                                navModel.push("FitnessSpaceView")
                                }
                            case 11:
                                bubbleButton("Plan A Workout Routine") {
                                    navModel.push("WorkoutPlannerView")
                                }
                            
                            case 12:
                                bubbleButton("Open Psychosis Tips") {
                                    navModel.push("PsychosisTipsView")

                                }
                            
                            case 18:
                                bubbleButton("Open Spotify") {
                                    if let url = URL(string: "spotify://") {
                                        UIApplication.shared.open(url)
                                    }
                                }
                            
                            case 21:
                                bubbleButton("Open Goals") {
                                    navModel.push("GoalsView")
                                }

                            case 24:
                                bubbleButton("Open Day Planner") {
                                    navModel.push("DayPlannerView")
                                }
                            
                            case 26:
                                bubbleButton("Sleep Hygiene Checklist") {
                                    navModel.push("SleepHygieneView")
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
    // BUBBLE BUTTON STYLE B
    // ---------------------------------------------------------
    // BUBBLE BUTTON — REDESIGNED
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
        .frame(maxWidth: .infinity)            // centers inside paragraph box
        .shadow(color: Color.white.opacity(0.55), radius: 8)
        .scaleEffect(localPulse ? 1.04 : 1.0)  // LOCAL pulse state
        .animation(.easeInOut(duration: 1.2).repeatForever(), value: localPulse)
        .onAppear { localPulse = true }        // starts reliably in scroll views
        .padding(.bottom, 10)                   // equal gap below
    }
}
