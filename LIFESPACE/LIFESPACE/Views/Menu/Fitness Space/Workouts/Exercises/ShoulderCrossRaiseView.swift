import SwiftUI

struct ShoulderCrossRaiseView: View {
    var body: some View {
        ExerciseTemplateView(
            title: "How to Do a Shoulder Cross Raise",
            gifName: "Shoulder-Cross-Raise",
            description: """
            Cross your arms in front of your chest, then raise them diagonally upward to target front and lateral deltoids in one motion.
            """,
            nextScreen: "ArnoldPressView"
        )
    }
}
