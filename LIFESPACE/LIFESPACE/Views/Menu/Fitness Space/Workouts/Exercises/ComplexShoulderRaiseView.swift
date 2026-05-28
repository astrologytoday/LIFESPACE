import SwiftUI

struct ComplexShoulderRaiseView: View {
    var body: some View {
        ExerciseTemplateView(
            title: "Shoulder Raise Complex",
            gifName: "Complex-Shoulder-Raise",
            description: """
            Perform a front raise, followed by a lateral raise, then a rear raise. Complete all three motions in sequence without rest.
            """,
            nextScreen: "ArnoldPressView"
        )
    }
}
