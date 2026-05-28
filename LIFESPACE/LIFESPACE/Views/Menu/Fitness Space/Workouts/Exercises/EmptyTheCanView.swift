import SwiftUI

struct EmptyTheCanView: View {
    var body: some View {
        ExerciseTemplateView(
            title: "How to Empty the Can",
            gifName: "Empty-The-Can",
            description: """
            Stand upright with dumbbells. Rotate thumbs down as you raise arms diagonally, like pouring out two cans.

            **Pro Tip:** Keep elbows slightly bent and focus on the upper traps and shoulders.

            Aim for 3 sets of 12 slow, controlled reps.
            """,
            nextScreen: "ForearmRotationView"
        )
    }
}
