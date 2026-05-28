//
//  ExerciseTemplateView.swift
//  LIFESPACE
//
//  Created by Mario Sbardella on 2026-04-30.
//


import SwiftUI

struct ExerciseTemplateView: View {
    @EnvironmentObject var navModel: NavigationModel

    let title: String
    let gifName: String
    let description: LocalizedStringKey
    let nextScreen: String?

    @State private var isVisible = false

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                lifespaceGradient

                VStack(spacing: 8) {
                    Text(title)
                        .font(.custom("Avenir-Heavy", size: titleFontSize(for: geo)))
                        .foregroundColor(.white)
                        .underline()
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .minimumScaleFactor(0.75)
                        .padding(.horizontal, 18)
                        .padding(.top, geo.safeAreaInsets.top + 8)
                        .padding(.bottom, 2)

                    GifView(name: gifName)
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: gifHeight(for: geo)
                        )
                        .padding(.horizontal, 8)
                        .layoutPriority(1)

                    Text(description)
                        .font(.custom("Avenir", size: bodyFontSize(for: geo)))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .minimumScaleFactor(0.85)
                        .padding(.vertical, 14)
                        .padding(.horizontal, 14)
                        .frame(maxWidth: .infinity)
                        .background(descriptionCardGradient)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1.5)
                        )
                        .padding(.horizontal, 16)
                        .opacity(isVisible ? 1 : 0)

                    Spacer(minLength: 92)
                }

                bottomButtons
                    .padding(.bottom, max(geo.safeAreaInsets.bottom + 10, 20))
            }
            .ignoresSafeArea()
            .onAppear {
                withAnimation(.easeInOut(duration: 0.6)) {
                    isVisible = true
                }
            }
        }
    }

    private var bottomButtons: some View {
        HStack(spacing: 40) {
            circleButton(systemName: "arrow.left") {
                fadeThen {
                    navModel.pop()
                }
            }

            circleButton(systemName: "figure.strengthtraining.traditional", isResizable: true) {
                fadeThen {
                    navModel.push("FitnessSpaceView")
                }
            }

            circleButton(systemName: "arrow.right") {
                guard let nextScreen else { return }

                fadeThen {
                    navModel.push(nextScreen)
                }
            }
            .opacity(nextScreen == nil ? 0.35 : 1)
            .disabled(nextScreen == nil)
        }
    }

    private func circleButton(
        systemName: String,
        isResizable: Bool = false,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Circle()
                .fill(buttonGradient)
                .frame(width: 65, height: 65)
                .overlay {
                    if isResizable {
                        Image(systemName: systemName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 58, height: 58)
                            .foregroundColor(.black)
                    } else {
                        Image(systemName: systemName)
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.black)
                    }
                }
        }
    }

    private func fadeThen(_ action: @escaping () -> Void) {
        withAnimation(.easeInOut(duration: 0.4)) {
            isVisible = false
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.easeInOut(duration: 0.4)) {
                action()
            }
        }
    }

    private func titleFontSize(for geo: GeometryProxy) -> CGFloat {
        let height = geo.size.height

        if height < 760 {
            return 27
        } else if height < 840 {
            return 30
        } else {
            return 34
        }
    }

    private func bodyFontSize(for geo: GeometryProxy) -> CGFloat {
        geo.size.height < 760 ? 15 : 16
    }

    private func gifHeight(for geo: GeometryProxy) -> CGFloat {
        let height = geo.size.height

        if height < 760 {
            return 330
        } else if height < 840 {
            return 385
        } else {
            return 450
        }
    }

    private var lifespaceGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.35, green: 0.80, blue: 0.75),
                Color(red: 0.20, green: 0.65, blue: 0.60),
                Color(red: 0.10, green: 0.45, blue: 0.45)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }

    private var descriptionCardGradient: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.10, green: 0.65, blue: 0.55),
                        Color(red: 0.05, green: 0.75, blue: 0.60),
                        Color(red: 0.05, green: 0.90, blue: 0.75)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }

    private var buttonGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.85, green: 1.0, blue: 0.9),
                Color(red: 0.4, green: 0.9, blue: 0.8)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}