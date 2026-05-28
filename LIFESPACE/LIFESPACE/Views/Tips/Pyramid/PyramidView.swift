import SwiftUI

struct PyramidView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var pulse = false

    @AppStorage("lifespaceChecklist") private var checklistString: String = "000000000"
    @AppStorage("checklistDate") private var checklistDate: String = ""

    let checklistItems = [
        "I got at least 15 minutes of sunlight today",
        "I did at least 15 minutes of Inner Work today",
        "I worked out for at least 5 minutes today",
        "I ate at least 2 healthy meals today",
        "I showered, brushed my teeth, and did the dishes today",
        "I worked for at least 3 hours today (on weekdays)",
        "I will sleep before midnight today",
        "I talked to someone today",
        "I creatively expressed myself today"
    ]

    let lifespaceLetters = ["L","I","F","E","S","P","A","C","E"]

    let menuOptions: [(title: String, desc: String)] = [
        ("LIFESTYLE SURVEY", "Take the Lifestyle Survey with a pen and paper to make notes on where you might need improvement. This will help you focus on personal areas for growth."),
        ("FITNESS SPACE", "Plan your physical activity, log your workouts, and track your progress as you build energy, confidence, and discipline."),
        ("TO-DO LIST", "Keep track of important tasks and reminders that support your daily well-being. Prioritize what matters most and check things off as you go."),
        ("DAY PLANNER", "Design your perfect day: schedule time for essentials, block out focus hours, and visually map how you spend your time for greater structure."),
        ("DAILY JOURNAL", "Reflect on your thoughts and experiences. Journaling helps you process emotions, build self-awareness, and notice patterns over time."),
        ("GOALS", "Set long-term goals and break them into achievable steps. Stay motivated as you track your progress and celebrate each milestone.")
    ]

    func getChecklist() -> [Bool] {
        checklistString.map { $0 == "1" }
    }

    func setChecklist(_ new: [Bool]) {
        checklistString = new.map { $0 ? "1" : "0" }.joined()
    }

    func resetIfNeeded() {
        let today = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)

        if checklistDate != today {
            setChecklist(Array(repeating: false, count: 9))
            checklistDate = today
        }
    }

    private var menuPriorityDragGesture: some Gesture {
        DragGesture(minimumDistance: 8)
            .onEnded { value in
                let horizontal = value.translation.width
                let vertical = value.translation.height

                let absHorizontal = abs(horizontal)
                let absVertical = abs(vertical)

                let isMeaningfulHorizontalSwipe = absHorizontal > 22

                // ✅ Vertical scrolling only wins if it is clearly more vertical than horizontal.
                // ✅ Diagonal swipes now count as menu swipes.
                let shouldOpenMenu =
                    isMeaningfulHorizontalSwipe &&
                    absHorizontal >= absVertical * 0.45

                if shouldOpenMenu {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        navModel.showMenu = true
                    }
                }
            }
    }

    var body: some View {
        ZStack {
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

            ScrollView {
                VStack(spacing: 34) {

                    Text("How to Practice the LIFESPACE Model")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .shadow(color: .black.opacity(0.45), radius: 6, x: 0, y: 3)
                        .padding(.top, 20)

                    Text("""
Completing the Daily LIFESPACE Checklist helps you create momentum as you work through each LIFESPACE module each day.
""")
                    .font(.system(size: 18))
                    .foregroundColor(.white.opacity(0.95))
                    .multilineTextAlignment(.leading)
                    .padding()
                    .background(Color.white.opacity(0.06))
                    .cornerRadius(18)
                    .padding(.horizontal, 12)

                    VStack(alignment: .leading, spacing: 18) {
                        Text("Daily LIFESPACE Checklist")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)

                        ForEach(0..<checklistItems.count, id: \.self) { i in
                            Button {
                                var updated = getChecklist()
                                updated[i].toggle()
                                setChecklist(updated)
                            } label: {
                                HStack(alignment: .top, spacing: 14) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.white.opacity(0.7), lineWidth: 2)
                                            .background(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(Color.white.opacity(getChecklist()[i] ? 0.22 : 0.08))
                                            )
                                            .frame(width: 36, height: 36)

                                        if getChecklist()[i] {
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 18, weight: .bold))
                                                .foregroundColor(.teal)
                                        } else {
                                            Text(lifespaceLetters[i])
                                                .font(.system(size: 18, weight: .bold))
                                                .foregroundColor(.white)
                                        }
                                    }

                                    Text(checklistItems[i])
                                        .font(.system(size: 18))
                                        .foregroundColor(.white)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 12)
                    .onAppear { resetIfNeeded() }

                    Button {
                        navModel.push("LifespacePyramidView")
                    } label: {
                        Image("lifespace_pyramid")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200)
                            .shadow(radius: 18)
                            .scaleEffect(pulse ? 1.05 : 0.95)
                            .animation(
                                .easeInOut(duration: 1.3).repeatForever(autoreverses: true),
                                value: pulse
                            )
                            .onAppear { pulse = true }
                    }

                    HStack {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Sample LIFESPACE Routine")
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundColor(.white)

                            VStack(alignment: .leading, spacing: 8) {
                                Text("• Open your blinds to let sunlight in (**Light**)")
                                Text("• Start the day with prayer or meditation (**Inner Work**)")
                                Text("• Exercise for 15–20 minutes (**Fitness**)")
                                Text("• Enjoy a healthy breakfast (**Eating Healthy**)")
                                Text("• Shower and brush your teeth (**Sensory Health**)")
                                Text("• Go to work (**Purpose**)")
                                Text("• Do an activity with friends (**Activity/Community**)")
                                Text("• Blog or write in a journal (**Expression**)")
                            }
                            .font(.system(size: 17))
                            .foregroundColor(.white.opacity(0.95))
                        }
                        .padding()
                        .background(Color.white.opacity(0.06))
                        .cornerRadius(18)
                        .padding(.leading, 12)
                        .padding(.trailing, 0)

                        Spacer()
                    }
                    .padding(.trailing, 12)

                    VStack(alignment: .leading, spacing: 16) {
                        Text("How to Use the LIFESPACE Menu")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)

                        Text("Swipe from left to right anywhere on a page to open the LIFESPACE Menu. Each section supports a different area of growth:")
                            .font(.system(size: 17))
                            .foregroundColor(.white.opacity(0.95))
                    }
                    .padding()
                    .background(Color.white.opacity(0.06))
                    .cornerRadius(18)
                    .padding(.horizontal, 12)

                    ForEach(menuOptions, id: \.title) { opt in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(opt.title)
                                .font(.system(size: 17, weight: .heavy))
                                .foregroundColor(.white)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.white.opacity(0.11))
                                        .shadow(color: .black.opacity(0.04), radius: 1, y: 2)
                                )

                            Text(opt.desc)
                                .font(.system(size: 17))
                                .foregroundColor(.white.opacity(0.94))
                                .padding(.leading, 6)
                                .padding(.bottom, 2)
                        }
                        .padding(.horizontal, 12)
                        .padding(.bottom, 4)
                    }

                    Button {
                        navModel.selectedScreen = "TipsView"
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56)
                            .background(Color.white.opacity(0.18))
                            .clipShape(Circle())
                            .shadow(radius: 6)
                    }
                    .padding(.bottom, 50)
                }
                .frame(maxWidth: 520)
                .padding(.horizontal, 8)
            }
            .simultaneousGesture(menuPriorityDragGesture)
        }
    }
}
