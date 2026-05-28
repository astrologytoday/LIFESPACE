//
//  LIFESPACEGamesView.swift
//  LIFESPACE
//
//  Created by Mario Sbardella on 2025-12-21.
//

import SwiftUI

struct LIFESPACEGamesView: View {
    @EnvironmentObject var navModel: NavigationModel

    var body: some View {
        ZStack {
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

            VStack(spacing: 18) {
                Text("LIFESPACE Games")
                    .font(.system(size: 42, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(radius: 4)
                    .padding(.top, 18)

                Text("Sharpen Your Mind With Brain Games")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.bottom, 6)

                // ✅ Game buttons
                VStack(spacing: 14) {

                    // Word Search
                    Button {
                        navModel.push("WordSearchView")
                    } label: {
                        GameCardRow(
                            icon: "textformat.abc",
                            title: "Word Search",
                            subtitle: "A classic word search puzzle game."
                        )
                    }
                    .buttonStyle(.plain)

                    // ✅ Hangman
                    Button {
                        navModel.push("HangmanView")
                    } label: {
                        GameCardRow(
                            icon: "figure.stand",
                            title: "Hangman",
                            subtitle: "Guess the letters to try and solve the word."
                        )
                    }
                    .buttonStyle(.plain)

                    // Checkers
                    Button {
                        navModel.push("CheckersView")
                    } label: {
                        GameCardRow(
                            icon: "crown.fill",
                            title: "Checkers",
                            subtitle: "Jump opponent pieces and clear the board."
                        )
                    }
                    .buttonStyle(.plain)

                    // Chess
                    Button {
                        navModel.push("ChessView")
                    } label: {
                        GameCardRow(
                            icon: "checkerboard.rectangle",
                            title: "Chess",
                            subtitle: "Classic chess strategy board game."
                        )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 18)

                Spacer()

                Button {
                    navModel.pop()
                } label: {
                    Text("BACK")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .frame(width: 160)
                        .background(Color.white.opacity(0.14))
                        .cornerRadius(18)
                        .shadow(radius: 8)
                }
                .padding(.bottom, 18)
            }
        }
    }
}

// MARK: - Reusable Card

private struct GameCardRow: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)

                Text(subtitle)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.9))
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white.opacity(0.9))
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.16))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.25), lineWidth: 1)
                )
        )
        .shadow(radius: 12)
    }
}
