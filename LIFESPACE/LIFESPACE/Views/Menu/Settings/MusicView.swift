import SwiftUI

struct MusicView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var musicPlayer: MusicPlayerModel

    let tracks = [
        "432Hz.mp3",
        "528Hz.mp3",
        "963Hz.mp3"
    ]

    var body: some View {
        ZStack {
            // Teal Gradient Background
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

                Text("MUSIC PLAYER")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 40)
                    .opacity(0.95)

                ForEach(tracks, id: \.self) { track in
                    Button(action: {
                        musicPlayer.play(track: track)
                    }) {
                        Text(track.replacingOccurrences(of: ".mp3", with: ""))
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white.opacity(0.15))
                            .cornerRadius(14)
                    }
                }

                Button(action: {
                    musicPlayer.stop()
                }) {
                    Text("STOP MUSIC")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.3))
                        .cornerRadius(14)
                }

                // ✅ Spacer between STOP and the navigation buttons
                Spacer()
                    .frame(height: 24)

                // ✅ Centered Back + Home row
                HStack(spacing: 14) {
                    Button {
                        navModel.pop()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Circle())
                    }

                    Button {
                        navModel.push("HomeView")
                    } label: {
                        Image(systemName: "house.fill")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Circle())
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 10)

                Spacer()
            }
            .padding()
        }
    }
}
