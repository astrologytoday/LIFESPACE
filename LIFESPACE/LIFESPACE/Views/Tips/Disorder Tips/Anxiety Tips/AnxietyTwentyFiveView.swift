import SwiftUI
// ---------------------------------------------------------
// MAIN VIEW
// ---------------------------------------------------------
struct AnxietyTwentyFiveView: View {
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
        ("Dim Lights In The Evening",
         "Make space for yourself by lowering stimulation and reducing movement in the evening to stabilize and regulate emotions."),
        ("Avoid Harsh Fluorescent Lighting",
         "Fluorescent flicker overstimulates the nervous system and can trigger irritability, dissociation, or emotional overload in sensitive individuals."),
        ("Try Using Trataka Techniques",
         "Trataka is an ancient practice that involves candle gazing to activate the parasympathetic nervous system. When gazing into a candle's flame, the pineal gland emits its own biophotons which can awaken inner processes that affect melatonin, serotonin, and the circadian rhythm."),
        
        ("Practice Breathing Exercises",
         "The 4-4-4 Breathing Technique (also known as 'Box Breathing') helps ease anxiety and tension. To do this, inhale for 4 seconds, hold your breath for 4 seconds, and exhale slowly for 4 seconds. Alternatively, the 4-7-8 method requires you to inhale through your nose for 7 seconds, hold for 4 seconds, and exhale through your mouth for 8 seconds."),
        ("Practice Daily Yoga or Prayer Meditation",
         "Daily yoga or meditative prayer works by changing your brain, lowering cortisol and calming the nervous system so emotional regulation can improve."),
        ("Name the Fear Clearly",
         "Ask yourself: 'What specifically am I afraid of right now?' Anxiety becomes smaller when it’s defined instead of floating and shapeless."),
        ("This Too Shall Pass",
         "Repeat grounding truths: 'I am safe in this moment.' 'This feeling will pass.' 'My body is reacting, not predicting.'"),
        
        ("Do An Intense Exercise",
         "A good workout releases endorphins, improves circulation, and lowers stress hormones, all of which can rapidly reduce emotional overwhelm."),
        ("Track Your Fitness Progress",
         "Logging your workouts reinforces identity. Progress tracking builds motivation, reveals patterns, and strengthens self-image through measurable, consistent action."),
        ("Use Exercise As Your Cognitive Reset",
         "When you feel overwhelmed or like you're spiraling, a quick workout interrupts the loop."),
        ("Build A Fitness Plan",
         "A structured plan reduces decision fatigue and builds behavioral consistency. Define your goal, schedule realistic workouts, and include fallback options."),
        
        ("Eat An Orthomolecular Diet",
         "Prioritize magnesium, B-vitamins, amino acids, omega-3s, and mineral-rich foods. Reduce sugar, caffeine, alcohol, and processed food to stabilize the nervous system. Create a shopping list and develop a meal plan that targets the main neurotransmitters that affect people with anxiety. See the 'Nutrient Recommendations' section on the previous Anxiety Tips page for more information."),
        ("Regulate Blood Sugar",
         "Eat consistent meals with protein, fiber, and healthy fats. Blood sugar crashes mimic anxiety symptoms."
        ),
        ("Drink Herbal Tea",
         "Herbal teas like chamomile, lemon balm, and lavender contain natural compounds that calm the nervous system and regulate stress pathways. Warm fluids also activate parasympathetic relaxation, lowering muscle tension and slowing intrusive thoughts."),
        ("Take Vitamins That Support Brain Health",
         "Consider magnesium glycinate, taurine, inositol, B-complex, L-theanine, or GABA (with support). These nutrients regulate neurotransmitters that calm the system."),
        
        ("Keep Your Space Clean & Decluttered",
         "Schedule a monthly decluttering session. Empty one drawer, shelf, or closet at a time, toss trash, donate what you don’t use, and put everything else back with intention. Removing clutter reduces background stress and makes your space feel calmer and easier to think in."),
        ("Try Hz-Based Vibrational Audio Therapy",
         "Binaural beats regulate brainwaves. Listening to specific frequencies — such as 432Hz for grounding or 528Hz for mood elevation — can reduce agitation, enhance focus, and induce calm."),
        ("Weighted Pressure & Deep Touch",
         "Weighted blankets, compression gear, or firm hugs calm the vagus nerve and reduce instability during emotional activation."),
        ("Epsom Salt Baths",
         "Warm Epsom salt baths relax the muscles through magnesium absorption. Add calming oils like lavender or chamomile and keep lights dim to lower cortisol."),
        
        ("Develop a Self-Anchor",
         "Create a short sentence that grounds your identity: 'I am learning.' 'I have a purpose.' 'I am becoming.' This builds inner continuity."),
        ("Set Digital Boundaries",
         "Limit exposure to chaotic media or overstimulating conversations. Declutter your digital world to reduce unnecessary activation."),
        ("Get A Plant",
         "Having a plant nearby creates a calming presence and offers a simple, grounding focus when anxiety feels overwhelming. The steady rhythm of watering and tending to a living thing encourages mindfulness and helps shift your attention away from racing thoughts. The natural green color and growth also signal safety to the nervous system, making your space feel more peaceful."),
        ("Build a Future Self Narrative",
         "Picture a wiser, calmer, healed version of yourself. Let that version guide decisions during emotional storms."),
        
        ("Stabilize Through Routine",
         "Predictability brings safety. Simple anchors like a morning ritual, consistent sleep, or regular meal schedule can help regulate emotional depth."),
        ("Learn What Coping Strategy Works For You",
         "Remind yourself that healing takes time and is possible. When urges to self-sabotage arise, pause and reach for a safe coping skill instead. Your safety and well-being should always come first."),
        ("Embrace Your Hobbies",
         "Find a hobby you enjoy and embrace it. Whether it’s cooking, gardening, gaming, painting, or collecting something meaningful, hobbies create structure, identity, and small daily wins. They anchor your attention, reduce impulsive urges, and just make you feel good overall."),
        ("Avoid Stimulants",
         "Reduce caffeine, energy drinks, nicotine, and certain pre-workouts. Stimulants hijack the same circuitry as panic."),
        
        ("Build Connections",
         "Introducing yourself to someone you don’t know opens the door to new experiences and connection. A brief, low-pressure interaction with someone new can gently signal safety to your nervous system, reduce hypervigilance, and remind your body that social contact does not have to be threatening."),
        ("Never Put All Your Eggs In One Basket",
         "Balance your time, money, and relationships. Relying on just one person or pursuit can intensify emotional swings and lead to disappointment. Diversifying means supporting your stability and resilience in everyday life."),
        ("Avoid Assumptions About What Others Are Thinking",
         "Fear of abandonment distorts perception. Pause before believing the worst-case scenario."),
        ("Start With Small Interactions",
         "Short, low-stakes social moments teach your brain that people are safe. Begin with low-pressure interactions: a quick hello, brief eye contact, a short comment to a cashier. These tiny exposures gently retrain your nervous system to reduce social anxiety symptoms."),
        
        ("Write Down Who You Are",
         "Write down values, preferences, and the things that identify you. Emotional intensity can blur identity. Write your story so you don't forget who you are."),
        ("Sing Your Heart Out",
         "Singing interrupts the physiological loop of social anxiety by activating the vagus nerve, slowing the breath, and lifting emotional tension. It shifts your focus from internal worry to embodied expression."),
        ("Get Creative With Your Cooking",
         "Make a list of foods that help with anxiety, such as those that support GABA production, and create new recipes that are all your own."),
        ("Write Stream of Consciousness Poetry",
         "Poetry lets you express emotional storms without needing to “make sense.” The act of translating feeling into language using automatic writing often reduces intensity and builds emotional clarity."),
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

                    Text("Anxiety Tips")
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
        case 4, 6, 8, 9, 11, 12, 15, 17, 24, 28, 32:
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
                Text(tips[i].description)
                    .font(.custom("Avenir", size: 17))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .transition(.opacity.combined(with: .move(edge: .top)))

                if tipHasButtons(i) {
                    Spacer().frame(height: 2)

                    VStack(alignment: .leading, spacing: 14) {
                        switch i {
                            case 4:
                                bubbleButton("Learn Breathing Techniques") {
                                    navModel.push("BreathworkView")
                                }
                            case 6:
                                bubbleButton("Open Journal") {
                                    let created = UserDefaults.standard.bool(forKey: "dreamPasswordCreated")
                                    navModel.push(created ? "DreamPasswordView" : "CreateDreamPasswordView")
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
                                bubbleButton("Open Anxiety Tips") {
                                    navModel.push("AnxietyTipsView")
        
                                }
                            case 15:
                                bubbleButton("Buy Vitamins") {
                                    if let url = URL(string: "https://www.hardynutritionals.com") {
                                        UIApplication.shared.open(url)
                                    }
                                }

                            case 17:
                                bubbleButton("Start Audio Therapy") {
                                    navModel.push("SoundBathView")
                                }

                            case 24:
                                bubbleButton("Open Day Planner") {
                                    navModel.push("DayPlannerView")
                                }

                            case 28:
                                bubbleButton("Meet Someone New") {
                                    navModel.push("CommunityTipsView")
                                }

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
