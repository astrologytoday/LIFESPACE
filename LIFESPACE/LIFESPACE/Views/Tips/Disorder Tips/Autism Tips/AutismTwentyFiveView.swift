import SwiftUI
// ---------------------------------------------------------
// MAIN VIEW
// ---------------------------------------------------------
struct AutismTwentyFiveView: View {
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
        (
            "Spend Time Outside",
            "Regular sunlight boosts vitamin D, balances circadian rhythms, and improves mood stability. Just a few minutes outdoors each day can help regulate emotions and energy levels."
        ),
        (
            "Replace White/Blue LEDs With Softer Colours",
            "Warm gold, peach, and soft red light are biologically calming and reduce impulsive behavior in the evening."
        ),
        (
            "Try Using Trataka Techniques",
            "Trataka is an ancient practice that involves candle gazing to activate the parasympathetic nervous system. When gazing into a candle's flame, the pineal gland emits its own biophotons which can awaken inner processes that affect melatonin, serotonin, and the circadian rhythm."
        ),
        (
            "Color-Changing Lights",
            "Fairy lights or color-changing lamps that you can control are a great way to create a sensory-friendly space. Adjusting the colors and brightness gives you safe, visual stimming options and lets you set the mood to what feels best in the moment. Soft, changing lights can help with relaxation, focus, or just provide comfort when you need it."
        ),
        (
            "Practice Daily Yoga",
            "Daily yoga or meditative prayer works by changing your brain, lowering cortisol and calming the nervous system so emotional regulation can improve."
        ),
        (
            "Keep A Journal",
            "Journaling helps you process emotions, track patterns, and clarify thoughts. Writing regularly is shown to reduce emotional intensity and support self-awareness and healing. Journal without pressure. Just dump your thoughts in bullet points or messy handwriting. Clear the fog."
        ),
        (
            "Do Shadow Work",
            "Shadow Work is a method developed by Carl Jung which involves noticing emotions or traits you tend to avoid or judge. Reflect on your reactions, journal honestly, and integrate these hidden parts to support healing."
        ),
        (
            "Nature Walks",
            "Walk through a forest, along a winding trail, or into a wild green space. Exposure to living, breathing environments lowers stress hormones, regulates heart rate, and supports healthy dopamine and serotonin levels which are key for lifting mood and restoring motivation. Take off your shoes and feel different surfaces under your feet, like soft grass, sand, pebbles, or cool earth. Exploring a variety of natural textures can provide soothing sensory input and help you feel more grounded and connected to your surroundings."
        ),
        (
            "Do An Intense Exercise",
            "A good workout releases endorphins, improves circulation, and lowers stress hormones, all of which can rapidly reduce emotional overwhelm and impulsivity in autistic individuals."
        ),
        (
            "Build A Fitness Plan",
            "A structured plan reduces decision fatigue and builds behavioral consistency. Define your goal, schedule realistic workouts, and include fallback options."
        ),
        (
            "Go Swimming",
            "Swimming can be a uniquely enjoyable and regulating activity for many autistic people. The gentle pressure of the water provides calming deep-touch input, which may help reduce stress and sensory overload. Swimming is also a repetitive, rhythmic exercise that can soothe the nervous system and support both physical and emotional well-being."
        ),
        (
            "Body-Doubling Workout",
            "Exercising alongside someone else, even if you’re doing different activities, can make workouts feel easier and more motivating. This approach, called body-doubling, provides gentle social support and structure, which can help with focus, consistency, and sticking to your fitness routine. You can body-double with a friend, family member, or a support worker. Try scheduling regular body-doubling workouts to help you stay on track and celebrate progress together."
        ),
        (
            "Eliminate Artificial Sweeteners",
            "Artificial sweeteners such as aspartame or sucralose can disrupt gut health and mood stability. Cutting them out supports healthier brain chemistry and has been linked to reduced irritability in autistic individuals."
        ),
        (
            "Build A Meal Plan",
            "Creating a meal plan can make eating less stressful and more predictable, especially if you have strong food preferences. Start by making a list of favorite foods and textures, and organize meals and snacks around them. Visual schedules or weekly meal charts can help reduce mealtime anxiety and keep your circadian rhythm on track."
        ),
        (
            "Balance Your Meals",
            "Aim to include a variety of foods in each meal, such as some protein, healthy fats, fruits or veggies, and whole grains. Even if you have strong food preferences or sensitivities, small, gradual changes can make a big difference over time. Building balanced meals from your favorite and most comfortable foods helps support energy, focus, and overall health."
        ),
        (
            "Crunchy Snack Break",
            "Taking a break to enjoy a crunchy snack can be a great way to meet sensory needs and refresh your focus. Crunchy foods like carrots, pretzels, granola bars, or rice cakes provide strong oral feedback, which can reduce anxiety for many autistic individuals."
        ),
        (
            "Keep Your Space Clean & Decluttered",
            "Schedule a monthly decluttering session. Empty one drawer, shelf, or closet at a time, toss trash, donate what you don’t use, and put everything else back with intention. Removing clutter reduces background stress and makes your space feel calmer and easier to think in."
        ),
        (
            "Prioritize Comfort Over Fashion",
            "Soft fabrics, breathable layers, and temperature-regulating options (i.e., thermals) can help you stay comfortable in any environment. Compression clothing may also provide calming sensory input. Dressing in a way that feels good helps prevent overload and supports focus and calm throughout your day."
        ),
        (
            "Wear Noise-Canceling Headphones",
            "Use noise‑canceling headphones to reduce overwhelming background sounds in busy or unpredictable environments. Lowering sensory input helps conserve mental energy, improve focus, and prevent sensory overload before it builds."
        ),
        (
            "Wear Sunglasses",
            "Sunglasses can reduce light sensitivity and visual overload, especially in bright or crowded environments. They can also ease the pressure of direct eye contact in social situations, helping you feel more regulated, comfortable, and present."
        ),
        (
            "Transition Rituals",
            "Switching from one activity to another can be challenging, but short rituals can help your brain and body adjust more smoothly. Try using a 1-minute stretch, changing the lighting, listening to a favorite sound, or sipping water between tasks. These small, consistent actions act as cues that it’s time to shift gears, making transitions feel more predictable and less overwhelming. Creating your own transition rituals can provide comfort, support focus, and bring a sense of control to changes in your day."
        ),
            (
                "Get A Plant",
                "Watching a plant grow provides gentle visual interest and a calming anchor without social pressure. Caring for a plant lets you engage with nature at your own pace, and you can choose a type with textures, colors, or scents that feel comfortable for your sensory preferences."
            ),
            (
            "Reduce Multi-Tasking",
            "Focusing on one task at a time can help you feel more calm and in control. Multitasking often fragments attention, increases stress, and makes it harder to finish what you start, especially if you’re already processing a lot of sensory input. Give yourself permission to work on just one thing before moving to the next. This approach reduces overwhelm, supports better focus, and helps you experience a greater sense of accomplishment throughout your day."
        ),
        (
            "Break Tasks Into Predictable Steps",
            "Write out each part of a specific task in order, and focus on completing one step at a time. Predictable, step-by-step instructions help you know what to expect and reduce uncertainty, which can make starting and finishing tasks feel much more achievable."
        ),
        (
            "Read For Pleasure",
            "Reading shifts your mind into a calmer, more imaginative state, and is shown to increase intelligence. Books can transport you mentally and help you settle instead of spiral."
        ),
        (
            "Practice Sleep Hygiene",
            "Protect your sleep at all costs. Keep your room dark, cool, and quiet, and maintain a predictable bedtime. Create an evening wind-down ritual: dim the lights, take a warm shower, drink calming tea, or play gentle music. Predictable cues signal to the brain that the day is ending, reducing nighttime spiraling and sensory overstimulation. Avoid sleep deprivation triggers such as caffeine after noon, heavy meals late at night, or emotionally intense conversations close to bedtime."
        ),
        (
            "Special-Interest Walks",
            "Combine your favorite interests with gentle movement by going on special-interest walks. This could mean playing Pokémon GO, train-spotting, bird-watching, or exploring a topic you love outdoors. These walks blend the comfort of hyper-focus with the benefits of fresh air and light exercise, which can boost dopamine and improve your mood."
        ),
        (
            "Deep Dives",
            "Give yourself permission to fully immerse in your current special interest by drawing, writing, building, coding, filming, or just learning about it. Deep-diving into what fascinates you taps into hyper-focus and creativity, often leading to a pure flow state where time slips away and the world feels quiet."
        ),
        (
            "Use Direct Communication",
            "Say exactly what you mean whenever possible. Clear, direct communication helps prevent misunderstandings and makes interactions easier for everyone involved. It also reduces emotional labor, so you don’t have to guess or interpret hidden meanings. If you’re not sure how a joke or comment might be received, it’s okay to skip it. Avoiding inappropriate jokes or sarcasm can help keep conversations comfortable and respectful for you and others. Focusing on honesty and clarity creates more predictable, positive social experiences."
        ),
        (
            "Social Recovery Time",
            "Schedule decompression after social interaction. Silence, dim light, and solitude help your nervous system return to baseline."
        ),
        (
            "Parallel Play",
            "Enjoy time with others without the pressure to talk or interact directly by trying parallel play. This could mean gaming, drawing, or reading side-by-side with a friend. You can also plan low-demand hangouts, like a quiet picnic where simply lying on a blanket and watching the clouds is encouraged. Parallel play lets you connect with others in a way that feels comfortable and safe, offering companionship without the stress of constant conversation."
        ),
        (
            "Repair After Rupture",
            "If you react intensely, come back gently: 'I felt scared. I’m sorry I withdrew or panicked.' Repair builds trust and an apology for acting badly can go a long way."
        ),
        (
            "Learn An Instrument",
            "Music engages both hemispheres of the brain, improving emotional processing, focus, and self-expression. It is a great way to relax and also builds confidence as your skills grow over time."
        ),
        (
            "Solo Dance Party",
            "Have your own solo dance party in a dimly lit room. Moving your body to music provides strong proprioceptive input, which can help regulate your vestibular system and release anxious energy in a fun, safe way. Dancing alone means you can go at your own pace and move however feels best. Build your own playlist to your liking to create a soothing auditory environment and make the experience enjoyable."
        ),
        (
            "Texture Art",
            "Explore art projects that focus on texture and sensory experience, such as working with clay, wool roving, sand, acrylic painting, or watercolors that bleed and blend. Creating with rich textures can be calming and deeply satisfying, offering hands-on sensory input as you make something unique."
        ),
        (
            "Blogging",
            "Express yourself online through anonymous blogging or posting, be it on Tumblr, AO3, Reddit with an alternate account, or a private YouTube channel. Sharing your thoughts, art, or interests this way lets you communicate without the pressure of using your real name. Consider keeping one special anonymous account just for raw expression. This gives you a safe outlet to process feelings, share passions, and connect with others at your own pace."
        )
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
                    
                    Text("Autism Tips")
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
        case 4, 5, 6, 8, 9, 13, 20, 25, 33:
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
                            
                        case 4:
                            bubbleButton("Try Yoga Techniques") {
                                navModel.push("YogaView")
                            }
                        case 5:
                            bubbleButton("Open Journal") {
                                let created = UserDefaults.standard.bool(forKey: "dreamPasswordCreated")
                                navModel.push(created ? "DreamPasswordView" : "CreateDreamPasswordView")
                            }
                            
                        case 6:
                            bubbleButton("Do Shadow Work") {
                                navModel.push("ShadowWorkView")
                            }
                            
                        case 8:
                            bubbleButton("Open Fitness Space") {
                                navModel.push("FitnessSpaceView")
                            }
                            
                        case 9:
                            bubbleButton("Plan A Workout Routine") {
                                navModel.push("WorkoutPlannerView")
                            }
                            
                        case 13:
                            bubbleButton("Make A Meal Plan") {
                                navModel.push("MealPlannerView")
                            }
                            
                        case 20:
                            bubbleButton("Open Day Planner") {
                                navModel.push("DayPlannerView")
                            }
                            
                        case 25:
                            bubbleButton("Sleep Hygiene Checklist") {
                                navModel.push("SleepHygieneView")
                            }
                            
                            
                        case 33:
                            bubbleButton("Make A Playlist") {
                                if let url = URL(string: "spotify://") {
                                    UIApplication.shared.open(url)
                                }
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
