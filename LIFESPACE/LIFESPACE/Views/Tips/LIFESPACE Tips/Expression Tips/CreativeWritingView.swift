import SwiftUI

struct CreativeWritingView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var creativeWritingModel: CreativeWritingModel

    // ✅ Keep these as one source of truth
    private let lineSpacing: CGFloat = 40

    // ✅ Fine-tune these in 1–2pt increments
    private let headerGap: CGFloat = 8      // space between title bar and first entry
    private let textOffsetY: CGFloat = 2     // + moves DOWN, - moves UP

    var body: some View {
        ZStack {
            // ✅ Purple/Navy gradient
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

            // Notebook gridlines
            GeometryReader { _ in
                Canvas { context, size in
                    let lineColor = Color.white.opacity(0.12)

                    for y in stride(from: 0, through: size.height, by: lineSpacing) {
                        let line = Path { path in
                            path.move(to: CGPoint(x: 0, y: y))
                            path.addLine(to: CGPoint(x: size.width, y: y))
                        }
                        context.stroke(line, with: .color(lineColor), lineWidth: 0.6)
                    }
                }
            }

            VStack(spacing: 14) {

                // ✅ Top bar with title + plus
                HStack {
                    Text("Creative Writing")
                        .font(.custom("Fabled Hand", size: 26))
                        .foregroundColor(.white)

                    Spacer()

                    Button(action: {
                        navModel.push("CreativeEntryView:new")
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                            .padding(10)
                            .background(Color.white.opacity(0.92))
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.18), radius: 8, x: 0, y: 5)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("New Entry")
                }
                .padding(.horizontal)
                .padding(.top)

                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 0) {

                        // ✅ Adjustable space under header (in pt, not rows)
                        Color.clear
                            .frame(height: headerGap)

                        ForEach(creativeWritingModel.sortedEntriesNewestFirst()) { entry in
                            HStack(spacing: 12) {
                                Text(entry.date)
                                    .font(.custom("Fabled Hand", size: 20))
                                    .foregroundColor(.white)
                                    .frame(width: 60, alignment: .leading)

                                Button(action: {
                                    navModel.push("CreativeEntryView:\(entry.id.uuidString)")
                                }) {
                                    Text(entry.title.isEmpty ? "Untitled" : entry.title)
                                        .font(.custom("IM FELL DW Pica", size: 20))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(.horizontal)
                            .frame(height: lineSpacing, alignment: .bottom) // ✅ locks row to grid
                            .offset(y: textOffsetY)                        // ✅ fine vertical alignment
                        }

                        if creativeWritingModel.entries.isEmpty {
                            Text("Tap + to start a new entry.")
                                .font(.custom("IM FELL DW Pica", size: 20))
                                .foregroundColor(.white.opacity(0.85))
                                .padding(.horizontal)
                                .frame(height: lineSpacing, alignment: .bottom)
                                .offset(y: textOffsetY)
                                .padding(.top, 10)
                        }
                    }
                    .padding(.bottom, 90)
                }

                Spacer()
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
                                        Color.white.opacity(0.92),
                                        Color.white.opacity(0.72)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.18), radius: 10, x: 0, y: 7)
                    }
                    .padding(.bottom, 28)
                    .padding(.trailing, 20)
                }
            }
            .ignoresSafeArea()
        }
    }
}
