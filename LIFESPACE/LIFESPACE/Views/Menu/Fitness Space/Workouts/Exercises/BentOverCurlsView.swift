import SwiftUI

struct BentOverCurlsView: View {
    var body: some View {
        ExerciseTemplateView(
            title: "How to Do a Bent-Over Curl",
            gifName: "Bent-Over-Curls",
            description: """
            **Bent-Over Curls** target your biceps with added tension by keeping your arms hanging. Bend slightly forward, let the dumbbells hang, and curl slowly without swinging.

            Try and do 3 sets of 10–12 slow, controlled reps.
            """,
            nextScreen: "ChestCrossRaiseView"
        )
    }
}
