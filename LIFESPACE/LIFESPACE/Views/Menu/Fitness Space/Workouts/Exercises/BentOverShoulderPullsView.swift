import SwiftUI

struct BentOverShoulderPullsView: View {
    var body: some View {
        ExerciseTemplateView(
            title: "How to Do Bent-Over Shoulder Pulls",
            gifName: "Bent-Over-Shoulder-Pulls",
            description: """
            **Bent-Over Shoulder Pulls** target your upper back and rear delts. Hinge forward, keep your back flat, and pull the weights out wide.

            **Pro Tip:** Squeeze your shoulder blades at the top.  
            Do 3 sets of 12–15 slow, controlled reps.
            """,
            nextScreen: "ShoulderCrossRaiseView"
        )
    }
}
