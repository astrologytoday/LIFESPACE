//
//  WordSearchModel.swift
//  LIFESPACE
//
//  Created by Mario Sbardella on 2025-12-21.
//

import Foundation

struct GridPoint: Codable, Hashable {
    var r: Int
    var c: Int
}

enum WordDirection: String, Codable, CaseIterable {
    case e, w, s, n, se, nw, sw, ne

    var dr: Int {
        switch self {
        case .e, .w: return 0
        case .s, .se, .sw: return 1
        case .n, .ne, .nw: return -1
        }
    }

    var dc: Int {
        switch self {
        case .s, .n: return 0
        case .e, .se, .ne: return 1
        case .w, .sw, .nw: return -1
        }
    }
}

struct PlacedWord: Codable, Hashable {
    var word: String
    var start: GridPoint
    var end: GridPoint
    var direction: WordDirection

    func positions() -> [GridPoint] {
        let len = word.count
        guard len > 0 else { return [] }

        var pts: [GridPoint] = []
        pts.reserveCapacity(len)

        var r = start.r
        var c = start.c
        for _ in 0..<len {
            pts.append(GridPoint(r: r, c: c))
            r += direction.dr
            c += direction.dc
        }
        return pts
    }
}

struct WordSearchPuzzle: Codable, Equatable {
    let size: Int
    let rows: [String]        // Each row is length == size, uppercase letters
    let placed: [PlacedWord]
    let createdAt: Date

    var words: [String] { placed.map { $0.word } }

    func letter(at r: Int, _ c: Int) -> Character {
        let row = rows[r]
        let idx = row.index(row.startIndex, offsetBy: c)
        return row[idx]
    }

    func placedWordMap() -> [String: PlacedWord] {
        var dict: [String: PlacedWord] = [:]
        for pw in placed { dict[pw.word] = pw }
        return dict
    }
}
