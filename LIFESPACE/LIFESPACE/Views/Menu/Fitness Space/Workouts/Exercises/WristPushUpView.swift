import SwiftUI

struct WristPushUpView: View {
    var body: some View {
        ExerciseTemplateView(
            title: "How to Do Wrist Push-Ups",
            gifName: "Wrist-Push-Up",
            description: """
            Begin in a kneeling position, rotate palms upward, and gently lower into a controlled push-up.
            """,
            nextScreen: "ElbowPlankView"
        )
    }
}
