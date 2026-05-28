import SwiftUI

struct ForearmRotationView: View {
    var body: some View {
        ExerciseTemplateView(
            title: "How to Do Forearm Rotations",
            gifName: "Forearm-Rotations",
            description: """
            Hold dumbbells at your sides with elbows bent. Rotate your forearms outward, then inward, keeping elbows tucked and still.

            **Pro Tip:** Focus on twisting without swinging your arms or shoulders.
            """,
            nextScreen: "HammerWristCurlsView"
        )
    }
}
