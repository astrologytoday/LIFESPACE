import SwiftUI

struct DeliveranceView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var contentOpacity: Double = 0.0

    let psalm86 = """
1 Bow down thine ear, O Lord, hear me: for I am poor and needy.

2 Preserve my soul; for I am holy: O thou my God, save thy servant that trusteth in thee.

3 Be merciful unto me, O Lord: for I cry unto thee daily.

4 Rejoice the soul of thy servant: for unto thee, O Lord, do I lift up my soul.

5 For thou, Lord, art good, and ready to forgive; and plenteous in mercy unto all them that call upon thee.

6 Give ear, O Lord, unto my prayer; and attend to the voice of my supplications.

7 In the day of my trouble I will call upon thee: for thou wilt answer me.

8 Among the gods there is none like unto thee, O Lord; neither are there any works like unto thy works.

9 All nations whom thou hast made shall come and worship before thee, O Lord; and shall glorify thy name.

10 For thou art great, and doest wondrous things: thou art God alone.

11 Teach me thy way, O Lord; I will walk in thy truth: unite my heart to fear thy name.

12 I will praise thee, O Lord my God, with all my heart: and I will glorify thy name for evermore.

13 For great is thy mercy toward me: and thou hast delivered my soul from the lowest hell.

14 O God, the proud are risen against me, and the assemblies of violent men have sought after my soul; and have not set thee before them.

15 But thou, O Lord, art a God full of compassion, and gracious, long suffering, and plenteous in mercy and truth.

16 O turn unto me, and have mercy upon me; give thy strength unto thy servant, and save the son of thine handmaid.

17 Shew me a token for good; that they which hate me may see it, and be ashamed: because thou, Lord, hast holpen me, and comforted me.
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

                    Text("Psalm 86")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .white.opacity(0.7), radius: 10)
                        .frame(maxWidth: .infinity, alignment: .center)

                    Text(psalm86)
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
