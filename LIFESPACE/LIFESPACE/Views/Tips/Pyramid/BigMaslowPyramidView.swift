import SwiftUI

struct BigMaslowPyramidView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero

    var body: some View {
        ZStack(alignment: .topLeading) {
            // Background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.35, green: 0.80, blue: 0.75),
                    Color(red: 0.20, green: 0.65, blue: 0.60),
                    Color(red: 0.10, green: 0.45, blue: 0.45)
                ]),
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            // Zoomable Pyramid
            VStack {
                Spacer()
                Image("maslow2")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 540, maxHeight: 900) // allow larger max in landscape!
                    .shadow(radius: 30)
                    .scaleEffect(scale)
                    .offset(offset)
                    .gesture(
                        SimultaneousGesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    scale = min(max(lastScale * value, 1.0), 4.0)
                                }
                                .onEnded { _ in
                                    lastScale = scale
                                },
                            DragGesture()
                                .onChanged { value in
                                    offset = CGSize(
                                        width: lastOffset.width + value.translation.width,
                                        height: lastOffset.height + value.translation.height
                                    )
                                }
                                .onEnded { _ in
                                    lastOffset = offset
                                }
                        )
                    )
                    .animation(.easeInOut(duration: 0.18), value: scale)
                    .accessibilityLabel("Pinch or drag to zoom. Use the top-left button to return.")
                Spacer()
            }
            // NAVIGATION BUTTON (always top left, never moves with zoom)
            Button(action: {
                // Dismiss landscape window and go back to LifespacePyramidView
                dismissLandscapeWindow(to: "LifespacePyramidView", navModel: navModel)
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .padding(14)
                    .background(Color.black.opacity(0.16))
                    .clipShape(Circle())
                    .shadow(radius: 10)
            }
            .padding(.top, 26)
            .padding(.leading, 18)
        }
        .navigationBarBackButtonHidden(true) // If inside a NavigationStack
    }
}


