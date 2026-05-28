import SwiftUI

struct CancerView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var contentOpacity: Double = 0.0

    var body: some View {
        ZStack {
            // Cancer-style background: dark, lunar, emotional
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.15, green: 0.18, blue: 0.30),
                    Color(red: 0.07, green: 0.09, blue: 0.20)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    Spacer(minLength: 20)

                    // Cancer Zodiac Chart
                    Image("cancer-chart")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .scaledToFit()
                        .frame(width: 180)
                        .shadow(radius: 12)
                        .padding(.top, 10)

                    Text("June 21 – July 21")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .center)

                    // Info rows and symbol image
                    HStack(alignment: .top, spacing: 16) {
                        VStack(alignment: .leading, spacing: 14) {
                            infoRow(label: "Symbol:", value: "Crab")
                            infoRow(label: "Ruling Planet:", value: "Moon ☽")
                            infoRow(label: "Element:", value: "Water 🜄")
                            infoRow(label: "Mode:", value: "Cardinal")
                            infoRow(label: "Keyword:", value: "Feeling")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)

                        // Cancer Symbol (Crab)
                        Image("cancer-symbol")
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

                    // Rewritten Cancer description
                    Text("""
                    Cancer individuals are caring, intuitive, and instinctively protective of the people they love. Guided by the Moon, their emotions shift easily, giving them great empathy but also frequent mood changes. They are naturally drawn to security and tend to place strong importance on home, family, and a sense of belonging.

                    Although they may seem gentle or reserved on the surface, their feelings run deep, and they often make choices based on intuition. Cancer prefers subtlety over being confronted. Their sensitivity allows them to understand others with remarkable depth.
                    """)
                    .foregroundColor(.white)
                    .padding(.horizontal)

                    // Back button
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

