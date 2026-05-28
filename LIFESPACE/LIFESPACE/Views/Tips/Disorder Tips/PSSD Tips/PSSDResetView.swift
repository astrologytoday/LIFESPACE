import SwiftUI
import UIKit

struct PSSDResetView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var currentReset: String = "Take a deep breath"
    @State private var pulse = false

    var body: some View {
        ZStack {
            // Teal gradient background
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

            ScrollView {   // ← WRAP ENTIRE VIEW TO ALLOW VERTICAL EXPANSION SAFELY
                VStack(spacing: 44) {
                    Spacer(minLength: 0)

                    // Reset card
                    resetCard(for: currentReset)
                        .padding(.horizontal, 18)

                    // Generate new reset
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            currentReset = DepressionResetData.randomElement() ?? currentReset
                        }
                    }) {
                        Text("Generate New Reset")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 24)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(30)
                            .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(Color.white.opacity(0.4), lineWidth: 1)
                            )
                    }

                    // Day Planner section
                    VStack(spacing: 18) {

                        // FIXED: NO MORE TRUNCATION EVER
                        Text("""
Use one of the prompts to shake yourself out of a depression. Once feeling more stabilized, start making a plan for the rest of your day.
""")
                            .font(.custom("Avenir", size: 16))
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                            .fixedSize(horizontal: false, vertical: true)   // ← THE FIX
                            .frame(maxWidth: .infinity, alignment: .center)

                        VStack(spacing: 10) {
                            Image(systemName: "arrow.down")
                                .foregroundColor(.white.opacity(0.8))
                                .font(.system(size: 24, weight: .medium))

                            Button(action: { navModel.push("DayPlannerView") }) {
                                ZStack {
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 130, height: 130)

                                    Text("DAY\nPLANNER")
                                        .foregroundColor(.teal)
                                        .multilineTextAlignment(.center)
                                        .font(.system(size: 18, weight: .bold))
                                }
                                .shadow(color: Color.white.opacity(0.75), radius: 22, x: 0, y: 0)
                                .scaleEffect(pulse ? 1.06 : 1.0)
                                .onAppear {
                                    withAnimation(Animation.easeInOut(duration: 1.4).repeatForever(autoreverses: true)) {
                                        pulse = true
                                    }
                                }
                            }
                        }
                    }

                    Spacer(minLength: 0)

                    // Back button
                    Button(action: { navModel.pop() }) {
                        HStack(spacing: 10) {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 18, weight: .bold))
                            
                            Text("Back to PSSD Tips")
                                .font(.system(size: 18, weight: .semibold))
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 26)
                        .background(
                            RoundedRectangle(cornerRadius: 28)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(red: 0.35, green: 0.80, blue: 0.75),
                                            Color(red: 0.20, green: 0.65, blue: 0.60),
                                            Color(red: 0.10, green: 0.45, blue: 0.45)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.25), radius: 4, y: 2)
                    }
                    .padding(.bottom, 36)
                }
                .padding(.top, 8)
            }
        }
        .onAppear {
            currentReset = DepressionResetData.randomElement() ?? "Take a deep breath"
        }
    }

    // MARK: - Reset Card Router
    @ViewBuilder
    func resetCard(for reset: String) -> some View {
        switch reset {

        case "Get down on your knees and pray":
            highlightedCard(
                before: "Get down on your knees and ",
                link: "pray",
                after: "",
                action: { navModel.push("PrayerView") }
            )

        case "Do a guided meditation":
            highlightedCard(
                before: "",
                link: "Do a guided meditation",
                after: "",
                action: { navModel.push("YogaView") }
            )

        case "Put on a loud song and DANCE!":
            highlightedCard(
                before: "",
                link: "Put on a loud song",
                after: " and DANCE!",
                action: {
                    if let url = URL(string: "spotify://") {
                        UIApplication.shared.open(url)
                    }
                }
            )

        case "Clean your space with intense focus and music":
            highlightedCard(
                before: "Clean your space with intense focus and ",
                link: "music",
                after: "",
                action: {
                    if let url = URL(string: "spotify://") {
                        UIApplication.shared.open(url)
                    }
                }
            )

        case "Set a 15-minute timer and knock one thing off your to-do list":
            highlightedDoubleLinkCard(
                fullText: "Set a 15-minute timer and knock one thing off your to-do list",
                links: [
                    ("timer", { navModel.push("TimerView") }),
                    ("to-do list", { navModel.push("ToDoListView") })
                ]
            )

        case "Go outside, lie on the grass, and look at the sky for 5 whole minutes":
            highlightedCard(
                before: "Go outside, lie on the grass, and look at the sky for ",
                link: "5 whole minutes",
                after: "",
                action: { navModel.push("TimerView") }
            )

        case "Change your Phone Wallpaper":
            highlightedCard(
                before: "",
                link: "Change your Phone Wallpaper",
                after: "",
                action: {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
            )

        case "Set a timer for 2 minutes and look at memes":
            highlightedCard(
                before: "",
                link: "Set a timer for 2 minutes",
                after: " and look at memes",
                action: { navModel.push("TimerView") }
            )

        case "Balance on one leg for 1-2 minutes with your eyes closed":
            highlightedCard(
                before: "Balance on one leg for ",
                link: "1-2 minutes",
                after: " with your eyes closed",
                action: { navModel.push("TimerView") }
            )

        case "Hum “AUM” for a whole 2 minutes":
            highlightedCard(
                before: "Hum “AUM” for a whole ",
                link: "2 minutes",
                after: "",
                action: { navModel.push("TimerView") }
            )

        case "Step away from all electronics for 10 minutes":
            highlightedCard(
                before: "Step away from all electronics for ",
                link: "10 minutes",
                after: "",
                action: { navModel.push("TimerView") }
            )

        default:
            Text(reset)
                .font(.system(size: 28, weight: .semibold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)  // ← ALSO GOOD HERE
                .padding()
                .background(Color.white.opacity(0.15))
                .cornerRadius(16)
        }
    }

    // MARK: - Link Highlight Card Functions
    func highlightedCard(
        before: String,
        link: String,
        after: String,
        action: @escaping () -> Void
    ) -> some View {

        var full = AttributedString(before + link + after)

        if let r = full.range(of: link) {
            full[r].foregroundColor = Color(red: 0.00, green: 0.48, blue: 1.00)
            full[r].underlineStyle = .single
        }

        return Text(full)
            .font(.system(size: 28, weight: .semibold))
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)  // ← PREVENT CUT-OFF
            .padding()
            .background(Color.white.opacity(0.15))
            .cornerRadius(16)
            .onTapGesture { action() }
    }

    func highlightedDoubleLinkCard(
        fullText: String,
        links: [(String, () -> Void)]
    ) -> some View {

        var attributed = AttributedString(fullText)

        for (word, _) in links {
            if let range = attributed.range(of: word) {
                attributed[range].foregroundColor = Color(red: 0.00, green: 0.48, blue: 1.00)
                attributed[range].underlineStyle = .single
            }
        }

        return Text(attributed)
            .font(.system(size: 28, weight: .semibold))
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .padding(.top, 36)
            .background(Color.white.opacity(0.15))
            .cornerRadius(16)
            .onTapGesture {
                for (_, action) in links { action() }
            }
    }

    // MARK: - Reset Data Array
    private let DepressionResetData: [String] = [
        "Shower (switch between hot and cold, give yourself the willies)",
        "Coffee",
        "Go for a walk",
        "Put on a loud song and DANCE!",
        "Scream into a pillow or out loud",
        "Plunge your face in ice water",
        "Smell something sharp or strange (e.g., vinegar, eucalyptus oil)",
        "Get down on your knees and pray",
        "Clean your space with intense focus and music",
        "Set a 15-minute timer and knock one thing off your to-do list",
        "Go get a haircut",
        "Put on some makeup",
        "Hit a punching bag",
        "Do a guided meditation",
        "Go outside, lie on the grass, and look at the sky for 5 whole minutes",
        "Change your Phone Wallpaper",
        "Look in the mirror and tell yourself you’re beautiful",
        "Brush your teeth with your non-dominant hand",
        "Set a timer for 2 minutes and look at memes",
        "Rub an ice cube all over your face, neck and wrists until it melts",
        "Balance on one leg for 1-2 minutes with your eyes closed",
        "Stretch!",
        "Bite a lemon wedge in the mirror",
        "Write a wish on a small piece of paper, burn it, and then throw it in the toilet",
        "Hum “AUM” for a whole 2 minutes",
        "Close your eyes and walk backwards through your house without bumping into anything",
        "Jump in a pool",
        "Do cat-cow breathing on the floor while listening to rainforest sounds",
        "Open a random book or article, point to a line, and think about what it means",
        "Unfollow 5 accounts that don’t impress you",
        "Paint your nails",
        "Chew gum",
        "Gargle saltwater",
        "Step away from all electronics for 10 minutes",
        "Do 10 jumping jacks",
        "Run cold water over the sides of your wrists and splash it on your face",
        "Do a sudoku puzzle",
        "Play a game of Solitaire",
        "Go for a quick run",
    ]
}
