import SwiftUI

struct InnerWorkCheckView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var userProfile: UserProfileModel
    @EnvironmentObject var lifespaceLog: LifespaceLogModel

    @State private var selectedOptions: Set<String> = []
    @State private var didLogAndAdvance = false

    var body: some View {
        ZStack {
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
                let columns = [GridItem(.adaptive(minimum: 120), spacing: 16)]

                ScrollView(showsIndicators: true) {
                    VStack(spacing: 24) {
                        Text("Have you been practicing your Inner Work?")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .lineLimit(3)
                            .minimumScaleFactor(0.7)
                            .fixedSize(horizontal: false, vertical: true)
                            .layoutPriority(1)
                            .padding(.horizontal, 22)
                            .padding(.top, 34)

                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(userProfile.innerWorkOptions, id: \.self) { option in
                                Button {
                                    if selectedOptions.contains(option) {
                                        selectedOptions.remove(option)
                                    } else {
                                        selectedOptions.insert(option)
                                    }
                                } label: {
                                    Text(option)
                                        .font(.custom("Avenir", size: 15))
                                        .foregroundColor(.white)
                                        .lineLimit(2)
                                        .minimumScaleFactor(0.72)
                                        .allowsTightening(true)
                                        .multilineTextAlignment(.center)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .padding(.vertical, 11)
                                        .padding(.horizontal, 10)
                                        .frame(maxWidth: .infinity, minHeight: 48)
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
                        .padding(.bottom, 110)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: geo.size.height)
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            Button(action: nextTapped) {
                Text(didLogAndAdvance ? "Next..." : "Next")
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 52)
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(12)
            }
            .buttonStyle(.plain)
            .disabled(didLogAndAdvance)
            .opacity(didLogAndAdvance ? 0.6 : 1)
            .padding(.horizontal, 18)
            .padding(.top, 10)
            .padding(.bottom, 8)
            .background(.ultraThinMaterial.opacity(0.20))
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