import SwiftUI

struct SagittariusView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var contentOpacity: Double = 0.0

    var body: some View {
        ZStack {
            // Fire-like, expansive gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.35, green: 0.10, blue: 0.20),
                    Color(red: 0.15, green: 0.00, blue: 0.05)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    Spacer(minLength: 20)

                    Image("sagittarius-chart")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .scaledToFit()
                        .frame(width: 180)
                        .shadow(radius: 12)
                        .padding(.top, 10)

                    Text("November 22 – December 21")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.horizontal)

                    HStack(alignment: .top, spacing: 16) {
                        VStack(alignment: .leading, spacing: 14) {
                            infoRow(label: "Symbol:", value: "Centaur")
                            infoRow(label: "Ruling Planet:", value: "Jupiter ♃")
                            infoRow(label: "Element:", value: "Fire 🜂")
                            infoRow(label: "Mode:", value: "Mutable")
                            infoRow(label: "Keyword:", value: "Idealize")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                        .layoutPriority(1)

                        Image("sagittarius-symbol")
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
                    Sagittarius is a sign of expansion, enthusiasm, and unfiltered honesty. Ruled by Jupiter, it’s associated with philosophy, freedom, and the lifelong search for truth. These individuals are naturally curious, outspoken, and often drawn to big ideas like religion, ethics, or world exploration.

                    They speak directly and sometimes bluntly, driven by a need to express what they believe is right. Though this can ruffle feathers, their intentions are rarely harsh. At their best, Sagittarians are joyful, adventurous, and guided by a strong moral compass that helps them see life as a journey of growth.
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
