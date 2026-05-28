import SwiftUI

// -----------------------------------------------------------------------------
// MARK: - AnxietyBuildingBlocksMatrixView (FULL DROP-IN VERSION)
// -----------------------------------------------------------------------------
struct AnxietyBuildingBlocksMatrixView: View {
    @Binding var selected: Int?
    let treatments: [(title: String, message: String)]

    // 3 rows × 4 columns; -1 = empty gap in center
    private let pattern: [[Int]] = [
        [0, 1, 2, 3],
        [4, -1, -1, 5],
        [6, 7, 8, 9]
    ]

    // Layout constants
    private let hSpacing: CGFloat = 10
    private let vSpacing: CGFloat = 10
    private let corner: CGFloat  = 18

    var body: some View {

        // Compute cell sizes without forcing the grid wider than smaller iPhones
        let containerW = max(0, min(UIScreen.main.bounds.width, 900) - 24)
        let totalHSpace = hSpacing * 3
        let cellW = max(64, (containerW - totalHSpace) / 4.0)
        let cellH = max(52, cellW * 0.52)
        let gridHeight = cellH * 3 + vSpacing * 2

        return ZStack {

            // -----------------------------------------------------------------
            // STATIC GRID (identical to Depression version)
            // -----------------------------------------------------------------
            VStack(spacing: vSpacing) {
                ForEach(pattern.indices, id: \.self) { r in
                    HStack(spacing: hSpacing) {
                        ForEach(pattern[r].indices, id: \.self) { c in
                            let idx = pattern[r][c]

                            if idx == -1 {
                                Color.clear
                                    .frame(width: cellW, height: cellH)

                            } else {

                                MatrixCell(
                                    title: bubbleTitle(for: treatments[idx].title),
                                    selected: selected == idx,
                                    size: CGSize(width: cellW, height: cellH),
                                    corner: corner
                                ) {
                                    withAnimation(.easeInOut(duration: 0.15)) {
                                        // tap again to close popup
                                        selected = (selected == idx ? nil : idx)
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // -----------------------------------------------------------------
            // CENTER POPUP OVERLAY (identical to Depression's visual style)
            // -----------------------------------------------------------------
            if let i = selected {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.yellow.opacity(0.99),
                                    Color.orange.opacity(0.92)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.orange, lineWidth: 2)
                        )
                        .shadow(color: .yellow.opacity(0.22), radius: 10, y: 6)

                    Text(treatments[i].message)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .lineLimit(3)
                        .minimumScaleFactor(0.85)
                }
                .frame(width: cellW * 2.00, height: max(cellH * 1.05, 60))
                .allowsHitTesting(false)
                .transition(.opacity.combined(with: .scale))
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: gridHeight)
        .padding(.vertical, 2)
    }

    // -------------------------------------------------------------------------
    // MARK: - bubbleTitle (identical logic as Depression, adapted for Anxiety)
    // -------------------------------------------------------------------------
    private func bubbleTitle(for title: String) -> String {
        switch title {
        case "Light Therapy":             return "Light\nTherapy"
        case "Meditation/Yoga":           return "Meditation/\nYoga"
        case "Fitness Training":          return "Fitness\nTraining"
        case "Orthomolecular Diet":       return "Orthomolecular\nDiet"
        case "Vibrational Audio Therapy": return "Vibrational\nAudio Therapy"
        case "Occupational Therapy":      return "Occupational\nTherapy"
        case "Recreational Therapy":      return "Recreational\nTherapy"
        case "Sleep Optimization":        return "Sleep\nOptimization"
        case "Judgment-Free Community":   return "Judgment-Free\nCommunity"
        case "Art & Music Therapy":       return "Art & Music\nTherapy"
        default:                          return title
        }
    }
}

// -----------------------------------------------------------------------------
// MARK: - MatrixCell (EXACT FULL VERSION)
// -----------------------------------------------------------------------------
private struct MatrixCell: View {
    let title: String
    let selected: Bool
    let size: CGSize
    let corner: CGFloat
    let action: () -> Void

    var body: some View {
        Button(action: action) {

            ZStack {

                // Base
                RoundedRectangle(cornerRadius: corner)
                    .fill(Color.white.opacity(0.18))

                // Highlight on selection
                if selected {
                    RoundedRectangle(cornerRadius: corner)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.yellow.opacity(0.90),
                                    Color.orange.opacity(0.85)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                }

                // Border
                RoundedRectangle(cornerRadius: corner)
                    .stroke(
                        selected ? Color.yellow : Color.white.opacity(0.26),
                        lineWidth: selected ? 3 : 1
                    )

                // Label
                Text(title)
                    .font(.system(size: 13.5, weight: .semibold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 4)
                    .lineLimit(2)
                    .allowsTightening(true)
                    .minimumScaleFactor(0.60)
            }
            .frame(width: size.width, height: size.height)
        }
        .buttonStyle(.plain)
    }
}
