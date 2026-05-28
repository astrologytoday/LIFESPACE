import SwiftUI

struct VirgoView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var contentOpacity: Double = 0.0

    var body: some View {
        ZStack {
            // Virgo earth-tone gradient (deep green)
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.10, green: 0.25, blue: 0.15),
                    Color(red: 0.04, green: 0.15, blue: 0.10)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    Spacer(minLength: 20)

                    Image("virgo-chart")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .scaledToFit()
                        .frame(width: 180)
                        .shadow(radius: 12)
                        .padding(.top, 10)

                    Text("August 23 – September 22")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .center)

                    HStack(alignment: .top, spacing: 16) {
                        VStack(alignment: .leading, spacing: 14) {
                            infoRow(label: "Symbol:", value: "Maiden")
                            infoRow(label: "Ruling Planet:", value: "Mercury ☿")
                            infoRow(label: "Element:", value: "Earth 🜃")
                            infoRow(label: "Mode:", value: "Mutable")
                            infoRow(label: "Keyword:", value: "Analyze")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)

                        Image("virgo-symbol")
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
                    Virgo is attentive, thoughtful, and deeply concerned with doing things the right way. They have a natural gift for organization, precision, and analysis. Many are drawn to healing and practical service, finding fulfillment in supporting others behind the scenes.

                    Order helps them feel grounded, but if they haven’t yet discovered their ideal system, their environment may reflect inner tension. While Virgo seeks clarity and improvement, their deeper strength lies in their devotion, reliability, and drive to create something meaningful through care and consistency.
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

