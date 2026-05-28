import SwiftUI

struct MoodBoardDetailView: View {

    @EnvironmentObject var navModel: NavigationModel
    @AppStorage(MoodBoardStorage.boardsKey) private var moodBoardsJSON: String = "[]"

    @State private var board: MoodBoard? = nil
    @State private var appeared = false

    private var selectedID: String? {
        UserDefaults.standard.string(forKey: MoodBoardKeys.selectedID)
    }

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
                        navModel.pop()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 8)
                    }
                    .buttonStyle(.plain)

                    Spacer()

                    Text(board?.title ?? "NEW MOOD BOARD")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 10)
                        .animation(.easeInOut(duration: 0.4), value: appeared)

                    Spacer()

                    Button {
                        guard let board else { return }

                        // ✅ Set editing id so MoodBoardView loads and edits THIS board
                        UserDefaults.standard.set(board.id, forKey: MoodBoardKeys.editingID)
                        UserDefaults.standard.set(board.id, forKey: MoodBoardKeys.selectedID)

                        withAnimation(.easeInOut(duration: 0.4)) {
                            navModel.push("MoodBoardView")
                        }
                    } label: {
                        Image(systemName: "pencil.circle.fill")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
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

                if let board {
                    MoodBoardViewerCanvas(board: board)
                        .padding(.horizontal, 18)
                        .padding(.top, 6)
                        .padding(.bottom, 18)
                } else {
                    VStack(spacing: 12) {
                        Text("Couldn’t load this mood board.")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)

                        Button {
                            navModel.pop()
                        } label: {
                            Text("Go Back")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.95)))
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.top, 30)

                    Spacer()
                }
            }
        }
        .onAppear {
            appeared = true
            loadBoard()
        }
    }

    private func loadBoard() {
        guard let selectedID else {
            board = nil
            return
        }

        let allBoards = MoodBoardStorage.loadBoards(from: moodBoardsJSON)
        board = allBoards.first(where: { $0.id == selectedID })
    }
}

// MARK: - Viewer Canvas (non-editable)

private struct MoodBoardViewerCanvas: View {

    let board: MoodBoard

    var body: some View {
        GeometryReader { geo in
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white.opacity(0.98))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black.opacity(0.85), lineWidth: 3)
                    )

                ForEach(board.elements) { el in
                    if let img = MoodBoardStorage.readImage(filename: el.imageFilename) {
                        let w = max(geo.size.width, 1)
                        let h = max(geo.size.height, 1)
                        let offsetX = CGFloat(el.normalizedX) * w
                        let offsetY = CGFloat(el.normalizedY) * h

                        Image(uiImage: img)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 240)
                            .scaleEffect(CGFloat(el.scale))
                            .rotationEffect(.radians(el.rotationRadians))
                            .offset(x: offsetX, y: offsetY)
                            .shadow(color: Color.black.opacity(0.22), radius: 6, x: 0, y: 3)
                    }
                }
            }
            .highPriorityGesture(
                DragGesture(minimumDistance: 10, coordinateSpace: .local)
                    .onChanged { _ in }
            )
        }
        .aspectRatio(1.0, contentMode: .fit)
    }
}
