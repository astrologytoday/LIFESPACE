import SwiftUI

struct InnerBicepCurlsView: View {
    var body: some View {
        ExerciseTemplateView(
            title: "How to Do Inner Bicep Curls",
            gifName: "Inner-Bicep-Curls",
            description: """
            Perform curls with elbows slightly behind your body and palms turned outward to target the inner head of the biceps.
            """,
            nextScreen: "KettlebellSwingSquatView"
        )
    }
}
