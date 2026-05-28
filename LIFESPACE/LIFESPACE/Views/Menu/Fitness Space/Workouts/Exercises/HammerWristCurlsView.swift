import SwiftUI

struct HammerWristCurlsView: View {
    var body: some View {
        ExerciseTemplateView(
            title: "How to Do Hammer Wrist Curls",
            gifName: "Hammer-Wrist-Curls",
            description: """
            Sit or stand with your forearms parallel with your thighs, palms facing down.

            Holding dumbbells, curl your wrists upward, then slowly lower.
            """,
            nextScreen: "ChestCrossRaiseView"
        )
    }
}
