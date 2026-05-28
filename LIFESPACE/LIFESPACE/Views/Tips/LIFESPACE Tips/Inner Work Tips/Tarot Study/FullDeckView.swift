import SwiftUI
import Foundation

struct FullDeckView: View {
    @EnvironmentObject var navModel: NavigationModel

    @State private var shuffledDeck: [TarotCard] = []
    @State private var currentCardIndex = 0
    @State private var showMeaning = false
    @State private var rotation: Double = 0

    private let cardWidth = UIScreen.main.bounds.width * 0.8
    private let cardHeight = UIScreen.main.bounds.height * 0.55

    var body: some View {
        ZStack(alignment: .topLeading) {

            LinearGradient(
                colors: [
                    Color(.black),
                    Color(.purple).opacity(0.4)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            Button(action: {
                withAnimation(.easeInOut(duration: 0.4)) {
                    navModel.pop()
                }
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                    .padding()
            }
            .padding(.top, 50)

            VStack {
                Spacer()

                cardView
                    .highPriorityGesture(swipeGesture)

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.2)) {
                navModel.showMenu = false
            }
            if shuffledDeck.isEmpty { setupDeck() }
        }
        .onChange(of: navModel.showMenu) { isOpen in
            if isOpen {
                withAnimation(.easeInOut(duration: 0.2)) {
                    navModel.showMenu = false
                }
            }
        }
    }

    private var swipeGesture: some Gesture {
        DragGesture(minimumDistance: 25, coordinateSpace: .local)
            .onEnded { value in
                let horizontal = value.translation.width
                let vertical = value.translation.height
                guard abs(horizontal) > abs(vertical) else { return }

                if horizontal > 60 {
                    swipeRightForward()
                } else if horizontal < -60 {
                    swipeLeftBackward()
                }
            }
    }

    private var cardView: some View {
        ZStack {
            if shuffledDeck.isEmpty {
                ProgressView().scaleEffect(2)
            } else {
                let angle = normalizedAngle(rotation)

                if angle < 90 || angle > 270 {
                    frontSide
                }

                if angle >= 90 && angle <= 270 {
                    meaningSide
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                }
            }
        }
        .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0))
        .animation(.easeInOut(duration: 0.4), value: rotation)
    }

    private var frontSide: some View {
        Group {
            if shuffledDeck.indices.contains(currentCardIndex) {
                Image(shuffledDeck[currentCardIndex].image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: cardWidth, height: cardHeight)
                    .cornerRadius(16)
                    .shadow(radius: 20)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }

    private var meaningSide: some View {
        Group {
            if shuffledDeck.indices.contains(currentCardIndex) {
                VStack(spacing: 14) {
                    Text(shuffledDeck[currentCardIndex].meaning)
                        .font(.system(size: 22, weight: .regular))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 26)
                .padding(.vertical, 22)
                .frame(width: cardWidth, height: cardHeight)
                .background(Color.black.opacity(0.85))
                .cornerRadius(16)
                .shadow(radius: 20)
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }

    private func setupDeck() {
        shuffledDeck = tarotCards.shuffled()
        currentCardIndex = 0
        showMeaning = false
        rotation = 0
    }

    private func swipeRightForward() {
        guard !shuffledDeck.isEmpty else { return }

        if !showMeaning {
            withAnimation(.easeInOut(duration: 0.4)) { rotation += 180 }
            showMeaning = true
            return
        }

        withAnimation(.easeInOut(duration: 0.4)) { rotation += 180 }
        showMeaning = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            moveToNextCard()
        }
    }

    private func swipeLeftBackward() {
        guard !shuffledDeck.isEmpty else { return }

        if showMeaning {
            withAnimation(.easeInOut(duration: 0.4)) { rotation -= 180 }
            showMeaning = false
            return
        }

        moveToPreviousCard()
        withAnimation(.easeInOut(duration: 0.4)) { rotation -= 180 }
        showMeaning = true
    }

    private func moveToNextCard() {
        guard !shuffledDeck.isEmpty else { return }
        currentCardIndex = (currentCardIndex + 1) % shuffledDeck.count
    }

    private func moveToPreviousCard() {
        guard !shuffledDeck.isEmpty else { return }
        currentCardIndex = (currentCardIndex - 1 + shuffledDeck.count) % shuffledDeck.count
    }

    private func normalizedAngle(_ degrees: Double) -> Double {
        let r = degrees.truncatingRemainder(dividingBy: 360)
        let a = (r + 360).truncatingRemainder(dividingBy: 360)
        return a
    }
}
