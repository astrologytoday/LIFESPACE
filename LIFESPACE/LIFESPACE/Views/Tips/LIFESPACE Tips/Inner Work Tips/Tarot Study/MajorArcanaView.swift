import SwiftUI
import Foundation

struct MajorArcanaView: View {
    @EnvironmentObject var navModel: NavigationModel

    @State private var deck: [TarotCard] = []
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
            setupDeck()
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
            if deck.isEmpty {
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
            if deck.indices.contains(currentCardIndex) {
                Image(deck[currentCardIndex].image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: cardWidth, height: cardHeight)
                    .cornerRadius(16)
                    .shadow(radius: 20)
                    .frame(maxWidth: .infinity)
            }
        }
    }

    private var meaningSide: some View {
        Group {
            if deck.indices.contains(currentCardIndex) {
                VStack(spacing: 14) {
                    Text(deck[currentCardIndex].meaning)
                        .font(.system(size: 22, weight: .regular))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 26)
                .padding(.vertical, 22)
                .frame(width: cardWidth, height: cardHeight)
                .background(Color.black.opacity(0.85))
                .cornerRadius(16)
                .shadow(radius: 20)
                .frame(maxWidth: .infinity)
            }
        }
    }

    private func setupDeck() {
        let majorArcanaNames: Set<String> = [
            "The Fool","The Magician","The High Priestess","The Empress","The Emperor","The Hierophant",
            "The Lovers","The Chariot","Strength","The Hermit","Wheel of Fortune","Justice","The Hanged Man",
            "Death","Temperance","The Devil","The Tower","The Star","The Moon","The Sun","Judgement","The World",
            "The Fool (Reversed)","The Magician (Reversed)","The High Priestess (Reversed)","The Empress (Reversed)",
            "The Emperor (Reversed)","The Hierophant (Reversed)","The Lovers (Reversed)","The Chariot (Reversed)",
            "Strength (Reversed)","The Hermit (Reversed)","Wheel of Fortune (Reversed)","Justice (Reversed)",
            "The Hanged Man (Reversed)","Death (Reversed)","Temperance (Reversed)","The Devil (Reversed)",
            "The Tower (Reversed)","The Star (Reversed)","The Moon (Reversed)","The Sun (Reversed)",
            "Judgement (Reversed)","The World (Reversed)"
        ]

        deck = tarotCards.filter { majorArcanaNames.contains($0.name) }
        deck.shuffle()

        currentCardIndex = 0
        showMeaning = false
        rotation = 0
    }

    private func swipeRightForward() {
        guard !deck.isEmpty else { return }

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
        guard !deck.isEmpty else { return }

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
        guard !deck.isEmpty else { return }
        currentCardIndex = (currentCardIndex + 1) % deck.count
    }

    private func moveToPreviousCard() {
        guard !deck.isEmpty else { return }
        currentCardIndex = (currentCardIndex - 1 + deck.count) % deck.count
    }

    private func normalizedAngle(_ degrees: Double) -> Double {
        let r = degrees.truncatingRemainder(dividingBy: 360)
        let a = (r + 360).truncatingRemainder(dividingBy: 360)
        return a
    }
}
