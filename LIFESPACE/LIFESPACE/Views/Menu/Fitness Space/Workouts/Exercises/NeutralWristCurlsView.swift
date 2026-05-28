import SwiftUI

struct NeutralWristCurlsView: View {
    var body: some View {
        ExerciseTemplateView(
            title: "How to Do Neutral Wrist Curls",
            gifName: "Neutral-Wrist-Curls",
            description: """
            Sit with forearms resting on your thighs, palms facing each other. Slowly curl the dumbbells downward using only your wrists.

            **Pro Tip:** Keep your forearms stable and avoid rolling your shoulders or elbows.
            """,
            nextScreen: "WristPushUpView"
        )
    }
}
