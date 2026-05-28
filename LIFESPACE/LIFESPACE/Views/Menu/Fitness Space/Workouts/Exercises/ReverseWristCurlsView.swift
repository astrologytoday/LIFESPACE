import SwiftUI

struct ReverseWristCurlsView: View {
    var body: some View {
        ExerciseTemplateView(
            title: "How to Do Reverse Wrist Curls",
            gifName: "Reverse-Wrist-Curls",
            description: """
            Hold a barbell or dumbbells with your palms facing down. Rest your forearms on your thighs and slowly curl your wrists upward, then lower with slow, controlled reps.
            """,
            nextScreen: "NeutralWristCurlsView"
        )
    }
}
