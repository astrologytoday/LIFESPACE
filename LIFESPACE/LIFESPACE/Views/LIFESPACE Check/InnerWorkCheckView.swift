import SwiftUI

struct InnerWorkCheckView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var userProfile: UserProfileModel
    @EnvironmentObject var lifespaceLog: LifespaceLogModel

    @State private var selectedOptions: Set<String> = []
    @State private var didLogAndAdvance = false

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

            GeometryReader { geo in
                // Bubble grid columns (keeps your original vibe)
                let columns = [GridItem(.adaptive(minimum: 120), spacing: 20)]

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 30) {
                        Spacer(minLength: 0)

                        Text("Have you been practicing your Inner Work?")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .layoutPriority(1)
                            .padding(.horizontal, 18)

                        // Grid scroll area: constrained so button stays visible,
                        // but still scrolls on smaller devices.
                        ScrollView(showsIndicators: false) {
                            LazyVGrid(columns: columns, spacing: 20) {
                                ForEach(userProfile.innerWorkOptions, id: \.self) { option in
                                    Button {
                                        if selectedOptions.contains(option) {
                                            selectedOptions.remove(option)
                                        } else {
                                            selectedOptions.insert(option)
                                        }
                                    } label: {
                                        Text(option)
                                            .font(.custom("Avenir", size: 16))
                                            .foregroundColor(.white)
                                            .lineLimit(1)                 // prevents ugly wrapping
                                            .minimumScaleFactor(0.90)
                                            .allowsTightening(true)
                                            .multilineTextAlignment(.center)
                                            .padding()
                                            .frame(maxWidth: .infinity, minHeight: 44)
                                            .background(
                                                selectedOptions.contains(option)
                                                ? Color.white.opacity(0.3)
                                                : Color.white.opacity(0.15)
                                            )
                                            .clipShape(Capsule())
                                            .overlay(
                                                Capsule()
                                                    .stroke(Color.white.opacity(0.5), lineWidth: 1)
                                            )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, 18)
                            .padding(.vertical, 6)
                        }
                        .frame(maxHeight: max(220, geo.size.height * 0.42))

                        Button(action: nextTapped) {
                            Text(didLogAndAdvance ? "Next..." : "Next")
                                .fontWeight(.bold)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .foregroundColor(.black)
                                .cornerRadius(12)
                                .padding(.horizontal, 18)
                                .padding(.bottom, 8)
                        }
                        .buttonStyle(.plain)
                        .disabled(didLogAndAdvance)
                        .opacity(didLogAndAdvance ? 0.6 : 1)

                        Spacer(minLength: 0)
                    }
                    .padding(.vertical, 18)
                    .frame(maxWidth: .infinity)
                    // ✅ This is what keeps your whole layout centered on normal devices,
                    // but still scrollable when needed.
                    .frame(minHeight: geo.size.height)
                }
            }
        }
    }

    private func nextTapped() {
        guard !didLogAndAdvance else { return }
        didLogAndAdvance = true

        let yesCount = selectedOptions.isEmpty ? 0 : 1

        lifespaceLog.addEntry(
            LifespaceLogEntry(
                type: .lifespace,
                module: .innerWork,
                questionCount: 1,
                yesCount: yesCount
            )
        )

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.easeInOut(duration: 0.4)) {
                navModel.push("FitnessCheckView")
            }
        }
    }
}
