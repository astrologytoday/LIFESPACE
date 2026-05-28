import SwiftUI

struct LateralShoulderRaiseView: View {
    var body: some View {
        ExerciseTemplateView(
            title: "How to Do Lateral Shoulder Raises",
            gifName: "Lateral-Shoulder-Raise",
            description: """
            Stand upright with dumbbells at your sides. Raise your arms outward until they reach shoulder height, then lower with control.

            **Pro Tip:** Keep your elbows slightly bent and wrists level with your shoulders.
            """,
            nextScreen: "ComplexShoulderRaiseView"
        )
    }
}
