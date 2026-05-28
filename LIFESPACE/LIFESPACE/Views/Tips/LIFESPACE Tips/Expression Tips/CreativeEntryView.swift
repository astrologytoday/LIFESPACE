import SwiftUI

struct CreativeEntryView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var creativeWritingModel: CreativeWritingModel

    let entryID: String
    let todayDate = currentDateMMDD()

    @State private var title: String = ""
    @State private var content: String = ""
    @State private var isEditingExisting = false
    @State private var existingEntryID: UUID?
    @State private var originalDate: String = ""
    @State private var originalCreatedAt: Date = Date()
    @State private var showDeleteConfirmation = false

    let lightCard = Color.white.opacity(0.92)

    var body: some View {
        ZStack {
            // ✅ NEW: Purple/Navy gradient (matches CreativeWritingView)
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.22, green: 0.18, blue: 0.55),
                    Color(red: 0.14, green: 0.18, blue: 0.45),
                    Color(red: 0.08, green: 0.10, blue: 0.22)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 22) {

                Text(isEditingExisting ? "Creative Entry" : "New Entry")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.top, 10)

                TextField("Title", text: $title)
                    .font(.system(size: 21, weight: .semibold, design: .rounded))
                    .padding(12)
                    .background(lightCard)
                    .cornerRadius(10)
                    .foregroundColor(.black)
                    .padding(.horizontal)
                    .padding(.bottom, 2)

                TextEditor(text: $content)
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                    .foregroundColor(.black)
                    .padding(12)
                    .scrollContentBackground(.hidden)
                    .background(lightCard)
                    .cornerRadius(14)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.black.opacity(0.10), lineWidth: 1)
                    )
                    .frame(minHeight: 220, maxHeight: .infinity)

                Button("Finish Entry") {
                    saveEntry()
                }
                .font(.system(size: 21, weight: .semibold, design: .rounded))
                .foregroundColor(.black)
                .padding(.horizontal, 36)
                .padding(.vertical, 11)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.92),
                            Color.white.opacity(0.70)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.18), radius: 10, x: 0, y: 7)

                // Trash button w/ confirm
                if isEditingExisting {
                    Button(action: {
                        showDeleteConfirmation = true
                    }) {
                        Image(systemName: "trash.fill")
                            .font(.system(size: 19))
                            .foregroundColor(.red)
                            .padding(10)
                            .background(Color.white.opacity(0.18))
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.14), radius: 6, x: 0, y: 5)
                    }
                    .accessibilityLabel("Delete Entry")
                    .padding(.top, 6)
                    .alert(isPresented: $showDeleteConfirmation) {
                        Alert(
                            title: Text("Delete Entry?"),
                            message: Text("Are you sure you want to permanently delete this entry?"),
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
           let existing = creativeWritingModel.entries.first(where: { $0.id == uuid }) {

            title = existing.title
            content = existing.content
            existingEntryID = existing.id
            originalDate = existing.date
            originalCreatedAt = existing.createdAt
            isEditingExisting = true
        }
    }

    private func saveEntry() {
        if isEditingExisting, let id = existingEntryID {
            let updated = CreativeEntry(
                id: id,
                date: originalDate,
                createdAt: originalCreatedAt,   // ✅ preserve timestamp
                title: title,
                content: content
            )
            creativeWritingModel.updateEntry(updated)
        } else {
            creativeWritingModel.addEntry(title: title, content: content, date: todayDate)
        }
        navModel.pop()
    }

    private func deleteEntry() {
        if let id = existingEntryID {
            creativeWritingModel.deleteEntry(id)
        }
        navModel.pop()
    }
}
