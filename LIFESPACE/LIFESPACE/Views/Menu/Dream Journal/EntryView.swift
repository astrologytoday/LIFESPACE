import SwiftUI

struct EntryView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var dreamJournalModel: DreamJournalModel

    let entryID: String
    let todayDate = currentDateMMDD()

    @State private var title: String = ""
    @State private var content: String = ""
    @State private var isEditingExisting = false
    @State private var existingEntryID: UUID?
    @State private var originalDate: String = ""
    @State private var showDeleteConfirmation = false

    // Light parchment color for text fields
    let parchment = Color(red: 0.96, green: 0.93, blue: 0.87)

    var body: some View {
        ZStack {
            // Ancient parchment/burnt paper gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.89, green: 0.80, blue: 0.60),
                    Color(red: 0.74, green: 0.65, blue: 0.47),
                    Color(red: 0.56, green: 0.46, blue: 0.32)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 22) {
                Text(isEditingExisting ? "Dream Entry" : "New Dream Entry")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                    .padding(.top, 10)

                TextField("Title", text: $title)
                    .font(.system(size: 21, weight: .semibold, design: .rounded))
                    .padding(12)
                    .background(parchment)
                    .cornerRadius(10)
                    .foregroundColor(.black)
                    .padding(.horizontal)
                    .padding(.bottom, 2)

                TextEditor(text: $content)
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                    .foregroundColor(.black)
                    .padding(12)
                    .scrollContentBackground(.hidden)
                    .background(parchment)
                    .cornerRadius(14)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.brown.opacity(0.16), lineWidth: 1)
                    )
                    .frame(minHeight: 220, maxHeight: .infinity)

                Button("Finish Entry") {
                    saveEntry()
                }
                .font(.system(size: 21, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .padding(.horizontal, 36)
                .padding(.vertical, 11)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.91, green: 0.79, blue: 0.56),
                            Color(red: 0.75, green: 0.64, blue: 0.43)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.13), radius: 6, x: 0, y: 3)

                // Trash icon with confirmation
                if isEditingExisting {
                    Button(action: {
                        showDeleteConfirmation = true
                    }) {
                        Image(systemName: "trash.fill")
                            .font(.system(size: 19))
                            .foregroundColor(.red)
                            .padding(10)
                            .background(Color.black.opacity(0.10))
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.10), radius: 2, x: 0, y: 2)
                    }
                    .accessibilityLabel("Delete Entry")
                    .padding(.top, 6)
                    .alert(isPresented: $showDeleteConfirmation) {
                        Alert(
                            title: Text("Delete Entry?"),
                            message: Text("Are you sure you want to permanently delete this dream journal entry?"),
                            primaryButton: .destructive(Text("Delete")) {
                                deleteEntry()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
            }
            .padding(.top, 10)
            .padding(.horizontal)
            .onAppear { loadEntryIfNeeded() }
        }
    }

    private func loadEntryIfNeeded() {
        if entryID != "new",
           let uuid = UUID(uuidString: entryID),
           let existing = dreamJournalModel.entries.first(where: { $0.id == uuid }) {
            title = existing.title
            content = existing.content
            existingEntryID = existing.id
            originalDate = existing.date
            isEditingExisting = true
        }
    }

    private func saveEntry() {
        if isEditingExisting, let id = existingEntryID {
            let updated = DreamEntry(id: id, date: originalDate, title: title, content: content)
            dreamJournalModel.updateEntry(updated)
        } else {
            dreamJournalModel.addEntry(title: title, content: content, date: todayDate)
        }
        navModel.pop()
    }

    private func deleteEntry() {
        if let id = existingEntryID {
            dreamJournalModel.deleteEntry(id)
        }
        navModel.pop()
    }
}

