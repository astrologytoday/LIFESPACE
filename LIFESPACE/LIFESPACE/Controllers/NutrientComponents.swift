import SwiftUI
import UIKit

// MARK: - UILabel-backed text that NEVER hyphenates (no mid-word breaks)
struct NoHyphenText: UIViewRepresentable {
    let text: String
    var font: UIFont = .systemFont(ofSize: 16)
    var color: UIColor = .white
    var alignment: NSTextAlignment = .left

    func makeUIView(context: Context) -> UILabel {
        let l = UILabel()
        l.numberOfLines = 0
        l.lineBreakMode = .byWordWrapping
        l.setContentCompressionResistancePriority(.required, for: .vertical)
        l.setContentHuggingPriority(.required, for: .vertical)
        return l
    }

    func updateUIView(_ l: UILabel, context: Context) {
        let p = NSMutableParagraphStyle()
        p.hyphenationFactor = 0
        p.alignment = alignment
        l.attributedText = NSAttributedString(
            string: text,
            attributes: [
                .paragraphStyle: p,
                .font: font,
                .foregroundColor: color
            ]
        )
    }
}

// MARK: - One nutrient table (header + 2 columns)
struct SingleNutrientTable: View {
    let title: String
    let rows: [(label: String, value: String)]
    let onHeaderTap: () -> Void

    @State private var pulse = false

    // Visual constants
    private let corner: CGFloat = 20
    private let headerH: CGFloat = 52

    // Width model (from screen, safe for ScrollView)
    private var totalWidth: CGFloat {
        min(UIScreen.main.bounds.width, 900) - 20
    }
    private var labelWidth: CGFloat {
        let proposed = totalWidth * 0.28
        return min(150, max(110, proposed))
    }
    private var valueWidth: CGFloat { totalWidth - labelWidth }

    var body: some View {
        VStack(spacing: 0) {

            Button(action: onHeaderTap) {
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: headerH)
                    .scaleEffect(pulse ? 1.035 : 1.0)
                    .opacity(pulse ? 1.0 : 0.92)
                    .animation(
                        .easeInOut(duration: 1.4)
                            .repeatForever(autoreverses: true),
                        value: pulse
                    )
                    .onAppear { pulse = true }
            }
            .buttonStyle(.plain)
            .background(Color.black.opacity(0.50))
            .overlay(
                Rectangle()
                    .frame(height: 0.5)
                    .foregroundColor(.white.opacity(0.12)),
                alignment: .bottom
            )

            ForEach(rows.indices, id: \.self) { i in
                HStack(spacing: 0) {

                    NoHyphenText(
                        text: rows[i].label,
                        font: .italicSystemFont(ofSize: 16)
                    )
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                    .frame(width: labelWidth, alignment: .topLeading)
                    .background(Color.black.opacity(0.18))

                    ScrollView(.horizontal, showsIndicators: false) {
                        Text(rows[i].value)
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: false)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 12)
                    }
                    .frame(width: valueWidth, alignment: .leading)
                    .background(Color.black.opacity(0.08))
                }
                .overlay(Rectangle().frame(height: 0.5).foregroundColor(.white.opacity(0.12)), alignment: .top)
                .overlay(Rectangle().frame(height: 0.5).foregroundColor(.white.opacity(0.12)), alignment: .bottom)
                .overlay(Rectangle().frame(width: 0.5).foregroundColor(.white.opacity(0.12)), alignment: .leading)
                .overlay(Rectangle().frame(width: 0.5).foregroundColor(.white.opacity(0.12)), alignment: .trailing)
            }
        }
        .background(Color.white.opacity(0.09))
        .clipShape(RoundedRectangle(cornerRadius: corner, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: corner, style: .continuous)
                .stroke(Color.white.opacity(0.08), lineWidth: 0.5)
        )
        .fixedSize(horizontal: false, vertical: true)
    }
}
