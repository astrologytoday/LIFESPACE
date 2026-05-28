import SwiftUI

struct FitnessCheckView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var lifespaceLog: LifespaceLogModel

    @State private var showTitle = false
    @State private var selected: String? = nil

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

            VStack(spacing: 40) {
                Spacer()

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
                    .padding(.horizontal)

                VStack(spacing: 20) {
                    fitnessOption("30+ minutes", tag: "long")
                    fitnessOption("5–10 minutes", tag: "short")
                    fitnessOption("Not at all", tag: "none")
                }

                Spacer()
            }
            .padding()
        }
        .onAppear {
            withAnimation {
                showTitle = true
            }
        }
    }

    // MARK: - Fitness Option Builder
    func fitnessOption(_ label: String, tag: String) -> some View {
        Button(action: {
            guard selected == nil else { return }

            withAnimation {
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
                navModel.push("EatingCheckView")
            }
        }) {
            Text(label)
                .font(.headline)
                .foregroundColor(.white)
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
                .animation(.easeInOut(duration: 0.3), value: selected == tag)
        }
        .padding(.horizontal, 30)
    }
}

