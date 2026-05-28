import SwiftUI

struct ElevatedSquatsView: View {
    var body: some View {
        ExerciseTemplateView(
            title: "How to Do Elevated Squats",
            gifName: "Elevated-Squats",
            description: """
            Stand on an elevated surface with heels raised to engage your quads. Lower into a squat while keeping knees out and back straight.
            """,
            nextScreen: "GobletSquatsView"
        )
    }
}
