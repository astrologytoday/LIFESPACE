import SwiftUI

struct BackButtonView: View {
    @EnvironmentObject var navModel: NavigationModel
    var customTarget: String? = nil

    var body: some View {
        Button(action: {
            if let target = customTarget {
                navModel.selectedScreen = target
            } else {
                navModel.pop()
            }
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .bold))
                .padding(10)
                .background(Color.white.opacity(0.15))
                .clipShape(Circle())
        }
    }
}

