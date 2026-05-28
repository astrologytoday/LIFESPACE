//
//  KeyboardUIView.swift
//  LIFESPACE
//
//  Created by Mario Sbardella on 2025-12-23.
//


import UIKit

final class KeyboardUIView: UIView {

    struct Key {
        let note: UInt8
        let isBlack: Bool
        var frame: CGRect
    }

    // Visual
    var whiteKeyCorner: CGFloat = 10
    var blackKeyCorner: CGFloat = 8

    // Callbacks
    var onNoteOn: ((UInt8) -> Void)?
    var onNoteOff: ((UInt8) -> Void)?

    // State
    private var keys: [Key] = []
    private var pressedNotes: Set<UInt8> = []
    private var touchToNote: [UITouch: UInt8] = [:]

    // Range: C3(48) -> C6(84) = 37 notes
    private let minNote: UInt8 = 48
    private let maxNote: UInt8 = 84

    override init(frame: CGRect) {
        super.init(frame: frame)
        isMultipleTouchEnabled = true
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        buildKeyFrames()
        setNeedsDisplay()
    }

    private func isBlackNote(_ midi: UInt8) -> Bool {
        // C# D# F# G# A# (1,3,6,8,10)
        let pc = Int(midi) % 12
        return pc == 1 || pc == 3 || pc == 6 || pc == 8 || pc == 10
    }

    private func buildKeyFrames() {
        keys.removeAll()

        // Compute white key count in range (22 whites)
        var whiteNotes: [UInt8] = []
        for n in minNote...maxNote where !isBlackNote(n) {
            whiteNotes.append(n)
        }

        let w = bounds.width
        let h = bounds.height
        let whiteCount = max(1, whiteNotes.count)
        let whiteW = w / CGFloat(whiteCount)

        // White keys frames
        var whiteIndexMap: [UInt8: Int] = [:]
        for (i, n) in whiteNotes.enumerated() {
            let x = CGFloat(i) * whiteW
            let f = CGRect(x: x, y: 0, width: whiteW, height: h)
            keys.append(Key(note: n, isBlack: false, frame: f))
            whiteIndexMap[n] = i
        }

        // Black keys: overlay shorter keys
        let blackH = h * 0.62
        let blackW = whiteW * 0.62

        // For each black note, position it between adjacent whites.
        for n in minNote...maxNote where isBlackNote(n) {
            // black note sits between the previous and next white notes
            // find nearest previous white in range
            var prev: UInt8? = nil
            var next: UInt8? = nil

            var p = n
            while p > minNote {
                p -= 1
                if !isBlackNote(p) { prev = p; break }
            }
            var q = n
            while q < maxNote {
                q += 1
                if !isBlackNote(q) { next = q; break }
            }

            guard let prevW = prev, let nextW = next,
                  let prevIndex = whiteIndexMap[prevW],
                  let nextIndex = whiteIndexMap[nextW] else { continue }

            let leftX = CGFloat(prevIndex) * whiteW
            let rightX = CGFloat(nextIndex) * whiteW
            let centerX = (leftX + rightX) / 2.0

            let x = centerX - (blackW / 2.0)
            let f = CGRect(x: x, y: 0, width: blackW, height: blackH)
            keys.append(Key(note: n, isBlack: true, frame: f))
        }

        // Draw order matters: whites first, blacks later (so hit-testing checks blacks first)
        keys.sort { (a, b) in
            if a.isBlack != b.isBlack { return a.isBlack == false } // whites first
            return a.note < b.note
        }
    }

    private func hitTestNote(at point: CGPoint) -> UInt8? {
        // Check black keys first for accuracy
        let blackKeys = keys.filter { $0.isBlack }
        for k in blackKeys where k.frame.contains(point) { return k.note }

        let whiteKeys = keys.filter { !$0.isBlack }
        for k in whiteKeys where k.frame.contains(point) { return k.note }

        return nil
    }

    private func press(_ note: UInt8) {
        guard !pressedNotes.contains(note) else { return }
        pressedNotes.insert(note)
        onNoteOn?(note)
        setNeedsDisplay()
    }

    private func release(_ note: UInt8) {
        guard pressedNotes.contains(note) else { return }
        pressedNotes.remove(note)
        onNoteOff?(note)
        setNeedsDisplay()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let pt = t.location(in: self)
            if let note = hitTestNote(at: pt) {
                touchToNote[t] = note
                press(note)
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let pt = t.location(in: self)
            let oldNote = touchToNote[t]
            let newNote = hitTestNote(at: pt)

            if newNote != oldNote {
                if let old = oldNote { release(old) }
                if let newN = newNote {
                    touchToNote[t] = newN
                    press(newN)
                } else {
                    touchToNote[t] = nil
                }
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            if let note = touchToNote[t] {
                release(note)
                touchToNote[t] = nil
            }
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }

    func panicReleaseAll() {
        for n in pressedNotes { onNoteOff?(n) }
        pressedNotes.removeAll()
        touchToNote.removeAll()
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }

        // Draw whites
        for k in keys where !k.isBlack {
            let path = UIBezierPath(roundedRect: k.frame.insetBy(dx: 1, dy: 1), cornerRadius: whiteKeyCorner)
            let pressed = pressedNotes.contains(k.note)
            ctx.setFillColor((pressed ? UIColor(white: 0.80, alpha: 1.0) : UIColor.white).cgColor)
            ctx.addPath(path.cgPath)
            ctx.fillPath()

            ctx.setStrokeColor(UIColor(white: 0.2, alpha: 0.25).cgColor)
            ctx.addPath(path.cgPath)
            ctx.strokePath()
        }

        // Draw blacks
        for k in keys where k.isBlack {
            let path = UIBezierPath(roundedRect: k.frame, cornerRadius: blackKeyCorner)
            let pressed = pressedNotes.contains(k.note)
            ctx.setFillColor((pressed ? UIColor(white: 0.25, alpha: 1.0) : UIColor(white: 0.08, alpha: 1.0)).cgColor)
            ctx.addPath(path.cgPath)
            ctx.fillPath()
        }
    }
}
