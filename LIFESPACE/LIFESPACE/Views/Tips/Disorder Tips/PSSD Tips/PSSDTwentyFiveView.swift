import SwiftUI
// ---------------------------------------------------------
// MAIN VIEW
// ---------------------------------------------------------
struct PSSDTwentyFiveView: View {
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
        ("Try Using Trataka Techniques",
         "Trataka is an ancient practice that involves candle gazing to activate the parasympathetic nervous system. When gazing into a candle's flame, the pineal gland emits its own biophotons which can awaken inner processes that affect melatonin, serotonin, and the circadian rhythm."),
        ("Avoid Screens Before Bed",
         "Sleep hygiene is critical for healing, and late-night screen use can disrupt it. Blue light from phones, TVs, and computers delays melatonin release, keeps the brain in a hyper-alert state, and increases sensory overstimulation (all of which can intensify paranoia, thought pressure, and nighttime agitation.) To protect your sleep cycle, minimize screen exposure **at least one hour before bed.** Consider downloading a blue-light–filtering tool to your computer, or activating *Night Shift* in your iOS settings."),
        
        ("Practice Daily Yoga or Prayer Meditation",
         "Daily yoga or meditative prayer works by changing your brain, lowering cortisol and calming the nervous system so emotional regulation can improve."),
        ("Complete To-Do Lists",
         "Completing to-do lists restores autonomy, builds confidence, and strengthens the executive-function pathways responsible for drive and follow-through. Small wins accumulate, and each completed task reinforces your ability to direct your life, even during periods of blunted feeling."),
        ("Take Cold Showers",
         "Cold exposure momentarily activates the body’s natural alertness pathways, increasing norepinephrine and improving circulation (both major contributors to healing from PSSD.) Challenging yourself with cold water also builds confidence and reminds you that you can handle tough situations."),
        ("Practice Shadow Work",
         "Shadow Work is a method developed by Carl Jung which involves noticing emotions or traits you tend to avoid or judge. Reflect on your reactions, journal honestly, and integrate these hidden parts to support healing.'"),
        
        ("Incorporate HIIT Training",
         "High-intensity interval training boosts dopamine, endorphins, and cardiovascular activation. This type of exercise rapidly increases blood circulation reawakening systems of the body that may feel muted, making you feel more alert, present, and alive."),
        ("Build A Fitness Plan",
         "A structured plan reduces decision fatigue and builds behavioral consistency. Define your goal, schedule realistic workouts, and include fallback options."),
        ("Focus On Leg Day",
         "Working the large muscles of your legs through squats, lunges, or deadlifts stimulates robust blood circulation, floods the brain with oxygen, and supports healthy hormone production.Similarly, cycling is a dynamic, low-impact way to engage these muscle groups for extended periods, promoting cardiovascular health and sustained neurochemical activation."),
        ("Increase Endurance",
         "Building cardiovascular endurance through activities like brisk jogging, swimming, or cycling supports not only physical stamina but also neurochemical health. Endurance exercise raises levels of dopamine and endorphins while improving circulation and blood flow. "),
        
        ("Lower Serotonin, Raise Testosterone",
         "Chronic elevation of serotonin is a key factor in sexual dysfunction, linked to emotional flatness and reduced libido. To target serotonergic neural pathways, minimize high-glycemic carbohydrates and foods rich in tryptophan, which can boost serotonin. Instead, emphasize **zinc-rich proteins** (like beef, eggs, oysters), **healthy fats** (avocado, olive oil, nuts), and **cruciferous vegetables** (broccoli, kale) that promote testosterone synthesis and metabolic health. Include plenty of B-vitamins, magnesium, and vitamin D to support dopamine and androgen pathways."),
        ("Practice Intermittent Fasting",
         "Intermittent fasting helps regulate hormonal rhythms and can increase sensitivity to dopamine and testosterone. Restricting eating to a set window each day (such as 8 hours on, 16 hours off) gives the body time to rebalance insulin, reduce inflammation, and promote cellular repair. Fasting has been shown to upregulate brain-derived neurotrophic factor (BDNF), enhance neuroplasticity, and potentially improve androgen receptor sensitivity, counteracting PSSD symptoms. "),
        ("Hydrate and Add Electrolytes",
         "Aim for steady water intake throughout the day, and include electrolytes like magnesium, potassium, and sodium to support nerve signaling and balanced brain chemistry. Electrolytes help regulate electrical activity in the brain, stabilize mood, and prevent the fatigue or lightheadedness that can trigger mental overwhelm."),
        ("Always Eat Clean",
         "Sugar substitutes like aspartame and sucralose disrupt gut health and contribute to mood instability. For many people, cutting them out supports a clearer mind and steadier emotions. Chronic inflammation is a factor in mood and sexual health challenges, and this is contributed to by eating trans-fats, processed snacks, and fried items. Eating clean, whole foods is a practical way to tip the balance back toward well-being."),

        ("Keep Your Space Clean & Decluttered",
         "Schedule a monthly decluttering session. Empty one drawer, shelf, or closet at a time, toss trash, donate what you don’t use, and put everything else back with intention. Removing clutter reduces background stress and makes your space feel calmer and easier to think in."),
        ("Try Hz-Based Vibrational Audio Therapy",
         "Vibrational sound frequencies can help retrain the brain and body at a fundamental level. Hz-based vibrational therapies, like binaural beats, use specific sound frequencies to entrain brainwaves, encourage relaxation, and promote emotional regulation. Some mystical traditions even attribute sexual healing to the sacral chakra, an area of the body located near the pelvis. Listening to binaural beats at or around 210 Hz range may help rekindle a sense of physical and emotional connection."),
        ("Foster Emotional Intimacy",
         "Restoring healthy sexual function and satisfaction often begins with emotional closeness. Deep touch activities, such as massage, gentle holding, or prolonged skin-to-skin contact, can activate the body’s parasympathetic response, reducing anxiety and building a sense of physical safety. Sharing thoughts, feelings, and intentions with your partner helps regulate the nervous system and reinforces trust. These practices help re-establish neural pathways associated with pleasure and bonding, making the experience of intimacy less performance-driven and more deeply attuned to mutual comfort."),
        ("Prioritize Self-Care",
         "Regular habits, like showering, grooming your hair, or choosing clothes that reflect your personal style, can all reinforce a sense of agency and dignity. Investing time in your presentation helps you rediscover aspects of your authentic identity that may feel diminished. When you look good, you’re more likely to feel good, and when you feel good, healing can begin."),
        
        ("Settle On Your Purpose",
         "Having an occupation that you love builds real confidence and self-worth. Beyond its psychological and financial benefits, a good job also functions biologically: when individuals pursue goals that align with their strengths and values, it regulates stress pathways and boosts reward-related neurotransmitters in the brain. Being emotionally satisfied with your work restores motivation, pleasure, and daily drive."),
        ("Set Digital Boundaries",
         "Setting healthy boundaries with digital content is crucial for restoring attention, motivation, and sexual health. Short-form media, such as rapid-fire videos and endless scrolling feeds, overstimulates dopamine pathways and can desensitize the brain’s natural reward system. This constant stream of novelty may impair the ability to sustain arousal or focus, and emerging research links excessive consumption of fast-paced digital content to increased rates of erectile dysfunction and decreased satisfaction in real-life intimacy."),
        ("Keep Track Of Your Finances",
         "Financial stress is a major contributor to performance anxiety. Uncertainty about money can trigger chronic stress responses, undermine feelings of safety, and make intimacy more difficult to initiate or sustain. By taking an active role in managing your finances, you create a foundation of stability and self-assurance. Being able to provide for yourself and those you care about also boosts confidence and reinforces your sense of competence."),
        ("Plan For The Future",
         "Physical symptoms of PSSD can take time to heal. Staying motivated by setting goals and looking ahead to the future is a good way to avoid depressive slumps that would otherwise halt progress. Consider developing a 5-Year-Plan outlining your goals, values, and actionable steps to becoming the person you want to be in the near future. When you feel prepared for what’s ahead, you’re more likely to make choices that support well-being, intimacy, and emotional stability."),
        
        ("Embrace Your Hobbies",
         "Find a hobby you enjoy and embrace it. Whether it’s cooking, gardening, gaming, painting, or collecting something meaningful, hobbies create structure, identity, and small daily wins. They anchor your attention, reduce impulsive urges, and just make you feel good overall."),
        ("Avoid Stimulants",
         "Stimulants (like amphetamines, cocaine, and nicotine) activate the sympathetic nervous system, causing vasoconstriction: narrowing of blood vessels, which could lead to sexual dysfunction. Stimulants raise adrenaline and cortisol levels. High adrenaline keeps the body in “fight-or-flight” mode, suppressing arousal and making it physically harder for the body to shift into a relaxed state. Stimulants can also cause or worsen anxiety, insomnia, and mood instability (each of which can independently contribute to sexual dysfunction or problems with arousal.)"),
        ("Limit Pornography Consumption",
         "Frequent consumption of pornography can desensitize the brain’s natural reward pathways and alter sexual response patterns. Over time, excessive exposure may **raise the threshold for arousal,** making real-life intimacy feel less stimulating and contributing to issues with arousal. Prioritizing mindful, present-moment sexual experiences can help retrain the nervous system and support a more satisfying, responsive sex life."),
        ("Maintain Sleep Hygiene",
         "Protect your sleep at all costs. Keep your room dark, cool, and quiet, and maintain a predictable bedtime. Create an evening wind-down ritual: dim the lights, take a warm shower, drink calming tea, or play gentle music. Predictable cues signal to the brain that the day is ending, reducing nighttime spiraling and sensory overstimulation. Avoid sleep deprivation triggers such as caffeine after noon, heavy meals late at night, or emotionally intense conversations close to bedtime."),
        
        ("Make Plans With Friends",
         "Social connection provides motivation, lifts mood, and reinforces your sense of belonging. Even limited social interaction has been shown to raise testosterone levels, which support confidence and sexual function. Whether it’s a simple meetup, a shared hobby, or a hike outdoors, spending time with others helps stimulate healthy dopamine and testosterone release, bringing hormonal balance that supports long-term well-being."),
        ("Step Outside Your Comfort Zone",
         "Engaging socially can feel challenging, especially when dealing with emotional blunting or low confidence. Don't be shy! Each time you initiate conversation, join a group, or simply make eye contact, you reinforce approach behaviors that strengthen both your sense of self and your biological resilience."),
        ("Avoid Isolation",
         "Spending too much time alone can worsen hormonal imbalances. Isolation reduces opportunities for positive social signals that boost dopamine and testosterone. Regular social contact acts as a buffer against stress and fosters healing over a long-term period."),
        ("Keep It Light",
         "Humor and friendliness not only ease tension and help you connect, but also trigger positive neurochemicals like dopamine and endorphins. Simple acts of kindness, a smile, or sharing a joke can break the ice and make socializing feel more natural. Keep social interactions light to reinforce positive feedback loops in your brain that support resilience and optimism."),
        
        ("Organize Your Space",
         "A thoughtfully organized environment is not only tidy, but a reflection of your identity and a tool for self-care. Arrange your space in a way that expresses who you are. Display items that inspire you, choose colors and objects that match your personality, and create areas dedicated to your interests or hobbies. Over time, this will foster a sense of ownership, stability, and pride."),
        ("Explore Your Interests",
         "Take time to mindfully practice self-exploration and discover what interests you. Small moments of positive sensation can gradually reawaken your body’s capacity for pleasure and emotional connection. Exploring what feels good is a key part of retraining your brain and nervous system, helping you discover new pathways to sexual well-being."),
        ("Get Creative With Your Cooking",
         "Make a list of foods that help with PSSD, such as those that support testosterone and GABA production, and create new recipes that are all your own. Try making recipes with some of the PSSD nurtritional recommendations."),
        ("Take An Acting Or Improv Class",
         "Community-based acting classes offer a powerful way to reconnect with emotion, spontaneity, and self-expression. These group activities encourage you to step into different roles, practice body language, and access a wide range of feelings in a supportive environment. Improv in particular strengthens social confidence and emotional responsiveness by rewarding presence and creativity in the moment. Participation can help retrain the brain’s reward pathways, improve communication skills, and foster a renewed sense of playfulness and identity, supporting recovery."),
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

                    Text("PSSD Tips")
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
        case 3, 4, 5, 7, 9, 17, 22, 23, 27, 29, 34:
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
                                bubbleButton("Try Yoga Techniques") {
                                    navModel.push("YogaView")
                                }
                            case 5:
                                bubbleButton("Open To-Do List") {
                                    navModel.push("ToDoListView")
                                }

                            case 7:
                                bubbleButton("Start Shadow Work") {
                                    navModel.push("ShadowWorkView")
                                }
                            case 9:
                                bubbleButton("Plan A Workout Routine") {
                                    navModel.push("WorkoutPlannerView")
                                }
                            case 17:
                                bubbleButton("Start Audio Therapy") {
                                    navModel.push("SoundBathView")
                                }
                            
                            case 22:
                                bubbleButton("Open Budget Planner") {
                                    navModel.push("BudgetPlannerView")
        
                                }
                            case 23:
                            bubbleButton("Make a 5-Year-Plan") {
                                navModel.push("FiveYearPlanView")
                                
                            }
                            
                            case 27:
                                bubbleButton("Sleep Hygiene Checklist") {
                                    navModel.push("SleepHygieneView")
                                }

                            case 29:
                                bubbleButton("Meet Someone New") {
                                    navModel.push("CommunityTipsView")
                                }

                            case 34:
                                bubbleButton("Open PSSD Tips") {
                                    navModel.push("PSSDTipsView")
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
