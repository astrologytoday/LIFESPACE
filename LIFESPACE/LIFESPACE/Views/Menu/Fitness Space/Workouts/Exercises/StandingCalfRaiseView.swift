import SwiftUI

struct StandingCalfRaiseView: View {
    var body: some View {
        ExerciseTemplateView(
            title: "How to Do Standing Calf Raises",
            gifName: "Standing-Calf-Raise",
            description: """
            Stand upright and raise your heels off the floor, keeping your knees straight. Pause briefly at the top, then lower.
            """,
            nextScreen: "LyingCalfStretchView"
        )
    }
}
