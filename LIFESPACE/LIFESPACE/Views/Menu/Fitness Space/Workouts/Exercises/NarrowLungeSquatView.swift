import SwiftUI

struct NarrowLungeSquatView: View {
    var body: some View {
        ExerciseTemplateView(
            title: "How to Do Narrow Lunge Squats",
            gifName: "Narrow-Lunge-Squat",
            description: """
            Step one foot back into a lunge, then rise into a narrow squat without standing up fully. Repeat for 10-12 slow, controlled reps.
            """,
            nextScreen: "NegativePushUpsView"
        )
    }
}
