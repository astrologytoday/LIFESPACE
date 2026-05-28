import SwiftUI

struct HammerCurlsView: View {
    var body: some View {
        ExerciseTemplateView(
            title: "How to Do Hammer Curls",
            gifName: "Hammer-Curls",
            description: """
            Keep your elbows close to your body as you curl dumbbells upward with a neutral grip. Focus on contracting the biceps with each rep.
            """,
            nextScreen: "InnerBicepCurlsView"
        )
    }
}
