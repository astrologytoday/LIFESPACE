import SwiftUI

struct RollingCalvesView: View {
    var body: some View {
        ExerciseTemplateView(
            title: "How to Do Rolling Calves",
            gifName: "Rolling-Calves",
            description: """
            Start on your toes and slowly roll onto your heels, lifting your toes and activating your calves for balance and mobility.
            """,
            nextScreen: "GluteBridgeChestPressView"
        )
    }
}
