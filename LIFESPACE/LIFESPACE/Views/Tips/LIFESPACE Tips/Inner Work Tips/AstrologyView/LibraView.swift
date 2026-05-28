import SwiftUI

struct LibraView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var contentOpacity: Double = 0.0

    var body: some View {
        ZStack {
            // Libra background gradient (soft night sky tone)
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.10, green: 0.18, blue: 0.30),
                    Color(red: 0.03, green: 0.08, blue: 0.18)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    Spacer(minLength: 20)

                    Image("libra-chart")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .scaledToFit()
                        .frame(width: 180)
                        .shadow(radius: 12)
                        .padding(.top, 10)

                    Text("September 23 – October 22")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .center)

                    HStack(alignment: .top, spacing: 16) {
                        VStack(alignment: .leading, spacing: 14) {
                            infoRow(label: "Symbol:", value: "Scales")
                            infoRow(label: "Ruling Planet:", value: "Venus ♀")
                            infoRow(label: "Element:", value: "Air 🜁")
                            infoRow(label: "Mode:", value: "Cardinal")
                            infoRow(label: "Keyword:", value: "Relating")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)

                        Image("libra-symbol")
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

                    Text("""
                    Libra is the sign of relationships, beauty, and connection. These individuals are often diplomatic and fair-minded, easily relating to others and their environments. Ruled by Venus, they’re naturally drawn to aesthetics, social grace, and experiences that promote peace and understanding.

                    Partnership comes naturally to Libra, and they often feel most at ease when collaborating or sharing life with others. With a strong sense of justice, they care deeply about fairness. Still, they can sometimes hesitate when faced with tough decisions, weighing every side before choosing a path.
                    """)
                    .foregroundColor(.white)
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
                .fixedSize()

            Spacer()
        }
        .fixedSize(horizontal: true, vertical: false)
    }
}

