import SwiftUI

struct JournalView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var dreamJournalModel: DreamJournalModel

    @State private var todayDate: String = currentDateMMDD()

    var body: some View {
        ZStack {
            // Burnt parchment background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.8, green: 0.7, blue: 0.5),
                    Color(red: 0.5, green: 0.3, blue: 0.2)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            // Notebook gridlines
            GeometryReader { geo in
                Canvas { context, size in
                    let lineSpacing: CGFloat = 40
                    let lineColor = Color.white.opacity(0.15)

                    for y in stride(from: 0, through: size.height, by: lineSpacing) {
                        let line = Path { path in
                            path.move(to: CGPoint(x: 0, y: y))
                            path.addLine(to: CGPoint(x: size.width, y: y))
                        }
                        context.stroke(line, with: .color(lineColor), lineWidth: 0.6)
                    }
                }
            }

            VStack(spacing: 16) {
                Text("Dream Journal")
                    .font(.custom("Fabled Hand", size: 26))
                    .foregroundColor(.white)
                    .padding(.top)

                ScrollView {
                    VStack(alignment: .leading, spacing: 14) {
                        // 🆕 New Entry if allowed
                        if dreamJournalModel.canCreateEntry(for: todayDate) {
                            HStack {
                                Text(todayDate)
                                    .font(.custom("Fabled Hand", size: 20))
                                    .foregroundColor(.white)
                                    .frame(width: 60, alignment: .leading)

                                Button(action: {
                                    navModel.push("EntryView:new")
                                }) {
                                    Text("New Entry")
                                        .font(.custom("IM FELL DW Pica", size: 20))
                                        .foregroundColor(.white)
                                        .italic()
                                }
                            }
                            .padding(.horizontal)
                        }

                        // 📅 Entries
                        ForEach(sortedEntriesDescending()) { entry in
                            HStack {
                                Text(entry.date)
                                    .font(.custom("Fabled Hand", size: 20))
                                    .foregroundColor(.white)
                                    .frame(width: 60, alignment: .leading)

                                Button(action: {
                                    navModel.push("EntryView:\(entry.id.uuidString)")
                                }) {
                                    Text(entry.title)
                                        .font(.custom("IM FELL DW Pica", size: 20))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom, 48) // padding for home button
                }
            }

            // Floating Home Button (bottom right)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        navModel.push("HomeView")
                    }) {
                        Image(systemName: "house.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                            .padding(18)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(red: 0.8, green: 0.7, blue: 0.5),
                                        Color(red: 0.5, green: 0.3, blue: 0.2)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 6)
                    }
                    .padding(.bottom, 28)
                    .padding(.trailing, 20)
                }
            }
            .ignoresSafeArea()
        }
    }

    private func sortedEntriesDescending() -> [DreamEntry] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return dreamJournalModel.entries.sorted {
            guard let date1 = formatter.date(from: $0.date),
                  let date2 = formatter.date(from: $1.date) else { return false }
            return date1 > date2
        }
    }
}
