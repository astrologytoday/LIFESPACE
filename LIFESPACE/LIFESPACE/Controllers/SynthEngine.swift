import Foundation
import AVFoundation

final class SynthEngine: ObservableObject {

    private let engine = AVAudioEngine()
    private let sampler = AVAudioUnitSampler()

    @Published var isReady: Bool = false

    // Sustain amount: 0.0 = no sustain (immediate note off)
    // 1.0 = max sustain delay
    @Published var sustainAmount: Double = 0.35

    // 37 keys: C3 (48) to C6 (84)
    let minNote: UInt8 = 48
    let maxNote: UInt8 = 84

    // Max linger time when sustainAmount = 1.0
    private let maxSustainSeconds: Double = 3.0

    // For each note, store a pending stop task (so we can cancel it if the note is played again)
    private var pendingStop: [UInt8: DispatchWorkItem] = [:]

    func start() {
        guard !engine.isRunning else { return }

        // Helps avoid “silent” issues on device
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, options: [.mixWithOthers])
            try session.setActive(true)
        } catch {
            print("❌ Audio session error:", error)
        }

        engine.attach(sampler)
        engine.connect(sampler, to: engine.mainMixerNode, format: nil)

        do {
            try engine.start()
            isReady = true
        } catch {
            print("❌ Audio engine failed to start:", error)
            isReady = false
        }
    }

    func stop() {
        allNotesOff()
        engine.stop()
        isReady = false
    }

    func loadSoundFont(
        named filenameNoExt: String,
        preset: UInt8 = 0,
        bankMSB: UInt8 = UInt8(kAUSampler_DefaultMelodicBankMSB),
        bankLSB: UInt8 = 0
    ) {
        guard let url = Bundle.main.url(forResource: filenameNoExt, withExtension: "sf2") else {
            print("⚠️ SoundFont not found: \(filenameNoExt).sf2")
            return
        }
        do {
            try sampler.loadSoundBankInstrument(
                at: url,
                program: preset,
                bankMSB: bankMSB,
                bankLSB: bankLSB
            )
        } catch {
            print("❌ Failed to load SoundFont:", error)
        }
    }

    func noteOn(_ note: UInt8, velocity: UInt8 = 100) {
        guard isReady else { return }

        // If this note had a delayed stop scheduled, cancel it
        if let task = pendingStop[note] {
            task.cancel()
            pendingStop[note] = nil
        }

        sampler.startNote(note, withVelocity: velocity, onChannel: 0)
    }

    func noteOff(_ note: UInt8) {
        guard isReady else { return }

        // Cancel any existing pending stop (just in case)
        if let task = pendingStop[note] {
            task.cancel()
            pendingStop[note] = nil
        }

        let amt = max(0.0, min(1.0, sustainAmount))

        // No sustain = immediate stop
        if amt <= 0.001 {
            sampler.stopNote(note, onChannel: 0)
            return
        }

        // Sustain slider controls how long we delay stopping the note
        let delay = amt * maxSustainSeconds

        let task = DispatchWorkItem { [weak self] in
            guard let self else { return }
            self.sampler.stopNote(note, onChannel: 0)
            self.pendingStop[note] = nil
        }

        pendingStop[note] = task
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: task)
    }

    func allNotesOff() {
        // Cancel all pending stops
        for (_, task) in pendingStop {
            task.cancel()
        }
        pendingStop.removeAll()

        for n in minNote...maxNote {
            sampler.stopNote(n, onChannel: 0)
        }
    }
}
