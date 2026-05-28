import SwiftUI

struct AnkleCirclesView: View {
    var body: some View {
        ExerciseTemplateView(
            title: "How to Do Ankle Circles",
            gifName: "Ankle-Circles",
            description: """
            **Ankle Circles** are a gentle mobility movement that helps lubricate the ankle joint, improve range of motion, and increase circulation, especially helpful before or after physical activity.

            Lift one foot slightly off the ground while seated or lying down. Slowly rotate your ankle in a full circle, then reverse direction.
            """,
            nextScreen: "RollingCalvesView"
        )
    }
}
