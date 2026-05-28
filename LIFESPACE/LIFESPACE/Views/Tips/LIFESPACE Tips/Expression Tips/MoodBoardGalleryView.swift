//
//  MoodBoardGalleryView.swift
//  LIFESPACE
//
//  Created by Mario Sbardella on 2025-12-23.
//

import SwiftUI

struct MoodBoardGalleryView: View {

    @EnvironmentObject var navModel: NavigationModel
    @AppStorage(MoodBoardStorage.boardsKey) private var moodBoardsJSON: String = "[]"

    @State private var boards: [MoodBoard] = []
    @State private var appeared = false

    // ✅ Delete confirmation
    @State private var showDeleteConfirm: Bool = false
    @State private var pendingDelete: MoodBoard? = nil

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
                    Button {
                        openLastMoodBoardOrPop()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 8)
                    }
                    .buttonStyle(.plain)

                    Spacer()

                    Text("MOOD BOARDS")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 10)
                        .animation(.easeInOut(duration: 0.4), value: appeared)

                    Spacer()

                    // ✅ Home button (replaces +)
                    Button {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            navModel.selectedScreen = "HomeView"
                            navModel.showMenu = false
                        }
                    } label: {
                        Image(systemName: "house.fill")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(Color(red: 0.06, green: 0.30, blue: 0.30))
                            .frame(width: 44, height: 44)
                            .background(Circle().fill(Color.white.opacity(0.96)))
                            .overlay(
                                Circle()
                                    .stroke(Color.white.opacity(0.85), lineWidth: 2)
                                    .shadow(color: Color.white.opacity(0.22), radius: 8)
                            )
                            .shadow(color: Color.black.opacity(0.18), radius: 10, x: 0, y: 6)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 8)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 18)
                .padding(.top, 18)

                Rectangle()
                    .fill(Color.white.opacity(0.9))
                    .frame(height: 2)
                    .padding(.horizontal, 34)

                // Content
                if boards.isEmpty {
                    VStack(spacing: 12) {
                        Text("No mood boards yet.")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)

                        Text("Tap back to create one.")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .padding(.top, 30)

                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 14) {
                            ForEach(boards) { board in
                                MoodBoardCard(
                                    board: board,
                                    onOpen: { open(board) },
                                    onAskDelete: { askDelete(board) }
                                )
                            }
                        }
                        .padding(.horizontal, 18)
                        .padding(.top, 8)
                        .padding(.bottom, 24)
                    }
                }
            }
        }
        .onAppear {
            appeared = true
            reloadBoards()
        }
        // ✅ Confirmation prompt
        .alert("Are you sure you want to delete this Mood Board?", isPresented: $showDeleteConfirm) {
            Button("Delete", role: .destructive) {
                if let board = pendingDelete {
                    delete(board)
                }
                pendingDelete = nil
            }
            Button("Cancel", role: .cancel) {
                pendingDelete = nil
            }
        }
    }

    private func openLastMoodBoardOrPop() {
        let sortedBoards = MoodBoardStorage
            .loadBoards(from: moodBoardsJSON)
            .sorted(by: { $0.createdAt > $1.createdAt })

        if let selectedID = UserDefaults.standard.string(forKey: MoodBoardKeys.selectedID),
           sortedBoards.contains(where: { $0.id == selectedID }) {

            UserDefaults.standard.set(selectedID, forKey: MoodBoardKeys.editingID)

            withAnimation(.easeInOut(duration: 0.4)) {
                navModel.push("MoodBoardView")
            }

        } else if let mostRecent = sortedBoards.first {

            UserDefaults.standard.set(mostRecent.id, forKey: MoodBoardKeys.selectedID)
            UserDefaults.standard.set(mostRecent.id, forKey: MoodBoardKeys.editingID)

            withAnimation(.easeInOut(duration: 0.4)) {
                navModel.push("MoodBoardView")
            }

        } else {
            navModel.pop()
        }
    }
    
    private func reloadBoards() {
        boards = MoodBoardStorage
            .loadBoards(from: moodBoardsJSON)
            .sorted(by: { $0.createdAt > $1.createdAt })
    }

    private func saveBoards() {
        moodBoardsJSON = MoodBoardStorage.saveBoards(boards)
    }

    private func askDelete(_ board: MoodBoard) {
        pendingDelete = board
        showDeleteConfirm = true
    }

    private func delete(_ board: MoodBoard) {
        // delete image files too (best effort)
        for el in board.elements {
            let url = MoodBoardStorage.imageURL(filename: el.imageFilename)
            try? FileManager.default.removeItem(at: url)
        }

        boards.removeAll(where: { $0.id == board.id })
        saveBoards()
    }

    private func open(_ board: MoodBoard) {
        // ✅ Open directly into editor (fixes "Unknown View" / no detail screen required)
        UserDefaults.standard.set(board.id, forKey: MoodBoardKeys.selectedID)
        UserDefaults.standard.set(board.id, forKey: MoodBoardKeys.editingID)

        withAnimation(.easeInOut(duration: 0.4)) {
            navModel.push("MoodBoardView")
        }
    }
}

// MARK: - Card

private struct MoodBoardCard: View {

    let board: MoodBoard
    let onOpen: () -> Void
    let onAskDelete: () -> Void

    var body: some View {
        HStack(spacing: 14) {

            MoodBoardPreview(board: board)
                .frame(width: 92, height: 68)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.75), lineWidth: 2)
                )
                .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 5)

            VStack(alignment: .leading, spacing: 6) {
                Text(board.title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                    .lineLimit(2)

                Text(formattedDate(board.createdAt))
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.black.opacity(0.6))
            }

            Spacer()

            Button {
                onAskDelete()
            } label: {
                Image(systemName: "trash.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color(red: 0.90, green: 0.15, blue: 0.15))
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(Color.white.opacity(0.96)))
                    .overlay(
                        Circle().stroke(Color.black.opacity(0.12), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 5)
            }
            .buttonStyle(.plain)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.96))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.white.opacity(0.75), lineWidth: 2)
        )
        .shadow(color: Color.black.opacity(0.16), radius: 12, x: 0, y: 7)
        .contentShape(RoundedRectangle(cornerRadius: 18))
        .onTapGesture {
            onOpen()
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        return df.string(from: date)
    }
}

// MARK: - Preview (mini canvas render)

private struct MoodBoardPreview: View {

    let board: MoodBoard

    var body: some View {
        GeometryReader { geo in
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)

                ForEach(board.elements.prefix(4)) { el in
                    if let img = MoodBoardStorage.readImage(filename: el.imageFilename) {
                        let w = max(geo.size.width, 1)
                        let h = max(geo.size.height, 1)
                        let offsetX = CGFloat(el.normalizedX) * w
                        let offsetY = CGFloat(el.normalizedY) * h

                        Image(uiImage: img)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70)
                            .scaleEffect(CGFloat(el.scale))
                            .rotationEffect(.radians(el.rotationRadians))
                            .offset(x: offsetX, y: offsetY)
                            .clipped()
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}
