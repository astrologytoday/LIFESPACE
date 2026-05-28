import SwiftUI

struct SquatsView: View {
    var body: some View {
        ExerciseTemplateView(
            title: "How to Do Squats",
            gifName: "Squats",
            description: """
            Stand with feet about shoulder-width apart, toes slightly turned out. Start the squat by sending your hips back and bending your knees at the same time.

            Lower until your thighs are parallel to the floor. Press the floor away to stand up.
            """,
            nextScreen: "GobletSquatsView"
        )
    }
}
