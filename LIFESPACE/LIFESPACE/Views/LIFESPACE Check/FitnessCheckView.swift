import SwiftUI

struct FitnessCheckView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var lifespaceLog: LifespaceLogModel

    @State private var showTitle = false
    @State private var selected: String? = nil
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
                ScrollView(showsIndicators: true) {
                    VStack(spacing: 28) {
                        Text("FITNESS")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                            .opacity(showTitle ? 1 : 0)
                            .animation(.easeIn(duration: 1), value: showTitle)
                            .padding(.top, 48)

                        Text("How long have you worked out today?")
                            .foregroundColor(.white)
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal, 24)

                        VStack(spacing: 18) {
                            fitnessOption("30+ minutes", tag: "long")
                            fitnessOption("5–10 minutes", tag: "short")
                            fitnessOption("Not at all", tag: "none")
                        }
                        .padding(.bottom, 44)
                    }
                    .padding(.vertical, 18)
                    .frame(maxWidth: .infinity)
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
                .minimumScaleFactor(0.8)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, minHeight: 50)
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(selected == tag ? Color.white.opacity(0.3) : Color.white.opacity(0.15))
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