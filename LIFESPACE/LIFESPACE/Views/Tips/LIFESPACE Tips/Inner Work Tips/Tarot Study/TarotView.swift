import SwiftUI

struct TarotView: View {
    @EnvironmentObject var navModel: NavigationModel

    var body: some View {
        ZStack {
            // Background gradient
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
                VStack(alignment: .leading, spacing: 20) {
                    Spacer(minLength: 20)

                    // Title
                    Text("TAROT")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .white.opacity(0.28), radius: 10, x: 0, y: 0) // mystical glow
                        .shadow(color: .black.opacity(0.30), radius: 3, x: 0, y: 2)  // depth
                        .shadow(color: .white.opacity(0.7), radius: 10)              // your original title glow (optional)
                        .frame(maxWidth: .infinity, alignment: .center)


                    // Description text (same layout, mystical glow)
                    Group {
                        Text("For centuries, it has been used by magicians, occultists, and mystics for the purpose of divination and meditation. It is also a map for uncovering the various parts of the human psyche.")
                            .foregroundColor(.white)
                            .shadow(color: .white.opacity(0.28), radius: 10, x: 0, y: 0)
                            .shadow(color: .black.opacity(0.30), radius: 3, x: 0, y: 2)

                        Text("The exact origins of the Tarot are unclear. It has been claimed by some that the Tarot has existed since the time of the Ancient Egyptians and even earlier with its knowledge dating as far back as Atlantis.")
                            .foregroundColor(.white)
                            .shadow(color: .white.opacity(0.28), radius: 10, x: 0, y: 0)
                            .shadow(color: .black.opacity(0.30), radius: 3, x: 0, y: 2)

                        Text("It can be a very powerful tool for mind development.")
                            .foregroundColor(.white)
                            .shadow(color: .white.opacity(0.28), radius: 10, x: 0, y: 0)
                            .shadow(color: .black.opacity(0.30), radius: 3, x: 0, y: 2)
                    }
                    .padding(.horizontal)

                    // 🔮 Card image
                    Image("tarot_magician")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width * 0.4)
                        .shadow(radius: 15)
                        .cornerRadius(12)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)

                    // Study button
                    Button(action: {
                        navModel.push("TarotStudyView")
                    }) {
                        Text("Study Tarot Now")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.15))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)

                    // Back button (bottom)
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
            }
        }
    }
}
