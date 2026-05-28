
import SwiftUI

struct MusicCreativeView: View {

    @EnvironmentObject var navModel: NavigationModel
    @StateObject private var synth = SynthEngine()

    var body: some View {
        ZStack {
            // Use your standard teal gradient
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

            VStack(spacing: 14) {

                // Top bar
                HStack {
                    Button {
                        synth.allNotesOff()
                        dismissLandscapeWindow(to: "HomeView", navModel: navModel)
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(Color.black.opacity(0.25))
                            .clipShape(Capsule())
                    }

                    Spacer()

                    Text("SYNTHESIZER")
                        .font(.system(size: 26, weight: .heavy))
                        .foregroundColor(.white)
                        .shadow(radius: 4)

                    Spacer()

                    // Panic button
                    Button {
                        synth.allNotesOff()
                    } label: {
                        Image(systemName: "speaker.slash.fill")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(Color.black.opacity(0.25))
                            .clipShape(Capsule())
                    }
                }
                .padding(.horizontal, 18)
                .padding(.top, 10)

                // Small controls row
                HStack(spacing: 14) {
                    Text(synth.isReady ? "READY" : "LOADING...")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.black.opacity(0.18))
                        .clipShape(Capsule())

                    // ✅ Sustain Amount Slider (0 = no sustain, 1 = max sustain)
                    HStack(spacing: 10) {
                        Image(systemName: "waveform.path")
                            .foregroundColor(.white.opacity(0.9))

                        Text("SUSTAIN")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white.opacity(0.9))

                        Slider(
                            value: Binding(
                                get: { synth.sustainAmount },
                                set: { synth.sustainAmount = $0 }
                            ),
                            in: 0.0...1.0
                        )
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.black.opacity(0.18))
                    .clipShape(Capsule())

                    Spacer()
                }
                .padding(.horizontal, 18)

                // Keyboard
                KeyboardView(
                    onNoteOn: { note in
                        synth.noteOn(note, velocity: 105)
                    },
                    onNoteOff: { note in
                        synth.noteOff(note)
                    }
                )
                .frame(maxWidth: .infinity)
                .frame(height: 240)
                .padding(.horizontal, 18)
                .padding(.bottom, 14)
                .background(Color.black.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .padding(.horizontal, 18)

                Spacer(minLength: 0)
            }
        }
        .onAppear {
            synth.start()
            synth.loadSoundFont(named: "LIFESPACEGrand", preset: 0) // keep as requested
        }
        .onDisappear {
            synth.allNotesOff()
            synth.stop()
        }
    }
}
