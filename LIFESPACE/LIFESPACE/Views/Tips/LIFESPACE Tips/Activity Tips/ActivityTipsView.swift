import SwiftUI

struct ActivityTipsView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var appeared = false

    var body: some View {
        ZStack(alignment: .topLeading) {

            // 🌊 LIFESPACE gradient background
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

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {

                    // 🧠 Header
                    Text("Activity Tips")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(radius: 4)

                    // ✅ Subtitle
                    Text("To maintain your energy")
                        .font(.title3)
                        .italic()
                        .foregroundColor(Color.white.opacity(0.95))
                        .fixedSize(horizontal: false, vertical: true)

                    // ✅ Quick description
                    Text("In the LIFESPACE model, your Activity levels relate to rest and recreation. Sleep and fun activities are biological needs that restore energy and motivation, stabilize mood, and protect focus. Regular recovery supports dopamine balance and reduces stress load, which helps your brain stay resilient.")
                        .font(.custom("Avenir", size: 18))
                        .foregroundColor(.white.opacity(0.92))
                        .fixedSize(horizontal: false, vertical: true)

                    // ✅ Action Buttons
                    VStack(spacing: 12) {

                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                navModel.push("LIFESPACEGamesView")
                            }
                        }) {
                            HStack(spacing: 10) {
                                Image(systemName: "gamecontroller.fill")
                                    .font(.system(size: 18, weight: .bold))

                                Text("PLAY LIFESPACE GAMES")
                                    .font(.custom("Avenir", size: 18))
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.center)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .foregroundColor(.white)
                            .padding(.vertical, 14)
                            .padding(.horizontal, 10)
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.18))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white.opacity(0.25), lineWidth: 1)
                            )
                            .cornerRadius(16)
                            .shadow(radius: 6)
                        }

                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                navModel.push("SleepHygieneView")
                            }
                        }) {
                            HStack(spacing: 10) {
                                Image(systemName: "bed.double.fill")
                                    .font(.system(size: 18, weight: .bold))

                                Text("SLEEP HYGIENE CHECKLIST")
                                    .font(.custom("Avenir", size: 18))
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.center)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .foregroundColor(.white)
                            .padding(.vertical, 14)
                            .padding(.horizontal, 10)
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.18))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white.opacity(0.25), lineWidth: 1)
                            )
                            .cornerRadius(16)
                            .shadow(radius: 6)
                        }
                    }
                    .padding(.top, 2)

                    // 🎉 Fun section
                    VStack(alignment: .leading, spacing: 14) {
                        HStack(alignment: .firstTextBaseline, spacing: 10) {
                            Text("🎉")
                                .font(.system(size: 26))

                            Text("Ideas for Fun & Play")
                                .font(.system(size: 22, weight: .heavy))
                                .foregroundColor(.white)
                                .shadow(radius: 3)
                                .fixedSize(horizontal: false, vertical: true)
                        }

                        Text("Fun reduces stress, boosts dopamine, and reminds you that life is worth living. Even 15 minutes can change the tone of your whole day.")
                            .font(.custom("Avenir", size: 17))
                            .foregroundColor(.white.opacity(0.92))
                            .fixedSize(horizontal: false, vertical: true)

                        FunGrid()
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 22)
                            .fill(Color.black.opacity(0.20))
                            .overlay(
                                RoundedRectangle(cornerRadius: 22)
                                    .stroke(Color.white.opacity(0.18), lineWidth: 1)
                            )
                    )
                    .shadow(radius: 14)
                    .padding(.top, 6)

                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 24)
                .padding(.top, 64)
                .padding(.bottom, 160)
                .opacity(appeared ? 1 : 0)
                .animation(.easeInOut(duration: 0.6), value: appeared)
            }

            // ⬅️ Back Button
            BackButtonView(customTarget: "TipsView")
                .padding(.top, 12)
                .padding(.leading, 56)

            // 🏠 Home Button
            VStack {
                Spacer()
                HStack {
                    Spacer()

                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            navModel.push("HomeView")
                        }
                    }) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.white.opacity(0.9),
                                            Color.white.opacity(0.6)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 60, height: 60)
                                .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 6)

                            Image(systemName: "house.fill")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(Color(red: 0.10, green: 0.45, blue: 0.45))
                        }
                    }
                    .padding(.trailing, 22)
                    .padding(.bottom, 22)
                }
            }
        }
        .onAppear {
            appeared = true
        }
        .transition(.opacity)
    }
}

// MARK: - Dictionary Card
private struct DictionaryCard: View {
    let headword: String
    let partOfSpeech: String
    let definition: String

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.12))
                .blur(radius: 16)

            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.18))
                .overlay(
                    HStack(spacing: 0) {
                        Rectangle()
                            .fill(Color.white.opacity(0.55))
                            .frame(width: 3)
                            .padding(.vertical, 18)
                            .padding(.leading, 16)

                        Spacer()
                    }
                )
                .shadow(color: .black.opacity(0.18), radius: 12, x: 0, y: 8)

            VStack(alignment: .leading, spacing: 8) {
                Text(headword)
                    .font(.system(size: 28, weight: .semibold, design: .serif))
                    .foregroundColor(.white)

                Text(partOfSpeech)
                    .font(.system(size: 16, weight: .semibold, design: .serif))
                    .foregroundColor(Color.white.opacity(0.85))
                    .textCase(.lowercase)
                    .padding(.bottom, 6)

                Text(definition)
                    .font(.system(size: 18, weight: .regular, design: .serif))
                    .foregroundColor(Color.white.opacity(0.95))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 26)
        }
    }
}

// MARK: - Fun Grid
private struct FunGrid: View {

    private let items: [(icon: String, title: String, examples: String)] = [
        ("figure.walk", "Movement", "Sports, yoga, lifting, martial arts"),
        ("gamecontroller.fill", "Games", "Cards, puzzles, video games"),
        ("pawprint.fill", "Animals", "Pets, shelters, dog parks"),
        ("music.note", "Music & Dance", "Listen, play, freestyle"),
        ("tv.fill", "Shows & Movies", "Comfort shows, good films"),
        ("book.fill", "Reading", "Books, comics, graphic novels"),
        ("leaf.fill", "Outdoors", "Parks, trails, sunlight"),
        ("paintbrush.fill", "Creative", "Drawing, crafts, design")
    ]

    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        LazyVGrid(columns: columns, alignment: .center, spacing: 12) {
            ForEach(items.indices, id: \.self) { i in
                FunCard(
                    icon: items[i].icon,
                    title: items[i].title,
                    examples: items[i].examples
                )
            }
        }
        .padding(.top, 6)
    }
}

// MARK: - Fun Card
private struct FunCard: View {
    let icon: String
    let title: String
    let examples: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.14))
                    .frame(width: 38, height: 38)

                Image(systemName: icon)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
                    .minimumScaleFactor(0.8)
            }

            Text(title)
                .font(.system(size: 16.5, weight: .heavy))
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .allowsTightening(false)
                .minimumScaleFactor(1.0)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(examples)
                .font(.custom("Avenir", size: 14.5))
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .allowsTightening(false)
                .minimumScaleFactor(1.0)
                .frame(maxWidth: .infinity, alignment: .leading)

            Spacer(minLength: 0)
        }
        .padding(.top, 14)
        .padding(.horizontal, 14)
        .padding(.bottom, 14)
        .frame(maxWidth: .infinity, minHeight: 142, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.12))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.white.opacity(0.18), lineWidth: 1)
                )
        )
        .shadow(radius: 10)
    }
}
