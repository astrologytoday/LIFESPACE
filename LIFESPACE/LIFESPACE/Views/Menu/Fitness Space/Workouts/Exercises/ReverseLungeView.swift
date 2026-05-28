import SwiftUI

struct ReverseLungeView: View {
    var body: some View {
        ExerciseTemplateView(
            title: "How to Do Reverse Lunges",
            gifName: "Reverse-Lunge",
            description: """
            Step one leg back and lower your hips until both knees are at 90 degrees. Push through the front heel to return to standing.

            **Pro Tip:** Keep your chest upright and core braced throughout.
            """,
            nextScreen: "SquatsView"
        )
    }
}
