import SwiftUI

struct NavArrowButton: View {
    @EnvironmentObject var navModel: NavigationModel
    var direction: ArrowDirection
    var target: String
    var usePush: Bool = false // ✅ new flag
    var size: CGFloat = 48
    var color: Color = .white
    var padding: EdgeInsets

    enum ArrowDirection {
        case left, right
    }

    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.6)) {
                if usePush {
                    navModel.push(target)
                } else {
                    navModel.selectedScreen = target
                }
            }
        }) {
            Image(systemName: direction == .left ? "arrow.left.circle.fill" : "arrow.right.circle.fill")
                .resizable()
                .frame(width: size, height: size)
                .foregroundColor(color)
                .shadow(radius: 5)
        }
        .padding(padding)
    }
}
