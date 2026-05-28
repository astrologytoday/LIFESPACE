//
//  TarotCardModel.swift
//  LIFESPACE
//
//  Created by Mario Sbardella on 2025-11-14.
//

import Foundation

struct TarotCard: Identifiable {
    let id = UUID()
    let name: String        // "The Fool"
    let image: String       // "tarot_fool"
    let meaning: String     // meaning text
}
