import Foundation
import AVFoundation

@MainActor
class MusicPlayerModel: ObservableObject {
    @Published var isPlaying: Bool = false
    @Published var currentTrack: String? = nil

    private var player: AVAudioPlayer?

    init() {
        // Do NOT activate .playback here.
        // This prevents LIFESPACE from stopping Spotify / Apple Music when the app opens.
        AudioSessionManager.shared.allowBackgroundMusic()
    }

    // MARK: - Play Selected Track

    func play(track: String) {
        // LIFESPACE should only take over audio when the user intentionally plays app audio.
        AudioSessionManager.shared.activateAppMusicPlayback()

        guard track != currentTrack else {
            // If tapping the same track again, just resume.
            player?.play()
            isPlaying = true
            return
        }

        currentTrack = track

        if let url = Bundle.main.url(forResource: track, withExtension: nil) {
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.numberOfLoops = -1 // loop forever
                player?.prepareToPlay()
                player?.play()
                isPlaying = true
            } catch {
                print("Error loading \(track):", error)
                isPlaying = false
            }
        } else {
            print("Could not find track in bundle:", track)
            isPlaying = false
        }
    }

    // MARK: - Pause Playback

    func pause() {
        player?.pause()
        isPlaying = false

        // Give audio control back to Spotify / Apple Music / podcasts.
        AudioSessionManager.shared.stopAppMusicPlayback()
    }

    // MARK: - Stop Playback

    func stop() {
        player?.stop()
        player?.currentTime = 0
        isPlaying = false

        // Give audio control back to Spotify / Apple Music / podcasts.
        AudioSessionManager.shared.stopAppMusicPlayback()
    }

    // MARK: - Toggle Playback

    func toggle(track: String) {
        if isPlaying && currentTrack == track {
            pause()
        } else {
            play(track: track)
        }
    }
}
