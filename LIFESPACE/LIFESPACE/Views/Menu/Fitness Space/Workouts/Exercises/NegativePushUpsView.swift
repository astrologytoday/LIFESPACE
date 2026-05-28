import SwiftUI

struct NegativePushUpsView: View {
    var body: some View {
        ExerciseTemplateView(
            title: "How to Do Negative Push-Ups",
            gifName: "Negative-Push-Ups",
            description: """
            Begin in a plank position, then lower your body slowly to the floor in a controlled descent. Reset at the top and repeat.

            **Pro Tip:** Keep your core tight and elbows tucked throughout the motion.
            """,
            nextScreen: "RollingCalvesView"
        )
    }
}
