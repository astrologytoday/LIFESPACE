import SwiftUI

struct WallCalfStretchView: View {
    var body: some View {
        ExerciseTemplateView(
            title: "How to Do Wall Calf Stretches",
            gifName: "Wall-Calf-Stretch",
            description: """
            Stand facing a wall, place one foot back and press the heel down. Keep both legs straight, lean forward slightly, and stretch the back calf.
            """,
            nextScreen: "CrucifixCurlsView"
        )
    }
}
