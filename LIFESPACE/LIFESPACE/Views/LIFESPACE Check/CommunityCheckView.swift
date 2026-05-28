import SwiftUI

struct CommunityCheckView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var lifespaceLog: LifespaceLogModel

    @State private var showTitle = false
    @State private var communityEngaged: Bool? = nil
    @State private var relationshipQuality: RelationshipQuality? = nil
    @State private var didLogAndAdvance = false

    private enum RelationshipQuality: String {
        case positive = "Positive"
        case negative = "Negative"
    }

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
                    VStack(spacing: 32) {
                        Text("COMMUNITY")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                            .padding(.horizontal, 24)
                            .opacity(showTitle ? 1 : 0)
                            .animation(.easeIn(duration: 1), value: showTitle)
                            .padding(.top, 48)

                        VStack(spacing: 30) {
                            VStack(spacing: 16) {
                                Text("Have you engaged with your community in the last 7 days?")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 24)
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)

                                HStack(spacing: 18) {
                                    boolButton(title: "Yes", selected: communityEngaged == true) {
                                        communityEngaged = true
                                        checkAutoAdvance()
                                    }

                                    boolButton(title: "No", selected: communityEngaged == false) {
                                        communityEngaged = false
                                        checkAutoAdvance()
                                    }
                                }
                                .padding(.horizontal, 24)
                            }

                            VStack(spacing: 16) {
                                Text("How are your relationships?")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 24)
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)

                                VStack(spacing: 14) {
                                    relationshipButton(title: "Mostly Positive", selected: relationshipQuality == .positive) {
                                        relationshipQuality = .positive
                                        checkAutoAdvance()
                                    }

                                    relationshipButton(title: "Mostly Negative", selected: relationshipQuality == .negative) {
                                        relationshipQuality = .negative
                                        checkAutoAdvance()
                                    }
                                }
                                .padding(.horizontal, 24)
                            }
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

    private func boolButton(title: String, selected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .frame(maxWidth: .infinity, minHeight: 48)
                .background(selected ? Color.white : Color.white.opacity(0.3))
                .foregroundColor(.black)
                .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }

    private func relationshipButton(title: String, selected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .lineLimit(2)
                .minimumScaleFactor(0.75)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(selected ? Color.white : Color.white.opacity(0.3))
                .foregroundColor(.black)
                .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }

    private func checkAutoAdvance() {
        guard let engaged = communityEngaged, let relationship = relationshipQuality else { return }
        guard !didLogAndAdvance else { return }
        didLogAndAdvance = true

        let yesCount = (engaged ? 1 : 0) + (relationship == .positive ? 1 : 0)

        lifespaceLog.addEntry(
            LifespaceLogEntry(
                type: .lifespace,
                module: .community,
                questionCount: 2,
                yesCount: yesCount
            )
        )

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeInOut(duration: 0.4)) {
                navModel.push("ExpressionCheckView")
            }
        }
    }
}