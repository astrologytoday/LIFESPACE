import SwiftUI

struct MenuTutorialView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var showInstruction = false
    @State private var textOpacity = 0.0
    @State private var hasOpenedMenu = false
    @State private var showArrows = false
    @State private var showTapHint = true
    @State private var tapHintOpacity = 0.0
    @AppStorage("hasSeenMenuTutorial") private var hasSeenMenuTutorial: Bool = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Teal Background
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

                // Tap Hint Animation (fades out on tap)
                if showTapHint {
                    VStack {
                        Spacer()
                        Image(systemName: "hand.tap")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.white.opacity(0.7))
                            .opacity(tapHintOpacity)
                            .onAppear {
                                withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                                    tapHintOpacity = 1.0
                                }
                            }
                        Spacer()
                    }
                }

                // Instruction Box
                if showInstruction {
                    VStack {
                        Text("Swipe right to open the menu and then tap on your screen to close it.")
                            .font(Font.custom("Avenir", size: 18).weight(.medium))
                            .foregroundColor(.white)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.1))
                            )
                            .opacity(textOpacity)
                            .onAppear {
                                withAnimation(.easeInOut(duration: 0.6)) {
                                    textOpacity = 1.0
                                }
                            }
                            .padding(.top, geometry.size.height / 3)

                        Spacer()
                    }
                }

                // Navigation Arrows (fade in AFTER tap + closing menu once)
                if showInstruction && hasOpenedMenu {
                    VStack {
                        Spacer()
                        HStack {
                            NavArrowButton(
                                direction: .left,
                                target: "LifespaceInfoView",
                                padding: EdgeInsets(top: 0, leading: 30, bottom: 30, trailing: 0)
                            )

                            Spacer()

                            NavArrowButton(
                                direction: .right,
                                target: "OptimizationInfoView",
                                padding: EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 30)
                            )
                        }
                    }
                    .opacity(showArrows ? 1 : 0)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.6)) {
                            showArrows = true
                        }
                    }
                }
            }
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showTapHint = false
                    showInstruction = true
                }
            }
            .onChange(of: navModel.showMenu) { isMenuOpen in
                if !isMenuOpen && !hasOpenedMenu {
                    hasOpenedMenu = true
                }
            }
        }
        .onAppear {
            hasSeenMenuTutorial = true
        }
    }
}

