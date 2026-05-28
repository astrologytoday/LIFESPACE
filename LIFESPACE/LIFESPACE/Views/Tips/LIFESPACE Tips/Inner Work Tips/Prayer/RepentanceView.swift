import SwiftUI

struct RepentanceView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var contentOpacity: Double = 0.0

    let psalm51 = """
1 Have mercy upon me, O God, according to thy lovingkindness: according unto the multitude of thy tender mercies blot out my transgressions.

2 Wash me throughly from mine iniquity, and cleanse me from my sin.

3 For I acknowledge my transgressions: and my sin is ever before me.

4 Against thee, thee only, have I sinned, and done this evil in thy sight: that thou mightest be justified when thou speakest, and be clear when thou judgest.

5 Behold, I was shapen in iniquity; and in sin did my mother conceive me.

6 Behold, thou desirest truth in the inward parts: and in the hidden part thou shalt make me to know wisdom.

7 Purge me with hyssop, and I shall be clean: wash me, and I shall be whiter than snow.

8 Make me to hear joy and gladness; that the bones which thou hast broken may rejoice.

9 Hide thy face from my sins, and blot out all mine iniquities.

10 Create in me a clean heart, O God; and renew a right spirit within me.

11 Cast me not away from thy presence; and take not thy holy spirit from me.

12 Restore unto me the joy of thy salvation; and uphold me with thy free spirit.

13 Then will I teach transgressors thy ways; and sinners shall be converted unto thee.

14 Deliver me from bloodguiltiness, O God, thou God of my salvation: and my tongue shall sing aloud of thy righteousness.

15 O Lord, open thou my lips; and my mouth shall shew forth thy praise.

16 For thou desirest not sacrifice; else would I give it: thou delightest not in burnt offering.

17 The sacrifices of God are a broken spirit: a broken and a contrite heart, O God, thou wilt not despise.

18 Do good in thy good pleasure unto Zion: build thou the walls of Jerusalem.

19 Then shalt thou be pleased with the sacrifices of righteousness, with burnt offering and whole burnt offering: then shall they offer bullocks upon thine altar.
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

                    Text("Psalm 51")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .white.opacity(0.7), radius: 10)
                        .frame(maxWidth: .infinity, alignment: .center)

                    Text(psalm51)
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

