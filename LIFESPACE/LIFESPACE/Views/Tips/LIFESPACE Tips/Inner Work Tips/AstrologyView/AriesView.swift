import SwiftUI

struct AriesView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var contentOpacity: Double = 0.0

    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.45, green: 0.10, blue: 0.20),
                    Color(red: 0.35, green: 0.00, blue: 0.15)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    Spacer(minLength: 20)

                    // Zodiac Circle Image as Title
                    Image("aries-chart")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .scaledToFit()
                        .frame(width: 180)
                        .shadow(radius: 12)
                        .padding(.top, 10)

                    Text("March 21 – April 19")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .center)

                    // Info Section + Aries Symbol
                    HStack(alignment: .top, spacing: 16) {
                        VStack(alignment: .leading, spacing: 14) {
                            infoRow(label: "Symbol:", value: "Ram")
                            infoRow(label: "Ruling Planet:", value: "Mars ♂︎")
                            infoRow(label: "Element:", value: "Fire 🜂")
                            infoRow(label: "Mode:", value: "Cardinal")
                            infoRow(label: "Keyword:", value: "Assert")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)

                        // Aries Ram Symbol (Large)
                        Image("aries-symbol")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .padding(.trailing, 20)
                            .shadow(radius: 10)
                    }

                    Divider()
                        .background(.white)
                        .padding(.horizontal)

                    // Description
                    Text("""
                    Aries are bold, direct, and full of life force. Ruled by Mars, they carry the energy of a new beginning; like a spark that ignites a fire. These individuals are natural pioneers, often diving headfirst into action before others have even decided what to do.

                    They’re driven by instinct, known for their courage and quick temper. Aries may struggle with patience, preferring movement over stillness and passion over passivity. Their leadership comes not from planning but from presence — they show up and make things happen.

                    The First House governs identity, and Aries thrives when exploring who they are through independence, action, and self-expression.
                    """)
                    .foregroundColor(.white)
                    .padding(.horizontal)

                    // Back Button
                    HStack {
                        Spacer()
                        Button(action: {
                            navModel.pop()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 28, weight: .medium))
                                .foregroundColor(.white)
                                .padding(24)
                                .background(Color.white.opacity(0.2))
                                .clipShape(Circle())
                                .shadow(radius: 8)
                        }
                        Spacer()
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 30)
                }
                .opacity(contentOpacity)
                .onAppear {
                    withAnimation(.easeInOut(duration: 0.6)) {
                        contentOpacity = 1.0
                    }
                }
            }
        }
    }

    // MARK: - Info Row Builder
    func infoRow(label: String, value: String) -> some View {
        HStack(spacing: 6) {
            Text("• \(label)")
                .foregroundColor(.white)
                .font(.system(size: 18, weight: .medium))

            Text(value)
                .foregroundColor(.white)
                .font(.system(size: 18, weight: .medium))
                .fixedSize() // ← prevents line wrapping

            Spacer()
        }
        .fixedSize(horizontal: true, vertical: false) // ← forces entire row to stay on one line
    }
}

