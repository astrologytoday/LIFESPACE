//
//  SearchIndex.swift
//  LIFESPACE
//
//  Created by Mario Sbardella on 2025-12-11.
//

import Foundation

struct SearchIndex {

    static let items: [SearchItem] = [

        SearchItem(
            title: "Lifestyle Survey",
            keywords: ["lifespace", "survey", "assessment", "check-in", "brain optimization", "score", "questions", "wellness", "daily check", "lifestyle"],
            screen: "LifestyleSurveyView"
        ),

        SearchItem(
            title: "Budget Planner",
            keywords: ["budget", "budgeting", "income", "expenses", "savings", "finance", "cash flow", "categories", "bills", "planner"],
            screen: "BudgetPlannerView"
        ),

        SearchItem(
            title: "Track Spending",
            keywords: ["spending", "expenses", "transactions", "purchases", "categories", "weekly spending", "budget", "tracking", "log", "breakdown"],
            screen: "SpendingView"
        ),

        SearchItem(
            title: "Day Planner",
            keywords: ["day planner", "schedule", "time blocks", "hourly", "agenda", "routine", "productivity", "plan", "calendar", "daily"],
            screen: "DayPlannerView"
        ),

        SearchItem(
            title: "To-Do List",
            keywords: ["to do", "todo list", "tasks", "checklist", "reminders", "priorities", "productivity", "plan", "organize", "complete"],
            screen: "ToDoListView"
        ),

        SearchItem(
            title: "Grocery List",
            keywords: ["grocery list", "groceries", "shopping", "ingredients", "meal planning", "checklist", "food", "supermarket", "pantry", "list"],
            screen: "GroceryListView"
        ),

        SearchItem(
            title: "Meal Planner",
            keywords: ["meal planner", "meal plan", "menu", "breakfast", "lunch", "dinner", "nutrition", "recipes", "prep", "schedule"],
            screen: "MealPlannerView"
        ),

        SearchItem(
            title: "Timer",
            keywords: ["timer", "countdown", "stopwatch", "interval", "focus", "pomodoro", "workout timer", "breathwork", "meditation", "alarm"],
            screen: "TimerView"
        ),

        SearchItem(
            title: "Workout Planner",
            keywords: ["workout planner", "training", "routine", "gym", "sets", "reps", "schedule", "strength", "fitness", "exercise plan"],
            screen: "WorkoutPlannerView"
        ),

        SearchItem(
            title: "Arnold Press Exercise",
            keywords: ["arnold press", "shoulders", "deltoids", "dumbbell", "press", "upper body", "strength", "bodybuilding", "form", "exercise"],
            screen: "ArnoldPressView"
        ),

        SearchItem(
            title: "Elbow Plank Exercise",
            keywords: ["elbow plank", "plank", "core", "abs", "stability", "isometric", "bodyweight", "endurance", "posture", "exercise"],
            screen: "ElbowPlankView"
        ),

        SearchItem(
            title: "Empty the Can Exercise",
            keywords: ["empty the can", "rotator cuff", "shoulder rehab", "physical therapy", "injury prevention", "external rotation", "mobility", "stability", "strengthening", "exercise"],
            screen: "EmptyTheCanView"
        ),

        SearchItem(
            title: "Fish Pose Matsyasana",
            keywords: ["fish pose", "matsyasana", "yoga", "chest opener", "backbend", "stretch", "posture", "breathing", "flexibility", "relaxation"],
            screen: "FishPoseMatsyasanaView"
        ),

        SearchItem(
            title: "Forearm Rotation Exercise",
            keywords: ["forearm rotation", "wrist", "pronation", "supination", "mobility", "rehab", "grip", "tendonitis", "strength", "exercise"],
            screen: "ForearmRotationView"
        ),

        SearchItem(
            title: "Goblet Squats Exercise",
            keywords: ["goblet squat", "squat", "legs", "glutes", "quads", "dumbbell", "lower body", "strength", "form", "exercise"],
            screen: "GobletSquatsView"
        ),

        SearchItem(
            title: "Hammer Curls Exercise",
            keywords: ["hammer curls", "biceps", "brachialis", "dumbbell", "arms", "forearms", "grip", "strength", "workout", "exercise"],
            screen: "HammerCurlsView"
        ),

        SearchItem(
            title: "Rolling Calves Exercise",
            keywords: ["rolling calves", "calves", "foam rolling", "recovery", "mobility", "massage", "soreness", "circulation", "stretching", "exercise"],
            screen: "RollingCalvesView"
        ),

        SearchItem(
            title: "Abdominal Workouts",
            keywords: ["abs", "abdominals", "core", "workouts", "exercise", "strength", "stability", "fitness", "training", "routine"],
            screen: "AbsView"
        ),

        SearchItem(
            title: "Bicep Workouts",
            keywords: ["biceps", "arms", "workouts", "curls", "strength", "training", "fitness", "hypertrophy", "exercise", "routine"],
            screen: "BicepsView"
        ),

        SearchItem(
            title: "Calves Exercises",
            keywords: ["calves", "lower legs", "ankles", "exercises", "strength", "training", "mobility", "fitness", "workout", "routine"],
            screen: "CalvesView"
        ),

        SearchItem(
            title: "Forearm Exercises",
            keywords: ["forearms", "grip", "wrists", "exercises", "strength", "training", "mobility", "fitness", "workout", "routine"],
            screen: "ForearmsView"
        ),

        SearchItem(
            title: "Glutes Exercises",
            keywords: ["glutes", "butt", "hips", "exercises", "strength", "training", "lower body", "fitness", "workout", "routine"],
            screen: "GlutesView"
        ),

        SearchItem(
            title: "Hamstring Exercises",
            keywords: ["hamstrings", "posterior chain", "legs", "exercises", "strength", "training", "mobility", "fitness", "workout", "routine"],
            screen: "HamstringsView"
        ),

        SearchItem(
            title: "Shoulder Workouts",
            keywords: ["shoulders", "deltoids", "upper body", "workouts", "strength", "training", "fitness", "press", "exercise", "routine"],
            screen: "ShouldersView"
        ),

        SearchItem(
            title: "Tricep Workouts",
            keywords: ["triceps", "arms", "push", "workouts", "strength", "training", "fitness", "exercise", "hypertrophy", "routine"],
            screen: "TricepsView"
        ),

        SearchItem(
            title: "Fitness Space",
            keywords: ["fitness space", "gym", "training", "workouts", "exercises", "strength", "cardio", "health", "routine", "performance"],
            screen: "FitnessSpaceView"
        ),

        SearchItem(
            title: "Weight Tracker",
            keywords: ["weight tracker", "weigh-in", "bodyweight", "progress", "goals", "tracking", "trend", "measurements", "fitness", "health"],
            screen: "WeightTrackerView"
        ),

        SearchItem(
            title: "My Five-Year Plan",
            keywords: ["five-year plan", "goals", "vision", "roadmap", "milestones", "future", "planning", "strategy", "life plan", "purpose"],
            screen: "FiveYearPlanView"
        ),

        SearchItem(
            title: "Music Settings",
            keywords: ["music", "audio", "settings", "sound", "volume", "synth", "instruments", "preferences", "effects", "playback"],
            screen: "MusicView"
        ),

        SearchItem(
            title: "Notification Settings",
            keywords: ["notifications", "reminders", "alerts", "schedule", "daily check", "push", "settings", "permission", "timing", "toggle"],
            screen: "NotificationsView"
        ),

        SearchItem(
            title: "LIFESPACE Prescription",
            keywords: ["results", "lifespace prescription", "score", "summary", "feedback", "recommendations", "brain optimization", "insights", "report", "modules"],
            screen: "ResultsView"
        ),

        SearchItem(
            title: "LIFESPACE Analytics",
            keywords: ["analytics", "charts", "trends", "progress", "metrics", "scores", "history", "graphs", "dashboard", "tracking"],
            screen: "AnalyticsView"
        ),

        SearchItem(
            title: "ADHD Tips",
            keywords: ["adhd", "attention", "focus", "executive function", "hyperactivity", "distractibility", "organization", "time management", "routines", "productivity"],
            screen: "ADHDTwentyFiveView"
        ),

        SearchItem(
            title: "Cognitive Resets For ADHD",
            keywords: ["adhd reset", "focus reset", "grounding", "quick reset", "regulation", "attention", "break", "calm", "coping", "stability"],
            screen: "ADHDResetView"
        ),

        SearchItem(
            title: "Attention Deficit-Hyperactivity Disorder",
            keywords: ["attention deficit", "hyperactivity", "adhd", "focus", "impulsivity", "executive function", "organization", "routines", "time management", "strategies"],
            screen: "ADHDTipsView"
        ),

        SearchItem(
            title: "Anxiety Tips",
            keywords: ["anxiety", "worry", "panic", "stress", "nervousness", "fear", "relaxation", "breathing", "grounding", "calm"],
            screen: "AnxietyTwentyFiveView"
        ),

        SearchItem(
            title: "Cognitive Resets For Anxiety",
            keywords: ["anxiety reset", "panic", "grounding", "breathing", "calm", "soothing", "regulation", "coping", "nervous system", "quick relief"],
            screen: "AnxietyResetView"
        ),

        SearchItem(
            title: "Generalized Anxiety Disorder",
            keywords: ["generalized anxiety", "gad", "worry", "stress", "panic", "fear", "coping", "relaxation", "strategies", "support"],
            screen: "AnxietyTipsView"
        ),

        SearchItem(
            title: "Autism Tips",
            keywords: ["autism", "spectrum", "neurodivergent", "sensory", "routines", "communication", "social", "support", "meltdowns", "regulation"],
            screen: "AutismTwentyFiveView"
        ),

        SearchItem(
            title: "Cognitive Resets For Autism",
            keywords: ["sensory reset", "autism reset", "overload", "regulation", "calm", "grounding", "breaks", "routine", "soothing", "stability"],
            screen: "AutismResetView"
        ),

        SearchItem(
            title: "Autism Spectrum Disorder",
            keywords: ["autism spectrum", "asd", "sensory", "communication", "social skills", "routines", "support", "neurodiversity", "regulation", "tips"],
            screen: "AutismTipsView"
        ),

        SearchItem(
            title: "Cognitive Resets For BPD",
            keywords: ["bpd reset", "borderline", "emotion regulation", "distress tolerance", "grounding", "coping", "dbt skills", "calm", "triggers", "stability"],
            screen: "BPDResetView"
        ),

        SearchItem(
            title: "BPD Tips",
            keywords: ["bpd", "borderline", "emotion regulation", "relationships", "impulsivity", "dbt", "coping", "triggers", "stability", "support"],
            screen: "BPDTwentyFiveView"
        ),

        SearchItem(
            title: "Borderline Personality Disorder",
            keywords: ["borderline personality", "bpd", "dbt", "emotion regulation", "relationships", "attachment", "impulsivity", "coping", "skills", "support"],
            screen: "BPDTipsView"
        ),

        SearchItem(
            title: "Cognitive Resets For CPTSD",
            keywords: ["cptsd reset", "trauma reset", "grounding", "flashback", "regulation", "safety", "breathing", "coping", "calm", "stability"],
            screen: "CPTSDResetView"
        ),

        SearchItem(
            title: "CPTSD Tips",
            keywords: ["cptsd", "complex trauma", "trauma", "triggers", "flashbacks", "nervous system", "grounding", "recovery", "healing", "support"],
            screen: "CPTSDTwentyFiveView"
        ),

        SearchItem(
            title: "Complex Post-Traumatic Stress Disorder",
            keywords: ["complex ptsd", "cptsd", "trauma", "triggers", "flashbacks", "dissociation", "regulation", "safety", "coping", "recovery"],
            screen: "CPTSDTipsView"
        ),

        SearchItem(
            title: "Depression Tips",
            keywords: ["depression", "low mood", "sadness", "motivation", "fatigue", "anhedonia", "mood", "coping", "support", "self-care"],
            screen: "DepressionTwentyFiveView"
        ),

        SearchItem(
            title: "Cognitive Resets For Depression",
            keywords: ["depression reset", "mood lift", "behavioral activation", "small steps", "grounding", "routine", "energy", "coping", "resilience", "support"],
            screen: "DepressionResetView"
        ),

        SearchItem(
            title: "Major Depressive Disorder",
            keywords: ["major depressive", "mdd", "depression", "low mood", "sadness", "therapy", "coping", "motivation", "support", "self-care"],
            screen: "DepressionTipsView"
        ),

        SearchItem(
            title: "PSSD Tips",
            keywords: ["pssd", "ssri", "sexual dysfunction", "libido", "numbness", "anorgasmia", "side effects", "recovery", "support", "education"],
            screen: "PSSDTwentyFiveView"
        ),

        SearchItem(
            title: "Post-SSRI Sexual Dysfunction",
            keywords: ["post-ssri", "pssd", "ssri", "sexual health", "symptoms", "numbness", "libido", "side effects", "recovery", "support"],
            screen: "PSSDTipsView"
        ),

        SearchItem(
            title: "Psychosis Fact Sheet",
            keywords: ["psychosis", "hallucinations", "delusions", "paranoia", "reality testing", "grounding", "stability", "support", "coping", "safety"],
            screen: "PsychosisTipsView"
        ),

        SearchItem(
            title: "Cognitive Resets For Psychosis",
            keywords: ["psychosis reset", "grounding", "reality check", "reduce stimulation", "calm", "safety", "support", "coping", "stabilize", "routine"],
            screen: "PsychosisResetView"
        ),

        // MARK: Psychosis
        SearchItem(
            title: "Psychosis Tips",
            keywords: ["psychosis", "hallucinations", "delusions", "paranoia", "grounding", "support", "coping", "reality testing", "stability", "safety"],
            screen: "PsychosisTwentyFiveView"
        ),

        SearchItem(
            title: "Play Checkers",
            keywords: ["checkers", "game", "board game", "strategy", "fun", "cognitive", "focus", "relaxation", "play", "brain"],
            screen: "CheckersView"
        ),

        SearchItem(
            title: "Activity Tips",
            keywords: ["activity", "sleep", "rest", "fun", "recreation", "leisure", "balance", "routine", "recharge", "wellness"],
            screen: "ActivityTipsView"
        ),

        SearchItem(
            title: "Play Chess",
            keywords: ["chess", "game", "strategy", "board game", "tactics", "focus", "brain", "cognitive", "fun", "play"],
            screen: "ChessView"
        ),

        SearchItem(
            title: "Play LIFESPACE Hangman",
            keywords: ["hangman", "word game", "letters", "spelling", "puzzle", "fun", "brain", "play", "vocabulary", "cognitive"],
            screen: "HangmanView"
        ),

        SearchItem(
            title: "LIFESPACE Games",
            keywords: ["games", "play", "fun", "brain", "puzzles", "strategy", "focus", "cognitive", "relaxation", "entertainment"],
            screen: "LIFESPACEGamesView"
        ),

        SearchItem(
            title: "Sleep Hygiene Checklist",
            keywords: ["sleep hygiene", "sleep", "bedtime", "insomnia", "routine", "circadian", "screens", "relaxation", "rest", "habits"],
            screen: "SleepHygieneView"
        ),

        SearchItem(
            title: "LIFESPACE Word Search",
            keywords: ["word search", "puzzle", "letters", "words", "focus", "brain", "game", "relaxation", "fun", "cognitive"],
            screen: "WordSearchView"
        ),

        SearchItem(
            title: "Community Tips",
            keywords: ["community", "connection", "friends", "social", "belonging", "support", "relationships", "communication", "loneliness", "meetups"],
            screen: "CommunityTipsView"
        ),

        SearchItem(
            title: "LIFESPACE Meetups",
            keywords: ["meetups", "community", "nearby", "location", "events", "social", "friends", "activities", "connect", "profile"],
            screen: "MeetupsProfileView"
        ),

        SearchItem(
            title: "What Is Circadian Rhythm?",
            keywords: ["circadian rhythm", "body clock", "sleep cycle", "melatonin", "light exposure", "blue light", "morning light", "routine", "chronobiology", "sleep"],
            screen: "CircadianRhythmView"
        ),

        SearchItem(
            title: "The Gut-Brain Connection",
            keywords: ["gut brain", "microbiome", "digestion", "vagus nerve", "inflammation", "nutrition", "mood", "probiotics", "neurotransmitters", "health"],
            screen: "GutBrainView"
        ),

        SearchItem(
            title: "Meal Prepping Guide",
            keywords: ["meal prep", "meal prepping", "batch cooking", "planning", "groceries", "recipes", "time-saving", "containers", "nutrition", "routine"],
            screen: "MealPrepView"
        ),

        SearchItem(
            title: "What Is An Orthomolecular Diet?",
            keywords: ["orthomolecular", "nutrition", "vitamins", "minerals", "nutrients", "supplementation", "biochemistry", "mental health", "diet", "wellness"],
            screen: "OrthomolecularView"
        ),

        SearchItem(
            title: "Acetylcholine Fact Sheet",
            keywords: ["acetylcholine", "neurotransmitter", "memory", "learning", "attention", "choline", "cognition", "brain", "nerves", "focus"],
            screen: "AcetylcholineView"
        ),

        SearchItem(
            title: "Dopamine Fact Sheet",
            keywords: ["dopamine", "neurotransmitter", "motivation", "reward", "focus", "drive", "habits", "pleasure", "attention", "brain"],
            screen: "DopamineView"
        ),

        SearchItem(
            title: "Epinephrine Fact Sheet",
            keywords: ["epinephrine", "adrenaline", "stress response", "alertness", "energy", "fight or flight", "arousal", "focus", "neurotransmitter", "nervous system"],
            screen: "EpinephrineView"
        ),

        SearchItem(
            title: "GABA Fact Sheet",
            keywords: ["gaba", "neurotransmitter", "calm", "relaxation", "inhibitory", "anxiety", "sleep", "stress", "balance", "nervous system"],
            screen: "GABAView"
        ),

        SearchItem(
            title: "Glutamate Fact Sheet",
            keywords: ["glutamate", "neurotransmitter", "excitatory", "learning", "memory", "cognition", "focus", "brain", "stimulation", "balance"],
            screen: "GlutamateView"
        ),

        SearchItem(
            title: "Healthy Eating Tips",
            keywords: ["healthy eating", "nutrition", "diet", "food", "gut health", "energy", "meal planning", "vitamins", "recipes", "wellness"],
            screen: "EatingTipsView"
        ),

        SearchItem(
            title: "My Favorite Recipes",
            keywords: ["favorite recipes", "saved recipes", "meals", "cooking", "food", "ingredients", "meal plan", "nutrition", "dishes", "favorites"],
            screen: "FavoriteRecipesView"
        ),

        SearchItem(
            title: "LIFESPACE Recipe Index",
            keywords: ["recipe index", "recipes", "search recipes", "filters", "ingredients", "meal planning", "cooking", "nutrition", "dishes", "categories"],
            screen: "RecipeIndexView"
        ),

        SearchItem(
            title: "LIFESPACE Sketchpad",
            keywords: ["sketchpad", "drawing", "canvas", "doodle", "art", "creative", "paint", "sketch", "design", "relaxation"],
            screen: "ArtCreativeView"
        ),

        SearchItem(
            title: "LIFESPACE Sketchpad",
            keywords: ["sketchpad", "drawing", "canvas", "doodle", "art", "creative", "paint", "sketch", "design", "relaxation"],
            screen: "ArtCreativeView"
        ),

        SearchItem(
            title: "LIFESPACE Synthesizer",
            keywords: ["synthesizer", "music", "keyboard", "notes", "sound", "audio", "instrument", "compose", "create", "play"],
            screen: "MusicCreativeView"
        ),

        SearchItem(
            title: "LIFESPACE Mood Boards",
            keywords: ["mood board", "design", "inspiration", "collage", "aesthetic", "creative", "images", "style", "vision", "board"],
            screen: "DesignCreativeView"
        ),

        SearchItem(
            title: "Aquarius Astrology Chart",
            keywords: ["aquarius", "astrology", "zodiac", "horoscope", "birth chart", "sign", "traits", "element", "personality", "natal"],
            screen: "AquariusView"
        ),

        SearchItem(
            title: "Aries Astrology Chart",
            keywords: ["aries", "astrology", "zodiac", "horoscope", "birth chart", "sign", "traits", "element", "personality", "natal"],
            screen: "AriesView"
        ),

        SearchItem(
            title: "Astrology Charts",
            keywords: ["astrology", "zodiac", "horoscope", "birth chart", "natal chart", "signs", "sun sign", "moon sign", "rising sign", "traits"],
            screen: "AstrologyView"
        ),

        SearchItem(
            title: "Cancer Astrology Chart",
            keywords: ["cancer", "astrology", "zodiac", "horoscope", "birth chart", "sign", "traits", "element", "personality", "natal"],
            screen: "CancerView"
        ),

        SearchItem(
            title: "Capricorn Astrology Chart",
            keywords: ["capricorn", "astrology", "zodiac", "horoscope", "birth chart", "sign", "traits", "element", "personality", "natal"],
            screen: "CapricornView"
        ),

        SearchItem(
            title: "Gemini Astrology Chart",
            keywords: ["gemini", "astrology", "zodiac", "horoscope", "birth chart", "sign", "traits", "element", "personality", "natal"],
            screen: "GeminiView"
        ),

        SearchItem(
            title: "Leo Astrology Chart",
            keywords: ["leo", "astrology", "zodiac", "horoscope", "birth chart", "sign", "traits", "element", "personality", "natal"],
            screen: "LeoView"
        ),

        SearchItem(
            title: "Libra Astrology Chart",
            keywords: ["libra", "astrology", "zodiac", "horoscope", "birth chart", "sign", "traits", "element", "personality", "natal"],
            screen: "LibraView"
        ),

        SearchItem(
            title: "Pisces Astrology Chart",
            keywords: ["pisces", "astrology", "zodiac", "horoscope", "birth chart", "sign", "traits", "element", "personality", "natal"],
            screen: "PiscesView"
        ),

        SearchItem(
            title: "Sagittarius Astrology Chart",
            keywords: ["sagittarius", "astrology", "zodiac", "horoscope", "birth chart", "sign", "traits", "element", "personality", "natal"],
            screen: "SagittariusView"
        ),

        SearchItem(
            title: "Scorpio Astrology Chart",
            keywords: ["scorpio", "astrology", "zodiac", "horoscope", "birth chart", "sign", "traits", "element", "personality", "natal"],
            screen: "ScorpioView"
        ),

        SearchItem(
            title: "Taurus Astrology Chart",
            keywords: ["taurus", "astrology", "zodiac", "horoscope", "birth chart", "sign", "traits", "element", "personality", "natal"],
            screen: "TaurusView"
        ),

        SearchItem(
            title: "Virgo Astrology Chart",
            keywords: ["virgo", "astrology", "zodiac", "horoscope", "birth chart", "sign", "traits", "element", "personality", "natal"],
            screen: "VirgoView"
        ),

        SearchItem(
            title: "Nature Walks",
            keywords: ["nature walk", "walking", "outdoors", "fresh air", "sunlight", "grounding", "mindfulness", "stress relief", "exercise", "parks"],
            screen: "NatureWalkView"
        ),

        SearchItem(
            title: "Prayer Guide",
            keywords: ["prayer", "spirituality", "faith", "guidance", "devotion", "meditation", "hope", "strength", "gratitude", "inner work"],
            screen: "PrayerView"
        ),

        SearchItem(
            title: "Prayer For Assistance",
            keywords: ["prayer", "assistance", "help", "support", "guidance", "comfort", "strength", "faith", "hope", "spirituality"],
            screen: "AssistanceView"
        ),

        SearchItem(
            title: "Prayer For Deliverance",
            keywords: ["prayer", "deliverance", "freedom", "healing", "release", "strength", "faith", "courage", "protection", "spirituality"],
            screen: "DeliveranceView"
        ),

        SearchItem(
            title: "Prayer For Protection",
            keywords: ["prayer", "protection", "safety", "shield", "faith", "strength", "comfort", "guidance", "spirituality", "peace"],
            screen: "ProtectionView"
        ),

        SearchItem(
            title: "Prayer For Repentance",
            keywords: ["prayer", "repentance", "forgiveness", "humility", "renewal", "faith", "spirituality", "reflection", "growth", "healing"],
            screen: "RepentanceView"
        ),

        SearchItem(
            title: "Tarot Game",
            keywords: ["tarot", "cards", "reading", "study", "intuition", "archetypes", "guidance", "spirituality", "practice", "game"],
            screen: "TarotStudyView"
        ),

        SearchItem(
            title: "Aromatherapy Guide",
            keywords: ["aromatherapy", "essential oils", "diffuser", "scent", "calming", "relaxation", "stress", "sensory", "mood", "wellness"],
            screen: "AromatherapyView"
        ),

        SearchItem(
            title: "How to Do Breathwork",
            keywords: ["breathwork", "breathing", "respiration", "calm", "stress", "anxiety", "techniques", "nervous system", "relaxation", "practice"],
            screen: "BreathworkView"
        ),

        SearchItem(
            title: "Trataka Techniques",
            keywords: ["trataka", "candle", "candle meditation", "gazing", "focus", "concentration", "mindfulness", "visualization", "breathing", "inner work"],
            screen: "CandleWorkView"
        ),

        SearchItem(
            title: "Fasting Guide",
            keywords: ["fasting", "intermittent fasting", "time restricted", "discipline", "metabolism", "autophagy", "wellness", "health", "routine", "guide"],
            screen: "FastingView"
        ),

        SearchItem(
            title: "Inner Work Tips",
            keywords: ["inner work", "meditation", "prayer", "mindfulness", "reflection", "journaling", "healing", "growth", "spirituality", "self-awareness"],
            screen: "InnerWorkTipsView"
        ),

        SearchItem(
            title: "Meditation Guide",
            keywords: ["meditation", "mindfulness", "breathing", "calm", "focus", "practice", "relaxation", "inner peace", "visualization", "stress"],
            screen: "MeditationView"
        ),

        SearchItem(
            title: "How to Practice Mirror Work",
            keywords: ["mirror work", "affirmations", "self love", "confidence", "mindset", "self talk", "reflection", "manifestation", "practice", "inner work"],
            screen: "MirrorWorkView"
        ),

        SearchItem(
            title: "Shadow Work Techniques",
            keywords: ["shadow work", "journaling", "inner child", "triggers", "emotions", "healing", "self reflection", "integration", "trauma", "growth"],
            screen: "ShadowWorkView"
        ),

        SearchItem(
            title: "Soundbath Guide",
            keywords: ["sound bath", "soundbath", "frequency", "vibrations", "singing bowls", "relaxation", "meditation", "calming", "mindfulness", "healing"],
            screen: "SoundBathView"
        ),

        SearchItem(
            title: "Tai Chi Fact Sheet",
            keywords: ["tai chi", "movement", "balance", "flow", "gentle exercise", "mindfulness", "breathing", "qigong", "relaxation", "practice"],
            screen: "TaiChiView"
        ),

        SearchItem(
            title: "Yoga Techniques",
            keywords: ["yoga", "poses", "stretching", "flexibility", "breathing", "mindfulness", "relaxation", "mobility", "balance", "practice"],
            screen: "YogaView"
        ),

        SearchItem(
            title: "Light Tips",
            keywords: ["light", "sunlight", "circadian", "sleep", "blue light", "lamp", "vitamin d", "seasonal", "mood", "brightness"],
            screen: "LightTipsView"
        ),

        SearchItem(
            title: "Blue Color Psychology",
            keywords: ["blue", "color psychology", "mood", "calm", "focus", "emotion", "lighting", "decor", "chromotherapy", "meaning"],
            screen: "BlueView"
        ),

        SearchItem(
            title: "Cool Light Fact Sheet",
            keywords: ["cool light", "kelvin", "daylight", "blue light", "alertness", "focus", "lighting", "bulbs", "circadian", "productivity"],
            screen: "CoolLightView"
        ),

        SearchItem(
            title: "Green Color Psychology",
            keywords: ["green", "color psychology", "balance", "calm", "nature", "healing", "mood", "lighting", "decor", "meaning"],
            screen: "GreenView"
        ),

        SearchItem(
            title: "Indigo Color Psychology",
            keywords: ["indigo", "color psychology", "intuition", "spiritual", "depth", "mood", "lighting", "decor", "meaning", "chromotherapy"],
            screen: "IndigoView"
        ),

        SearchItem(
            title: "Neutral Light Fact Sheet",
            keywords: ["neutral light", "kelvin", "balanced lighting", "indoor light", "mood", "focus", "home", "office", "circadian", "lighting"],
            screen: "NeutralLightView"
        ),

        SearchItem(
            title: "Orange Color Psychology",
            keywords: ["orange", "color psychology", "energy", "warmth", "creativity", "mood", "lighting", "decor", "meaning", "chromotherapy"],
            screen: "OrangeView"
        ),

        SearchItem(
            title: "Red Color Psychology",
            keywords: ["red", "color psychology", "energy", "alertness", "intensity", "mood", "lighting", "decor", "meaning", "chromotherapy"],
            screen: "RedView"
        ),

        SearchItem(
            title: "Violet Color Psychology",
            keywords: ["violet", "color psychology", "spiritual", "creativity", "mood", "calm", "lighting", "decor", "meaning", "chromotherapy"],
            screen: "VioletView"
        ),

        SearchItem(
            title: "Warm Light Fact Sheet",
            keywords: ["warm light", "kelvin", "evening", "relaxation", "sleep", "cozy", "melatonin", "lamp", "lighting", "amber"],
            screen: "WarmLightView"
        ),

        SearchItem(
            title: "Yellow Color Psychology",
            keywords: ["yellow", "color psychology", "optimism", "energy", "mood", "brightness", "lighting", "decor", "meaning", "chromotherapy"],
            screen: "YellowView"
        ),

        SearchItem(
            title: "Feng Shui Guide",
            keywords: ["feng shui", "chi", "energy", "home", "space", "declutter", "flow", "harmony", "design", "arrangement"],
            screen: "FengShuiView"
        ),

        SearchItem(
            title: "Sensory Health Tips",
            keywords: ["sensory", "sensory health", "sight", "sound", "smell", "touch", "taste", "stimulation", "grounding", "environment"],
            screen: "SensoryTipsView"
        ),

        SearchItem(
            title: "Fitness Tips",
            keywords: ["fitness tips", "exercise", "training", "strength", "cardio", "routine", "health", "confidence", "workouts", "consistency"],
            screen: "FitnessTipsView"
        ),

        SearchItem(
            title: "Purpose Tips",
            keywords: ["purpose", "meaning", "direction", "values", "mission", "goals", "motivation", "vision", "intention", "life plan"],
            screen: "PurposeTipsView"
        ),

        SearchItem(
            title: "LIFESPACE Hierachy of Needs",
            keywords: ["lifespace hierarchy", "pyramid", "needs", "modules", "framework", "wellness", "brain optimization", "structure", "levels", "model"],
            screen: "BigLifespacePyramidView"
        ),

        SearchItem(
            title: "Maslow's Hierachy of Needs",
            keywords: ["maslow", "hierarchy of needs", "psychology", "motivation", "self actualization", "belonging", "esteem", "safety", "growth", "pyramid"],
            screen: "BigMaslowPyramidView"
        ),

        SearchItem(
            title: "Daily LIFESPACE Checklist",
            keywords: ["daily checklist", "check-in", "habits", "modules", "tracking", "routine", "wellness", "complete", "lifespace", "score"],
            screen: "PyramidView"
        ),

        // MARK: Goals
        SearchItem(
            title: "My Goals",
            keywords: ["goals", "goal planner", "planning", "objectives", "milestones", "habits", "motivation", "purpose", "progress", "tracking"],
            screen: "GoalsView"
        ),

        SearchItem(
            title: "My Recipes",
            keywords: ["my recipes", "recipes", "custom recipes", "create", "cooking", "meals", "ingredients", "save", "meal planning", "food"],
            screen: "MyRecipesView"
        )
    ]
}
