//
//  DailyGoalBank.swift
//  LIFESPACE
//
//  Created by Mario Sbardella on 2025-12-24.
//

import Foundation

// MARK: - Models

enum LifespaceDisorder: String, CaseIterable, Codable {
    case anxiety = "Anxiety"
    case depression = "Depression"
    case pssd = "PSSD"
    case adhd = "ADHD"
    case autism = "Autism"
    case bpd = "BPD"
    case psychosis = "Psychosis"
    case cptsd = "C-PTSD"
}

struct DailyGoalTip: Identifiable, Codable, Equatable {
    let id: String
    let disorder: LifespaceDisorder
    let module: LifespaceModule
    let title: String
    let body: String

    init(disorder: LifespaceDisorder, module: LifespaceModule, title: String, body: String) {
        self.disorder = disorder
        self.module = module
        self.title = title
        self.body = body
        self.id = "\(disorder.rawValue)|\(module.rawValue)|\(title)"
    }
}

// MARK: - Daily Goal Bank (216 = 3 tips × 9 modules × 8 disorders)

let dailyGoalBank: [DailyGoalTip] = [

    // =========================================================
    // ANXIETY
    // =========================================================

    // Anxiety • Light
    DailyGoalTip(disorder: .anxiety, module: .light, title: "Spend Time Outside",
                 body: "If the weather permits it, spend some time outside today!"),
    DailyGoalTip(disorder: .anxiety, module: .light, title: "Dim Lights after 7PM",
                 body: "After 7PM, dim lights to reduce stimulation and support calmer sleep hormones."),
    DailyGoalTip(
        disorder: .anxiety,
        module: .light,
        title: "Practice Trataka Techniques",
        body: "Try candle gazing to invite alpha and theta waves, calming attention and arousal."
    ),

    // Anxiety • Inner Work
    DailyGoalTip(disorder: .anxiety, module: .innerWork, title: "Do Breathing Exercises For 5-10 Minutes",
                 body: "Do five minutes of slow breathing: inhale four, hold for seven, exhale six."),
    DailyGoalTip(disorder: .anxiety, module: .innerWork, title: "Do a Yoga or Prayer Meditation",
                 body: "Choose a short yoga or prayer meditation to reset tension and perspective."),
    DailyGoalTip(
        disorder: .anxiety,
        module: .innerWork,
        title: "Write a Journal Entry",
        body: "Write about what’s on your mind. Make it honest and real."
    ),

    // Anxiety • Fitness
    DailyGoalTip(
        disorder: .anxiety,
        module: .fitness,
        title: "Do An Intense Exercise",
        body: "Do some intense exercise today. Move your body to release stress and reset your energy."),
    DailyGoalTip(disorder: .anxiety, module: .fitness, title: "Take A Progress Pic",
                 body: "Take one photo to mark progress on your fitness journey."),
    DailyGoalTip(disorder: .anxiety, module: .fitness, title: "Use Exercise As Your Cognitive Reset",
                 body: "When anxiety spikes, do some pushups or squats, then continue your day."),

    // Anxiety • Eating
    DailyGoalTip(disorder: .anxiety, module: .eating, title: "Eat An Orthomolecular Meal",
                 body: "Eat one whole-food meal with protein and minerals to steady mood and focus."),
    DailyGoalTip(
        disorder: .anxiety,
        module: .eating,
        title: "Drink Herbal Tea",
        body: "Make yourself a soothing herbal tea today."
    ),
    DailyGoalTip(disorder: .anxiety, module: .eating, title: "Take Vitamins That Support Brain Health",
                 body: "Focus on magnesium, B-vitamins, omega-3s, and zinc to reduce anxiety."),

    // Anxiety • Sensory
    DailyGoalTip(disorder: .anxiety, module: .sensory, title: "Declutter Your Space",
                 body: "Declutter your living space to reduce emotional overwhelm and anxiety."),
    DailyGoalTip(disorder: .anxiety, module: .sensory, title: "Clean Your House",
                 body: "Spend at least 30 minutes cleaning up what you can, or do a deep clean."),
    DailyGoalTip(disorder: .anxiety, module: .sensory, title: "Take An Epsom Salt Bath",
                 body: "Take an Epsom salt bath or warm soak to relax your muscles and your thoughts."),

    // Anxiety • Purpose
    DailyGoalTip(disorder: .anxiety, module: .purpose, title: "Water Your Plants",
                 body: "Water your plants. If you have none, then think about getting some!"),
    DailyGoalTip(disorder: .anxiety, module: .purpose, title: "Take A Break From Digital Media",
                 body: "Take a day off from the news or social media. Replace the time with something valuable."),
    DailyGoalTip(disorder: .anxiety, module: .purpose, title: "Build A Future Self Narrative",
                 body: "Write three sentences describing your improved future self, and then start working on it."),

    // Anxiety • Activity
    DailyGoalTip(disorder: .anxiety, module: .activity, title: "Fill Out Your Day Planner",
                 body: "Plan your day in blocks. Clear structure lowers uncertainty and mental noise."),
    DailyGoalTip(disorder: .anxiety, module: .activity, title: "Enjoy Your Hobbies",
                 body: "Enjoy one of your hobbies for at least 30 minutes. You deserve it."),
    DailyGoalTip(disorder: .anxiety, module: .activity, title: "Avoid All Stimulants",
                 body: "Avoid stimulants today, including excess caffeine. Choose water and steady meals."),

    // Anxiety • Community
    DailyGoalTip(disorder: .anxiety, module: .community, title: "Don’t Worry About What Other People Think",
                 body: "If you do something imperfect, then at least you know you're real."),
    DailyGoalTip(disorder: .anxiety, module: .community, title: "Hang Out With a Trusted Friend",
                 body: "Call or text a friend and schedule a lunch or a dinner."),
    DailyGoalTip(disorder: .anxiety, module: .community, title: "Talk To Somebody",
                 body: "Have a conversation with someone that lasts more than five minutes."),

    // Anxiety • Expression
    DailyGoalTip(disorder: .anxiety, module: .expression, title: "Sing A Song",
                 body: "Sing it loud and proud. Vibration and breath help regulate stress responses."),
    DailyGoalTip(disorder: .anxiety, module: .expression, title: "Get Creative With Your Cooking",
                 body: "Cook one meal creatively. Make up your own recipe."),
    DailyGoalTip(disorder: .anxiety, module: .expression, title: "Write A Poem",
                 body: "Write a poem about anything you like."),

    // =========================================================
    // DEPRESSION
    // =========================================================

    // Depression • Light
    DailyGoalTip(disorder: .depression, module: .light, title: "Spend Time Outside",
                 body: "If the weather permits it, spend some time outside today!"),
    DailyGoalTip(disorder: .depression, module: .light, title: "Stay Out of Bed For the Whole Day",
                 body: "Stay out of bed today except sleep. Protect your bed as a sleep cue."),
    DailyGoalTip(disorder: .depression, module: .light, title: "Don’t Use Any Screens 1 Hour Before Bed",
                 body: "Turn screens off one hour before bed. Use dim light and a simple routine."),

    // Depression • Inner Work
    DailyGoalTip(disorder: .depression, module: .innerWork, title: "Write A Journal Entry",
                 body: "Write about what’s on your mind. Make it honest and real."),
    DailyGoalTip(disorder: .depression, module: .innerWork, title: "Go On A Nature Walk",
                 body: "Take a long nature walk. Notice sounds, smells, and the feeling of air."),
    DailyGoalTip(disorder: .depression, module: .innerWork, title: "Light Scented Candles or Incense",
                 body: "Use candlelight or incense safely. Create a calm ritual and enjoy the clarity."),

    // Depression • Fitness
    DailyGoalTip(disorder: .depression, module: .fitness, title: "Do An Intense Exercise",
                 body: "Do some intense exercise today. Move your body to release stress and reset your energy."),
    DailyGoalTip(disorder: .depression, module: .fitness, title: "Take A Progress Pic",
                 body: "Take one photo to mark progress on your fitness journey."),
    DailyGoalTip(disorder: .depression, module: .fitness, title: "Use Exercise As Your Cognitive Reset",
                 body: "When depression hits, do pushups or squats, then continue your day."),

    // Depression • Eating
    DailyGoalTip(disorder: .depression, module: .eating, title: "Eat An Orthomolecular Meal",
                 body: "Eat one nutrient-dense meal with protein and colorful foods to support mood."),
    DailyGoalTip(disorder: .depression, module: .eating, title: "Eat Protein Every 4 Hours",
                 body: "Aim for protein every four hours to stabilize energy and reduce crash feelings."),
    DailyGoalTip(disorder: .depression, module: .eating, title: "Don’t Drink Any Alcohol",
                 body: "Skip alcohol today. Give your brain a clean window for mood stabilization and sleep."),

    // Depression • Sensory
    DailyGoalTip(disorder: .depression, module: .sensory, title: "Clean Your House",
                 body: "Spend at least 30 minutes cleaning up what you can, or do a deep clean."),
    DailyGoalTip(disorder: .depression, module: .sensory, title: "Take A Cold Shower",
                 body: "Take a short cold shower. Use it as a wake-up and mood-shift. Prove to yourself you can."),
    DailyGoalTip(disorder: .depression, module: .sensory, title: "Take A Break From Digital Media",
                 body: "Take a day off from the news or social media. Replace the time with something valuable."),

    // Depression • Purpose
    DailyGoalTip(disorder: .depression, module: .purpose, title: "Set A Goal",
                 body: "Set one achievable goal. If you have goals already, take one concrete step today."),
    DailyGoalTip(disorder: .depression, module: .purpose, title: "Revisit A Past Interest or Passion",
                 body: "Revisit an old interest or passion you had in the past years. Familiar passion can restart desire."),
    DailyGoalTip(disorder: .depression, module: .purpose, title: "Water Your Plants",
                 body: "Water your plants. If you have none, then think about getting some."),

    // Depression • Activity
    DailyGoalTip(disorder: .depression, module: .activity, title: "Enjoy Your Hobbies",
                 body: "Enjoy one of your hobbies for at least 30 minutes. You deserve it."),
    DailyGoalTip(disorder: .depression, module: .activity, title: "Complete A Sleep Hygiene Checklist",
                 body: "Try and follow everything on the sleep hygiene checklist before you go to bed."),
    DailyGoalTip(disorder: .depression, module: .activity, title: "Use The Cognitive Reset Button",
                 body: "Use the cognitive reset button when depression creeps in, then continue your day."),

    // Depression • Community
    DailyGoalTip(disorder: .depression, module: .community, title: "Hang Out With A Friend",
                 body: "Call or text a friend and schedule a lunch or a dinner."),
    DailyGoalTip(disorder: .depression, module: .community, title: "Tell Someone How You’re Feeling",
                 body: "Open up to someone and be honest how you feel."),
    DailyGoalTip(disorder: .depression, module: .community, title: "Talk To Somebody",
                 body: "Have a conversation with someone that lasts more than five minutes."),

    // Depression • Expression
    DailyGoalTip(disorder: .depression, module: .expression, title: "Learn A Musical Skill",
                 body: "Express yourself with music. Pick up an instrument and play."),
    DailyGoalTip(disorder: .depression, module: .expression, title: "Make Up A Recipe",
                 body: "Make up your own recipe. Keep it simple and creative."),
    DailyGoalTip(disorder: .depression, module: .expression, title: "Write A Poem",
                 body: "Write a poem about anything you feel like."),

    // =========================================================
    // ADHD
    // =========================================================

    // ADHD • Light (kept aligned with your earlier set, tightened to 12–16 words)
    DailyGoalTip(disorder: .adhd, module: .light, title: "Spend Time Outside",
                 body: "If the weather permits it, spend some time outside today!"),
    DailyGoalTip(disorder: .adhd, module: .light, title: "Dim The Lights",
                 body: "Keep the lighting relaxed today. Lower stimulation improves follow-through."),
    DailyGoalTip(disorder: .adhd, module: .light, title: "Practice Trataka Techniques",
                 body: "Try candle gazing to invite alpha and theta waves, calming attention and arousal."),

    // ADHD • Inner Work
    DailyGoalTip(disorder: .adhd, module: .innerWork, title: "Do A Yoga Meditation",
                 body: "Do a short yoga meditation. Slow movement helps attention settle into the body."),
    DailyGoalTip(disorder: .adhd, module: .innerWork, title: "Write A Journal Entry",
                 body: "Brain-dump one page. Write about what's on your mind."),
    DailyGoalTip(disorder: .adhd, module: .innerWork, title: "Knock Something Off Your To-Do List",
                 body: "Complete one task fully. Finish lines teach your brain completion is possible."),

    // ADHD • Fitness (kept aligned with earlier set, tightened)
    DailyGoalTip(disorder: .adhd, module: .fitness, title: "Do an Intense Exercise",
                 body: "Do some intense exercise today. Move your body to release stress and reset your energy."),
    DailyGoalTip(disorder: .adhd, module: .fitness, title: "Take a Progress Pic",
                 body: "Take one photo to mark progress on your fitness journey."),
    DailyGoalTip(disorder: .adhd, module: .fitness, title: "Use Exercise As Your Cognitive Reset",
                 body: "When distracted, do ten pushups or twenty squats, then continue your day."),

    // ADHD • Eating (kept aligned with earlier set, tightened)
    DailyGoalTip(disorder: .adhd, module: .eating, title: "Eat an Orthomolecular Meal",
                 body: "Eat one whole-food meal with protein and minerals. Keep it simple and clean."),
    DailyGoalTip(disorder: .adhd, module: .eating, title: "Eat Protein Every 4 Hours",
                 body: "Set two or three protein check-ins. Stable fuel reduces hyperactivity or impulsive behavior."),
    DailyGoalTip(disorder: .adhd, module: .eating, title: "Avoid Junk Food",
                 body: "Skip junk food today. If cravings hit, drink water and eat protein first."),

    // ADHD • Sensory
    DailyGoalTip(disorder: .adhd, module: .sensory, title: "Declutter Your Space",
                 body: "Declutter your living space to improve task initiation."),
    DailyGoalTip(disorder: .adhd, module: .sensory, title: "Clean Your House",
                 body: "Spend at least 30 minutes cleaning up what you can, or do a deep clean."),
    DailyGoalTip(disorder: .adhd, module: .sensory, title: "Take A Break From Digital Media",
                 body: "Take a day off from the news or social media. Replace the time with something valuable."),

    // ADHD • Purpose
    DailyGoalTip(disorder: .adhd, module: .purpose, title: "Make a 5-Year-Plan",
                 body: "Write a simple five-year vision. Big direction makes today’s tasks feel meaningful."),
    DailyGoalTip(disorder: .adhd, module: .purpose, title: "Set A Goal",
                 body: "Set one goal with a deadline. Specific targets reduce drifting and procrastination."),
    DailyGoalTip(disorder: .adhd, module: .purpose, title: "Break Tasks Into Micro-Steps",
                 body: "Break your tasks into three micro-steps. Start the first step immediately."),

    // ADHD • Activity
    DailyGoalTip(disorder: .adhd, module: .activity, title: "Fill Out Your Day Planner",
                 body: "Plan your day in short blocks. Structure prevents time loss and overwhelm."),
    DailyGoalTip(disorder: .adhd, module: .activity, title: "Complete A Sleep Hygiene Checklist",
                 body: "Try and follow everything on the sleep hygiene checklist before you go to bed."),
    DailyGoalTip(disorder: .adhd, module: .activity, title: "Schedule Fun Activities First",
                 body: "Schedule one fun activity for later. Interest boosts motivation and supports follow-through."),

    // ADHD • Community
    DailyGoalTip(disorder: .adhd, module: .community, title: "Body Double With Somebody",
                 body: "Do one task beside someone, even silently. Shared presence increases completion rates."),
    DailyGoalTip(disorder: .adhd, module: .community, title: "Join A Structured Social Group",
                 body: "Join a structured group that has ongoing meetups. Community provides motivation and accountability."),
    DailyGoalTip(disorder: .adhd, module: .community, title: "Get An Accountability Partner",
                 body: "Ask someone to be your accountability buddy. Gentle accountability builds willpower."),

    // ADHD • Expression
    DailyGoalTip(disorder: .adhd, module: .expression, title: "Write Down Your Good Ideas As They Come",
                 body: "Capture ideas immediately in one note. External memory prevents scattered thinking."),
    DailyGoalTip(disorder: .adhd, module: .expression, title: "Make Up A Recipe",
                 body: "Make up your own recipe. Keep it simple and creative."),
    DailyGoalTip(disorder: .adhd, module: .expression, title: "Brainstorm An Idea",
                 body: "Brainstorm one good idea for at least 15 minutes."),

    // =========================================================
    // AUTISM
    // =========================================================

    // Autism • Light (aligned with earlier set, tightened)
    DailyGoalTip(disorder: .autism, module: .light, title: "Spend Time Outside",
                 body: "If the weather permits it, spend some time outside today!"),
    DailyGoalTip(disorder: .autism, module: .light, title: "Practice Trataka Techniques",
                 body: "Try candle gazing to invite alpha and theta waves, calming attention and arousal."),
    DailyGoalTip(disorder: .autism, module: .light, title: "Spend Time Around Color Changing Lights",
                 body: "Whether it's fairy lights or a lava lamp, enjoy some color changing magic."),

    // Autism • Inner Work
    DailyGoalTip(disorder: .autism, module: .innerWork, title: "Do A Yoga Meditation",
                 body: "Do a short yoga meditation. Let your breathing guide movement and calm awareness."),
    DailyGoalTip(disorder: .autism, module: .innerWork, title: "Write A Journal Entry",
                 body: "Write about what’s on your mind. Make it honest and real."),
    DailyGoalTip(disorder: .autism, module: .innerWork, title: "Take A Nature Walk",
                 body: "Take a long nature walk. Notice sounds, smells, and the feeling of air."),

    // Autism • Fitness (aligned with earlier set, tightened)
    DailyGoalTip(disorder: .autism, module: .fitness, title: "Do An Intense Exercise",
                 body: "Do some intense exercise today. Move your body to release stress and reset your energy."),
    DailyGoalTip(disorder: .autism, module: .fitness, title: "Go Swimming",
                 body: "If possible, go for a swim today in your pool, gym, or local community center."),
    DailyGoalTip(disorder: .autism, module: .fitness, title: "Work Out With a Friend",
                 body: "Work out beside someone. Shared activity reduces isolation and social friction."),

    // Autism • Eating (aligned with earlier set, tightened)
    DailyGoalTip(disorder: .autism, module: .eating, title: "Don’t Eat Any Sweets",
                 body: "Skip sweets today. Replace it with something healthy instead."),
    DailyGoalTip(disorder: .autism, module: .eating, title: "Eat a Balanced Meal",
                 body: "Eat one balanced meal: protein, carbs, fat, and something colorful."),
    DailyGoalTip(disorder: .autism, module: .eating, title: "Eat a Crunchy Snack",
                 body: "Choose a crunchy snack intentionally. Use it as a grounding sensory anchor today."),

    // Autism • Sensory
    DailyGoalTip(disorder: .autism, module: .sensory, title: "Clean Your House",
                 body: "Tidy one zone to reduce sensory overload."),
    DailyGoalTip(disorder: .autism, module: .sensory, title: "Spend Time In Your Sensory Safe Zone",
                 body: "Spend ten minutes relaxing in your sensory safe zone. Reduce noise and soften lighting."),
    DailyGoalTip(disorder: .autism, module: .sensory, title: "Wear Temperature-Regulated Clothing",
                 body: "If it's cold, wear layers. If it's hot, wear loose, breathable fabrics."),

    // Autism • Purpose
    DailyGoalTip(disorder: .autism, module: .purpose, title: "Water Your Plants",
                 body: "Water your plants. If you have none, then think about getting some!"),
    DailyGoalTip(disorder: .autism, module: .purpose, title: "Don’t Multi-Task Today",
                 body: "Do one thing at a time. Single-tasking lowers overload and improves completion."),
    DailyGoalTip(disorder: .autism, module: .purpose, title: "Fill Out Your Day Planner",
                 body: "Plan your day clearly. Predictable structure reduces stress and decision fatigue."),

    // Autism • Activity
    DailyGoalTip(disorder: .autism, module: .activity, title: "Read One Chapter Of A Book",
                 body: "Take some time today to finish a chapter of that book you've been meaning to read."),
    DailyGoalTip(disorder: .autism, module: .activity, title: "Complete A Sleep Hygiene Checklist",
                 body: "Try and follow everything on the sleep hygiene checklist before you go to bed."),
    DailyGoalTip(disorder: .autism, module: .activity, title: "Do A Deep Dive Into Something Interesting",
                 body: "Spend twenty minutes deep-diving a special interest. Let curiosity recharge you."),

    // Autism • Community
    DailyGoalTip(disorder: .autism, module: .community, title: "Hang Out With A Friend",
                 body: "Call or text a friend and schedule a lunch or a dinner."),
    DailyGoalTip(disorder: .autism, module: .community, title: "Apologize To Someone You Hurt",
                 body: "Offer a simple apology if needed. Repair can reduce lingering social stress."),
    DailyGoalTip(disorder: .autism, module: .community, title: "Play A Multiplayer Game",
                 body: "Play a multiplayer game with others. Shared activity can connect without heavy conversation."),

    // Autism • Expression
    DailyGoalTip(disorder: .autism, module: .expression, title: "Learn A Musical Skill",
                 body: "Express yourself with music. Pick up an instrument and play."),
    DailyGoalTip(disorder: .autism, module: .expression, title: "Make Something With Your Hands",
                 body: "Make something with your hands. Tactile creation can regulate energy and mood."),
    DailyGoalTip(disorder: .autism, module: .expression, title: "Write A Blog Post",
                 body: "Write a blog post about that happened to you, that you care about, or just something you know."),

    // =========================================================
    // BPD
    // =========================================================

    // BPD • Light
    DailyGoalTip(disorder: .bpd, module: .light, title: "Spend Time Outside",
                 body: "If the weather permits it, spend some time outside today!"),
    DailyGoalTip(disorder: .bpd, module: .light, title: "Dim Lights After 7PM",
                 body: "Lower stimulation reduces emotional intensity and supports hormone balance."),
    DailyGoalTip(disorder: .bpd, module: .light, title: "Avoid Harsh Fluorescent Light",
                 body: "Avoid harsh fluorescent lighting today. Choose softer lamps and enjoy the peaceful glow."),

    // BPD • Inner Work
    DailyGoalTip(disorder: .bpd, module: .innerWork, title: "Do a Yoga or Prayer Meditation",
                 body: "Do a short yoga or prayer meditation for grounding and spiritual connection."),
    DailyGoalTip(disorder: .bpd, module: .innerWork, title: "Write A Journal Entry",
                 body: "Write about what’s on your mind. Make it honest and real."),
    DailyGoalTip(disorder: .bpd, module: .innerWork, title: "Do Shadow Work",
                 body: "Do a brief shadow work exercise and connect with your inner self."),

    // BPD • Fitness
    DailyGoalTip(disorder: .bpd, module: .fitness, title: "Do An Intense Exercise",
                 body: "Do some intense exercise today. Move your body to release stress and reset your energy."),
    DailyGoalTip(disorder: .bpd, module: .fitness, title: "Take A Progress Pic",
                 body: "Take one photo to mark progress on your fitness journey."),
    DailyGoalTip(disorder: .bpd, module: .fitness, title: "Use Exercise As Your Cognitive Reset",
                 body: "When emotions spike, do ten pushups or fast walking, then breathe slowly."),

    // BPD • Eating
    DailyGoalTip(disorder: .bpd, module: .eating, title: "Eat An Orthomolecular Meal",
                 body: "Eat a whole-food meal with protein. Stable fuel supports stable emotions."),
    DailyGoalTip(disorder: .bpd, module: .eating, title: "Don’t Eat Any Sweets",
                 body: "Skip sweets today. Replace it with something healthy instead."),
    DailyGoalTip(disorder: .bpd, module: .eating, title: "Take Amino Acids That Support Brain Health",
                 body: "Focus on GABA and 5-HTP supplements to reduce BPD-related symptoms."),

    // BPD • Sensory
    DailyGoalTip(disorder: .bpd, module: .sensory, title: "Declutter Your Space",
                 body: "Declutter your living space to reduce emotional overwhelm and impulsivity."),
    DailyGoalTip(disorder: .bpd, module: .sensory, title: "Clean Your House",
                 body: "Spend at least 30 minutes cleaning up what you can, or do a deep clean."),
    DailyGoalTip(disorder: .bpd, module: .sensory, title: "Take An Epsom Salt Bath",
                 body: "Take an Epsom salt bath or warm soak to relax your muscles and your thoughts."),

    // BPD • Purpose
    DailyGoalTip(disorder: .bpd, module: .purpose, title: "Set A Goal",
                 body: "Set one achievable goal. If you have goals already, take one concrete step today."),
    DailyGoalTip(disorder: .bpd, module: .purpose, title: "Water Your Plants",
                 body: "Water your plants. If you have none, then think about getting some."),
    DailyGoalTip(disorder: .bpd, module: .purpose, title: "Ground Your Identity",
                 body: "Write three identity anchors: values, strengths, and goals you will work towards today."),

    // BPD • Activity
    DailyGoalTip(disorder: .bpd, module: .activity, title: "Fill Out Your Day Planner",
                 body: "Plan your day in short blocks. Structure prevents time loss and overwhelm."),
    DailyGoalTip(disorder: .bpd, module: .activity, title: "Enjoy Your Hobbies",
                 body: "Enjoy one of your hobbies for at least 30 minutes. You deserve it."),
    DailyGoalTip(disorder: .bpd, module: .activity, title: "Read One Chapter Of A Book",
                 body: "Take some time today to finish a chapter of that book you've been meaning to read."),

    // BPD • Community
    DailyGoalTip(disorder: .bpd, module: .community, title: "Meet Someone New",
                 body: "Go out into the world and meet someone new. If you don't know how, here are some ideas."),
    DailyGoalTip(disorder: .bpd, module: .community, title: "Don’t Worry About What Others Think",
                 body: "If you do something imperfect, then at least you know you're real."),
    DailyGoalTip(disorder: .bpd, module: .community, title: "Apologize To Someone You Hurt",
                 body: "Offer a simple apology if needed. Repair builds trust and respect."),

    // BPD • Expression
    DailyGoalTip(disorder: .bpd, module: .expression, title: "Learn A Musical Skill",
                 body: "Express yourself with music. Pick up an instrument and play."),
    DailyGoalTip(disorder: .bpd, module: .expression, title: "Make Up A Recipe",
                 body: "Make up your own recipe. Keep it simple and creative."),
    DailyGoalTip(disorder: .bpd, module: .expression, title: "Write A Poem",
                 body: "Write a poem about anything you feel like."),

    // =========================================================
    // PSYCHOSIS
    // =========================================================

    // Psychosis • Light
    DailyGoalTip(disorder: .psychosis, module: .light, title: "Spend Time Outside",
                 body: "If the weather permits it, spend some time outside today!"),
    DailyGoalTip(disorder: .psychosis, module: .light, title: "Avoid Screens 1 Hour Before Bed",
                 body: "Turn screens off one hour before bed. Protect sleep and lower sensory load."),
    DailyGoalTip(disorder: .psychosis, module: .light, title: "Avoid Harsh Fluorescent Lighting",
                 body: "Avoid harsh fluorescents today. Use softer lamps to reduce agitation and strain."),

    // Psychosis • Inner Work
    DailyGoalTip(disorder: .psychosis, module: .innerWork, title: "Do A Breathing Exercise",
                 body: "Do five minutes of slow breathing: inhale four, hold for seven, exhale six."),
    DailyGoalTip(disorder: .psychosis, module: .innerWork, title: "Do A Yoga Meditation",
                 body: "Do a short yoga meditation. Let your breathing guide movement and calm awareness."),
    DailyGoalTip(disorder: .psychosis, module: .innerWork, title: "Connect With Your Higher Power",
                 body: "Spend 5-10 minutes in reflection with your inner self and higher power."),

    // Psychosis • Fitness
    DailyGoalTip(disorder: .psychosis, module: .fitness, title: "Do An Intense Exercise",
                 body: "Do some intense exercise today. Move your body to release stress and reset your energy."),
    DailyGoalTip(disorder: .psychosis, module: .fitness, title: "Take A Progress Pic",
                 body: "Take one photo to mark progress on your fitness journey."),
    DailyGoalTip(disorder: .psychosis, module: .fitness, title: "Use Exercise As Your Cognitive Reset",
                 body: "When thoughts start to spiral, do push-ups or squats, then continue on your day."),

    // Psychosis • Eating
    DailyGoalTip(disorder: .psychosis, module: .eating, title: "Eat An Orthomolecular Meal",
                 body: "Eat a whole-food meal with protein and minerals. Stable fuel supports clarity."),
    DailyGoalTip(disorder: .psychosis, module: .eating, title: "Make An Orthomolecular Meal Plan",
                 body: "Go to the meal planner and choose one of the preset meals by clicking the star."),
    DailyGoalTip(disorder: .psychosis, module: .eating, title: "Avoid Junk Food or Sweets",
                 body: "Avoid junk and sweets today. Replace it with something healthy."),

    // Psychosis • Sensory
    DailyGoalTip(disorder: .psychosis, module: .sensory, title: "Clean Your House",
                 body: "Spend at least 30 minutes cleaning up what you can, or do a deep clean."),
    DailyGoalTip(disorder: .psychosis, module: .sensory, title: "Declutter Your Space",
                 body: "Declutter your living space to reduce emotional overwhelm and perceptual stress."),
    DailyGoalTip(disorder: .psychosis, module: .sensory, title: "Do A Hygienic Self-Care Routine",
                 body: "Do basic self-care: shower, brush teeth, brush hair, and anything else in your routine."),

    // Psychosis • Purpose
    DailyGoalTip(disorder: .psychosis, module: .purpose, title: "Set A Goal",
                 body: "Set one achievable goal. If you have goals already, take one concrete step today."),
    DailyGoalTip(disorder: .psychosis, module: .purpose, title: "Take A Break From Digital Media",
                 body: "Take a day off from the news or social media. Replace the time with something valuable."),
    DailyGoalTip(disorder: .psychosis, module: .purpose, title: "Develop A Self-Anchor",
                 body: "Write three identity anchors: values, strengths, and goals you will work towards today."),

    // Psychosis • Activity
    DailyGoalTip(disorder: .psychosis, module: .activity, title: "Fill Out Your Day Planner",
                 body: "Plan your day in short blocks. Structure prevents time loss and overwhelm."),
    DailyGoalTip(disorder: .psychosis, module: .activity, title: "Complete A Sleep Hygiene Checklist",
                 body: "Try and follow everything on the sleep hygiene checklist before you go to bed."),
    DailyGoalTip(disorder: .psychosis, module: .activity, title: "Learn A Coping Strategy",
                 body: "Research coping skills and find one that fits best for you."),

    // Psychosis • Community
    DailyGoalTip(disorder: .psychosis, module: .community, title: "Avoid Isolation",
                 body: "Have one safe interaction today. Isolation can intensify heavy emotions."),
    DailyGoalTip(disorder: .psychosis, module: .community, title: "Don’t Worry About What Others Think",
                 body: "Stay aligned with reality-based goals. Others’ opinions do not define your worth."),
    DailyGoalTip(disorder: .psychosis, module: .community, title: "Apologize To Someone You Hurt",
                 body: "If needed, offer a simple apology. Repair strengthens relationships and respect."),

    // Psychosis • Expression
    DailyGoalTip(disorder: .psychosis, module: .expression, title: "Speak Your Thoughts Aloud",
                 body: "As a grounding technique, say what you're thinking out loud today."),
    DailyGoalTip(disorder: .psychosis, module: .expression, title: "Paint A Picture",
                 body: "Get some paint and make some simple art. Convert stress into calm expression."),
    DailyGoalTip(disorder: .psychosis, module: .expression, title: "Make Up A Recipe",
                 body: "Make up your own recipe. Keep it simple and creative."),

    // =========================================================
    // PSSD
    // =========================================================

    // PSSD • Light
    DailyGoalTip(disorder: .pssd, module: .light, title: "Spend Time Outside",
                 body: "If the weather permits it, spend some time outside today!"),
    DailyGoalTip(disorder: .pssd, module: .light, title: "Practice Trataka Techniques",
                 body: "Try candle gazing to invite alpha and theta waves, calming attention and arousal."),
    DailyGoalTip(disorder: .pssd, module: .light, title: "Avoid Screens 1 Hour Before Bed",
                 body: "Turn screens off one hour before bed. Protect deep sleep and recovery processes."),

    // PSSD • Inner Work
    DailyGoalTip(disorder: .pssd, module: .innerWork, title: "Practice Yoga Meditation",
                 body: "Do a short yoga meditation. Gentle movement supports circulation and calm focus."),
    DailyGoalTip(disorder: .pssd, module: .innerWork, title: "Practice Prayer Meditation",
                 body: "Spend some time meditating in prayer for grounding and spiritual connection."),
    DailyGoalTip(disorder: .pssd, module: .innerWork, title: "Take A Cold Shower",
                 body: "Take a short cold shower. Use it as a wake-up and mood-shift. Prove to yourself you can."),

    // PSSD • Fitness
    DailyGoalTip(disorder: .pssd, module: .fitness, title: "Do a HIIT Exercise",
                 body: "Do a short HIIT session. Intensity supports circulation, hormones, and energy resilience."),
    DailyGoalTip(disorder: .pssd, module: .fitness, title: "It’s Leg Day!",
                 body: "Train legs today with squats or lunges. Large leg muscles support hormone signaling."),
    DailyGoalTip(disorder: .pssd, module: .fitness, title: "Do Endurance Training",
                 body: "Do 30-60 minutes endurance movement. Moderate cardio supports circulation and recovery."),

    // PSSD • Eating
    DailyGoalTip(disorder: .pssd, module: .eating, title: "Eat Foods That Raise Testosterone",
                 body: "Eat protein and mineral-rich foods today. Support hormones and overall sexual health."),
    DailyGoalTip(disorder: .pssd, module: .eating, title: "Don’t Eat Any Junk Food",
                 body: "Skip junk food today. Clean eating supports energy, libido, and emotional stability."),
    DailyGoalTip(disorder: .pssd, module: .eating, title: "Practice Intermittent Fasting",
                 body: "Try a fasting window today. Hydrate well and break fast with protein."),

    // PSSD • Sensory
    DailyGoalTip(disorder: .pssd, module: .sensory, title: "Clean Your House",
                 body: "Spend at least 30 minutes cleaning up what you can, or do a deep clean."),
    DailyGoalTip(disorder: .pssd, module: .sensory, title: "Try And Connect With Someone Emotionally",
                 body: "Emotional connection supports nervous-system repair."),
    DailyGoalTip(disorder: .pssd, module: .sensory, title: "Do A Self-Care Routine",
                 body: "Practice self-care: shower, grooming, clean clothes, and anything else you want to include in your routine."),

    // PSSD • Purpose
    DailyGoalTip(disorder: .pssd, module: .purpose, title: "Make A 5-Year Plan",
                 body: "Write a simple five-year plan. If you have one already, take one concrete step today."),
    DailyGoalTip(disorder: .pssd, module: .purpose, title: "Take A Break From Digital Media",
                 body: "Take a day off from news or social media. Protect dopamine, mood, and recovery focus."),
    DailyGoalTip(disorder: .pssd, module: .purpose, title: "Set A Goal",
                 body: "Set one achievable goal. If you have goals already, take one concrete step today."),

    // PSSD • Activity
    DailyGoalTip(disorder: .pssd, module: .activity, title: "Enjoy Your Hobbies",
                 body: "Enjoy one of your hobbies for at least 30 minutes. You deserve it."),
    DailyGoalTip(disorder: .pssd, module: .activity, title: "Avoid Stimulants",
                 body: "Avoid stimulants today, including excess caffeine. Choose water and steady meals."),
    DailyGoalTip(disorder: .pssd, module: .activity, title: "Complete A Sleep Hygiene Checklist",
                 body: "Try and follow everything on the sleep hygiene checklist before you go to bed."),

    // PSSD • Community
    DailyGoalTip(disorder: .pssd, module: .community, title: "Make Plans With Friends",
                 body: "Make a plan to do something fun with friends. Connection supports confidence."),
    DailyGoalTip(disorder: .pssd, module: .community, title: "Avoid Isolation",
                 body: "Have one interaction today. If you can, reach out to a friend or family member."),
    DailyGoalTip(disorder: .pssd, module: .community, title: "Step Outside Your Comfort Zone",
                 body: "Do one small brave thing today. Micro-risks build confidence and social energy."),

    // PSSD • Expression
    DailyGoalTip(disorder: .pssd, module: .expression, title: "Organize Your Space",
                 body: "Organize one area in your living space. Order reduces stress and supports clearer thinking."),
    DailyGoalTip(disorder: .pssd, module: .expression, title: "Make Up A Recipe",
                 body: "Make up your own recipe. Keep it simple and creative."),
    DailyGoalTip(disorder: .pssd, module: .expression, title: "Sign Up For An Acting or Improv Class",
                 body: "Sign up for acting or improv. Expression through acting is good for the soul."),

    // =========================================================
    // C-PTSD
    // =========================================================

    // C-PTSD • Light (aligned with earlier set, tightened)
    DailyGoalTip(disorder: .cptsd, module: .light, title: "Spend Time Outside",
                 body: "If the weather permits it, spend some time outside today!"),
    DailyGoalTip(disorder: .cptsd, module: .light, title: "Don’t Spend Time in Bed Except to Sleep",
                 body: "Don't lounge in your bed today. Avoid associating your bed with anything other than sleep."),
    DailyGoalTip(disorder: .cptsd, module: .light, title: "Avoid Screens 1 Hour Before Sleep",
                 body: "Turn your screens off 60 minutes before bed. Use dim light and calming routine."),

    // C-PTSD • Inner Work
    DailyGoalTip(disorder: .cptsd, module: .innerWork, title: "Do Breathing Exercises For 5-10 Minutes",
                 body: "Do five minutes of slow breathing: inhale four, hold for seven, exhale six."),
    DailyGoalTip(disorder: .cptsd, module: .innerWork, title: "Write A Journal Entry",
                 body: "Write about what’s on your mind. Make it honest and real."),
    DailyGoalTip(disorder: .cptsd, module: .innerWork, title: "Go On A Nature Walk",
                 body: "Take a long nature walk. Notice sounds, smells, and the feeling of air."),

    // C-PTSD • Fitness (aligned with earlier set, tightened)
    DailyGoalTip(disorder: .cptsd, module: .fitness, title: "Do an Intense Exercise",
                 body: "Do some intense exercise today. Move your body to release stress and reset your energy."),
    DailyGoalTip(disorder: .cptsd, module: .fitness, title: "Take A Progress Pic",
                 body: "Take one photo to mark progress on your fitness journey."),
    DailyGoalTip(disorder: .cptsd, module: .fitness, title: "Use Exercise As Your Cognitive Reset",
                 body: "When thoughts begin to turn negative, do ten pushups, then move on with your day."),

    // C-PTSD • Eating (aligned with earlier set, tightened)
    DailyGoalTip(disorder: .cptsd, module: .eating, title: "Eat an Orthomolecular Diet",
                 body: "Choose whole foods today. If stress hits, eat protein before anything else."),
    DailyGoalTip(disorder: .cptsd, module: .eating, title: "Don’t Drink Any Alcohol Today",
                 body: "Skip alcohol today. Give your brain a clean window for mood stabilization and sleep."),
    DailyGoalTip(disorder: .cptsd, module: .eating, title: "Don’t Eat Any Junk Food Today",
                 body: "Skip junk food today. If cravings spike, swap protein and water first."),

    // C-PTSD • Sensory
    DailyGoalTip(disorder: .cptsd, module: .sensory, title: "Declutter Your Space",
                 body: "Declutter your living space to reduce emotional overwhelm and hypervigilance."),
    DailyGoalTip(disorder: .cptsd, module: .sensory, title: "Clean Your House",
                 body: "Spend at least 30 minutes cleaning up what you can, or do a deep clean."),
    DailyGoalTip(disorder: .cptsd, module: .sensory, title: "Take An Epsom Salt Bath",
                 body: "Take an Epsom salt bath or warm soak to relax your muscles and your thoughts."),

    // C-PTSD • Purpose
    DailyGoalTip(disorder: .cptsd, module: .purpose, title: "Set A Goal",
                 body: "Set one achievable goal. If you have goals already, take one concrete step today."),
    DailyGoalTip(disorder: .cptsd, module: .purpose, title: "Take A Break From Digital Media",
                 body: "Take a day off from the news or social media. Replace the time with something valuable."),
    DailyGoalTip(disorder: .cptsd, module: .purpose, title: "Develop A Self-Anchor",
                 body: "Write three identity anchors: values, strengths, and goals you will work towards today."),

    // C-PTSD • Activity
    DailyGoalTip(disorder: .cptsd, module: .activity, title: "Fill Out Your Day Planner",
                 body: "Plan your day in short blocks. Structure prevents time loss and overwhelm."),
    DailyGoalTip(disorder: .cptsd, module: .activity, title: "Complete A Sleep Hygiene Checklist",
                 body: "Try and follow everything on the sleep hygiene checklist before you go to bed."),
    DailyGoalTip(disorder: .cptsd, module: .activity, title: "Learn A Coping Strategy",
                 body: "Research coping skills and find one that fits best for you."),

    // C-PTSD • Community
    DailyGoalTip(disorder: .cptsd, module: .community, title: "Avoid Isolation",
                 body: "Have one interaction today. If you can, reach out to a friend or family member."),
    DailyGoalTip(disorder: .cptsd, module: .community, title: "Hang Out With A Trusted Friend",
                 body: "Call or text a trusted friend and schedule a lunch or a dinner."),
    DailyGoalTip(disorder: .cptsd, module: .community, title: "Talk To Somebody",
                 body: "Have a conversation with someone that lasts more than five minutes."),

    // C-PTSD • Expression
    DailyGoalTip(disorder: .cptsd, module: .expression, title: "Write A Poem",
                 body: "Write a poem about anything you like."),
    DailyGoalTip(disorder: .cptsd, module: .expression, title: "Paint A Picture",
                 body: "Paint something simple today. Creative focus can ground and soften intense feelings."),
    DailyGoalTip(disorder: .cptsd, module: .expression, title: "Sing A Song",
                 body: "Sing it loud and proud. Vibration and breath help regulate stress responses."),
]
