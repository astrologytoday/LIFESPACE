//
//  WordSearchGenerator.swift
//  LIFESPACE
//
//  Created by Mario Sbardella on 2025-12-21.
//


import Foundation

struct WordSearchGenerator {

    static func generate(size: Int = 10, wordCount: Int = 8) -> WordSearchPuzzle {
        let all = WordBank.lifespaceWords
            .map { $0.uppercased() }
            .filter { !$0.isEmpty && $0.count <= size }

        // Safety: if bank is too small
        let targetCount = min(wordCount, all.count)

        // Try multiple full attempts to avoid rare dead-ends
        for _ in 0..<30 {
            if let puzzle = attempt(size: size, wordCount: targetCount, sourceWords: all) {
                return puzzle
            }
        }

        // Fallback: fewer words
        for fallbackCount in stride(from: max(3, targetCount - 1), through: 3, by: -1) {
            for _ in 0..<20 {
                if let puzzle = attempt(size: size, wordCount: fallbackCount, sourceWords: all) {
                    return puzzle
                }
            }
        }

        // Absolute fallback: empty-ish grid
        return WordSearchPuzzle(
            size: size,
            rows: randomFilledRows(size: size, grid: Array(repeating: Array(repeating: nil, count: size), count: size)),
            placed: [],
            createdAt: Date()
        )
    }

    // MARK: - Core attempt

    private static func attempt(size: Int, wordCount: Int, sourceWords: [String]) -> WordSearchPuzzle? {
        var grid: [[Character?]] = Array(repeating: Array(repeating: nil, count: size), count: size)

        var words = sourceWords.shuffled()
        words = Array(words.prefix(wordCount))

        // Shuffle placement order by length (longer first usually helps)
        words.sort { $0.count > $1.count }

        var placed: [PlacedWord] = []

        for word in words {
            guard let placement = place(word: word, in: &grid, size: size) else {
                return nil
            }
            placed.append(placement)
        }

        let rows = randomFilledRows(size: size, grid: grid)
        return WordSearchPuzzle(size: size, rows: rows, placed: placed, createdAt: Date())
    }

    private static func place(word: String, in grid: inout [[Character?]], size: Int) -> PlacedWord? {
        let upper = word.uppercased()

        // Sometimes place reversed letters for variety
        let lettersForward = Array(upper)
        let lettersReversed = Array(upper.reversed())
        let letters = Bool.random() ? lettersForward : lettersReversed

        // Try many random placements
        for _ in 0..<300 {
            let dir = WordDirection.allCases.randomElement() ?? .e

            let len = letters.count
            guard len > 0 else { continue }

            // Compute valid start range so end stays in bounds
            let dr = dir.dr
            let dc = dir.dc

            let rMin: Int
            let rMax: Int
            let cMin: Int
            let cMax: Int

            if dr == 1 {
                rMin = 0
                rMax = size - len
            } else if dr == -1 {
                rMin = len - 1
                rMax = size - 1
            } else {
                rMin = 0
                rMax = size - 1
            }

            if dc == 1 {
                cMin = 0
                cMax = size - len
            } else if dc == -1 {
                cMin = len - 1
                cMax = size - 1
            } else {
                cMin = 0
                cMax = size - 1
            }

            if rMin > rMax || cMin > cMax { continue }

            let startR = Int.random(in: rMin...rMax)
            let startC = Int.random(in: cMin...cMax)

            // Check collisions
            var ok = true
            var rr = startR
            var cc = startC

            for ch in letters {
                if let existing = grid[rr][cc], existing != ch {
                    ok = false
                    break
                }
                rr += dr
                cc += dc
            }
            if !ok { continue }

            // Place
            rr = startR
            cc = startC
            for ch in letters {
                grid[rr][cc] = ch
                rr += dr
                cc += dc
            }

            let endR = startR + dr * (len - 1)
            let endC = startC + dc * (len - 1)

            return PlacedWord(
                word: upper, // Word bank uses the original forward word
                start: GridPoint(r: startR, c: startC),
                end: GridPoint(r: endR, c: endC),
                direction: dir
            )
        }

        return nil
    }

    private static func randomFilledRows(size: Int, grid: [[Character?]]) -> [String] {
        let letters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        return (0..<size).map { r in
            var rowChars: [Character] = []
            rowChars.reserveCapacity(size)
            for c in 0..<size {
                if let ch = grid[r][c] {
                    rowChars.append(ch)
                } else {
                    rowChars.append(letters.randomElement() ?? "A")
                }
            }
            return String(rowChars)
        }
    }
}
