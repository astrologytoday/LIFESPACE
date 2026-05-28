import SwiftUI

struct TarotStudyView: View {
    @EnvironmentObject var navModel: NavigationModel

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

            ScrollView {
                VStack(spacing: 24) {
                    Spacer(minLength: 20)

                    Text("Tarot Study")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .white.opacity(0.7), radius: 10)
                        .frame(maxWidth: .infinity, alignment: .center)

                    tarotLink(title: "Full Deck", destination: "FullDeckView")
                    tarotLink(title: "Major Arcana", destination: "MajorArcanaView")
                    tarotLink(title: "Minor Arcana", destination: "MinorArcanaView")
                    tarotLink(title: "Royal Cards", destination: "RoyalsView")
                    tarotLink(title: "Swords Cards", destination: "SwordsView")
                    tarotLink(title: "Cups Cards", destination: "CupsView")
                    tarotLink(title: "Wands Cards", destination: "WandsView")
                    tarotLink(title: "Pentacles Cards", destination: "PentaclesView")

                    HStack {
                        Spacer()
                        Button(action: {
                            navModel.pop()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 28, weight: .medium))
                                .foregroundColor(.white)
                                .padding(24)
                                .background(Color.white.opacity(0.2))
                                .clipShape(Circle())
                                .shadow(radius: 8)
                        }
                        Spacer()
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 30)
                }
                .padding(.horizontal)
            }
        }
    }

    func tarotLink(title: String, destination: String) -> some View {
        Button(action: {
            navModel.push(destination)
        }) {
            Text(title)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white.opacity(0.15))
                .cornerRadius(12)
        }
    }
}

