import SwiftUI

struct LyingCalfStretchView: View {
    var body: some View {
        ExerciseTemplateView(
            title: "How to Do Lying Calf Stretches",
            gifName: "Lying-Calf-Stretch",
            description: """
            Lie on your back and loop a towel or band around one foot. Extend your leg upward and gently pull the toes toward you.

            **Pro Tip:** Keep your opposite leg relaxed and breathe deeply into the stretch.
            """,
            nextScreen: "FishPoseMatsyasanaView"
        )
    }
}
