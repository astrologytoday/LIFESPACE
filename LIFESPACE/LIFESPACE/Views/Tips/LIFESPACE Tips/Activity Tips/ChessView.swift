//
//  ChessView.swift
//  LIFESPACE
//
//  Created by Mario Sbardella on 2025-12-21.
//

import Foundation
import SwiftUI

// MARK: - Models

private enum ChessDifficulty: String, CaseIterable, Codable {
    case easy, medium, hard

    var title: String {
        switch self {
        case .easy: return "EASY"
        case .medium: return "MEDIUM"
        case .hard: return "HARD"
        }
    }
}

private enum ChessTurn: String, Codable {
    case human   // White
    case ai      // Black
}

private enum ChessWinner: String, Codable {
    case none
    case human
    case ai
    case draw
}

private enum ChessPieceType: String, Codable {
    case king, queen, rook, bishop, knight, pawn
}

private struct ChessPiece: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var r: Int
    var c: Int
    var type: ChessPieceType
    var isWhite: Bool      // human = white, ai = black
    var hasMoved: Bool
}

private struct ChessMove: Hashable, Codable {
    var pieceID: UUID
    var fromR: Int
    var fromC: Int
    var toR: Int
    var toC: Int
    var capturedID: UUID? = nil
    var promotesTo: ChessPieceType? = nil
}

private struct ChessPersistentState: Codable {
    var pieces: [ChessPiece]
    var turn: ChessTurn
    var difficulty: ChessDifficulty
    var selectedPieceID: UUID?
    var didLogReward: Bool
    var winner: ChessWinner
}

// MARK: - View

struct ChessView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var lifespaceLogModel: LifespaceLogModel

    @AppStorage("chess_stateJSON") private var stateJSON: String = ""

    @State private var pieces: [ChessPiece] = []
    @State private var turn: ChessTurn = .human
    @State private var difficulty: ChessDifficulty = .easy

    @State private var selectedPieceID: UUID? = nil
    @State private var didLogReward: Bool = false
    @State private var winner: ChessWinner = .none

    // Popups
    @State private var showCompletePopup: Bool = false
    @State private var shimmerOn: Bool = false
    @State private var showResetConfirm: Bool = false
    @State private var showDifficultyPopup: Bool = false

    // Auto-reset guard
    @State private var autoResetToken: UUID = UUID()

    // AI move cancel token (prevents delayed move after reset)
    @State private var aiMoveToken: UUID = UUID()

    // ✅ Board colors (solid — avoids tint stacking)
    private let lightTeal = Color(red: 0.60, green: 0.90, blue: 0.87)
    private let darkTeal  = Color(red: 0.18, green: 0.52, blue: 0.52)

    // Piece colors (keep consistent with Checkers vibe)
    private let humanFill = Color.white.opacity(0.97)
    private let aiFill = Color(red: 0.74, green: 1.00, blue: 0.86).opacity(0.97)

    // ✅ Difficulty marker colors
    private var difficultyPillColor: Color {
        switch difficulty {
        case .easy:
            return Color(red: 0.60, green: 1.00, blue: 0.70).opacity(0.25)
        case .medium:
            return Color.orange.opacity(0.25)
        case .hard:
            return Color.red.opacity(0.25)
        }
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

            VStack(spacing: 0) {
                Spacer(minLength: 10)

                headerTitle
                    .padding(.bottom, 10)

                // ✅ Board: slightly left + a touch higher (same feel as Checkers)
                board
                    .frame(maxWidth: 430)
                    .aspectRatio(1, contentMode: .fit)
                    .padding(.horizontal, 14)
                    .offset(x: -12)
                    .padding(.top, -2)

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
    }

    // MARK: - Header (NO container)

    private var headerTitle: some View {
        Text("Chess")
            .font(.system(size: 42, weight: .bold))
            .foregroundColor(.white)
            .shadow(radius: 6)
            .offset(y: -6)
            .frame(maxWidth: .infinity)
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
            // ✅ Difficulty marker pill (top-left)
            .overlay(alignment: .topLeading) {
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
                                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
                            )
                    )
                    .shadow(color: .black.opacity(0.18), radius: 8, x: 0, y: 4)
                    .offset(x: -8, y: -60) // x negative = left, y negative = up
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
                        .fill(Color.white.opacity(mv.capturedID == nil ? 0.18 : 0.30))
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(mv.capturedID == nil ? 0.25 : 0.45), lineWidth: 2)
                        )
                        .frame(width: cell * 0.36, height: cell * 0.36)
                        .position(x: cell * (CGFloat(mv.toC) + 0.5), y: cell * (CGFloat(mv.toR) + 0.5))
                        .shadow(radius: 6)
                        .allowsHitTesting(false)
                }

                // Pieces
                ForEach(pieces) { p in
                    ChessPieceView(
                        piece: p,
                        fill: p.isWhite ? humanFill : aiFill,
                        selected: p.id == selectedPieceID
                    )
                    .frame(width: cell * 0.84, height: cell * 0.84)
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

    private func setDifficulty(_ d: ChessDifficulty) {
        withAnimation(.easeInOut(duration: 0.2)) {
            difficulty = d
            showDifficultyPopup = false
        }
        if turn == .ai && winner == .none { scheduleAIMove() }
    }

    private var completionPopup: some View {
        ZStack {
            Color.black.opacity(0.48)
                .ignoresSafeArea()

            VStack(spacing: 14) {
                Text(winnerTitleText())
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(radius: 6)

                if winner == .human {
                    Text("+1 Activity")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(Color(red: 0.75, green: 1.00, blue: 0.85))
                        .shadow(color: Color(red: 0.75, green: 1.00, blue: 0.85).opacity(0.75), radius: 10)
                } else if winner == .draw {
                    Text("Draw")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white.opacity(0.9))
                        .shadow(radius: 6)
                }

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

    private func winnerTitleText() -> String {
        switch winner {
        case .none: return "Game Complete!"
        case .human: return "You Win!"
        case .ai: return "Checkmate"
        case .draw: return "Draw!"
        }
    }

    // MARK: - Taps

    private func handleTapPiece(_ p: ChessPiece) {
        guard winner == .none else { return }
        guard turn == .human else { return }

        // ✅ If user taps an enemy piece while a piece is selected, attempt capture
        if !p.isWhite, selectedPieceID != nil {
            _ = tryMoveSelected(toR: p.r, toC: p.c)
            return
        }

        // Normal selection (white only)
        guard p.isWhite else { return }

        let moves = legalMoves(for: p, in: pieces)
        guard !moves.isEmpty else { return }

        let gen = UIImpactFeedbackGenerator(style: .light)
        gen.impactOccurred()

        selectedPieceID = (selectedPieceID == p.id) ? nil : p.id
    }

    private func handleTapSquare(r: Int, c: Int) {
        guard winner == .none else { return }
        guard turn == .human else { return }

        // ✅ If tapping any square while something is selected, try to move there (includes captures)
        if selectedPieceID != nil {
            if tryMoveSelected(toR: r, toC: c) { return }
        }

        // If no selection, allow selecting a white piece by tapping its square
        if let p = pieceAt(r: r, c: c), p.isWhite {
            handleTapPiece(p)
        }
    }

    private func hintMovesForSelected() -> [ChessMove] {
        guard winner == .none else { return [] }
        guard turn == .human else { return [] }
        guard let selID = selectedPieceID, let sel = pieceByID(selID) else { return [] }
        return legalMoves(for: sel, in: pieces)
    }

    // MARK: - Game Flow

    private func scheduleAIMove() {
        guard winner == .none else { return }
        guard turn == .ai else { return }

        aiMoveToken = UUID()
        let token = aiMoveToken

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            guard token == self.aiMoveToken else { return }
            self.performAIMove(token: token)
        }
    }

    private func performAIMove(token: UUID) {
        guard token == aiMoveToken else { return }
        guard winner == .none else { return }
        guard turn == .ai else { return }

        let aiMoves = allLegalMoves(isWhite: false, in: pieces)
        if aiMoves.isEmpty {
            finalizeEndState(afterSideToMove: .ai)
            return
        }

        guard let chosen = pickAIMove(from: aiMoves) else {
            finalizeEndState(afterSideToMove: .ai)
            return
        }

        applyMove(chosen)

        if winner != .none { return }

        // After AI move, check if human has moves
        if allLegalMoves(isWhite: true, in: pieces).isEmpty {
            finalizeEndState(afterSideToMove: .human)
            return
        }

        turn = .human
    }

    private func finalizeEndState(afterSideToMove sideToMove: ChessTurn) {
        // sideToMove is the player who would move now, but has no legal moves
        let whiteInCheck = isKingInCheck(isWhite: true, in: pieces)
        let blackInCheck = isKingInCheck(isWhite: false, in: pieces)

        if sideToMove == .human {
            // White to move but no moves
            if whiteInCheck {
                setWinner(.ai)      // checkmate
            } else {
                setWinner(.draw)    // stalemate
            }
        } else {
            // Black to move but no moves
            if blackInCheck {
                setWinner(.human)
            } else {
                setWinner(.draw)
            }
        }
    }

    private func setWinner(_ w: ChessWinner) {
        winner = w

        if w == .human {
            onGameCompleteIfNeeded()
            scheduleAutoNewGame(after: 2.2, hidePopup: true)
        } else if w == .ai {
            showCompletePopup = true
            scheduleAutoNewGame(after: 0.9, hidePopup: true)
        } else if w == .draw {
            showCompletePopup = true
            scheduleAutoNewGame(after: 1.5, hidePopup: true)
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

    private func pickAIMove(from candidates: [ChessMove]) -> ChessMove? {
        guard !candidates.isEmpty else { return nil }

        switch difficulty {
        case .easy:
            return candidates.randomElement()
        case .medium:
            return candidates.max(by: { scoreMoveForBlack($0, in: pieces) < scoreMoveForBlack($1, in: pieces) })
        case .hard:
            return bestMoveHard(from: candidates)
        }
    }

    private func scoreMoveForBlack(_ mv: ChessMove, in state: [ChessPiece]) -> Double {
        var sim = state
        applyMove(mv, on: &sim)

        // Prefer material & checks a bit
        var score = evaluateForBlack(sim)

        if isKingInCheck(isWhite: true, in: sim) { score += 0.35 }   // checking white is nice
        if isKingInCheck(isWhite: false, in: sim) { score -= 0.35 }  // avoid self-check (shouldn’t happen from legal move)

        // small random so Medium doesn’t feel robotic
        score += Double.random(in: 0...0.12)
        return score
    }

    private func bestMoveHard(from candidates: [ChessMove]) -> ChessMove {
        var best = candidates[0]
        var bestScore = -Double.infinity

        // Depth 2 is usually smooth on-device; bump to 3 if you want later.
        let depth = 2

        for mv in candidates {
            var sim = pieces
            applyMove(mv, on: &sim)

            let score = minimax(
                state: sim,
                depth: depth - 1,
                maximizingForBlack: false,
                alpha: -10_000,
                beta: 10_000
            )

            if score > bestScore {
                bestScore = score
                best = mv
            }
        }
        return best
    }

    private func minimax(state: [ChessPiece], depth: Int, maximizingForBlack: Bool, alpha: Double, beta: Double) -> Double {
        var alphaVar = alpha
        var betaVar = beta

        let blackMoves = allLegalMoves(isWhite: false, in: state)
        let whiteMoves = allLegalMoves(isWhite: true, in: state)

        // Terminal-ish: no moves for side to move (checkmate/stalemate)
        if maximizingForBlack {
            if blackMoves.isEmpty {
                // Black to move, no moves
                if isKingInCheck(isWhite: false, in: state) { return -9_000 } // black checkmated
                return 0 // draw
            }
        } else {
            if whiteMoves.isEmpty {
                // White to move, no moves
                if isKingInCheck(isWhite: true, in: state) { return 9_000 } // white checkmated -> good for black
                return 0
            }
        }

        if depth == 0 {
            return evaluateForBlack(state)
        }

        if maximizingForBlack {
            var best = -Double.infinity
            for mv in blackMoves {
                var sim = state
                applyMove(mv, on: &sim)
                let val = minimax(state: sim, depth: depth - 1, maximizingForBlack: false, alpha: alphaVar, beta: betaVar)
                best = max(best, val)
                alphaVar = max(alphaVar, best)
                if betaVar <= alphaVar { break }
            }
            return best
        } else {
            var best = Double.infinity
            for mv in whiteMoves {
                var sim = state
                applyMove(mv, on: &sim)
                let val = minimax(state: sim, depth: depth - 1, maximizingForBlack: true, alpha: alphaVar, beta: betaVar)
                best = min(best, val)
                betaVar = min(betaVar, best)
                if betaVar <= alphaVar { break }
            }
            return best
        }
    }

    private func evaluateForBlack(_ state: [ChessPiece]) -> Double {
        // Positive = good for black
        let material = state.reduce(0.0) { acc, p in
            let v: Double
            switch p.type {
            case .pawn: v = 1.0
            case .knight: v = 3.0
            case .bishop: v = 3.2
            case .rook: v = 5.0
            case .queen: v = 9.0
            case .king: v = 0.0
            }
            return acc + (p.isWhite ? -v : v)
        }

        // Tiny center preference
        let center = state.reduce(0.0) { acc, p in
            let dr = abs(Double(p.r) - 3.5)
            let dc = abs(Double(p.c) - 3.5)
            let bonus = max(0, 3.5 - (dr + dc)) * 0.02
            return acc + (p.isWhite ? -bonus : bonus)
        }

        // Mobility nudge
        let mob = Double(allLegalMoves(isWhite: false, in: state).count - allLegalMoves(isWhite: true, in: state).count) * 0.01

        return material * 1.0 + center + mob
    }

    // MARK: - Rules

    @discardableResult
    private func tryMoveSelected(toR: Int, toC: Int) -> Bool {
        guard winner == .none else { return false }
        guard turn == .human else { return false }
        guard let selID = selectedPieceID, let selPiece = pieceByID(selID) else { return false }

        let moves = legalMoves(for: selPiece, in: pieces)
        guard let chosen = moves.first(where: { $0.toR == toR && $0.toC == toC }) else { return false }

        applyMove(chosen)

        if winner != .none { return true }

        selectedPieceID = nil

        if allLegalMoves(isWhite: false, in: pieces).isEmpty {
            finalizeEndState(afterSideToMove: .ai)
            return true
        }

        turn = .ai
        scheduleAIMove()
        return true
    }

    private func legalMoves(for piece: ChessPiece, in state: [ChessPiece]) -> [ChessMove] {
        guard pieceAt(r: piece.r, c: piece.c, in: state)?.id == piece.id else { return [] }

        let pseudo = pseudoMoves(for: piece, in: state)

        // Filter out moves that leave your king in check
        var legal: [ChessMove] = []
        for mv in pseudo {
            var sim = state
            applyMove(mv, on: &sim)
            if !isKingInCheck(isWhite: piece.isWhite, in: sim) {
                legal.append(mv)
            }
        }
        return legal
    }

    private func allLegalMoves(isWhite: Bool, in state: [ChessPiece]) -> [ChessMove] {
        let side = state.filter { $0.isWhite == isWhite }
        var out: [ChessMove] = []
        out.reserveCapacity(64)
        for p in side {
            out.append(contentsOf: legalMoves(for: p, in: state))
        }
        return out
    }

    private func pseudoMoves(for piece: ChessPiece, in state: [ChessPiece]) -> [ChessMove] {
        switch piece.type {
        case .pawn:
            return pawnMoves(for: piece, in: state)
        case .knight:
            return knightMoves(for: piece, in: state)
        case .bishop:
            return slideMoves(for: piece, in: state, directions: [(-1,-1),(-1,1),(1,-1),(1,1)])
        case .rook:
            return slideMoves(for: piece, in: state, directions: [(-1,0),(1,0),(0,-1),(0,1)])
        case .queen:
            return slideMoves(for: piece, in: state, directions: [(-1,-1),(-1,1),(1,-1),(1,1),(-1,0),(1,0),(0,-1),(0,1)])
        case .king:
            return kingMoves(for: piece, in: state)
        }
    }

    private func pawnMoves(for p: ChessPiece, in state: [ChessPiece]) -> [ChessMove] {
        let dir = p.isWhite ? -1 : 1
        let startRow = p.isWhite ? 6 : 1
        let promoRow = p.isWhite ? 0 : 7

        var out: [ChessMove] = []

        // one forward
        let r1 = p.r + dir
        if isInBounds(r1, p.c) && pieceAt(r: r1, c: p.c, in: state) == nil {
            var mv = ChessMove(pieceID: p.id, fromR: p.r, fromC: p.c, toR: r1, toC: p.c, capturedID: nil, promotesTo: nil)
            if r1 == promoRow { mv.promotesTo = .queen }
            out.append(mv)

            // two forward
            let r2 = p.r + dir * 2
            if !p.hasMoved && p.r == startRow && isInBounds(r2, p.c) && pieceAt(r: r2, c: p.c, in: state) == nil {
                out.append(ChessMove(pieceID: p.id, fromR: p.r, fromC: p.c, toR: r2, toC: p.c, capturedID: nil, promotesTo: nil))
            }
        }

        // captures
        for dc in [-1, 1] {
            let rr = p.r + dir
            let cc = p.c + dc
            guard isInBounds(rr, cc) else { continue }
            guard let target = pieceAt(r: rr, c: cc, in: state) else { continue }
            guard target.isWhite != p.isWhite else { continue }

            var mv = ChessMove(pieceID: p.id, fromR: p.r, fromC: p.c, toR: rr, toC: cc, capturedID: target.id, promotesTo: nil)
            if rr == promoRow { mv.promotesTo = .queen }
            out.append(mv)
        }

        return out
    }

    private func knightMoves(for p: ChessPiece, in state: [ChessPiece]) -> [ChessMove] {
        let deltas = [(-2,-1),(-2,1),(-1,-2),(-1,2),(1,-2),(1,2),(2,-1),(2,1)]
        var out: [ChessMove] = []

        for (dr, dc) in deltas {
            let rr = p.r + dr
            let cc = p.c + dc
            guard isInBounds(rr, cc) else { continue }

            if let occ = pieceAt(r: rr, c: cc, in: state) {
                if occ.isWhite == p.isWhite { continue }
                out.append(ChessMove(pieceID: p.id, fromR: p.r, fromC: p.c, toR: rr, toC: cc, capturedID: occ.id))
            } else {
                out.append(ChessMove(pieceID: p.id, fromR: p.r, fromC: p.c, toR: rr, toC: cc, capturedID: nil))
            }
        }

        return out
    }

    private func slideMoves(for p: ChessPiece, in state: [ChessPiece], directions: [(Int, Int)]) -> [ChessMove] {
        var out: [ChessMove] = []

        for (dr, dc) in directions {
            var rr = p.r + dr
            var cc = p.c + dc
            while isInBounds(rr, cc) {
                if let occ = pieceAt(r: rr, c: cc, in: state) {
                    if occ.isWhite != p.isWhite {
                        out.append(ChessMove(pieceID: p.id, fromR: p.r, fromC: p.c, toR: rr, toC: cc, capturedID: occ.id))
                    }
                    break
                } else {
                    out.append(ChessMove(pieceID: p.id, fromR: p.r, fromC: p.c, toR: rr, toC: cc, capturedID: nil))
                }
                rr += dr
                cc += dc
            }
        }

        return out
    }

    private func kingMoves(for p: ChessPiece, in state: [ChessPiece]) -> [ChessMove] {
        var out: [ChessMove] = []
        for dr in -1...1 {
            for dc in -1...1 {
                if dr == 0 && dc == 0 { continue }
                let rr = p.r + dr
                let cc = p.c + dc
                guard isInBounds(rr, cc) else { continue }

                if let occ = pieceAt(r: rr, c: cc, in: state) {
                    if occ.isWhite == p.isWhite { continue }
                    out.append(ChessMove(pieceID: p.id, fromR: p.r, fromC: p.c, toR: rr, toC: cc, capturedID: occ.id))
                } else {
                    out.append(ChessMove(pieceID: p.id, fromR: p.r, fromC: p.c, toR: rr, toC: cc, capturedID: nil))
                }
            }
        }
        return out
    }

    private func isKingInCheck(isWhite: Bool, in state: [ChessPiece]) -> Bool {
        guard let king = state.first(where: { $0.type == .king && $0.isWhite == isWhite }) else { return false }
        return isSquareAttacked(r: king.r, c: king.c, byWhite: !isWhite, in: state)
    }

    private func isSquareAttacked(r: Int, c: Int, byWhite: Bool, in state: [ChessPiece]) -> Bool {
        let attackers = state.filter { $0.isWhite == byWhite }

        for p in attackers {
            switch p.type {
            case .pawn:
                let dir = p.isWhite ? -1 : 1
                let rr = p.r + dir
                for dc in [-1, 1] {
                    let cc = p.c + dc
                    if rr == r && cc == c { return true }
                }

            case .knight:
                let deltas = [(-2,-1),(-2,1),(-1,-2),(-1,2),(1,-2),(1,2),(2,-1),(2,1)]
                for (dr, dc) in deltas {
                    if p.r + dr == r && p.c + dc == c { return true }
                }

            case .bishop:
                if attacksBySliding(from: p, targetR: r, targetC: c, in: state, directions: [(-1,-1),(-1,1),(1,-1),(1,1)]) { return true }

            case .rook:
                if attacksBySliding(from: p, targetR: r, targetC: c, in: state, directions: [(-1,0),(1,0),(0,-1),(0,1)]) { return true }

            case .queen:
                if attacksBySliding(from: p, targetR: r, targetC: c, in: state, directions: [(-1,-1),(-1,1),(1,-1),(1,1),(-1,0),(1,0),(0,-1),(0,1)]) { return true }

            case .king:
                if abs(p.r - r) <= 1 && abs(p.c - c) <= 1 { return true }
            }
        }

        return false
    }

    private func attacksBySliding(from p: ChessPiece, targetR: Int, targetC: Int, in state: [ChessPiece], directions: [(Int, Int)]) -> Bool {
        for (dr, dc) in directions {
            var rr = p.r + dr
            var cc = p.c + dc
            while isInBounds(rr, cc) {
                if rr == targetR && cc == targetC { return true }
                if pieceAt(r: rr, c: cc, in: state) != nil { break }
                rr += dr
                cc += dc
            }
        }
        return false
    }

    // MARK: - Apply Move

    private func applyMove(_ mv: ChessMove) {
        applyMove(mv, on: &pieces)

        if mv.capturedID != nil {
            let gen = UIImpactFeedbackGenerator(style: .light)
            gen.impactOccurred()
        }

        // If a king disappears (shouldn’t happen in legal chess, but guard anyway)
        let whiteKingExists = pieces.contains(where: { $0.type == .king && $0.isWhite })
        let blackKingExists = pieces.contains(where: { $0.type == .king && !$0.isWhite })
        if !whiteKingExists { setWinner(.ai) }
        if !blackKingExists { setWinner(.human) }

        // Normal end detection: if side to move has no legal moves, decide mate/stalemate
        if winner == .none {
            let nextToMove: ChessTurn = (turn == .human) ? .ai : .human
            let sideIsWhite = (nextToMove == .human)
            if allLegalMoves(isWhite: sideIsWhite, in: pieces).isEmpty {
                finalizeEndState(afterSideToMove: nextToMove)
            }
        }
    }

    private func applyMove(_ mv: ChessMove, on state: inout [ChessPiece]) {
        if let capID = mv.capturedID, let capIdx = state.firstIndex(where: { $0.id == capID }) {
            state.remove(at: capIdx)
        }

        guard let idx = state.firstIndex(where: { $0.id == mv.pieceID }) else { return }

        state[idx].r = mv.toR
        state[idx].c = mv.toC
        state[idx].hasMoved = true

        // Promotion
        if let promo = mv.promotesTo {
            state[idx].type = promo
        }
    }

    // MARK: - Helpers

    private func isInBounds(_ r: Int, _ c: Int) -> Bool {
        (0..<8).contains(r) && (0..<8).contains(c)
    }

    private func pieceAt(r: Int, c: Int) -> ChessPiece? {
        pieces.first(where: { $0.r == r && $0.c == c })
    }

    private func pieceAt(r: Int, c: Int, in state: [ChessPiece]) -> ChessPiece? {
        state.first(where: { $0.r == r && $0.c == c })
    }

    private func pieceByID(_ id: UUID) -> ChessPiece? {
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

            if winner == .human {
                showCompletePopup = true
                scheduleAutoNewGame(after: 2.2, hidePopup: true)
            } else if winner == .ai {
                showCompletePopup = true
                scheduleAutoNewGame(after: 0.9, hidePopup: true)
            } else if winner == .draw {
                showCompletePopup = true
                scheduleAutoNewGame(after: 1.5, hidePopup: true)
            } else if turn == .ai {
                scheduleAIMove()
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

        if keepDifficulty { difficulty = d }

        showCompletePopup = false
        showResetConfirm = false
        showDifficultyPopup = false

        saveState()
    }

    private func initialPieces() -> [ChessPiece] {
        var out: [ChessPiece] = []

        // Black (AI) at top
        out.append(ChessPiece(r: 0, c: 0, type: .rook,   isWhite: false, hasMoved: false))
        out.append(ChessPiece(r: 0, c: 1, type: .knight, isWhite: false, hasMoved: false))
        out.append(ChessPiece(r: 0, c: 2, type: .bishop, isWhite: false, hasMoved: false))
        out.append(ChessPiece(r: 0, c: 3, type: .queen,  isWhite: false, hasMoved: false))
        out.append(ChessPiece(r: 0, c: 4, type: .king,   isWhite: false, hasMoved: false))
        out.append(ChessPiece(r: 0, c: 5, type: .bishop, isWhite: false, hasMoved: false))
        out.append(ChessPiece(r: 0, c: 6, type: .knight, isWhite: false, hasMoved: false))
        out.append(ChessPiece(r: 0, c: 7, type: .rook,   isWhite: false, hasMoved: false))
        for c in 0..<8 {
            out.append(ChessPiece(r: 1, c: c, type: .pawn, isWhite: false, hasMoved: false))
        }

        // White (Human) at bottom
        for c in 0..<8 {
            out.append(ChessPiece(r: 6, c: c, type: .pawn, isWhite: true, hasMoved: false))
        }
        out.append(ChessPiece(r: 7, c: 0, type: .rook,   isWhite: true, hasMoved: false))
        out.append(ChessPiece(r: 7, c: 1, type: .knight, isWhite: true, hasMoved: false))
        out.append(ChessPiece(r: 7, c: 2, type: .bishop, isWhite: true, hasMoved: false))
        out.append(ChessPiece(r: 7, c: 3, type: .queen,  isWhite: true, hasMoved: false))
        out.append(ChessPiece(r: 7, c: 4, type: .king,   isWhite: true, hasMoved: false))
        out.append(ChessPiece(r: 7, c: 5, type: .bishop, isWhite: true, hasMoved: false))
        out.append(ChessPiece(r: 7, c: 6, type: .knight, isWhite: true, hasMoved: false))
        out.append(ChessPiece(r: 7, c: 7, type: .rook,   isWhite: true, hasMoved: false))

        return out
    }

    private func saveState() {
        let state = ChessPersistentState(
            pieces: pieces,
            turn: turn,
            difficulty: difficulty,
            selectedPieceID: selectedPieceID,
            didLogReward: didLogReward,
            winner: winner
        )
        do {
            let data = try JSONEncoder().encode(state)
            stateJSON = String(data: data, encoding: .utf8) ?? ""
        } catch { }
    }

    private func decodeState() -> ChessPersistentState? {
        guard !stateJSON.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return nil }
        guard let data = stateJSON.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(ChessPersistentState.self, from: data)
    }
}

// MARK: - Piece View

private struct ChessPieceView: View {
    let piece: ChessPiece
    let fill: Color
    let selected: Bool

    private var symbol: String {
        switch (piece.type, piece.isWhite) {
        case (.king, true):   return "♔"
        case (.queen, true):  return "♕"
        case (.rook, true):   return "♖"
        case (.bishop, true): return "♗"
        case (.knight, true): return "♘"
        case (.pawn, true):   return "♙"
        case (.king, false):  return "♚"
        case (.queen, false): return "♛"
        case (.rook, false):  return "♜"
        case (.bishop, false):return "♝"
        case (.knight, false):return "♞"
        case (.pawn, false):  return "♟"
        }
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(fill)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(selected ? 0.60 : 0.20), lineWidth: selected ? 3 : 2)
                )
                .shadow(color: .black.opacity(0.20), radius: 10, x: 0, y: 6)

            Text(symbol)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Color.black.opacity(piece.isWhite ? 0.65 : 0.75))
                .shadow(color: .black.opacity(0.10), radius: 2, x: 0, y: 1)
                .minimumScaleFactor(0.6)
        }
    }
}
