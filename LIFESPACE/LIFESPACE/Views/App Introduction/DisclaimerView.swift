import SwiftUI

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct DisclaimerView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var agreed = false
    @State private var showNext = false
    @State private var checkboxEnabled = false

    // IMPORTANT: This must represent consent completion, not merely "opened"
    @AppStorage("hasSeenDisclaimer") private var hasSeenDisclaimer: Bool = false

    var body: some View {
        ZStack {
            // Background gradient
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

            if !showNext {
                VStack {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Disclaimer")
                                .font(Font.custom("Avenir", size: 30).weight(.bold))
                                .foregroundColor(.white)

                            Text("Last Updated: 06/22/25")
                                .font(Font.custom("Avenir", size: 13.5))

                            Text("The LIFESPACE app is a lifestyle and self-optimization tool designed for educational and informational purposes only. It is not intended to diagnose, treat, or cure any medical condition and is not a substitute for clinical care.")
                                .font(Font.custom("Avenir", size: 13.5))
                                .multilineTextAlignment(.leading)

                            Text("No Medical Advice")
                                .font(Font.custom("Avenir", size: 18).weight(.bold))
                                .foregroundColor(.white)

                            Text("""
The content within this app (including all text, graphics, questionnaires, recommendations, results, and related materials) is not a substitute for professional medical advice, diagnosis, or treatment. Always seek the advice of a qualified healthcare provider with any questions you may have regarding a medical or mental health condition. Never disregard professional advice or delay in seeking it because of something you have read or interpreted within the LIFESPACE app.

The LIFESPACE app is designed to promote mental wellness, emotional resilience, and healthy lifestyle habits. While the app may support psychological well-being and help users cultivate habits that can reduce stress and improve life satisfaction, it is not intended to diagnose, treat, or cure any medical or psychiatric condition.

The information provided is for general wellness education only and should not be considered a substitute for advice from a licensed medical or mental health professional.
""")
                                .font(Font.custom("Avenir", size: 13.5))
                                .multilineTextAlignment(.leading)

                            Text("Wellness Scoring System")
                                .font(Font.custom("Avenir", size: 18).weight(.bold))
                                .foregroundColor(.white)

                            Text("""
The "optimization score" and related feedback are designed to encourage holistic wellness habits based on the LIFESPACE framework. This framework should not be interpreted as a formal clinical evaluation. 

The LIFESPACE "optimization score" and related feedback are intended to provide users with insights into their current lifestyle patterns based on the LIFESPACE model, which includes modules such as light exposure, inner work, fitness, nutrition, sleep, purpose, fun, community, and creative expression. This scoring system is a self-reflective tool designed to encourage holistic wellness habits and promote conscious daily living.

The LIFESPACE framework is rooted in personal philosophy and psychological education. It is not based on any official diagnostic system and should not be interpreted as a clinical evaluation or a psychological profile. The score is not intended to label, diagnose, or treat any mental health or medical condition.

While users may find the scoring system motivational or emotionally impactful, it is important to understand that this tool functions strictly within the domain of lifestyle optimization and personal development. Any resemblance to psychological testing is coincidental and not legally or clinically binding.

Users should not make medical, psychiatric, or major lifestyle decisions based solely on their LIFESPACE score. We encourage users to consult with licensed health professionals for any concerns regarding mental health, physical health, or emotional well-being.
""")
                                .font(Font.custom("Avenir", size: 13.5))
                                .multilineTextAlignment(.leading)

                            Text("User Responsibility")
                                .font(Font.custom("Avenir", size: 18).weight(.bold))
                                .foregroundColor(.white)

                            Text("""
You acknowledge that any reliance on information provided by this app is at your own risk. Users are responsible for their own health choices and lifestyle decisions. If you experience any symptoms of illness, injury, or mental distress, we strongly encourage you to consult with a licensed professional. The app is intended as a self-guided wellness tool, not a substitute for medical or psychological evaluation, diagnosis, or treatment.

You are solely responsible for the choices you make regarding your health, behavior, lifestyle, and personal development. While the LIFESPACE framework may offer inspiration, motivation, or guidance in areas such as emotional wellness, physical activity, nutrition, spirituality, or social connection, it is not a regulated or prescriptive healthcare program.

We strongly encourage users to exercise discernment when interpreting their results or feedback, and to seek professional medical or mental health advice for any symptoms of illness, emotional distress, or functional impairment. If you are experiencing a crisis or ongoing difficulty, please consult with a licensed physician, therapist, or emergency support service in your area.

The creators of the LIFESPACE app are not liable for any decisions, outcomes, or consequences resulting from the use of the app or its content. By proceeding, you accept full responsibility for your well-being and understand that this tool is meant to supplement and not replace comprehensive care.
""")
                                .font(Font.custom("Avenir", size: 13.5))
                                .multilineTextAlignment(.leading)

                            Text("Fitness Safety")
                                .font(Font.custom("Avenir", size: 18).weight(.bold))
                                .foregroundColor(.white)

                            Text("""
The fitness content provided within the LIFESPACE app is for general informational and motivational purposes only and is not intended as a substitute for professional medical advice, diagnosis, or treatment. Before starting any exercise program or engaging in physical activity presented in the app, users are strongly encouraged to consult with a physician or qualified healthcare professional to determine whether such activities are appropriate for their individual health conditions.

By using this app, you voluntarily assume full responsibility for any risk of injury or loss, whether physical or otherwise, that may result from participation in any exercises, workouts, or fitness routines. You acknowledge that engaging in physical activity carries inherent risks, including but not limited to muscle strain, sprains, injury, or, in rare cases, serious medical events. You agree to exercise within your limits, monitor your condition, and stop immediately if you feel unwell or experience any pain or discomfort.

LIFESPACE, including its developers, affiliates, and partners, disclaims any and all liability for injuries, health complications, or damages resulting from the use of this app or the performance of any suggested activities. By continuing to use the app, you affirm that you understand and accept these risks and release LIFESPACE and its associates from any claims related to your participation in physical activities.
""")
                                .font(Font.custom("Avenir", size: 13.5))
                                .multilineTextAlignment(.leading)

                            Text("No Therapeutic Relationship")
                                .font(Font.custom("Avenir", size: 18).weight(.bold))
                                .foregroundColor(.white)

                            Text("""
Use of the LIFESPACE app does not establish any form of therapeutic, medical, or professional relationship between you and the creators of the app, its developers, contributors, or affiliated entities. Specifically, no therapist-client, doctor-patient, coach-client, or counselor-patient relationship is formed by interacting with this app or by receiving scores, insights, feedback, or suggestions generated through its content.

Although the app may contain tools, exercises, prompts, or information that resemble those used in therapeutic, coaching, or wellness practices, these are provided solely for general educational and self-development purposes. They are not tailored to your individual psychological history, clinical needs, or medical background, and they are not a substitute for licensed therapeutic support.

Any communications from the app including automated messages, guidance, prompts, or in-app feedback should not be interpreted as personal mental health advice or professional guidance. The creators and developers of LIFESPACE do not monitor, assess, or respond to individual user input in a clinical capacity.

If you are seeking mental health treatment, coaching, or professional medical advice, we strongly encourage you to consult with a licensed provider in your region. The LIFESPACE app is intended to empower you on your wellness journey, but it is not a replacement for therapeutic care or professional services.
""")
                                .font(Font.custom("Avenir", size: 13.5))
                                .multilineTextAlignment(.leading)

                            Text("Emergency Disclaimer")
                                .font(Font.custom("Avenir", size: 18).weight(.bold))
                                .foregroundColor(.white)

                            Text("If you are experiencing a crisis or medical emergency, please contact your local emergency services immediately or visit the nearest hospital or urgent care center.")
                                .font(Font.custom("Avenir", size: 13.5))
                                .multilineTextAlignment(.leading)

                            GeometryReader { geo in
                                Color.clear
                                    .frame(height: 1)
                                    .preference(
                                        key: ScrollOffsetPreferenceKey.self,
                                        value: geo.frame(in: .named("scroll")).maxY
                                    )
                            }
                            .frame(height: 1)
                        }
                        .padding(.horizontal)
                    }
                    .coordinateSpace(name: "scroll")
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                        let screenHeight = UIScreen.main.bounds.height
                        if value < screenHeight + 50 {
                            withAnimation {
                                checkboxEnabled = true
                            }
                        }
                    }

                    HStack(alignment: .center) {
                        Button(action: {
                            guard checkboxEnabled else { return }

                            withAnimation(.easeInOut(duration: 0.6)) {
                                agreed = true
                                hasSeenDisclaimer = true   // ✅ Only set when user explicitly consents
                                showNext = true
                            }
                        }) {
                            Image(systemName: agreed ? "checkmark.square.fill" : "square")
                                .foregroundColor(checkboxEnabled ? .white : .gray)
                                .font(.title2)
                        }
                        .disabled(!checkboxEnabled || agreed) // one-way consent

                        Text("Check here to indicate that you have read and agree to the Terms and Conditions.")
                            .padding(.leading, 4)
                            .font(Font.custom("Avenir", size: 13.5))
                            .multilineTextAlignment(.leading)
                    }
                    .padding()
                }
                .font(Font.custom("Avenir", size: 13.5))
                .foregroundColor(.white)
                .transition(.opacity)
            }

            if showNext {
                LifespaceInfoView()
                    .environmentObject(navModel)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.6), value: showNext)
    }
}
