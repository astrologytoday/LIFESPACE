import SwiftUI

struct BPDBuildingBlocksMatrixView: View {
    @Binding var selected: Int?
    let treatments: [(title: String, message: String)]

    // 3 rows × 4 cols; -1 makes the center gap
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
        // Compute sizes without GeometryReader so the view keeps a tight intrinsic height
        let containerW   = min(UIScreen.main.bounds.width, 900) - 24
        let totalHSpace  = hSpacing * 3        // 4 cols → 3 gaps
        let cellW        = max(88, (containerW - totalHSpace) / 4.0)
        let cellH        = max(52, cellW * 0.52)
        let gridHeight   = cellH * 3 + vSpacing * 2

        return ZStack {
            // STATIC GRID (doesn't move)
            VStack(spacing: vSpacing) {
                ForEach(pattern.indices, id: \.self) { r in
                    HStack(spacing: hSpacing) {
                        ForEach(pattern[r].indices, id: \.self) { c in
                            let idx = pattern[r][c]
                            if idx == -1 {
                                Color.clear
                                    .frame(width: cellW, height: cellH)
                            } else {
                                BPDMatrixCell(
                                    title: bubbleTitle(for: treatments[idx].title),
                                    selected: selected == idx,
                                    size: CGSize(width: cellW, height: cellH),
                                    corner: corner
                                ) {
                                    withAnimation(.easeInOut(duration: 0.15)) {
                                        selected = (selected == idx ? nil : idx)
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // CENTER POPUP (overlay; grid stays put)
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
        // clamp the height so ScrollView doesn't reserve extra whitespace
        .frame(height: gridHeight)
        .padding(.vertical, 2)
    }

    // Force clean two-line labels where needed
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

// MARK: - Reusable cell (BPD-specific to avoid conflicts)
private struct BPDMatrixCell: View {
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

                // Selected overlay
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
