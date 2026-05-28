import SwiftUI

struct BurpeeJumpPushUpView: View {
    var body: some View {
        ExerciseTemplateView(
            title: "Burpee + Jump + Push-Ups",
            gifName: "Burpee-Jump-Push-Up",
            description: """
            The **Burpee + Jump + Push-Up** is a full-body move blending cardio and strength. Start standing, drop to plank, do a push-up, jump forward, then leap up.

            Try 3 sets of 8–10 controlled reps.
            """,
            nextScreen: "SitUpsView"
        )
    }
}
