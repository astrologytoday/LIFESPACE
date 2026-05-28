//
//  WordSearchView.swift
//  LIFESPACE
//
//  Created by Mario Sbardella on 2025-12-21.
//

import SwiftUI

struct WordSearchView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var lifespaceLogModel: LifespaceLogModel

    @AppStorage("wordSearch_stateJSON") private var stateJSON: String = ""

    @State private var puzzle: WordSearchPuzzle?
    @State private var foundWords: Set<String> = []
    @State private var didLogReward: Bool = false

    @State private var dragStart: GridPoint?
    @State private var dragCurrent: GridPoint?
    @State private var selection: [GridPoint] = []

    @State private var showCompletePopup: Bool = false
    @State private var shimmerOn: Bool = false
    @State private var showResetConfirm: Bool = false

    struct WordSearchPersistentState: Codable {
        var puzzle: WordSearchPuzzle
        var found: [String]
        var didLogReward: Bool
    }

    var body: some View {
        ZStack {
            // 🌊 LIFESPACE gradient background
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
                Text("Word Search")
                    .font(.system(size: 42, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(radius: 4)
                    .padding(.top, 10)

                if let puzzle {
                    WordSearchGrid(
                        puzzle: puzzle,
                        foundWords: foundWords,
                        selection: selection,
                        onSelectionEnded: { selectedPoints in
                            handleSelection(points: selectedPoints, puzzle: puzzle)
                        },
                        onDragStateChanged: { start, current, points in
                            dragStart = start
                            dragCurrent = current
                            selection = points
                        }
                    )
                    .frame(maxWidth: 380)
                    .aspectRatio(1, contentMode: .fit)
                    .padding(.horizontal, 18)

                    WordBankCard(words: puzzle.words, foundWords: foundWords)
                        .padding(.horizontal, 18)

                } else {
                    ProgressView()
                        .tint(.white)
                        .scaleEffect(1.2)
                        .padding(.top, 40)
                }

                Spacer()

                // Bottom nav buttons
                HStack(spacing: 18) {
                    Button {
                        navModel.pop()
                    } label: {
                        Circle()
                            .fill(Color.white.opacity(0.20))
                            .overlay(
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                            )
                            .frame(width: 54, height: 54)
                            .shadow(radius: 4)
                    }

                    Button {
                        navModel.push("HomeView")
                    } label: {
                        Circle()
                            .fill(Color.white.opacity(0.20))
                            .overlay(
                                Image(systemName: "house.fill")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                            )
                            .frame(width: 54, height: 54)
                            .shadow(radius: 4)
                    }
                }
                .padding(.bottom, 18)
            }

            // ⭐ Temp reset button (top-right)
            VStack {
                HStack {
                    Spacer()
                    Button {
                        showResetConfirm = true
                    } label: {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.white.opacity(0.20))
                            .clipShape(Circle())
                    }
                    .padding(.trailing, 14)
                    .padding(.top, 10)
                }
                Spacer()
            }

            // ✅ LIFESPACE-style reset confirm popup
            if showResetConfirm {
                resetConfirmPopup
            }

            if showCompletePopup {
                completionPopup
            }
        }
        .onAppear {
            loadOrCreate()
        }
        .onChange(of: foundWords) { _ in
            saveState()
        }
        .onChange(of: didLogReward) { _ in
            saveState()
        }
        .onChange(of: puzzle) { _ in
            saveState()
        }
    }

    // MARK: - Completion Popup

    private var completionPopup: some View {
        ZStack {
            Color.black.opacity(0.48)
                .ignoresSafeArea()

            VStack(spacing: 14) {
                Text("Word Search Complete!")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(radius: 6)

                Text("+1 Activity")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(Color(red: 0.75, green: 1.00, blue: 0.85))
                    .shadow(color: Color(red: 0.75, green: 1.00, blue: 0.85).opacity(0.75), radius: 10)

                Button {
                    newPuzzle()
                    showCompletePopup = false
                } label: {
                    Text("NEW PUZZLE")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.22))
                        .cornerRadius(14)
                }
            }
            .padding(18)
            .frame(maxWidth: 340)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 22)
                        .fill(Color.white.opacity(0.24))
                        .overlay(
                            RoundedRectangle(cornerRadius: 22)
                                .stroke(Color.white.opacity(0.30), lineWidth: 1)
                        )

                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0.0),
                                    Color.white.opacity(0.22),
                                    Color.white.opacity(0.0)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .rotationEffect(.degrees(22))
                        .offset(x: shimmerOn ? 240 : -240)
                        .animation(.easeInOut(duration: 1.3).repeatForever(autoreverses: false), value: shimmerOn)
                        .mask(RoundedRectangle(cornerRadius: 22))
                }
            )
            .shadow(radius: 18)
            .onAppear { shimmerOn = true }
        }
    }

    // MARK: - Reset Confirm Popup (LIFESPACE-style)

    private var resetConfirmPopup: some View {
        ZStack {
            Color.black.opacity(0.48)
                .ignoresSafeArea()

            VStack(spacing: 14) {
                Text("NEW PUZZLE")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(radius: 6)

                Text("Do you want to start a new puzzle?")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white.opacity(0.92))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 6)

                HStack(spacing: 12) {
                    Button {
                        showResetConfirm = false
                        stateJSON = ""
                        newPuzzle()
                        showCompletePopup = false
                    } label: {
                        Text("YES")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.22))
                            .cornerRadius(14)
                    }

                    Button {
                        showResetConfirm = false
                    } label: {
                        Text("NO")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.14))
                            .cornerRadius(14)
                    }
                }
            }
            .padding(18)
            .frame(maxWidth: 340)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 22)
                        .fill(Color.white.opacity(0.24))
                        .overlay(
                            RoundedRectangle(cornerRadius: 22)
                                .stroke(Color.white.opacity(0.30), lineWidth: 1)
                        )

                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0.0),
                                    Color.white.opacity(0.18),
                                    Color.white.opacity(0.0)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .rotationEffect(.degrees(22))
                        .offset(x: shimmerOn ? 240 : -240)
                        .animation(.easeInOut(duration: 1.3).repeatForever(autoreverses: false), value: shimmerOn)
                        .mask(RoundedRectangle(cornerRadius: 22))
                }
            )
            .shadow(radius: 18)
            .onAppear { shimmerOn = true }
        }
    }

    // MARK: - Selection handling

    private func handleSelection(points: [GridPoint], puzzle: WordSearchPuzzle) {
        dragStart = nil
        dragCurrent = nil
        selection = []

        guard !points.isEmpty else { return }
        let candidate = points.map { puzzle.letter(at: $0.r, $0.c) }
        let candidateStr = String(candidate).uppercased()
        let reversed = String(candidateStr.reversed())

        let targets = Set(puzzle.words.map { $0.uppercased() })

        var matched: String?
        if targets.contains(candidateStr) { matched = candidateStr }
        else if targets.contains(reversed) { matched = reversed }

        guard let word = matched else { return }
        guard !foundWords.contains(word) else { return }

        foundWords.insert(word)

        // Haptic on find
        let gen = UIImpactFeedbackGenerator(style: .light)
        gen.impactOccurred()

        if let p = self.puzzle, foundWords.count == p.words.count {
            onPuzzleCompleteIfNeeded()
        }
    }

    private func onPuzzleCompleteIfNeeded() {
        guard !didLogReward else {
            showCompletePopup = true
            return
        }

        didLogReward = true
        showCompletePopup = true

        lifespaceLogModel.addEntry(
            LifespaceLogEntry(
                type: .lifespace,
                module: .activity,
                questionCount: 1,
                yesCount: 1
            )
        )
    }

    // MARK: - Persistence

    private func loadOrCreate() {
        if let loaded = decodeState() {
            puzzle = loaded.puzzle
            foundWords = Set(loaded.found)
            didLogReward = loaded.didLogReward

            // ✅ If it's already complete, bring the popup back
            if foundWords.count == loaded.puzzle.words.count {
                showCompletePopup = true
            }
            return
        }
        newPuzzle()
    }

    private func newPuzzle() {
        let fresh = WordSearchGenerator.generate(size: 10, wordCount: 16)
        puzzle = fresh
        foundWords = []
        didLogReward = false
        showCompletePopup = false
        showResetConfirm = false
        saveState()
    }

    private func saveState() {
        guard let puzzle else { return }
        let state = WordSearchPersistentState(puzzle: puzzle, found: Array(foundWords), didLogReward: didLogReward)
        do {
            let data = try JSONEncoder().encode(state)
            stateJSON = String(data: data, encoding: .utf8) ?? ""
        } catch {
            // If save fails, keep going
        }
    }

    private func decodeState() -> WordSearchPersistentState? {
        guard !stateJSON.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return nil }
        guard let data = stateJSON.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(WordSearchPersistentState.self, from: data)
    }
}

// MARK: - Grid

private struct WordSearchGrid: View {
    let puzzle: WordSearchPuzzle
    let foundWords: Set<String>
    let selection: [GridPoint]

    var onSelectionEnded: ([GridPoint]) -> Void
    var onDragStateChanged: (_ start: GridPoint?, _ current: GridPoint?, _ points: [GridPoint]) -> Void

    private let gridPadding: CGFloat = 10

    var body: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)
            let cell = (size - gridPadding * 2) / CGFloat(puzzle.size)

            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.white.opacity(0.16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color.white.opacity(0.25), lineWidth: 1)
                    )

                // Found capsules
                let placedMap = puzzle.placedWordMap()
                ForEach(puzzle.words, id: \.self) { w in
                    if foundWords.contains(w), let pw = placedMap[w] {
                        CapsuleOverlay(
                            start: pw.start,
                            end: pw.end,
                            cellSize: cell,
                            padding: gridPadding,
                            glow: true,
                            isSelection: false
                        )
                        .transition(.opacity.combined(with: .scale))
                        .animation(.easeInOut(duration: 0.25), value: foundWords)
                    }
                }

                // Current selection capsule (subtle)
                if let selStart = selection.first, let selEnd = selection.last, selection.count >= 2 {
                    CapsuleOverlay(
                        start: selStart,
                        end: selEnd,
                        cellSize: cell,
                        padding: gridPadding,
                        glow: false,
                        isSelection: true
                    )
                    .animation(.easeInOut(duration: 0.08), value: selection)
                }

                // Letters
                ForEach(0..<puzzle.size, id: \.self) { r in
                    ForEach(0..<puzzle.size, id: \.self) { c in
                        let ch = puzzle.letter(at: r, c)
                        Text(String(ch))
                            .font(.custom("Avenir", size: cell * 0.55))
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .shadow(radius: 1.5)
                            .frame(width: cell, height: cell)
                            .position(
                                x: gridPadding + cell * (CGFloat(c) + 0.5),
                                y: gridPadding + cell * (CGFloat(r) + 0.5)
                            )
                    }
                }
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let startPoint = gridPoint(from: value.startLocation, cell: cell, padding: gridPadding, size: puzzle.size)
                        let currentPoint = gridPoint(from: value.location, cell: cell, padding: gridPadding, size: puzzle.size)

                        guard let s = startPoint, let cur = currentPoint else {
                            onDragStateChanged(nil, nil, [])
                            return
                        }

                        let pts = snappedPath(from: s, to: cur)
                        onDragStateChanged(s, cur, pts)
                    }
                    .onEnded { _ in
                        onSelectionEnded(selection)
                        onDragStateChanged(nil, nil, [])
                    }
            )
        }
    }

    private func gridPoint(from loc: CGPoint, cell: CGFloat, padding: CGFloat, size: Int) -> GridPoint? {
        let x = loc.x - padding
        let y = loc.y - padding
        guard x >= 0, y >= 0 else { return nil }

        let c = Int(x / cell)
        let r = Int(y / cell)

        guard r >= 0, r < size, c >= 0, c < size else { return nil }
        return GridPoint(r: r, c: c)
    }

    // Snaps to horizontal, vertical, or diagonal (approx-friendly)
    private func snappedPath(from start: GridPoint, to end: GridPoint) -> [GridPoint] {
        let dr = end.r - start.r
        let dc = end.c - start.c
        if dr == 0 && dc == 0 { return [start] }

        let adr = abs(dr)
        let adc = abs(dc)

        var stepR = 0
        var stepC = 0
        var length = 0

        if adr == 0 {
            stepC = dc > 0 ? 1 : -1
            length = adc
        } else if adc == 0 {
            stepR = dr > 0 ? 1 : -1
            length = adr
        } else {
            let ratio = Double(adr) / Double(adc)
            if ratio > 1.5 {
                stepR = dr > 0 ? 1 : -1
                length = adr
            } else if ratio < 0.67 {
                stepC = dc > 0 ? 1 : -1
                length = adc
            } else {
                stepR = dr > 0 ? 1 : -1
                stepC = dc > 0 ? 1 : -1
                length = min(adr, adc)
            }
        }

        var pts: [GridPoint] = []
        pts.reserveCapacity(length + 1)
        for i in 0...length {
            pts.append(GridPoint(r: start.r + stepR * i, c: start.c + stepC * i))
        }
        return pts
    }
}

private struct CapsuleOverlay: View {
    let start: GridPoint
    let end: GridPoint
    let cellSize: CGFloat
    let padding: CGFloat
    let glow: Bool
    let isSelection: Bool

    var body: some View {
        let startCenter = CGPoint(
            x: padding + cellSize * (CGFloat(start.c) + 0.5),
            y: padding + cellSize * (CGFloat(start.r) + 0.5)
        )
        let endCenter = CGPoint(
            x: padding + cellSize * (CGFloat(end.c) + 0.5),
            y: padding + cellSize * (CGFloat(end.r) + 0.5)
        )

        let dx = endCenter.x - startCenter.x
        let dy = endCenter.y - startCenter.y
        let dist = max(1, sqrt(dx*dx + dy*dy)) + cellSize * 0.65
        let angle = Angle(radians: Double(atan2(dy, dx)))

        return Capsule()
            .fill(
                isSelection
                ? Color.white.opacity(0.16)
                : Color(red: 0.55, green: 1.00, blue: 0.72).opacity(0.28)
            )
            .overlay(
                Capsule().stroke(
                    isSelection
                    ? Color.white.opacity(0.22)
                    : Color(red: 0.55, green: 1.00, blue: 0.72).opacity(0.65),
                    lineWidth: 2
                )
            )
            .frame(width: dist, height: cellSize * 0.78)
            .rotationEffect(angle)
            .position(x: (startCenter.x + endCenter.x) / 2, y: (startCenter.y + endCenter.y) / 2)
            .shadow(color: glow ? Color(red: 0.55, green: 1.00, blue: 0.72).opacity(0.7) : .clear, radius: glow ? 10 : 0)
    }
}

// MARK: - Word Bank Card

private struct WordBankCard: View {
    let words: [String]
    let foundWords: Set<String>

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Word Bank")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .shadow(radius: 2)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                ForEach(words, id: \.self) { w in
                    Text(w)
                        .font(.custom("Avenir", size: 16))
                        .fontWeight(.bold)
                        .foregroundColor(.white.opacity(foundWords.contains(w) ? 0.55 : 1.0))
                        .strikethrough(foundWords.contains(w), color: .white.opacity(0.8))
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                }
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.14))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.white.opacity(0.22), lineWidth: 1)
                )
        )
        .shadow(radius: 10)
    }
}
