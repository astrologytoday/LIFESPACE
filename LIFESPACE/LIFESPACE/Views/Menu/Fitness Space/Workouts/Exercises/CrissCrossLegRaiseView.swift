import SwiftUI

struct CrissCrossLegRaiseView: View {
    var body: some View {
        ExerciseTemplateView(
            title: "How to Do a Criss-Cross Leg Raise",
            gifName: "Criss-Cross-Leg-Raise",
            description: """
            Lie on your back, lift your legs, and cross them over each other in a fluttering motion while keeping them extended and elevated.

            **Pro Tip:** Press your lower back into the floor and keep core engaged throughout.
            """,
            nextScreen: "FishPoseMatsyasanaView"
        )
    }
}
