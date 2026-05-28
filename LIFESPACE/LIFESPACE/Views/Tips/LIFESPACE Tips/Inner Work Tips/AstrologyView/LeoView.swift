import SwiftUI

struct LeoView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var contentOpacity: Double = 0.0

    var body: some View {
        ZStack {
            // Background Gradient – warm and bold
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.35, green: 0.05, blue: 0.15),
                    Color(red: 0.15, green: 0.00, blue: 0.05)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    Spacer(minLength: 20)

                    // Leo Chart
                    Image("leo-chart")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .scaledToFit()
                        .frame(width: 180)
                        .shadow(radius: 12)
                        .padding(.top, 10)

                    Text("July 23 – August 22")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.horizontal)

                    // Info Rows and Symbol
                    HStack(alignment: .top, spacing: 16) {
                        VStack(alignment: .leading, spacing: 14) {
                            infoRow(label: "Symbol:", value: "Lion")
                            infoRow(label: "Ruling Planet:", value: "Sun ☉")
                            infoRow(label: "Element:", value: "Fire 🜂")
                            infoRow(label: "Mode:", value: "Fixed")
                            infoRow(label: "Keyword:", value: "Creating")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                        .layoutPriority(1)

                        Image("leo-symbol")
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

                    // Description
                    Text("""
                    Leos are bold, expressive, and naturally drawn to the spotlight. They tend to lead with charisma and creativity, often choosing to share their passion through performance, art, or strong personal presence. Fueled by the Sun, they radiate warmth and confidence, with a powerful drive to be seen and appreciated.

                    They may come across as proud or attention-seeking at times, but beneath that is a genuine desire to inspire and uplift. Their courage, loyalty, and sense of purpose make them magnetic leaders who aren’t afraid to take the stage. Leo energy shines brightest when it's being shared.
                    """)
                    .foregroundColor(.white)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
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
