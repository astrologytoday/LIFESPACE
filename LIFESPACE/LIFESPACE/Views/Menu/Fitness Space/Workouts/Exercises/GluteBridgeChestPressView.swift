import SwiftUI

struct GluteBridgeChestPressView: View {
    var body: some View {
        ExerciseTemplateView(
            title: "How to Do the Glute Bridge Chest Press",
            gifName: "Glute-Bridge-Chest-Press",
            description: """
            Lie on your back with knees bent and hips lifted. While holding this position, press dumbbells upward from your chest.

            **Pro Tip:** Keep glutes fully engaged and don’t let your hips drop during the press.
            """,
            nextScreen: "HammerWristCurlsView"
        )
    }
}
