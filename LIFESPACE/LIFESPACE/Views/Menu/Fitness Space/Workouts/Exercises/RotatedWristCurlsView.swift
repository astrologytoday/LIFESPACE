import SwiftUI

struct RotatedWristCurlsView: View {
    var body: some View {
        ExerciseTemplateView(
            title: "How to Do Rotated Wrist Curls",
            gifName: "Rotated-Wrist-Curls",
            description: """
            Rotate your palms inward while curling to hit both forearms and brachioradialis. Keep wrists steady and focus on the contraction.
            """,
            nextScreen: "HammerWristCurlsView"
        )
    }
}
