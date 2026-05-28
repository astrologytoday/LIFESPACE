//
//  AudioSessionManager.swift
//  LIFESPACE
//
//  Created by Mario Sbardella on 2026-05-18.
//


import AVFoundation

final class AudioSessionManager {

    static let shared = AudioSessionManager()

    private init() {}

    // MARK: - App Launch / Normal App Use

    /// Allows Spotify, Apple Music, podcasts, etc. to keep playing
    /// while the user opens and browses LIFESPACE.
    func allowBackgroundMusic() {
        do {
            try AVAudioSession.sharedInstance().setCategory(
                .ambient,
                mode: .default,
                options: [.mixWithOthers]
            )

            try AVAudioSession.sharedInstance().setActive(
                false,
                options: .notifyOthersOnDeactivation
            )

            print("AudioSessionManager: Background music allowed.")
        } catch {
            print("AudioSessionManager: Failed to allow background music: \(error)")
        }
    }

    // MARK: - LIFESPACE Music Player

    /// Use this only when the user intentionally plays audio
    /// from the LIFESPACE music player.
    /// This lets LIFESPACE audio take over and pause Spotify.
    func activateAppMusicPlayback() {
        do {
            try AVAudioSession.sharedInstance().setCategory(
                .playback,
                mode: .default,
                options: []
            )

            try AVAudioSession.sharedInstance().setActive(true)

            print("AudioSessionManager: App music playback activated.")
        } catch {
            print("AudioSessionManager: Failed to activate app music playback: \(error)")
        }
    }

    /// Use this when the LIFESPACE music player stops or pauses.
    /// This gives control back to Spotify / Apple Music / other audio apps.
    func stopAppMusicPlayback() {
        do {
            try AVAudioSession.sharedInstance().setActive(
                false,
                options: .notifyOthersOnDeactivation
            )

            try AVAudioSession.sharedInstance().setCategory(
                .ambient,
                mode: .default,
                options: [.mixWithOthers]
            )

            print("AudioSessionManager: App music playback stopped.")
        } catch {
            print("AudioSessionManager: Failed to stop app music playback: \(error)")
        }
    }
}