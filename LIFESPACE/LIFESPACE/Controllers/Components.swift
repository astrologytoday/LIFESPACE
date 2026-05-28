// MARK: - Reusable Toggle Component
import SwiftUI

struct QuestionToggle: View {
    let question: String
    @Binding var selection: Bool?

    var body: some View {
        VStack(spacing: 12) {
            Text(question)
                .foregroundColor(.white)
                .font(Font.custom("Avenir", size: 18).weight(.medium))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 10)

            HStack(spacing: 30) {
                AnswerButton(
                    label: "Yes",
                    isSelected: selection == true
                ) {
                    selection = true
                }

                AnswerButton(
                    label: "No",
                    isSelected: selection == false
                ) {
                    selection = false
                }
            }
        }
    }
}

// MARK: - Custom Answer Button
struct AnswerButton: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(Font.custom("Avenir", size: 18).weight(.medium))
                .foregroundColor(.white)
                .frame(width: 160, height: 48)
                .background(isSelected ? Color.white.opacity(0.35) : Color.white.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? Color.white : Color.clear, lineWidth: 2)
                )
                .cornerRadius(12)
                .shadow(color: isSelected ? .white.opacity(0.4) : .clear, radius: 4, x: 0, y: 2)
        }
        .animation(.easeInOut(duration: 0.3), value: isSelected)
    }
}

