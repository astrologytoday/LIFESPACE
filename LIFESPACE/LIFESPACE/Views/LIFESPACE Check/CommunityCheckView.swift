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

                        Text("COMMUNITY")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .opacity(showTitle ? 1 : 0)
                            .animation(.easeIn(duration: 1), value: showTitle)

                        VStack(spacing: 30) {
                            // Q1
                            VStack(spacing: 16) {
                                Text("Have you engaged with your community in the last 7 days?")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)

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
                                    .buttonStyle(.plain)

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
                                    .buttonStyle(.plain)
                                }
                            }

                            // Q2
                            VStack(spacing: 16) {
                                Text("How are your relationships?")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)

                                HStack(spacing: 30) {
                                    Button(action: {
                                        relationshipQuality = .positive
                                        checkAutoAdvance()
                                    }) {
                                        Text("Mostly Positive")
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 10)
                                            .background(relationshipQuality == .positive ? Color.white : Color.white.opacity(0.3))
                                            .foregroundColor(.black)
                                            .cornerRadius(10)
                                    }
                                    .buttonStyle(.plain)

                                    Button(action: {
                                        relationshipQuality = .negative
                                        checkAutoAdvance()
                                    }) {
                                        Text("Mostly Negative")
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 10)
                                            .background(relationshipQuality == .negative ? Color.white : Color.white.opacity(0.3))
                                            .foregroundColor(.black)
                                            .cornerRadius(10)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }

                        Spacer(minLength: 0)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    // ✅ keeps your layout centered on normal phones, but scrolls on smaller ones
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
