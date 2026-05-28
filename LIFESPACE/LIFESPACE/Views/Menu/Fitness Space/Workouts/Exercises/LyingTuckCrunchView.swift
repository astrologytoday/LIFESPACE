import SwiftUI

struct LyingTuckCrunchView: View {
    var body: some View {
        ExerciseTemplateView(
            title: "How to Do Lying Tuck Crunches",
            gifName: "Lying-Tuck-Crunch",
            description: """
            Lie flat with your arms at your sides. Lift your upper body and knees simultaneously, tucking them toward each other in the center.

            **Pro Tip:** Keep your chin up and use your abs, not your neck, to drive the movement.
            """,
            nextScreen: "PushUpsView"
        )
    }
}
