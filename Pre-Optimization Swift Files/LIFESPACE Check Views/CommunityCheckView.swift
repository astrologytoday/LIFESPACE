import SwiftUI

struct CommunityCheckView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var lifespaceLog: LifespaceLogModel

    @State private var communityEngaged: Bool? = nil
    @State private var relationshipQuality: String? = nil

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
                Text("COMMUNITY")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 60)

                Text("Have you engaged with your community in the last 7 days?")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                HStack(spacing: 30) {
                    Button(action: {
                        communityEngaged = true
                        checkAutoAdvance()
                    }) {
                        Text("Yes")
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(communityEngaged == true ? Color.white : Color.white.opacity(0.3))
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }

                    Button(action: {
                        communityEngaged = false
                        checkAutoAdvance()
                    }) {
                        Text("No")
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(communityEngaged == false ? Color.white : Color.white.opacity(0.3))
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }
                }

                Text("How are your relationships?")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top, 30)

                HStack(spacing: 30) {
                    Button(action: {
                        relationshipQuality = "Positive"
                        checkAutoAdvance()
                    }) {
                        Text("Mostly Positive")
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(relationshipQuality == "Positive" ? Color.white : Color.white.opacity(0.3))
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }

                    Button(action: {
                        relationshipQuality = "Negative"
                        checkAutoAdvance()
                    }) {
                        Text("Mostly Negative")
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(relationshipQuality == "Negative" ? Color.white : Color.white.opacity(0.3))
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }
                }

                Spacer()
            }
        }
    }

    private func checkAutoAdvance() {
        if let engaged = communityEngaged, let relationship = relationshipQuality {
            let yesCount = (engaged ? 1 : 0) + (relationship == "Positive" ? 1 : 0)

            lifespaceLog.addEntry(
                LifespaceLogEntry(
                    type: .lifespace,
                    module: .community,
                    questionCount: 2,
                    yesCount: yesCount
                )
            )

            navModel.push("ExpressionCheckView")
        }
    }
}

