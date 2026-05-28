import SwiftUI

struct LifestyleSurveyQuestionView: View {
    let questionCount: Int

    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var lifespaceLogModel: LifespaceLogModel
    @AppStorage("lifestyleSurveyLastCompletedDate") private var lifestyleSurveyLastCompletedDate: String = ""

    @State private var shuffledQuestions: [SurveyQuestion] = []

    var body: some View {
        ZStack {
            // 🌊 LIFESPACE Gradient
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
                Text("Lifestyle Survey")
                    .font(.largeTitle)
                    .foregroundColor(.white)

                ScrollView {
                    Text("Answer each question based on the last 24 hours unless specified otherwise.")
                        .font(.custom("Avenir", size: 17))
                        .foregroundColor(.white.opacity(0.85))
                        .padding(.horizontal, 12)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 24)

                    VStack(alignment: .leading, spacing: 30) {
                        ForEach(shuffledQuestions.indices, id: \.self) { i in
                            VStack(alignment: .leading, spacing: 12) {
                                Text(shuffledQuestions[i].text)
                                    .foregroundColor(.white)
                                    .font(.headline)

                                HStack(spacing: 20) {
                                    Button(action: {
                                        shuffledQuestions[i].answer = true
                                    }) {
                                        Text("YES")
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 24)
                                            .padding(.vertical, 10)
                                            .background(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .fill(shuffledQuestions[i].answer == true ? Color.green.opacity(0.6) : Color.white.opacity(0.2))
                                            )
                                    }

                                    Button(action: {
                                        shuffledQuestions[i].answer = false
                                    }) {
                                        Text("NO")
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 24)
                                            .padding(.vertical, 10)
                                            .background(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .fill(shuffledQuestions[i].answer == false ? Color.red.opacity(0.6) : Color.white.opacity(0.2))
                                            )
                                    }
                                }
                            }
                        }
                    }
                    .padding(.bottom, 20)
                }

                HStack(spacing: 20) {
                    Button(action: {
                        // Set today's date as completed before showing results
                        lifestyleSurveyLastCompletedDate = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
                        navModel.push("LoadingView")
                        logSurveyResults()
                    }) {
                        Text("Go to Results")
                            .font(.custom("Avenir", size: 18))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .opacity(allQuestionsAnswered() ? 1.0 : 0.5)
                            .cornerRadius(10)
                    }
                    .disabled(!allQuestionsAnswered())
                    .opacity(allQuestionsAnswered() ? 1.0 : 0.5)

                    Button(action: {
                        navModel.push("HomeView")
                    }) {
                        Image(systemName: "house.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(12)
                            .background(tealGradient)
                            .cornerRadius(10)
                    }
                }
                .padding(.bottom, 20)
            }
            .padding()
            .onAppear {
                generateShuffledQuestions()
            }
        }
    }

    private var tealGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.35, green: 0.80, blue: 0.75),
                Color(red: 0.20, green: 0.65, blue: 0.60),
                Color(red: 0.10, green: 0.45, blue: 0.45)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private func generateShuffledQuestions() {
        let perModule = max(1, questionCount / LifespaceModule.allCases.count)
        var all: [SurveyQuestion] = []

        for module in LifespaceModule.allCases {
            if let pool = questionBankByModule[module] {
                let selected = pool.shuffled().prefix(perModule)
                let invertedSet = invertedQuestionsByModule[module] ?? []

                all += selected.map { text in
                    SurveyQuestion(
                        module: module,
                        text: text,
                        invertScoring: invertedSet.contains(text)
                    )
                }
            }
        }

        shuffledQuestions = all.shuffled()
    }

    private func logSurveyResults() {
        let grouped = Dictionary(grouping: shuffledQuestions.filter { $0.answer != nil }) { $0.module }

        for (module, questions) in grouped {

            let yesCount = questions.filter { question in
                if question.invertScoring {
                    return question.answer == false   // NO is positive
                } else {
                    return question.answer == true    // YES is positive
                }
            }.count

            lifespaceLogModel.addEntry(
                LifespaceLogEntry(
                    type: .lifestyleSurvey,
                    module: module,
                    questionCount: questions.count,
                    yesCount: yesCount
                )
            )
        }
    }

    private func allQuestionsAnswered() -> Bool {
        shuffledQuestions.allSatisfy { $0.answer != nil }
    }
}

// MARK: - Question Struct

struct SurveyQuestion: Identifiable {
    let id = UUID()
    let module: LifespaceModule
    let text: String
    var answer: Bool? = nil
    var invertScoring: Bool = false
}

