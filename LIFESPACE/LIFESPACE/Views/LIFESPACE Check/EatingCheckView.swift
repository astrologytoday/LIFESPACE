import SwiftUI

struct EatingCheckView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var lifespaceLog: LifespaceLogModel

    @State private var showTitle = false
    @State private var eatingHealthy: Bool? = nil
    @State private var eatingOnTime: Bool? = nil
    @State private var showInfoBubble = false
    @State private var didLogAndAdvance = false

    var body: some View {
        ZStack {
            // Background
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

                        Text("EATING")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                            .opacity(showTitle ? 1 : 0)
                            .animation(.easeIn(duration: 1), value: showTitle)

                        VStack(spacing: 30) {
                            // First question
                            QuestionToggle(
                                question: "Have you been eating healthy today?",
                                selection: $eatingHealthy
                            )

                            // Second question with info bubble
                            VStack(alignment: .leading, spacing: 10) {
                                HStack(alignment: .top, spacing: 8) {
                                    Text("Have you been eating at the correct times?")
                                        .foregroundColor(.white)
                                        .font(.headline)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(nil)
                                        .fixedSize(horizontal: false, vertical: true)

                                    Button {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            showInfoBubble.toggle()
                                        }
                                    } label: {
                                        Image(systemName: "questionmark.circle.fill")
                                            .foregroundColor(.white)
                                            .font(.headline)
                                    }
                                    .accessibilityLabel("Meal timing info")
                                }

                                HStack(spacing: 30) {
                                    AnswerButton(
                                        label: "Yes",
                                        isSelected: eatingOnTime == true
                                    ) {
                                        eatingOnTime = true
                                    }

                                    AnswerButton(
                                        label: "No",
                                        isSelected: eatingOnTime == false
                                    ) {
                                        eatingOnTime = false
                                    }
                                }

                                if showInfoBubble {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("🍽 Healthy Meal Timing:")
                                            .fontWeight(.semibold)
                                        Text("• BREAKFAST 5:00AM–9:00AM")
                                        Text("• LUNCH 11:00AM–2:00PM")
                                        Text("• DINNER 5:00PM–7:00PM")
                                    }
                                    .font(.footnote)
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Color.black.opacity(0.3))
                                    .cornerRadius(10)
                                    .transition(.opacity)
                                }
                            }
                        }
                        .padding(.horizontal, 6)

                        Spacer(minLength: 0)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    // ✅ Keeps your content centered on normal devices, but scrollable on smaller ones
                    .frame(minHeight: geo.size.height)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.4)) {
                showTitle = true
            }
        }
        .onChange(of: eatingHealthy) { _ in checkCompletion() }
        .onChange(of: eatingOnTime) { _ in checkCompletion() }
    }

    private func checkCompletion() {
        guard let healthy = eatingHealthy, let onTime = eatingOnTime else { return }
        guard !didLogAndAdvance else { return }
        didLogAndAdvance = true

        let yesCount = [healthy, onTime].filter { $0 }.count

        lifespaceLog.addEntry(
            LifespaceLogEntry(
                type: .lifespace,
                module: .eating,
                questionCount: 2,
                yesCount: yesCount
            )
        )

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeInOut(duration: 0.4)) {
                navModel.push("SensoryCheckView")
            }
        }
    }
}
