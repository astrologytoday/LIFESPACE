import SwiftUI

struct GobletSquatsView: View {
    var body: some View {
        ExerciseTemplateView(
            title: "How to Do Goblet Squats",
            gifName: "Goblet-Squats",
            description: """
            Hold a weight close to your chest with both hands. Lower into a squat while keeping your torso upright and elbows inside your knees.
            """,
            nextScreen: "LateralShoulderRaiseView"
        )
    }
}
