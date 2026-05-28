import SwiftUI

struct ProtectionView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var contentOpacity: Double = 0.0

    let psalm140 = """
1 Deliver me, O Lord, from the evil man: preserve me from the violent man;

2 Which imagine mischiefs in their heart; continually are they gathered together for war.

3 They have sharpened their tongues like a serpent; adders' poison is under their lips. Selah.

4 Keep me, O Lord, from the hands of the wicked; preserve me from the violent man; who have purposed to overthrow my goings.

5 The proud have hid a snare for me, and cords; they have spread a net by the wayside; they have set gins for me. Selah.

6 I said unto the Lord, Thou art my God: hear the voice of my supplications, O Lord.

7 O God the Lord, the strength of my salvation, thou hast covered my head in the day of battle.

8 Grant not, O Lord, the desires of the wicked: further not his wicked device; lest they exalt themselves. Selah.

9 As for the head of those that compass me about, let the mischief of their own lips cover them.

10 Let burning coals fall upon them: let them be cast into the fire; into deep pits, that they rise not up again.

11 Let not an evil speaker be established in the earth: evil shall hunt the violent man to overthrow him.

12 I know that the Lord will maintain the cause of the afflicted, and the right of the poor.

13 Surely the righteous shall give thanks unto thy name: the upright shall dwell in thy presence.
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

                    Text("Psalm 140")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .white.opacity(0.7), radius: 10)
                        .frame(maxWidth: .infinity, alignment: .center)

                    Text(psalm140)
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

