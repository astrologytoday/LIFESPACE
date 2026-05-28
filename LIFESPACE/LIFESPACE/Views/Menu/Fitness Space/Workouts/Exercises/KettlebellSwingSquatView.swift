import SwiftUI

struct KettlebellSwingSquatView: View {
    var body: some View {
        ExerciseTemplateView(
            title: "How to Do Kettlebell Swing Squats",
            gifName: "Kettlebell-Swing-Squat",
            description: """
            Swing the kettlebell between your legs, then drive it upward as you rise from a squat while maintaining full-body coordination and balance.
            """,
            nextScreen: "NarrowLungeSquatView"
        )
    }
}
