import SwiftUI

struct AssistanceView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var contentOpacity: Double = 0.0

    let psalm28 = """
1 Unto thee will I cry, O Lord my rock; be not silent to me: lest, if thou be silent to me, I become like them that go down into the pit.

2 Hear the voice of my supplications, when I cry unto thee, when I lift up my hands toward thy holy oracle.

3 Draw me not away with the wicked, and with the workers of iniquity, which speak peace to their neighbours, but mischief is in their hearts.

4 Give them according to their deeds, and according to the wickedness of their endeavours: give them after the work of their hands; render to them their desert.

5 Because they regard not the works of the Lord, nor the operation of his hands, he shall destroy them, and not build them up.

6 Blessed be the Lord, because he hath heard the voice of my supplications.

7 The Lord is my strength and my shield; my heart trusted in him, and I am helped: therefore my heart greatly rejoiceth; and with my song will I praise him.

8 The Lord is their strength, and he is the saving strength of his anointed.

9 Save thy people, and bless thine inheritance: feed them also, and lift them up for ever.
"""

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.35, green: 0.80, blue: 0.75),
                    Color(red: 0.20, green: 0.65, blue: 0.60),
                    Color(red: 0.10, green: 0.45, blue: 0.45)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Spacer(minLength: 20)

                    Text("Psalm 28")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .white.opacity(0.7), radius: 10)
                        .frame(maxWidth: .infinity, alignment: .center)

                    Text(psalm28)
                        .font(.system(size: 20, weight: .regular, design: .serif))
                        .italic()
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
}
