import SwiftUI

struct CrucifixCurlsView: View {
    var body: some View {
        ExerciseTemplateView(
            title: "How to Do Crucifix Curls",
            gifName: "Crucifix-Curls",
            description: """
            Hold your arms straight out to the sides, palms up. Perform small bicep curls while maintaining shoulder height.

            **Pro Tip:** Focus on constant tension and avoid lowering your arms during the set.
            """,
            nextScreen: "InnerBicepCurlsView"
        )
    }
}
