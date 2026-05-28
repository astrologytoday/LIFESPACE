//
//  CheckersView.swift
//  LIFESPACE
//
//  Updated: 2025-12-21
//

import SwiftUI
import UIKit

// MARK: - Models

private enum CheckersDifficulty: String, CaseIterable, Codable {
    case easy, medium, hard

    var title: String {
        switch self {
        case .easy: return "EASY"
        case .medium: return "MEDIUM"
        case .hard: return "HARD"
        }
    }
}

private enum CheckersTurn: String, Codable {
    case human
    case ai
}

private enum CheckersWinner: String, Codable {
    case none
    case human
    case ai
}

private struct CheckersPiece: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var r: Int
    var c: Int
    var isKing: Bool
    var isHuman: Bool
}

private struct CheckersMove: Hashable, Codable {
    var pieceID: UUID
    var fromR: Int
    var fromC: Int
    var toR: Int
    var toC: Int
    var capturedID: UUID? = nil
}

private struct CheckersPersistentState: Codable {
    var pieces: [CheckersPiece]
    var turn: CheckersTurn
    var difficulty: CheckersDifficulty
    var selectedPieceID: UUID?
    var didLogReward: Bool
    var winner: CheckersWinner

    // If a capture was made and more captures are available for that same piece,
    // force the chain to continue with this piece (only after the player chose to jump).
    var chainPieceID: UUID?
}

// Backward-compat decode (from older build that had forcedPieceID)
private struct CheckersPersistentStateV1: Codable {
    var pieces: [CheckersPiece]
    var turn: CheckersTurn
    var difficulty: CheckersDifficulty
    var selectedPieceID: UUID?
    var forcedPieceID: UUID?
    var didLogReward: Bool
    var winner: CheckersWinner
}

// MARK: - View

struct CheckersView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var lifespaceLogModel: LifespaceLogModel

    @AppStorage("checkers_stateJSON") private var stateJSON: String = ""

    @State private var pieces: [CheckersPiece] = []
    @State private var turn: CheckersTurn = .human
    @State private var difficulty: CheckersDifficulty = .easy

    @State private var selectedPieceID: UUID? = nil
    @State private var didLogReward: Bool = false
    @State private var winner: CheckersWinner = .none

    // Multi-jump chain (only activates AFTER a capture is chosen)
    @State private var chainPieceID: UUID? = nil

    // Popups
    @State private var showCompletePopup: Bool = false
    @State private var shimmerOn: Bool = false
    @State private var showResetConfirm: Bool = false
    @State private var showDifficultyPopup: Bool = false

    // Auto-reset guard
    @State private var autoResetToken: UUID = UUID()

    // AI move cancel token (prevents delayed multi-jumps after reset)
    @State private var aiMoveToken: UUID = UUID()

    // Board colors (solid - avoids “discolored” tint stacking)
    private let lightTeal = Color(red: 0.60, green: 0.90, blue: 0.87)
    private let darkTeal  = Color(red: 0.18, green: 0.52, blue: 0.52)

    // Piece colors
    private let humanColor = Color.white.opacity(0.97)
    private let aiColor = Color(red: 0.74, green: 1.00, blue: 0.86).opacity(0.97)

    // Difficulty badge colors
    private var difficultyPillColor: Color {
        switch difficulty {
        case .easy: return Color.green.opacity(0.22)
        case .medium: return Color.orange.opacity(0.22)
        case .hard: return Color.red.opacity(0.22)
        }
    }

    private var difficultyBadge: some View {
        Text(difficulty.title)
            .font(Font.custom("Avenir-Heavy", size: 13))
            .foregroundColor(.white.opacity(0.95))
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .background(
                Capsule()
                    .fill(difficultyPillColor)
                    .overlay(
                        Capsule()
                            .stroke(Color.white.opacity(0.18), lineWidth: 1)
                    )
            )
            .shadow(color: .black.opacity(0.18), radius: 8, x: 0, y: 4)
            .offset(x: -8, y: -60) // x negative = left, y negative = up
    }

    // Popup button gradient (FitnessSpaceView style)
    private var lifespaceButtonGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.85, green: 1.0, blue: 0.9),
                Color(red: 0.4, green: 0.9, blue: 0.8)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private func popupActionButton(_ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(Font.custom("Avenir-Heavy", size: 15))
                .foregroundColor(.black)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(lifespaceButtonGradient)
                .cornerRadius(18)
                .shadow(color: .black.opacity(0.18), radius: 6, x: 0, y: 3)
        }
        .buttonStyle(.plain)
    }

    var body: some View {
        ZStack {
            // LIFESPACE gradient background
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

            VStack(spacing: 0) {
                Spacer(minLength: 10)

                headerTitle
                    .padding(.bottom, 10)

                // Board: slightly left + a touch higher
                board
                    .frame(maxWidth: 430)
                    .aspectRatio(1, contentMode: .fit)
                    .padding(.horizontal, 14)
                    .offset(x: -12)
                    .padding(.top, -2)

                // More spacing below the board
                lowerPanel
                    .padding(.top, 64)

                Spacer(minLength: 12)
            }

            if showResetConfirm { resetConfirmPopup }
            if showDifficultyPopup { difficultyPopup }
            if showCompletePopup { completionPopup }
        }
        .onAppear { loadOrCreate() }
        .onChange(of: pieces) { _ in saveState() }
        .onChange(of: turn) { _ in saveState() }
        .onChange(of: difficulty) { _ in saveState() }
        .onChange(of: selectedPieceID) { _ in saveState() }
        .onChange(of: didLogReward) { _ in saveState() }
        .onChange(of: winner) { _ in saveState() }
        .onChange(of: chainPieceID) { _ in saveState() }
    }

    // MARK: - Header (NO container)

    private var headerTitle: some View {
        Text("Checkers")
            .font(.system(size: 42, weight: .bold))
            .foregroundColor(.white)
            .shadow(radius: 6)
            .offset(y: -6)
            .frame(maxWidth: .infinity)
            .overlay(alignment: .topLeading) {
                difficultyBadge
            }
            .overlay(alignment: .topTrailing) {
                Button { showResetConfirm = true } label: {
                    Image(systemName: "star.fill")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 36, height: 36)
                        .background(Color.white.opacity(0.18))
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.18), radius: 8, x: 0, y: 4)
                }
                .buttonStyle(.plain)
                .padding(.trailing, 52)
                .padding(.top, -18)
            }
            .padding(.horizontal, 18)
    }

    // MARK: - Board

    private var board: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)
            let cell = size / 8.0

            ZStack {
                RoundedRectangle(cornerRadius: 22)
                    .fill(Color.white.opacity(0.10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 22)
                            .stroke(Color.white.opacity(0.18), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.20), radius: 16, x: 0, y: 10)

                // Squares
                ForEach(0..<8, id: \.self) { r in
                    ForEach(0..<8, id: \.self) { c in
                        let isDark = ((r + c) % 2 == 1)
                        RoundedRectangle(cornerRadius: 7)
                            .fill(isDark ? darkTeal : lightTeal)
                            .frame(width: cell * 0.96, height: cell * 0.96)
                            .shadow(color: .black.opacity(0.06), radius: 3, x: 0, y: 2)
                            .position(x: cell * (CGFloat(c) + 0.5), y: cell * (CGFloat(r) + 0.5))
                            .onTapGesture { handleTapSquare(r: r, c: c) }
                    }
                }

                // Move hints
                let hints = hintMovesForSelected()
                ForEach(hints, id: \.self) { mv in
                    Circle()
                        .fill(Color.white.opacity(mv.capturedID == nil ? 0.18 : 0.28))
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(mv.capturedID == nil ? 0.25 : 0.40), lineWidth: 2)
                        )
                        .frame(width: cell * 0.36, height: cell * 0.36)
                        .position(x: cell * (CGFloat(mv.toC) + 0.5), y: cell * (CGFloat(mv.toR) + 0.5))
                        .shadow(radius: 6)
                        .allowsHitTesting(false)
                }

                // Pieces
                ForEach(pieces) { p in
                    CheckerPieceView(
                        isKing: p.isKing,
                        fill: p.isHuman ? humanColor : aiColor,
                        selected: p.id == selectedPieceID
                    )
                    .frame(width: cell * 0.80, height: cell * 0.80)
                    .position(x: cell * (CGFloat(p.c) + 0.5), y: cell * (CGFloat(p.r) + 0.5))
                    .onTapGesture { handleTapPiece(p) }
                }
            }
            .padding(12)
            .frame(width: size, height: size)
            .position(x: geo.size.width / 2, y: geo.size.height / 2)
            .compositingGroup()
        }
    }

    // MARK: - Lower Panel (NO container)

    private var lowerPanel: some View {
        VStack(spacing: 54) {
            changeDifficultyButton

            HStack(spacing: 30) {
                Button { navModel.pop() } label: {
                    Circle()
                        .fill(Color.white.opacity(0.20))
                        .overlay(
                            Image(systemName: "chevron.left")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                        )
                        .frame(width: 74, height: 74)
                        .shadow(color: .black.opacity(0.20), radius: 12, x: 0, y: 7)
                }

                Button { navModel.push("HomeView") } label: {
                    Circle()
                        .fill(Color.white.opacity(0.20))
                        .overlay(
                            Image(systemName: "house.fill")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                        )
                        .frame(width: 74, height: 74)
                        .shadow(color: .black.opacity(0.20), radius: 12, x: 0, y: 7)
                }
            }
        }
        .padding(.horizontal, 18)
    }

    // MARK: - Change Difficulty Button (shorter)

    private var changeDifficultyButton: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.25)) { showDifficultyPopup = true }
        } label: {
            Text("CHANGE DIFFICULTY")
                .font(Font.custom("Avenir-Heavy", size: 18))
                .foregroundColor(.black)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(lifespaceButtonGradient)
                .cornerRadius(22)
                .shadow(color: .black.opacity(0.18), radius: 10, x: 0, y: 6)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Popups

    private var difficultyPopup: some View {
        ZStack {
            Color.black.opacity(0.45)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)) { showDifficultyPopup = false }
                }

            VStack(spacing: 14) {
                popupActionButton("EASY") { setDifficulty(.easy) }
                popupActionButton("MEDIUM") { setDifficulty(.medium) }
                popupActionButton("HARD") { setDifficulty(.hard) }
            }
            .padding(18)
            .frame(width: 280)
            .background(
                RoundedRectangle(cornerRadius: 26)
                    .fill(Color.white.opacity(0.12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 26)
                            .stroke(Color.white.opacity(0.22), lineWidth: 1.2)
                    )
                    .shadow(color: .black.opacity(0.25), radius: 18, x: 0, y: 10)
            )
            .transition(.scale.combined(with: .opacity))
        }
        .zIndex(10)
    }

    private func setDifficulty(_ d: CheckersDifficulty) {
        withAnimation(.easeInOut(duration: 0.2)) {
            difficulty = d
            showDifficultyPopup = false
        }
        if turn == .ai && winner == .none {
            scheduleAIMove()
        }
    }

    private var completionPopup: some View {
        ZStack {
            Color.black.opacity(0.48)
                .ignoresSafeArea()

            VStack(spacing: 14) {
                Text("Game Complete!")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(radius: 6)

                Text("+1 Activity")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(Color(red: 0.75, green: 1.00, blue: 0.85))
                    .shadow(color: Color(red: 0.75, green: 1.00, blue: 0.85).opacity(0.75), radius: 10)

                Button { scheduleImmediateNewGame() } label: {
                    Text("NEW GAME")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.22))
                        .cornerRadius(14)
                }
                .buttonStyle(.plain)
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
        .zIndex(20)
    }

    private var resetConfirmPopup: some View {
        ZStack {
            Color.black.opacity(0.48)
                .ignoresSafeArea()

            VStack(spacing: 14) {
                Text("NEW GAME")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(radius: 6)

                Text("Do you want to start a new game?")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white.opacity(0.92))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 6)

                HStack(spacing: 12) {
                    Button {
                        showResetConfirm = false
                        scheduleImmediateNewGame()
                    } label: {
                        Text("YES")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.22))
                            .cornerRadius(14)
                    }
                    .buttonStyle(.plain)

                    Button { showResetConfirm = false } label: {
                        Text("NO")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.14))
                            .cornerRadius(14)
                    }
                    .buttonStyle(.plain)
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
        .zIndex(20)
    }

    // MARK: - Taps

    private func handleTapPiece(_ p: CheckersPiece) {
        guard winner == .none else { return }
        guard turn == .human else { return }
        guard p.isHuman else { return }

        // If we’re in a capture chain, you can only move THAT piece
        if let chainID = chainPieceID, chainID != p.id { return }

        let moves: [CheckersMove]
        if chainPieceID == p.id {
            // During chain: only allow captures
            moves = captureMoves(for: p, in: pieces)
        } else {
            // Normal: do NOT force capturing (mistakes allowed)
            moves = legalMoves(for: p, in: pieces, enforceCaptures: false)
        }
        guard !moves.isEmpty else { return }

        let gen = UIImpactFeedbackGenerator(style: .light)
        gen.impactOccurred()

        // During chain, keep it selected (no toggle off)
        if chainPieceID == p.id {
            selectedPieceID = p.id
        } else {
            selectedPieceID = (selectedPieceID == p.id) ? nil : p.id
        }
    }

    private func handleTapSquare(r: Int, c: Int) {
        guard winner == .none else { return }
        guard turn == .human else { return }

        if let p = pieceAt(r: r, c: c) {
            handleTapPiece(p)
            return
        }

        guard let selID = selectedPieceID, var selPiece = pieceByID(selID) else { return }

        // If chain is active, selection must be the chain piece
        if let chainID = chainPieceID, chainID != selID { return }

        let moves: [CheckersMove]
        if chainPieceID == selID {
            moves = captureMoves(for: selPiece, in: pieces)
        } else {
            moves = legalMoves(for: selPiece, in: pieces, enforceCaptures: false)
        }

        guard let chosen = moves.first(where: { $0.toR == r && $0.toC == c }) else { return }

        let wasKing = selPiece.isKing
        applyMove(chosen)
        let isKingNow = pieceByID(chosen.pieceID)?.isKing ?? false
        let didKing = (!wasKing && isKingNow)

        if winner != .none { return }

        if chosen.capturedID != nil && !didKing, let updated = pieceByID(chosen.pieceID) {
            let moreCaps = captureMoves(for: updated, in: pieces)
            if !moreCaps.isEmpty {
                chainPieceID = updated.id
                selectedPieceID = updated.id
                return
            }
        }

        chainPieceID = nil
        selectedPieceID = nil

        if isSideOutOfMoves(isHuman: false, in: pieces, enforceCaptures: true) {
            setWinner(.human)
            return
        }

        turn = .ai
        scheduleAIMove()
    }

    private func hintMovesForSelected() -> [CheckersMove] {
        guard winner == .none else { return [] }
        guard turn == .human else { return [] }
        guard let selID = selectedPieceID, let sel = pieceByID(selID) else { return [] }

        if chainPieceID == selID {
            return captureMoves(for: sel, in: pieces)
        }
        return legalMoves(for: sel, in: pieces, enforceCaptures: false)
    }

    // MARK: - Game Flow

    private func scheduleAIMove() {
        guard winner == .none else { return }
        guard turn == .ai else { return }

        aiMoveToken = UUID()
        let token = aiMoveToken

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            self.performAIMoveStep(token: token, forcedPieceID: nil)
        }
    }

    private func performAIMoveStep(token: UUID, forcedPieceID: UUID?) {
        guard token == aiMoveToken else { return }
        guard winner == .none else { return }
        guard turn == .ai else { return }

        if isSideOutOfMoves(isHuman: false, in: pieces, enforceCaptures: true) {
            setWinner(.human)
            return
        }

        let mv: CheckersMove?
        if let pid = forcedPieceID, let p = pieceByID(pid) {
            let caps = captureMoves(for: p, in: pieces)
            mv = caps.isEmpty ? nil : pickAIMove(from: caps)
        } else {
            mv = chooseAIMove()
        }

        guard let move = mv else {
            setWinner(.human)
            return
        }

        let wasKing = pieceByID(move.pieceID)?.isKing ?? false
        applyMove(move)
        let isKingNow = pieceByID(move.pieceID)?.isKing ?? false
        let didKing = (!wasKing && isKingNow)

        if winner != .none { return }

        if move.capturedID != nil && !didKing, let updated = pieceByID(move.pieceID) {
            let moreCaps = captureMoves(for: updated, in: pieces)
            if !moreCaps.isEmpty {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.28) {
                    self.performAIMoveStep(token: token, forcedPieceID: move.pieceID)
                }
                return
            }
        }

        if isSideOutOfMoves(isHuman: true, in: pieces, enforceCaptures: false) {
            setWinner(.ai)
            return
        }

        turn = .human
    }

    private func setWinner(_ w: CheckersWinner) {
        winner = w

        if w == .human {
            onGameCompleteIfNeeded()
            scheduleAutoNewGame(after: 2.2, hidePopup: true)
        } else if w == .ai {
            scheduleAutoNewGame(after: 0.9, hidePopup: true)
        }
    }

    private func scheduleImmediateNewGame() {
        scheduleAutoNewGame(after: 0.01, hidePopup: true)
    }

    private func scheduleAutoNewGame(after delay: Double, hidePopup: Bool) {
        let token = UUID()
        autoResetToken = token

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            guard self.autoResetToken == token else { return }
            self.newGame(keepDifficulty: true)
            if hidePopup {
                self.showCompletePopup = false
                self.showResetConfirm = false
                self.showDifficultyPopup = false
            }
        }
    }

    private func onGameCompleteIfNeeded() {
        if !didLogReward {
            didLogReward = true
            lifespaceLogModel.addEntry(
                LifespaceLogEntry(
                    type: .lifespace,
                    module: .activity,
                    questionCount: 1,
                    yesCount: 1
                )
            )
        }
        showCompletePopup = true
    }

    // MARK: - AI Selection

    private func chooseAIMove() -> CheckersMove? {
        let aiPieces = pieces.filter { !$0.isHuman }
        guard !aiPieces.isEmpty else { return nil }

        let captures = allCaptureMoves(isHuman: false, in: pieces)
        let candidates: [CheckersMove] = !captures.isEmpty
            ? captures
            : aiPieces.flatMap { legalMoves(for: $0, in: pieces, enforceCaptures: true) }

        guard !candidates.isEmpty else { return nil }
        return pickAIMove(from: candidates)
    }

    private func pickAIMove(from candidates: [CheckersMove]) -> CheckersMove {
        switch difficulty {
        case .easy:
            return candidates.randomElement() ?? candidates[0]
        case .medium:
            return candidates.max(by: { scoreMoveMedium($0) < scoreMoveMedium($1) }) ?? candidates[0]
        case .hard:
            return bestMoveHard(from: candidates)
        }
    }

    private func scoreMoveMedium(_ mv: CheckersMove) -> Double {
        var score: Double = 0
        if mv.capturedID != nil { score += 5.0 }
        score += Double(mv.toR) * 0.25

        let centerDist = abs(Double(mv.toC) - 3.5) + abs(Double(mv.toR) - 3.5)
        score += max(0, 3.5 - centerDist) * 0.15

        if let p = pieceByID(mv.pieceID), !p.isKing, mv.toR == 7 {
            score += 3.5
        }

        score += Double.random(in: 0...0.15)
        return score
    }

    private func bestMoveHard(from candidates: [CheckersMove]) -> CheckersMove {
        var best = candidates[0]
        var bestScore = -Double.infinity

        for mv in candidates {
            var sim = pieces
            applyMove(mv, on: &sim)

            let replyMoves = allLegalMoves(isHuman: true, in: sim, enforceCaptures: false)
            if replyMoves.isEmpty {
                let s = 999.0
                if s > bestScore { bestScore = s; best = mv }
                continue
            }

            var worstForAI = Double.infinity
            for reply in replyMoves {
                var sim2 = sim
                applyMove(reply, on: &sim2)
                let eval = evaluateBoard(sim2)
                if eval < worstForAI { worstForAI = eval }
            }

            if worstForAI > bestScore {
                bestScore = worstForAI
                best = mv
            }
        }
        return best
    }

    private func evaluateBoard(_ state: [CheckersPiece]) -> Double {
        let ai = state.filter { !$0.isHuman }
        let human = state.filter { $0.isHuman }

        let aiScore = ai.reduce(0.0) { $0 + ($1.isKing ? 1.75 : 1.0) }
        let humanScore = human.reduce(0.0) { $0 + ($1.isKing ? 1.75 : 1.0) }

        let aiMoves = allLegalMoves(isHuman: false, in: state, enforceCaptures: true).count
        let humanMoves = allLegalMoves(isHuman: true, in: state, enforceCaptures: false).count

        let aiAdvance = ai.reduce(0.0) { $0 + Double($1.r) * 0.03 }
        let humanAdvance = human.reduce(0.0) { $0 + Double(7 - $1.r) * 0.03 }

        return (aiScore - humanScore) * 3.0
        + (Double(aiMoves - humanMoves) * 0.10)
        + (aiAdvance - humanAdvance)
    }

    // MARK: - Rules

    private func legalMoves(for piece: CheckersPiece, in state: [CheckersPiece], enforceCaptures: Bool) -> [CheckersMove] {
        if enforceCaptures {
            let sideHasCapture = !allCaptureMoves(isHuman: piece.isHuman, in: state).isEmpty
            if sideHasCapture {
                return captureMoves(for: piece, in: state)
            }
        }
        return simpleMoves(for: piece, in: state) + captureMoves(for: piece, in: state)
    }

    private func allLegalMoves(isHuman: Bool, in state: [CheckersPiece], enforceCaptures: Bool) -> [CheckersMove] {
        let sidePieces = state.filter { $0.isHuman == isHuman }
        let captures = allCaptureMoves(isHuman: isHuman, in: state)
        if enforceCaptures, !captures.isEmpty { return captures }
        return sidePieces.flatMap { legalMoves(for: $0, in: state, enforceCaptures: false) }
    }

    private func allCaptureMoves(isHuman: Bool, in state: [CheckersPiece]) -> [CheckersMove] {
        let sidePieces = state.filter { $0.isHuman == isHuman }
        return sidePieces.flatMap { captureMoves(for: $0, in: state) }
    }

    private func simpleMoves(for piece: CheckersPiece, in state: [CheckersPiece]) -> [CheckersMove] {
        let dirs: [(dr: Int, dc: Int)]
        if piece.isKing {
            dirs = [(-1, -1), (-1, 1), (1, -1), (1, 1)]
        } else {
            let forward = piece.isHuman ? -1 : 1
            dirs = [(forward, -1), (forward, 1)]
        }

        var out: [CheckersMove] = []
        for d in dirs {
            let nr = piece.r + d.dr
            let nc = piece.c + d.dc
            if isInBounds(nr, nc) && pieceAt(r: nr, c: nc, in: state) == nil {
                out.append(CheckersMove(pieceID: piece.id, fromR: piece.r, fromC: piece.c, toR: nr, toC: nc, capturedID: nil))
            }
        }
        return out
    }

    private func captureMoves(for piece: CheckersPiece, in state: [CheckersPiece]) -> [CheckersMove] {
        let dirs: [(dr: Int, dc: Int)]
        if piece.isKing {
            dirs = [(-1, -1), (-1, 1), (1, -1), (1, 1)]
        } else {
            let forward = piece.isHuman ? -1 : 1
            dirs = [(forward, -1), (forward, 1)]
        }

        var out: [CheckersMove] = []
        for d in dirs {
            let midR = piece.r + d.dr
            let midC = piece.c + d.dc
            let landR = piece.r + d.dr * 2
            let landC = piece.c + d.dc * 2

            guard isInBounds(landR, landC) else { continue }
            guard pieceAt(r: landR, c: landC, in: state) == nil else { continue }
            guard let midPiece = pieceAt(r: midR, c: midC, in: state) else { continue }
            guard midPiece.isHuman != piece.isHuman else { continue }

            out.append(CheckersMove(pieceID: piece.id, fromR: piece.r, fromC: piece.c, toR: landR, toC: landC, capturedID: midPiece.id))
        }
        return out
    }

    private func applyMove(_ mv: CheckersMove) {
        applyMove(mv, on: &pieces)

        if mv.capturedID != nil {
            let gen = UIImpactFeedbackGenerator(style: .light)
            gen.impactOccurred()
        }

        let humanCount = pieces.filter { $0.isHuman }.count
        let aiCount = pieces.filter { !$0.isHuman }.count

        if aiCount == 0 { setWinner(.human) }
        if humanCount == 0 { setWinner(.ai) }
    }

    private func applyMove(_ mv: CheckersMove, on state: inout [CheckersPiece]) {
        if let capID = mv.capturedID, let capIdx = state.firstIndex(where: { $0.id == capID }) {
            state.remove(at: capIdx)
        }

        guard let idx = state.firstIndex(where: { $0.id == mv.pieceID }) else { return }

        state[idx].r = mv.toR
        state[idx].c = mv.toC

        if !state[idx].isKing {
            if state[idx].isHuman && mv.toR == 0 { state[idx].isKing = true }
            if !state[idx].isHuman && mv.toR == 7 { state[idx].isKing = true }
        }
    }

    private func isSideOutOfMoves(isHuman: Bool, in state: [CheckersPiece], enforceCaptures: Bool) -> Bool {
        let side = state.filter { $0.isHuman == isHuman }
        if side.isEmpty { return true }
        return allLegalMoves(isHuman: isHuman, in: state, enforceCaptures: enforceCaptures).isEmpty
    }

    // MARK: - Helpers

    private func isInBounds(_ r: Int, _ c: Int) -> Bool {
        (0..<8).contains(r) && (0..<8).contains(c)
    }

    private func pieceAt(r: Int, c: Int) -> CheckersPiece? {
        pieces.first(where: { $0.r == r && $0.c == c })
    }

    private func pieceAt(r: Int, c: Int, in state: [CheckersPiece]) -> CheckersPiece? {
        state.first(where: { $0.r == r && $0.c == c })
    }

    private func pieceByID(_ id: UUID) -> CheckersPiece? {
        pieces.first(where: { $0.id == id })
    }

    // MARK: - Persistence

    private func loadOrCreate() {
        if let loaded = decodeState() {
            pieces = loaded.pieces
            turn = loaded.turn
            difficulty = loaded.difficulty
            selectedPieceID = loaded.selectedPieceID
            didLogReward = loaded.didLogReward
            winner = loaded.winner
            chainPieceID = loaded.chainPieceID

            if winner == .human {
                showCompletePopup = true
                scheduleAutoNewGame(after: 2.2, hidePopup: true)
            } else if winner == .ai {
                scheduleAutoNewGame(after: 0.9, hidePopup: true)
            } else if turn == .ai {
                scheduleAIMove()
            } else if let chainID = chainPieceID {
                selectedPieceID = chainID
            }
            return
        }

        newGame(keepDifficulty: true)
    }

    private func newGame(keepDifficulty: Bool) {
        aiMoveToken = UUID()
        let d = difficulty

        pieces = initialPieces()
        turn = .human
        selectedPieceID = nil
        didLogReward = false
        winner = .none
        chainPieceID = nil

        if keepDifficulty { difficulty = d }

        showCompletePopup = false
        showResetConfirm = false
        showDifficultyPopup = false

        saveState()
    }

    private func initialPieces() -> [CheckersPiece] {
        var out: [CheckersPiece] = []

        for r in 0...2 {
            for c in 0..<8 where (r + c) % 2 == 1 {
                out.append(CheckersPiece(r: r, c: c, isKing: false, isHuman: false))
            }
        }

        for r in 5...7 {
            for c in 0..<8 where (r + c) % 2 == 1 {
                out.append(CheckersPiece(r: r, c: c, isKing: false, isHuman: true))
            }
        }

        return out
    }

    private func saveState() {
        let state = CheckersPersistentState(
            pieces: pieces,
            turn: turn,
            difficulty: difficulty,
            selectedPieceID: selectedPieceID,
            didLogReward: didLogReward,
            winner: winner,
            chainPieceID: chainPieceID
        )
        do {
            let data = try JSONEncoder().encode(state)
            stateJSON = String(data: data, encoding: .utf8) ?? ""
        } catch { }
    }

    private func decodeState() -> CheckersPersistentState? {
        guard !stateJSON.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return nil }
        guard let data = stateJSON.data(using: .utf8) else { return nil }

        if let v2 = try? JSONDecoder().decode(CheckersPersistentState.self, from: data) {
            return v2
        }

        if let v1 = try? JSONDecoder().decode(CheckersPersistentStateV1.self, from: data) {
            return CheckersPersistentState(
                pieces: v1.pieces,
                turn: v1.turn,
                difficulty: v1.difficulty,
                selectedPieceID: v1.selectedPieceID,
                didLogReward: v1.didLogReward,
                winner: v1.winner,
                chainPieceID: nil
            )
        }

        return nil
    }
}

// MARK: - Piece View

private struct CheckerPieceView: View {
    let isKing: Bool
    let fill: Color
    let selected: Bool

    var body: some View {
        ZStack {
            Circle()
                .fill(fill)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(selected ? 0.60 : 0.20), lineWidth: selected ? 3 : 2)
                )
                .shadow(color: .black.opacity(0.20), radius: 10, x: 0, y: 6)

            if isKing {
                Image(systemName: "crown.fill")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color.black.opacity(0.35))
                    .shadow(radius: 1.5)
            }
        }
    }
}
