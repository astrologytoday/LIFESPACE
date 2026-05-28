import SwiftUI
import EventKit

struct ReminderImportItemView: View {
    let calendar: EKCalendar
    @StateObject var reminderManager = ReminderManager()
    @EnvironmentObject var navModel: NavigationModel
    @Binding var tasks: [ToDoItem]
    @State private var importedIDs: Set<String> = []

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

            VStack(spacing: 16) {
                Text("Select a Reminder to Import")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.top)

                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(reminderManager.reminders, id: \.calendarItemIdentifier) { reminder in
                            if !importedIDs.contains(reminder.calendarItemIdentifier) {
                                HStack {
                                    Text(reminder.title?.isEmpty == false ? reminder.title! : "Untitled Reminder")
                                        .foregroundColor(.white)
                                        .lineLimit(2)
                                        .padding(.leading, 6)
                                    Spacer()
                                    Button(action: {
                                        importReminder(reminder)
                                    }) {
                                        ZStack {
                                            Circle()
                                                .fill(Color.white.opacity(0.20))
                                                .frame(width: 38, height: 38)
                                            Image(systemName: "arrow.down.to.line.alt")
                                                .foregroundColor(.green)
                                                .font(.system(size: 20, weight: .bold))
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 8)
                                Divider()
                            }
                        }
                    }
                }

                Spacer()

                Button(action: {
                    navModel.push("ToDoListView")
                }) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.white)
                        Text("To-Do List")
                            .foregroundColor(.white)
                            .bold()
                    }
                    .padding()
                    .background(Color(red: 0.20, green: 0.65, blue: 0.60).opacity(0.85))
                    .cornerRadius(14)
                }
                .padding(.bottom, 16)
            }
            .padding()
        }
        .onAppear {
            reminderManager.requestAccess { granted in
                if granted {
                    reminderManager.loadReminders(from: calendar) {}
                }
            }
        }
    }

    func importReminder(_ reminder: EKReminder) {
        let rawTitle = reminder.title ?? ""
        let title = rawTitle.isEmpty ? "Untitled Reminder" : rawTitle

        if !tasks.contains(where: { $0.title == title }) {
            tasks.append(ToDoItem(title: title, isCompleted: false))
        }

        // Instantly hide imported item
        importedIDs.insert(reminder.calendarItemIdentifier)
    }
}

