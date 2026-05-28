import SwiftUI
import EventKit

struct ReminderImportListView: View {
    @StateObject var reminderManager = ReminderManager()
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
            VStack(spacing: 24) {
                Text("Import from Reminders")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.top, 40)

                if reminderManager.reminderLists.isEmpty {
                    ProgressView("Loading Reminders…")
                        .foregroundColor(.white)
                        .padding(.top, 40)
                } else {
                    ScrollView {
                        VStack(spacing: 14) {
                            ForEach(reminderManager.reminderLists, id: \.self) { list in
                                Button(action: {
                                    navModel.push("ReminderImportItemView_\(list.calendarIdentifier)")
                                }) {
                                    HStack {
                                        Text(list.title)
                                            .foregroundColor(.white)
                                            .font(.headline)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.white.opacity(0.8))
                                    }
                                    .padding(.vertical, 14)
                                    .padding(.horizontal, 22)
                                    .background(
                                        RoundedRectangle(cornerRadius: 14)
                                            .fill(Color.white.opacity(0.10))
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                                .shadow(radius: 2, y: 2)
                            }
                        }
                        .padding(.top, 16)
                    }
                }
            }
            .padding()
        }
        .onAppear {
            reminderManager.requestAccess { granted in
                if granted {
                    reminderManager.loadReminderLists()
                }
            }
        }
    }
}

