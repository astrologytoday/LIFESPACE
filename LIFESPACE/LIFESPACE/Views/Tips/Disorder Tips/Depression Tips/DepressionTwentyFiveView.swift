import SwiftUI
// ---------------------------------------------------------
// MAIN VIEW
// ---------------------------------------------------------
struct DepressionTwentyFiveView: View {
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
        ("Get Up Out Of Bed",
         "Don’t give depression a chance to pull you back under after waking. Get up out of bed the moment your eyes start to open. Staying in bed or lying in the dark makes it harder to break free from the heavy grip of inertia. Force yourself to move, even if it’s just sitting up or swinging your feet to the floor. Micro-movements matter: standing up, walking to another room, or opening the curtains all start to break the “freeze” that depression can create."),
        ("Avoid Screens Before Bed",
         "Sleep hygiene is critical for beating depression, and late-night screen use can disrupt it. Blue light from phones, TVs, and computers delays melatonin release, keeps the brain in a hyper-alert state, and increases sensory overstimulation that can disturb your sleep. To protect your sleep cycle, minimize screen exposure **at least one hour before bed.** Consider downloading a blue-light–filtering tool to your computer, or activating *Night Shift* in your iOS settings."),
        
        ("This Too Shall Pass",
         "Repeat grounding truths: 'I am safe in this moment.' 'This feeling will pass.' 'My body is reacting, not predicting.' Speak aloud the opposite of your negative thoughts. For example, if you think 'I am worthless,' say: 'I am still becoming.' Rewiring begins with contradiction."),
        ("Keep A Journal",
         "Journaling helps you process emotions, track patterns, and clarify thoughts. Writing regularly is shown to reduce emotional intensity and support self-awareness and healing. Journal without pressure. Just dump your thoughts in bullet points or messy handwriting. Clear the fog."),
        ("Nature Walks",
         "Walk through a forest, along a winding trail, or into a wild green space. Surrounded by trees, water, or open sky, your senses begin to wake up: the scent of soil, the rustle of leaves, and shifting light all work together to gently ease the mind out of depression’s grip. Exposure to living, breathing environments lowers stress hormones, regulates heart rate, and supports healthy dopamine and serotonin levels which are key for lifting mood and restoring motivation. Let your eyes wander, feel the ground beneath your feet, and breathe deeply. Simply being present in any natural biome is enough to break through mental fog and isolation."),
        ("Try Aromatherapy",
         "Meta-analyses show that inhaling essential oils has a moderate effect on improving mood, reducing stress, and easing emotional heaviness. It’s been found beneficial across several groups, including older adults, menopausal women, and individuals with cardiovascular conditions, likely due to its ability to regulate the nervous system and lower physiological markers of stress. For the best results, choose **100% pure essential oils,** not synthetic fragrance oils, which lack the therapeutic compounds that studies rely on. Scents like lavender, bergamot, citrus, and rosemary may help reduce tension, increase alertness, or lift mood when inhaled or diffused."),
        
        ("Do An Intense Exercise",
         "A good workout releases endorphins, improves circulation, lowers stress hormones, and builds confidence! All of these combined can rapidly reduce emotional overwhelm and feelings of depression."),
        ("Track Your Fitness Progress",
         "Logging your workouts reinforces identity. Progress tracking builds motivation, reveals patterns, and strengthens self-image through measurable, consistent action."),
        ("Use Exercise As Your Cognitive Reset",
         "When you feel overwhelmed or like you're spiraling, a quick workout interrupts the loop."),
        ("Build A Fitness Plan",
         "A structured plan reduces decision fatigue and builds behavioral consistency. Define your goal, schedule realistic workouts, and include fallback options."),
        
        ("Eat An Orthomolecular Diet",
         "In many cases, depression is biochemical. Prioritize foods rich in **magnesium, B-vitamins (especially B6, B12, and folate), omega-3 fatty acids (EPA and DHA), zinc, vitamin D, and high-quality protein.** These nutrients play a critical role in serotonin and dopamine production, brain inflammation reduction, and overall mood stabilization. Regularly include sources like leafy greens, beans, eggs, salmon, walnuts, pumpkin seeds, whole grains, and fortified dairy or non-dairy milks. Create a shopping list and develop a meal plan that specifically targets neurotransmitter balance, anti-inflammatory support, and brain health. For further guidance, see the Nutrient Recommendations section on the previous Depression Tips page. Take vitamins and supplement wisely! Treatments work best under the guidance of a healthcare provider or nutritionist."),
        ("Front-Load Protein in the Morning",
         "Start your day with 20–30g of protein to boost dopamine and stabilize your energy early. Depression loves blood sugar crashes."),
        ("Intermittent Fasting",
         "Intermittent fasting (IF) is an eating pattern that alternates periods of eating and fasting. Some studies suggest it may increase brain-derived neurotrophic factor (BDNF), reduce oxidative stress, and enhance mitochondrial health, which are mechanisms linked to improved mood and reduced depressive symptoms. One simple method is to eat breakfast between 5:00 and 9:00am and dinner between 5:00 and 7:00pm, skipping lunch and avoiding snacks or calories in between. Remember to stay hydrated, focus on nutrient-rich foods, and listen to your body’s signals."),
        ("Eliminate Alcohol",
         "Alcohol falls under the 'depressant' drug class and can worsen symptoms of depression in already depressed individuals. Depressed individuals may be more sensitive to alcohol’s emotional blunting or numbing effects. After the effects wear off, depressed people are especially prone to stronger 'rebound' symptoms: deeper sadness, more intense anxiety, and lower mood than before drinking. This 'emotional crash' can feel sharper and more severe due to underlying neurochemical imbalances."),
        
        ("Keep Your Space Clean & Decluttered",
         "Schedule a monthly decluttering session. Empty one drawer, shelf, or closet at a time, toss trash, donate what you don’t use, and put everything else back with intention. Removing clutter reduces background stress and makes your space feel calmer and easier to think in."),
        ("Take Cold Showers",
         "Cold exposure momentarily activates the body’s natural alertness pathways, increasing norepinephrine and improving circulation (both major contributors to healing from depression.) Challenging yourself with cold water also builds confidence and reminds you that you can handle tough situations."),
        ("Set Digital Boundaries",
         "Limit digital drain by stepping away from the scrolling loops. Depression thrives on passivity. Limit exposure to chaotic media and break the trance."),
        ("Use the Cognitive Reset Button",
         "Depression can cause 'freezing' episodes where you feel stuck, unable to start even simple tasks. When this happens, use the Cognitive Reset button to interrupt the trance and get moving, even in a small way. Once you complete your reset task, go straight to the Day Planner to outline your next steps, then act on your plan right away."),
        
        ("Set Goals For Yourself",
         "Setting goals raises motivation and provides a sense direction. Start with **SMART goals:** make them *Specific, Measurable, Achievable, Relevant,* and *Time-bound.* Breaking larger dreams into small, realistic steps helps you see progress and prevents overwhelm. Alongside daily or weekly goals, consider building a **5-Year Plan.** This long-term roadmap gives purpose and a sense of forward motion, even when the path feels uncertain."),
        ("Build a Future Self Narrative",
         "Picture a wiser, calmer, healed version of yourself. Let that version guide decisions during emotional storms."),
        ("Revisit Past Interests or Passions",
         "When depression makes life feel flat or directionless, it can help to gently reconnect with activities or interests you once enjoyed. Think back to hobbies, causes, or creative outlets that used to spark curiosity or joy. Allow yourself to revisit them without expectation or pressure. You might read about a favorite subject, listen to old playlists, or pick up a project you set aside."),
        ("Get A Plant",
         "Caring for a plant introduces gentle routine, responsibility, and visible life into your environment, which are often diminished in depression. Watching something grow through small, consistent care can support motivation, restore a sense of purpose, and reinforce the belief that your actions still matter, even on low energy days."),
        
        ("Embrace Your Hobbies",
         "Find a hobby you enjoy and embrace it. Whether it’s cooking, gardening, gaming, painting, or collecting something meaningful, hobbies create structure, identity, and small daily wins. They anchor your attention, reduce impulsive urges, and just make you feel good overall."),
        ("Learn What Coping Strategy Works For You",
         "Remind yourself that healing takes time and is possible. When urges to self-sabotage arise, pause and reach for a safe coping skill instead. When you find out what that is, hold onto it, and remember what works for you in times of trouble."),
        ("Practise Sleep Hygiene",
         "Create a predictable sleep routine. Aim to go to bed and wake up at the same time every day, even on weekends. Avoid screens and bright lights before bed, and create a calming wind-down ritual, such as reading, listening to soft music, or taking a warm shower. Keep your bedroom cool, dark, and quiet to promote deep, restorative rest. Prioritizing sleep hygiene not only supports emotional stability but also gives your mind and body the resilience needed to beat depression."),
        ("Avoid Sleep Deprivation Triggers",
         "To give yourself the best chance at restful sleep, limit caffeine after noon. Avoid heavy meals late in the evening, as digestion can disrupt your rest. Steer clear of screens in bed, since the blue light from phones and computers can interfere with melatonin production and keep your mind alert when you need to wind down."),
        
        ("Build Connections",
         "Introducing yourself to someone you don’t know opens the door to new experiences and connection. Even a short, friendly exchange can boost your mood and remind you that positive social moments are always possible."),
        ("Never Put All Your Eggs In One Basket",
         "Balance your time, money, and relationships. Relying on just one person or pursuit can intensify emotional swings and lead to disappointment. Diversifying means supporting your stability and resilience in everyday life."),
        ("Take Off the Mask With One Person",
         "Depression often makes you feel like you have to hide your true feelings or put on a brave face for others. Choose just one person you trust: a friend, family member, or therapist, and let yourself be real with them. Sharing your authentic self, even in small ways, can ease the burden of isolation and reduce the pressure to pretend."),
        ("Start With Small Interactions",
         "Short, low-stakes social moments teach your brain that people are safe. Begin with low-pressure interactions: a quick hello, brief eye contact, a short comment to a cashier. These tiny exposures gently retrain your nervous system to reduce symptoms of depression."),
        
        ("Write Down Who You Are",
         "Write down values, preferences, and the things that identify you. Emotional intensity can blur identity. Write your story so you don't forget who you are."),
        ("Learn A Musical Skill",
         "Engaging with music activates both hemispheres of the brain, supporting emotional processing, sharper focus, and deeper self-expression. Making music is a healthy way to channel feelings that may be difficult to voice, and as your skills grow, you build confidence and experience moments of accomplishment. Singing helps interrupt cycles of rumination and emotional tension by slowing your breath and activating the vagus nerve. It shifts your attention from internal worries to embodied, creative expression. Whether you sing alone, join a group, or play an instrument, let music be a source of relaxation, joy, and connection as you move through depression."),
        ("Get Creative With Your Cooking",
         "Make a list of foods that help with depression, such as those that support serotonin production, and create new recipes that are all your own."),
        ("Write Poetry",
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
    // BODY
    // ---------------------------------------------------------
    var body: some View {
        ZStack {
            StarryNightBackground()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    Text("Depression Tips")
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
        case 3, 5, 8, 9, 11, 12, 19, 21, 26, 28, 32:
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

                        case 5:
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
                            bubbleButton("Open Depression Tips") {
                                navModel.push("DepressionTipsView")
                            }

                        case 19:
                            bubbleButton("Cognitive Reset") {
                                navModel.push("DepressionResetView")
                            }

                        case 21:
                            bubbleButton("Open Goals") {
                                navModel.push("GoalsView")
                            }

                        case 26:
                            bubbleButton("Sleep Hygiene Checklist") {
                                navModel.push("SleepHygieneView")
                            }
                            
                        case 28:
                            bubbleButton("Open Community Tips") {
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


