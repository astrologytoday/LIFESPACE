//
//  MenuPrioritySwipeModifier.swift
//  LIFESPACE
//
//  Created by Mario Sbardella on 2026-04-30.
//


import SwiftUI

struct MenuPrioritySwipeModifier: ViewModifier {
    @EnvironmentObject var navModel: NavigationModel

    var minimumDistance: CGFloat = 8
    var horizontalThreshold: CGFloat = 22
    var diagonalSensitivity: CGFloat = 0.45

    private var menuPriorityDragGesture: some Gesture {
        DragGesture(minimumDistance: minimumDistance)
            .onEnded { value in
                let absHorizontal = abs(value.translation.width)
                let absVertical = abs(value.translation.height)

                let shouldOpenMenu =
                    value.translation.width > horizontalThreshold &&
                    absHorizontal >= absVertical * diagonalSensitivity

                if shouldOpenMenu {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        navModel.showMenu = true
                    }
                }
            }
    }

    func body(content: Content) -> some View {
        content
            .simultaneousGesture(menuPriorityDragGesture)
    }
}

extension View {
    func menuPrioritySwipe(
        minimumDistance: CGFloat = 8,
        horizontalThreshold: CGFloat = 22,
        diagonalSensitivity: CGFloat = 0.45
    ) -> some View {
        self.modifier(
            MenuPrioritySwipeModifier(
                minimumDistance: minimumDistance,
                horizontalThreshold: horizontalThreshold,
                diagonalSensitivity: diagonalSensitivity
            )
        )
    }
}