import SwiftUI

struct PushUpsView: View {
    var body: some View {
        ExerciseTemplateView(
            title: "How to Do Push-Ups",
            gifName: "Push-Ups",
            description: """
            Begin in a plank position. Lower your body until your chest nearly touches the ground, then push back up.

            **Pro Tip:** Keep your spine neutral, elbows at a 45° angle, and your core fully engaged.

            Try and aim for a set of 50 slow, controlled reps.
            """,
            nextScreen: "LyingTuckCrunchView"
        )
    }
}
