import SwiftUI

struct FishPoseMatsyasanaView: View {
    var body: some View {
        ExerciseTemplateView(
            title: "How to Do Fish Pose (Matsyasana)",
            gifName: "Fish-Pose-Matsyasana",
            description: """
            Lie on your back, lift your chest, and arch through the spine with your head tilted back. Keep legs extended and arms relaxed.

            **Pro Tip:** Open the throat and breathe deeply through the chest.
            """,
            nextScreen: "NegativePushUpsView"
        )
    }
}
