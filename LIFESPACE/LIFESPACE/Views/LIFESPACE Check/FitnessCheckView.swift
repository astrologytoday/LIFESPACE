import SwiftUI

struct FitnessCheckView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var lifespaceLog: LifespaceLogModel

    @State private var showTitle = false
    @State private var selected: String? = nil
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
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 40) {
                        Spacer(minLength: 0)

                        Text("FITNESS")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                            .opacity(showTitle ? 1 : 0)
                            .animation(.easeIn(duration: 1), value: showTitle)

                        Text("How long have you worked out today?")
                            .foregroundColor(.white)
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal)

                        VStack(spacing: 20) {
                            fitnessOption("30+ minutes", tag: "long")
                            fitnessOption("5–10 minutes", tag: "short")
                            fitnessOption("Not at all", tag: "none")
                        }

                        Spacer(minLength: 0)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    // ✅ Keeps layout vertically centered on normal devices,
                    // but still allows scrolling on smaller screens.
                    .frame(minHeight: geo.size.height)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.4)) {
                showTitle = true
            }
        }
    }

    // MARK: - Fitness Option Builder
    private func fitnessOption(_ label: String, tag: String) -> some View {
        Button(action: {
            guard selected == nil else { return }
            guard !didLogAndAdvance else { return }
            didLogAndAdvance = true

            withAnimation(.easeInOut(duration: 0.25)) {
                selected = tag
            }

            let yesCount = (tag == "none") ? 0 : 1

            lifespaceLog.addEntry(
                LifespaceLogEntry(
                    type: .lifespace,
                    module: .fitness,
                    questionCount: 1,
                    yesCount: yesCount
                )
            )

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.easeInOut(duration: 0.4)) {
                    navModel.push("EatingCheckView")
                }
            }
        }) {
            Text(label)
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.85)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    selected == tag ? Color.white.opacity(0.3) : Color.white.opacity(0.15)
                )
                .cornerRadius(14)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(selected == tag ? Color.white : Color.clear, lineWidth: 2)
                )
                .animation(.easeInOut(duration: 0.25), value: selected == tag)
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 30)
    }
}
