//
//  HangmanView.swift
//  LIFESPACE
//
//  Created by Mario Sbardella on 2025-12-23.
//

import SwiftUI

// MARK: - HangmanView

struct HangmanView: View {
    @EnvironmentObject var navModel: NavigationModel
    @StateObject private var vm = HangmanViewModel()

    @State private var appeared = false

    var body: some View {
        ZStack(alignment: .topLeading) {

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

                // Top bar
                HStack {
                    Button(action: { navModel.pop() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.black.opacity(0.22))
                            .clipShape(Circle())
                    }

                    Spacer()

                    Text("HANGMAN")
                        .font(.system(size: 26, weight: .heavy))
                        .foregroundColor(.white)
                        .shadow(radius: 4)
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : -10)
                        .animation(.easeInOut(duration: 0.4), value: appeared)

                    Spacer()

                    Button(action: { vm.startNewGame() }) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.black.opacity(0.22))
                            .clipShape(Circle())
                    }
                    .accessibilityLabel("New Game")
                }
                .padding(.horizontal, 18)
                .padding(.top, 14)

                // Hangman drawing
                HangmanDrawing(stage: vm.wrongGuessesCount, maxStages: vm.maxWrongGuesses)
                    .frame(height: 200)
                    .padding(.horizontal, 18)
                    .padding(.top, 4)

                // Status + attempts
                VStack(spacing: 8) {
                    Text(vm.statusText)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(radius: 3)

                    Text("Attempts Left: \(vm.attemptsLeft)")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white.opacity(0.95))
                }
                .padding(.horizontal, 18)

                // Word display
                WordDisplayView(display: vm.displayWord, isLongWord: vm.isLongWord)
                    .padding(.horizontal, 18)

                // Wrong letters
                if !vm.wrongLetters.isEmpty {
                    Text("Wrong: \(vm.wrongLetters.joined(separator: " "))")
                        .font(.system(size: 14, weight: .semibold, design: .monospaced))
                        .foregroundColor(.white.opacity(0.95))
                        .padding(.horizontal, 18)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                }

                // Keyboard
                LetterKeyboardView(
                    guessed: vm.guessedLetters,
                    isGameOver: vm.isGameOver,
                    onTap: { vm.guess(letter: $0) }
                )
                .padding(.horizontal, 14)

                // End-game buttons
                if vm.isGameOver {
                    VStack(spacing: 10) {
                        if vm.didLose {
                            Text("Answer: \(vm.word)")
                                .font(.system(size: 14, weight: .bold, design: .monospaced))
                                .foregroundColor(.white.opacity(0.95))
                                .padding(.horizontal, 18)
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                        }

                        Button(action: { vm.startNewGame() }) {
                            Text("PLAY AGAIN")
                                .font(.system(size: 16, weight: .heavy))
                                .foregroundColor(.white)
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity)
                                .background(Color.black.opacity(0.28))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.white.opacity(0.18), lineWidth: 1)
                                )
                        }
                        .padding(.horizontal, 18)
                    }
                    .padding(.bottom, 8)
                }

                Spacer(minLength: 10)
            }
        }
        .onAppear {
            appeared = true
            if vm.word.isEmpty { vm.startNewGame() }
        }
    }
}

// MARK: - ViewModel

final class HangmanViewModel: ObservableObject {

    @Published private(set) var word: String = ""
    @Published private(set) var guessedLetters: Set<String> = []
    @Published private(set) var wrongLetters: [String] = []
    @Published private(set) var attemptsLeft: Int = 6

    // You can change this to 7/8 if you want longer games
    let maxWrongGuesses: Int = 6

    // Word source (shared WordBank)
    private var allWords: [String] {
        WordBank.lifespaceWords
            .map { $0.uppercased() }
            .map { $0.replacingOccurrences(of: "–", with: "-") } // normalize en-dash if ever present
            .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    }

    var wrongGuessesCount: Int { wrongLetters.count }
    var isGameOver: Bool { didWin || didLose }

    // ✅ Only A–Z letters count toward winning
    var didWin: Bool {
        guard !word.isEmpty else { return false }

        let requiredLetters = Set(
            word.compactMap { ch -> String? in
                let s = String(ch)
                return s.range(of: "^[A-Z]$", options: .regularExpression) != nil ? s : nil
            }
        )
        return requiredLetters.isSubset(of: guessedLetters)
    }

    var didLose: Bool { attemptsLeft <= 0 && !didWin }

    var statusText: String {
        if didWin { return "YOU WIN 🎉" }
        if didLose { return "GAME OVER" }
        return "Guess the word"
    }

    var isLongWord: Bool { word.count >= 10 }

    // ✅ Auto-reveal spaces, hyphens, apostrophes, etc.
    // So "ORTHOMOLECULAR DIET" shows as "_ _ _ ... _   _ _ _ _"
    // and "POST-SSRI SEXUAL DYSFUNCTION" shows with "-" and spaces visible.
    var displayWord: String {
        guard !word.isEmpty else { return "" }

        let tokens: [String] = word.map { ch in
            let s = String(ch)

            // Preserve spaces as real gaps between groups
            if s == " " { return " " }

            // Auto-reveal any non A–Z characters (like "-")
            if s.range(of: "^[A-Z]$", options: .regularExpression) == nil {
                return s
            }

            return guessedLetters.contains(s) ? s : "_"
        }

        // Join letters with spaces, but keep real spaces as separators between words.
        // Example:
        // ["_","_","_"," ","_","_"] -> "_ _ _   _ _"
        var out: [String] = []
        for t in tokens {
            if t == " " {
                // Extra spacing between words
                out.append("  ")
            } else {
                out.append(t)
                out.append(" ")
            }
        }
        if out.last == " " { out.removeLast() }
        return out.joined()
    }

    func startNewGame() {
        word = allWords.randomElement() ?? "LIFESPACE"
        guessedLetters = []
        wrongLetters = []
        attemptsLeft = maxWrongGuesses
    }

    func guess(letter: String) {
        guard !isGameOver else { return }
        let upper = letter.uppercased()
        guard upper.count == 1 else { return }
        guard !guessedLetters.contains(upper) else { return }

        guessedLetters.insert(upper)

        if !word.contains(upper) {
            wrongLetters.append(upper)
            attemptsLeft = max(0, attemptsLeft - 1)
        }
    }
}

// MARK: - Word display

private struct WordDisplayView: View {
    let display: String
    let isLongWord: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.black.opacity(0.22))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.white.opacity(0.18), lineWidth: 1)
                )

            Text(display)
                .font(.system(size: isLongWord ? 20 : 24, weight: .heavy, design: .monospaced))
                .foregroundColor(.white)
                .padding(.vertical, 18)
                .padding(.horizontal, 14)
                .lineLimit(3)
                .minimumScaleFactor(0.55)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Keyboard

private struct LetterKeyboardView: View {
    let guessed: Set<String>
    let isGameOver: Bool
    let onTap: (String) -> Void

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 7)
    private let letters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ").map { String($0) }

    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(letters, id: \.self) { letter in
                let isUsed = guessed.contains(letter)

                Button(action: { onTap(letter) }) {
                    Text(letter)
                        .font(.system(size: 14, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                        .frame(height: 38)
                        .frame(maxWidth: .infinity)
                        .background(
                            (isUsed || isGameOver)
                            ? Color.black.opacity(0.18)
                            : Color.black.opacity(0.28)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white.opacity(isUsed ? 0.10 : 0.18), lineWidth: 1)
                        )
                        .opacity(isUsed ? 0.55 : 1.0)
                }
                .disabled(isUsed || isGameOver)
            }
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Hangman Drawing

private struct HangmanDrawing: View {
    let stage: Int
    let maxStages: Int

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            ZStack {
                // Panel
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.black.opacity(0.22))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color.white.opacity(0.18), lineWidth: 1)
                    )

                // Drawing area
                Canvas { context, size in
                    func line(_ from: CGPoint, _ to: CGPoint, width: CGFloat = 4) {
                        var path = Path()
                        path.move(to: from)
                        path.addLine(to: to)
                        context.stroke(path, with: .color(.white.opacity(0.95)), lineWidth: width)
                    }

                    func circle(_ center: CGPoint, radius: CGFloat, width: CGFloat = 4) {
                        let rect = CGRect(
                            x: center.x - radius,
                            y: center.y - radius,
                            width: radius * 2,
                            height: radius * 2
                        )
                        context.stroke(Path(ellipseIn: rect), with: .color(.white.opacity(0.95)), lineWidth: width)
                    }

                    // Gallows (always)
                    let baseY = h * 0.82
                    let leftX = w * 0.25
                    let rightX = w * 0.70
                    let topY = h * 0.18

                    line(CGPoint(x: leftX, y: baseY), CGPoint(x: rightX, y: baseY))             // base
                    line(CGPoint(x: leftX, y: baseY), CGPoint(x: leftX, y: topY))               // post
                    line(CGPoint(x: leftX, y: topY), CGPoint(x: w * 0.60, y: topY))             // beam
                    line(CGPoint(x: w * 0.60, y: topY), CGPoint(x: w * 0.60, y: h * 0.28))      // rope

                    // Body parts by stage (max 6)
                    // 1 head, 2 body, 3 left arm, 4 right arm, 5 left leg, 6 right leg
                    let headCenter = CGPoint(x: w * 0.60, y: h * 0.35)
                    let headR: CGFloat = min(w, h) * 0.07

                    let neck = CGPoint(x: headCenter.x, y: headCenter.y + headR)
                    let torsoEnd = CGPoint(x: headCenter.x, y: h * 0.58)

                    let armY = h * 0.46
                    let armLeft = CGPoint(x: headCenter.x - w * 0.10, y: armY)
                    let armRight = CGPoint(x: headCenter.x + w * 0.10, y: armY)

                    let legLeft = CGPoint(x: headCenter.x - w * 0.08, y: h * 0.74)
                    let legRight = CGPoint(x: headCenter.x + w * 0.08, y: h * 0.74)

                    if stage >= 1 { circle(headCenter, radius: headR) }
                    if stage >= 2 { line(neck, torsoEnd) }
                    if stage >= 3 { line(CGPoint(x: headCenter.x, y: armY), armLeft) }
                    if stage >= 4 { line(CGPoint(x: headCenter.x, y: armY), armRight) }
                    if stage >= 5 { line(torsoEnd, legLeft) }
                    if stage >= 6 { line(torsoEnd, legRight) }
                }
                .padding(18)
            }
        }
    }
}
