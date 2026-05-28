import SwiftUI

struct CapricornView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var contentOpacity: Double = 0.0

    var body: some View {
        ZStack {
            // Capricorn earth-tone gradient (deep forest green)
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.08, green: 0.20, blue: 0.10),
                    Color(red: 0.02, green: 0.10, blue: 0.06)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    Spacer(minLength: 20)

                    Image("capricorn-chart")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .scaledToFit()
                        .frame(width: 180)
                        .shadow(radius: 12)
                        .padding(.top, 10)

                    Text("December 22 – January 19")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.horizontal)

                    HStack(alignment: .top, spacing: 16) {
                        VStack(alignment: .leading, spacing: 14) {
                            infoRow(label: "Symbol:", value: "Sea Goat")
                            infoRow(label: "Ruling Planet:", value: "Saturn ♄")
                            infoRow(label: "Element:", value: "Earth 🜃")
                            infoRow(label: "Mode:", value: "Cardinal")
                            infoRow(label: "Keyword:", value: "Achieve")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                        .layoutPriority(1)

                        Image("capricorn-symbol")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .scaledToFit()
                            .frame(maxWidth: 150, maxHeight: 150)
                            .padding(.trailing, 20)
                            .shadow(radius: 10)
                    }

                    Divider()
                        .background(.white)
                        .padding(.horizontal)

                    Text("""
                    Capricorn is disciplined, patient, and deeply committed to long-term goals. These individuals often carry a strong sense of duty and take their responsibilities seriously. Ruled by Saturn, they’re motivated by growth through structure and often climb steadily toward success, even if it takes time.

                    While they can be cautious or self-critical, their ability to endure setbacks makes them incredibly resilient. They value social order, tradition, and stability, and may feel uneasy when things feel uncertain. At their best, Capricorns lead with integrity and achieve through dedication, not shortcuts.
                    """)
                    .foregroundColor(.white)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal)

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
                    .padding(.bottom, 44)
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
        HStack(alignment: .top, spacing: 6) {
            Text("• \(label)")
                .foregroundColor(.white)
                .font(.system(size: 18, weight: .medium))
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)

            Text(value)
                .foregroundColor(.white)
                .font(.system(size: 18, weight: .medium))
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 0)
        }
    }
}
