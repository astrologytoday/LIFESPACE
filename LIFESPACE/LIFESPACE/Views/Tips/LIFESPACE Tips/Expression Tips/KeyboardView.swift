//
//  KeyboardView.swift
//  LIFESPACE
//
//  Created by Mario Sbardella on 2025-12-23.
//


import SwiftUI

struct KeyboardView: UIViewRepresentable {

    var onNoteOn: (UInt8) -> Void
    var onNoteOff: (UInt8) -> Void
    var onPanic: (() -> Void)? = nil

    func makeUIView(context: Context) -> KeyboardUIView {
        let v = KeyboardUIView()
        v.onNoteOn = onNoteOn
        v.onNoteOff = onNoteOff
        return v
    }

    func updateUIView(_ uiView: KeyboardUIView, context: Context) { }

    static func dismantleUIView(_ uiView: KeyboardUIView, coordinator: ()) {
        uiView.panicReleaseAll()
    }
}
