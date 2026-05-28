import SwiftUI
// ---------------------------------------------------------
// MAIN VIEW
// ---------------------------------------------------------
struct ADHDTwentyFiveView: View {
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
         "Lowering the lights signals to your nervous system that it’s time to wind down, making it easier to stabilize emotions and prepare for sleep. Avoid using the computer or phone before bed, as blue light from screens can disrupt melatonin production and delay sleep. If you need to use a device, install an app like **f.lux** for your computer or activate **Night Shift in your iOS Settings** to automatically reduce blue light in the evenings. Small changes in your nighttime routine can drastically improve sleep quality which is important for managing ADHD."),
        ("Replace White/Blue LEDs With Softer Colours",
         "ADHD brains are especially sensitive to the intensity and tone of their environment. Harsh white or blue LED lighting can keep your nervous system in a state of alertness, making it harder to relax, focus, or settle down at night. Swapping out these lights for warmer tones such as soft gold, peach, or gentle red, can lead to more organized thinking patterns."),
        ("Try Using Trataka Techniques",
         "Trataka is an ancient practice that involves candle gazing to activate the parasympathetic nervous system. When gazing into a candle's flame, the pineal gland emits its own biophotons which can awaken inner processes that affect melatonin, serotonin, and the circadian rhythm."),
        
        ("Practice Daily Yoga",
         "Daily yoga offers clinically supported benefits for individuals with ADHD by integrating physical movement, mindfulness, and breath regulation which support dopamine and GABA pathways regulation. Research shows that regular yoga practice can reduce hyperactivity and inattention while also lowering stress hormones and improving self-regulation."),
        ("Keep A Journal",
         "Journaling helps you process emotions, track patterns, and clarify thoughts. Writing regularly is shown to reduce emotional intensity and support self-awareness and healing."),
        ("Cold Water Techniques",
         "Sudden cold activates the mammalian dive reflex, a built-in calming response that slows the heart rate and shifts your body out of fight-or-flight mode. For many with ADHD, these techniques can quickly interrupt spiraling thoughts, increase alertness, and help you regain control during periods of distraction. If you feel yourself caught in a loop, try splashing your face with cold water, holding ice cubes in your hands, or taking a quick cold shower or plunge if it’s available."),
        ("Micro-Steps & The Two-Task Rule",
         "Choose just two meaningful tasks for your day. Once you’ve chosen your tasks, break each task into micro-steps. For example, instead of “clean the room,” write “pick up 5 items” or “fold 3 shirts.” Micro-steps turn big, vague goals into clear, winnable actions, helping you bypass overwhelm and build instant momentum."),
        
        ("Do An Intense Exercise",
         "A good workout releases endorphins, improves circulation, and lowers stress hormones, all of which can rapidly reduce emotional overwhelm and impulsivity in ADHD."),
        ("Track Your Fitness Progress",
         "Logging your workouts reinforces identity. Progress tracking builds motivation, reveals patterns, and strengthens self-image through measurable, consistent action."),
        ("Use Exercise As Your Cognitive Reset",
         "When you feel distracted or like you're spiraling, a quick workout interrupts the loop."),
        ("Build A Fitness Plan",
         "A structured plan reduces decision fatigue and builds behavioral consistency. Define your goal, schedule realistic workouts, and include fallback options."),
        
        ("Eat An Orthomolecular Diet",
         "Prioritize foods rich in tyrosine such as eggs, fish, lean meats, dairy, nuts, and seeds. Also, include sources of **vitamin B6, magnesium, zinc, and iron,** all of which are critical for dopamine production and regulation. Try creating a shopping list and developing a meal plan that specifically targets nutrients for dopamine and epinephrine production. For more guidance, see the *Nutrient Recommendations* section on the previous ADHD Tips page."),
        ("Front-Load Protein + Fat",
         "Start your day with a dopamine-stabilizing breakfast: eggs, Greek yogurt, salmon, chicken, nuts, chia pudding, or tofu. ADHD brains run better with early amino acids and steady blood sugar. It’s important for ADHD brains to **consume protein every 3–4 hours.** Steady protein prevents dopamine crashes. Keep snacks like nuts, cheese, tuna packs, eggs, or protein bars ready."),
        ("Always Eat Clean",
         "Reduce or eliminate sugar, artificial sweeteners, caffeine, alcohol, and highly processed foods which can destabilize the nervous system, spike and crash energy, and worsen symptoms of distractibility and impulsivity."),
        ("Build A Meal Plan",
        "Creating a meal plan can make eating less stressful and more predictable, especially if you have strong food preferences. Start by making a list of favorite foods and textures, and organize meals and snacks around them. Visual schedules or weekly meal charts can help reduce mealtime anxiety and keep your circadian rhythm on track."
    ),
        
        ("Keep Your Space Clean & Decluttered",
         "A tidy environment helps regulate sensory input. Decluttering reduces background tension, frees up mental bandwidth, and supports a greater sense of internal calm and focus. Try the **Five-Minute Cleanup:** set a timer for just five minutes and tackle whatever you can. Gamifying the task creates a sense of urgency and makes the process less daunting."),
        ("Try Hz-Based Vibrational Audio Therapy",
         "For increased alertness and sharper focus, try Beta wave frequencies (14–30 Hz), which are linked to heightened concentration and mental activity. To promote calm, sustained attention, experiment with Alpha waves (8–13 Hz), known to support relaxed but focused brain states."),
        ("Use Dedicated Zones",
         "Create clear zones in your environment. Have one for work, one for rest, another for creativity or art, and a dedicated spot for using your phone or other devices. For ADHD brains, having specific spaces with defined purposes makes it easier to transition between activities and helps reduce distraction. When your environment has clear meaning, your mind can switch tasks more smoothly and with less resistance. To minimize daily frustration, you can **also assign a “home” for everything you use.** ADHD often comes with challenges around object permanence, leading to misplaced items and wasted time searching. Give every object (e.g. keys, notebook) a specific, consistent spot. Label it if needed. This simple strategy reduces clutter, saves mental energy, and supports a sense of order and control throughout your day."),
        ("Set Digital Boundaries",
         "Limit exposure to chaotic media or overstimulating conversations. Declutter your digital world to reduce unnecessary activation."),
        
        ("Settle On Your Purpose",
         "Having an occupation that you love builds real confidence and self-worth. Beyond its psychological and financial benefits, a good job also functions biologically: when individuals pursue goals that align with their strengths and values, it regulates stress pathways and boosts dopamine."),
        ("Set Goals For Yourself",
         "Setting clear goals gives ADHD minds direction and momentum. Whether it’s finishing a project, learning a new skill, or building healthier routines, define what you want to achieve in clear terms that you can follow through with. Break big goals into manageable steps so you can track progress and celebrate wins along the way. Take it further by building a **5-Year Plan**: picture where you want to be in five years. What does your ideal life look like? What strengths will you have developed? Creating a narrative about your future self acts as a motivational anchor and helps you make daily decisions that align with your long-term vision."),
        ("Create Space Before Big Decisions",
         "Wait at least 24 hours before major decisions. A big decision creates an emotional peak, and emotional peaks distort long-term judgment."),
        ("Keep Track Of Your Finances",
         "Managing money can be challenging with ADHD, but having a simple financial system boosts confidence, reduces stress, and prevents last-minute surprises. Break down bills and savings goals into small, clear steps. Set calendar reminders for due dates and celebrate progress."),
        
        ("Stabilize Through Routine",
         "Routines provide essential structure for ADHD brains, transforming chaos into predictability and making it easier to start and finish daily tasks. Consistent schedules reduce the cognitive load of decision-making. Daily reminders can anchor these routines, making them more automatic and less stressful. Even small routines such as a set morning checklist or an evening wind-down ritual can offer stability."),
        ("Prioritize Your Sleep",
         "Quality sleep is the foundation for mood, focus, and self-control. Create a predictable wind-down routine each night: use dim lighting, take a warm shower, listen to calming music, or sip herbal tea. These cues signal to your brain that the day is ending and help prevent nighttime spiraling. To protect your sleep, avoid common disruptors. Eliminate caffeine or heavy meals late in the evening."),
        ("Plan Fun First",
         "For ADHD brains, motivation often follows interest and enjoyment. Scheduling fun activities, such as a hobby or a social event, can give you something to look forward to and can make the rest of your to-do list feel more manageable. By planning fun first, you create positive anticipation, boost dopamine, and give yourself permission to enjoy life without guilt."),
        ("Turn Boring Tasks Into Games",
         "Make dull tasks more engaging by turning them into a game: set a timer and see how much you can get done before it rings, race against yourself to beat your last “score,” or invent silly challenges along the way. Adding competition, rewards, or playful rules taps into your natural drive for stimulation and accomplishment."),
        
        ("Never Put All Your Eggs In One Basket",
         "Balance your time, money, and relationships. Relying on just one person or pursuit can intensify emotional swings and lead to disappointment. Diversifying means supporting your stability and resilience in everyday life."),
        ("Try Body Doubling",
         "Working alongside someone else (even if you’re not doing the same task) can dramatically boost focus and motivation for people with ADHD. This technique, known as **body doubling,** creates gentle social accountability and reduces the urge to drift off-task."),
        ("Seek Out Structured Social Groups",
         "Regular, scheduled meet-ups — such as clubs, classes, or group activities — help provide external structure, making it easier to maintain connections and show up consistently."),
        ("Find an Accountability Partner",
         "Pair up with a friend or group who can help you set reminders, stay on task, or follow through on shared goals. Social accountability can turn community into a tool for motivation."),
        
        ("Capture Ideas Instantly",
         "ADHD brains are bursting with creative ideas, but those sparks can disappear just as quickly as they arrive. Make it a habit to jot down good ideas the moment they pop up. Use a notebook, your phone, sticky notes, or a voice memo app. Keep organized notes to make it easier to return to and build on them later."),
        ("Embrace Messy Brainstorming",
         "Give yourself permission to brainstorm in a way that feels natural, even if it looks chaotic. Let your ideas flow freely and organize later. Messy brainstorming lets your creativity flow without the pressure of getting it “right” the first time."),
        ("Get Creative With Your Cooking",
         "Make a list of foods that help with ADHD, such as those that support dopamine pathways, and create new recipes that are all your own."),
        ("Write Down Who You Are",
         "Write down values, preferences, and the things that identify you. Emotional intensity can blur identity. Write your story so you don't forget who you are."),
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
                    
                    Text("ADHD Tips")
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
        case 1, 4, 5, 7, 8, 9, 11, 12, 15, 17, 21, 23, 24, 25, 30, 35:
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
                            
                        case 1:
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
                            bubbleButton("Open Journal") {
                                let created = UserDefaults.standard.bool(forKey: "dreamPasswordCreated")
                                navModel.push(created ? "DreamPasswordView" : "CreateDreamPasswordView")
                            }
                            
                        case 7:
                            bubbleButton("Open To-Do List") {
                                navModel.push("ToDoListView")
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
                            bubbleButton("Open ADHD Tips") {
                                navModel.push("ADHDTipsView")
                            }
                            
                        case 15:
                            bubbleButton("Build A Meal Plan") {
                                navModel.push("MealPlannerView")
                            }
                            
                        case 17:
                            bubbleButton("Start Audio Therapy") {
                                navModel.push("SoundBathView")
                            }
                            
                        case 21:
                            bubbleButton("Open Goals") {
                                navModel.push("GoalsView")
                            }
                            
                        case 23:
                            bubbleButton("Open Budget Planner") {
                                navModel.push("BudgetPlannerView")
                                
                            }
                        case 24:
                            bubbleButton("Open Day Planner") {
                                navModel.push("DayPlannerView")
                                
                            }
                            
                        case 25:
                            bubbleButton("Sleep Hygiene Checklist") {
                                navModel.push("SleepHygieneView")
                            }
                            
                        case 30:
                            bubbleButton("Open Community Tips") {
                                navModel.push("CommunityTipsView")
                            }
                            
                        case 35:
                            bubbleButton("Open Journal") {
                                bubbleButton("Open Journal") {
                                    let created = UserDefaults.standard.bool(forKey: "dreamPasswordCreated")
                                    navModel.push(created ? "DreamPasswordView" : "CreateDreamPasswordView")
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
