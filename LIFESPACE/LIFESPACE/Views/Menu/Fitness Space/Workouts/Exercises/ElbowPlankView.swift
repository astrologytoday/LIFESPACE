import SwiftUI

struct ElbowPlankView: View {
    var body: some View {
        ExerciseTemplateView(
            title: "How to Do an Elbow Plank",
            gifName: "Elbow-Plank",
            description: """
            Support your body weight on your elbows and toes, maintaining a straight line from your head to your heels. Keep your core engaged, your back flat, and your neck in a neutral position.

            **Pro Tip:** Press your forearms firmly into the ground to engage your upper body.
            """,
            nextScreen: "BurpeeJumpPushUpView"
        )
    }
}
