import SwiftUI

struct SitUpsView: View {
    var body: some View {
        ExerciseTemplateView(
            title: "How to Do Sit-Ups",
            gifName: "Sit-Ups",
            description: """
            Anchor your feet, brace your core, and sit up by curling your ribs toward your hips until your chest is over your thighs. Lower back down slowly with control. Keep your chin slightly tucked and your gaze forward.
            """,
            nextScreen: "PushUpsView"
        )
    }
}
