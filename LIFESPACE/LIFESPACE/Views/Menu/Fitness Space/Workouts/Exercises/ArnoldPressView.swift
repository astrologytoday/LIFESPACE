import SwiftUI

struct ArnoldPressView: View {
    var body: some View {
        ExerciseTemplateView(
            title: "How to Do an Arnold Press",
            gifName: "Arnold-Press",
            description: """
            The Arnold Press is an exercise named after Arnold Schwarzenegger that targets all three heads of the shoulder muscles by combining a standard press with a wrist rotation.

            **Instruction:** Start with palms in, then rotate them outward as you press upward.
            """,
            nextScreen: "BentOverShoulderPullsView"
        )
    }
}
