import SwiftUI

struct ChooseJournalView: View {
    @EnvironmentObject var navModel: NavigationModel

    var body: some View {
        ZStack {
            // LIFESPACE teal gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.35, green: 0.80, blue: 0.75),
                    Color(red: 0.20, green: 0.65, blue: 0.60),
                    Color(red: 0.10, green: 0.45, blue: 0.45)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 48) {
                Text("Choose Journal")
                    .font(.custom("Avenir", size: 34).weight(.bold))
                    .foregroundColor(.white)
                    .shadow(radius: 7)
                    .padding(.top, 82)

                Spacer()

                ZStack {
                    // Personal Journal (upper left, bigger)
                    JournalImageButton(
                        imageName: "personal_journal.png",
                        action: { navModel.push("PersonalJournalView") }
                    )
                    .frame(width: 315, height: 420)
                    .shadow(color: .black.opacity(0.15), radius: 16, x: 0, y: 10)
                    .offset(x: -100, y: -160)

                    // Dream Journal (lower right, still large)
                    JournalImageButton(
                        imageName: "dream_journal.png",
                        action: { navModel.push("JournalView") }
                    )
                    .frame(width: 315, height: 420)
                    .shadow(color: .black.opacity(0.15), radius: 16, x: 0, y: 10)
                    .offset(x: 100, y: 60)
                }
                .frame(maxWidth: .infinity, minHeight: 400, maxHeight: 500)

                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 18)
        }
    }
}

// MARK: - Custom Image Button
struct JournalImageButton: View {
    let imageName: String
    let action: () -> Void
    @State private var pressed = false

    var body: some View {
        Button(action: action) {
            Image(uiImage: UIImage(named: imageName) ?? UIImage())
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaleEffect(pressed ? 0.96 : 1.0)
                .animation(.spring(response: 0.18, dampingFraction: 0.5), value: pressed)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in pressed = true }
                .onEnded { _ in pressed = false }
        )
        .accessibilityLabel(Text(imageName.contains("personal") ? "Personal Journal" : "Dream Journal"))
    }
}

