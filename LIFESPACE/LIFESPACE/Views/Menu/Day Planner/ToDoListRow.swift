import SwiftUI
import EventKit

struct ToDoListRow: View {
    let item: ToDoItem
    let onComplete: () -> Void
    let onLongPress: () -> Void

    @State private var isAnimatingCompletion: Bool = false

    var body: some View {
        HStack {
            Button(action: {
                isAnimatingCompletion = true

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    onComplete()
                }
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.white, lineWidth: 2)
                        .background(
                            isAnimatingCompletion || item.isCompleted ?
                            AnyView(
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color(red: 0.85, green: 1.0, blue: 0.85))
                            ) :
                            AnyView(Color.clear)
                        )
                        .frame(width: 28, height: 28)

                    if isAnimatingCompletion || item.isCompleted {
                        Image(systemName: "checkmark")
                            .foregroundColor(Color(red: 0.0, green: 0.4, blue: 0.2))
                            .font(.system(size: 16, weight: .bold))
                    }
                }
            }
            .padding(.trailing, 8)

            if item.isUrgent {
                Image(systemName: "exclamationmark.circle.fill")
                    .foregroundColor(.red)
                    .font(.system(size: 15, weight: .bold))
            }

            Text(item.title)
                .foregroundColor(item.isUrgent ? .red : .white)
                .font(.system(size: 14, weight: item.isUrgent ? .bold : .regular))
                .allowsTightening(true)
                .fixedSize(horizontal: false, vertical: true)
                .layoutPriority(1)

            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onLongPressGesture {
            onLongPress()
        }
        .transition(.opacity)
    }
}
