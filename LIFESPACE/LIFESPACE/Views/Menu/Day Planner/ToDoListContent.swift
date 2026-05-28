import SwiftUI
import EventKit

struct ToDoListContent: View {
    @Binding var tasks: [ToDoItem]
    @State private var selectedUrgentItem: ToDoItem? = nil

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(tasks.indices, id: \.self) { index in
                        ToDoListRow(
                            item: tasks[index],
                            onComplete: {
                                tasks[index].isCompleted = true
                            },
                            onLongPress: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedUrgentItem = tasks[index]
                                }
                            }
                        )
                    }
                }
            }

            if let selectedItem = selectedUrgentItem {
                ZStack {
                    Color.black.opacity(0.001)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedUrgentItem = nil
                            }
                        }

                    urgentPopup(for: selectedItem)
                }
                .zIndex(999)
            }
        }
    }

    func urgentPopup(for item: ToDoItem) -> some View {
        VStack(spacing: 10) {
            Text("Task urgent?")
                .foregroundColor(.white)
                .font(.system(size: 14, weight: .bold))

            HStack(spacing: 12) {
                Button("YES") {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        markUrgent(item)
                        selectedUrgentItem = nil
                    }
                }
                .foregroundColor(.white)
                .padding(.vertical, 6)
                .padding(.horizontal, 14)
                .background(Color.red)
                .cornerRadius(8)

                Button("NO") {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        removeUrgent(item)
                        selectedUrgentItem = nil
                    }
                }
                .foregroundColor(.white)
                .padding(.vertical, 6)
                .padding(.horizontal, 14)
                .background(Color.white.opacity(0.25))
                .cornerRadius(8)
            }
        }
        .padding(12)
        .background(Color.black.opacity(0.8))
        .cornerRadius(14)
        .shadow(radius: 8)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        .padding(.top, 20)
        .padding(.trailing, 40)
    }

    func markUrgent(_ item: ToDoItem) {
        guard let index = tasks.firstIndex(where: { $0.id == item.id }) else { return }
        tasks[index].isUrgent = true
        sortTasks()
    }

    func removeUrgent(_ item: ToDoItem) {
        guard let index = tasks.firstIndex(where: { $0.id == item.id }) else { return }
        tasks[index].isUrgent = false
        sortTasks()
    }

    func sortTasks() {
        tasks.sort {
            if $0.isUrgent != $1.isUrgent {
                return $0.isUrgent && !$1.isUrgent
            } else {
                return $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
            }
        }
    }
}
