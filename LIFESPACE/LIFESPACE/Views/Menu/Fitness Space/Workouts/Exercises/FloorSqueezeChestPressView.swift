import SwiftUI

struct FloorSqueezeChestPressView: View {
    var body: some View {
        ExerciseTemplateView(
            title: "How to Do a Floor Squeeze Chest Press",
            gifName: "Floor-Squeeze-Chest-Press",
            description: """
            Lie on the floor with dumbbells pressed together above your chest. Lower them down while keeping constant inward pressure.

            **Pro Tip:** Squeezing the weights activates inner chest fibers through the entire range.
            """,
            nextScreen: "GluteBridgeChestPressView"
        )
    }
}
