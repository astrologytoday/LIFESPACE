import SwiftUI

struct CustomInnerWorkView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var userProfile: UserProfileModel

    @State private var customText: String = ""
    @State private var showTitle = false

    var body: some View {
        ZStack {
            // Teal gradient background
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

            VStack(spacing: 30) {
                Text("Enter Your Inner Work")
                    .font(Font.custom("Avenir", size: 24).weight(.bold))
                    .foregroundColor(.white)
                    .padding(.top, 80)
                    .opacity(showTitle ? 1 : 0)
                    .animation(.easeInOut(duration: 1), value: showTitle)

                TextField("Type here...", text: $customText)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .font(Font.custom("Avenir", size: 18))
                    .padding(.horizontal)

                Button(action: {
                    let trimmed = customText.trimmingCharacters(in: .whitespacesAndNewlines)
                    if !trimmed.isEmpty {
                        userProfile.pendingCustomInnerWork = trimmed
                        navModel.pop()
                    }
                }) {
                    Text("Save Practice")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(customText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.white.opacity(0.1) : Color.white.opacity(0.25))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .disabled(customText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

                Spacer()
            }
        }
        .onAppear {
            showTitle = true
            customText = userProfile.pendingCustomInnerWork ?? userProfile.customInnerWork ?? ""
        }
    }
}

