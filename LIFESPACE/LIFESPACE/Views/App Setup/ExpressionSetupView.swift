import SwiftUI

struct ExpressionSetupView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var userProfile: UserProfileModel
    @AppStorage("returnToConfirmation") private var returnToConfirmation: Bool = false
    @AppStorage("cameFromConfirmationExpression") private var cameFromConfirmationExpression: Bool = false

    @State private var showOptions = false
    @State private var selectedExpression: String?
    @State private var showTitle = false
    @State private var canNavigate = true

    var expressionOptions: [String] {
        var base = [
            "COOKING", "MUSIC", "DANCE", "ART", "WRITING",
            "SPIRITUALITY", "FASHION", "PHOTOGRAPHY", "DESIGN"
        ]

        let custom = userProfile.customExpression?.trimmingCharacters(in: .whitespacesAndNewlines)
        if let custom = custom, !custom.isEmpty {
            base.append(custom)
        } else {
            base.append("CUSTOM SKILL")
        }

        return base
    }

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

            VStack(spacing: 30) {
                Text("What Makes You Creative?")
                    .font(Font.custom("Avenir", size: 26).weight(.bold))
                    .foregroundColor(.white)
                    .padding(.top, 60)
                    .opacity(showTitle ? 1 : 0)
                    .animation(.easeInOut(duration: 1), value: showTitle)

                if showOptions {
                    VStack(spacing: 16) {
                        ForEach(expressionOptions, id: \.self) { expression in
                            Button(action: {
                                handleSelection(expression)
                            }) {
                                Text(expression)
                                    .font(Font.custom("Avenir", size: 18).weight(.medium))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(selectedExpression == expression ? Color.white.opacity(0.3) : Color.white.opacity(0.15))
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(selectedExpression == expression ? Color.white : Color.clear, lineWidth: 2)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal)
                    .transition(.opacity)
                }

                Spacer()
            }
            .padding(.bottom, 40)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if !showOptions {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showOptions = true
                }
            }
        }
        .onAppear {
            withAnimation { showTitle = true }

            if returnToConfirmation {
                cameFromConfirmationExpression = true
                returnToConfirmation = false
            }

            selectedExpression = userProfile.expressionOptions.first
        }
    }

    func handleSelection(_ expression: String) {
        if expression == "CUSTOM SKILL" && userProfile.customExpression == nil {
            // ❗️Preserve cameFromConfirmation before leaving
            if returnToConfirmation {
                cameFromConfirmationExpression = true
            }
            navModel.push("CustomCreativeView")
            return
        }

        guard canNavigate else { return }
        canNavigate = false

        selectedExpression = expression
        userProfile.expressionOptions = [expression]

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            if cameFromConfirmationExpression {
                cameFromConfirmationExpression = false
                navModel.push("SetupConfirmationView")
            } else {
                navModel.push("InnerWorkInfoView")
            }
        }
    }
}

