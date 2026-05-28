import SwiftUI

struct ChestCrossRaiseView: View {
    var body: some View {
        ExerciseTemplateView(
            title: "How to Do a Chest Cross",
            gifName: "Chest-Cross-Raise",
            description: """
            Raise your arms out to the sides with a slight bend in the elbows, then bring them forward to cross in front of your chest in a wide, sweeping motion. Focus on squeezing your chest at the top before returning to the starting position with control.
            """,
            nextScreen: "FloorSqueezeChestPressView"
        )
    }
}
