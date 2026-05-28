import SwiftUI

struct FengShuiView: View {
    @EnvironmentObject var navModel: NavigationModel

    @State private var appeared = false
    @State private var pulse = false
    @State private var showBackButton = false

    var body: some View {
        GeometryReader { outerGeo in
            ZStack(alignment: .bottom) {

                // 🌊 Enhanced LIFESPACE Teal Gradient Background with subtle overlay
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
                .overlay(
                    Image(systemName: "leaf.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .foregroundColor(.white.opacity(0.05))
                        .rotationEffect(.degrees(45))
                        .offset(x: 100, y: 200)
                        .blur(radius: 10)
                )

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {

                        // Title
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Feng Shui Tips")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.white)
                                .shadow(color: .white.opacity(0.3), radius: 5, x: 0, y: 0)

                            Text("Harmonize Your Space for Better Mental Flow")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.top, 8)
                        .opacity(appeared ? 1 : 0)
                        .scaleEffect(appeared ? 1 : 0.95)
                        .animation(.easeInOut(duration: 1.0), value: appeared)

                        ForEach(tips.indices, id: \.self) { i in
                            HStack(spacing: 16) {

                                Image(systemName: tips[i].icon)
                                    .font(.system(size: 24, weight: .medium))
                                    .foregroundColor(.white)
                                    .frame(width: 50, height: 50)
                                    .background(
                                        Circle()
                                            .fill(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [Color.white.opacity(0.3), Color.white.opacity(0.1)]),
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                    )
                                    .shadow(color: .black.opacity(0.2), radius: 5)

                                VStack(alignment: .leading, spacing: 6) {
                                    Text("\(i + 1). \(tips[i].title)")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(.white)

                                    Text(tips[i].description)
                                        .font(.custom("Avenir", size: 16))
                                        .foregroundColor(.white.opacity(0.9))
                                        .lineSpacing(4)
                                }
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                            )
                            .shadow(color: .black.opacity(0.3), radius: 8)
                            .scaleEffect(pulse ? 1.02 : 1.0)
                            .opacity(appeared ? 1 : 0)
                            .offset(y: appeared ? 0 : 20)
                            .animation(.easeInOut(duration: 0.8).delay(0.2 + Double(i) * 0.15), value: appeared)
                        }

                        // ✅ Bottom marker (this is what we detect)
                        Color.clear
                            .frame(height: 1)
                            .background(
                                GeometryReader { geo in
                                    Color.clear
                                        .preference(
                                            key: BottomMarkerKey.self,
                                            value: geo.frame(in: .named("FengShuiScroll")).minY
                                        )
                                }
                            )

                        // Extra space so button doesn’t cover last card
                        Spacer(minLength: 120)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                }
                .coordinateSpace(name: "FengShuiScroll")
                .onPreferenceChange(BottomMarkerKey.self) { markerMinY in
                    let threshold: CGFloat = 80
                    let shouldShow = markerMinY <= (outerGeo.size.height - threshold)

                    if shouldShow != showBackButton {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            showBackButton = shouldShow
                        }
                    }
                }

                // 🔙 Bottom-center back button (only appears at bottom)
                if showBackButton {
                    Button(action: {
                        navModel.pop()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .padding(.vertical, 14)
                        .padding(.horizontal, 28)
                        .background(
                            RoundedRectangle(cornerRadius: 22)
                                .fill(Color.black.opacity(0.22))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 22)
                                        .stroke(Color.white.opacity(0.18), lineWidth: 1)
                                )
                                .shadow(color: .black.opacity(0.35), radius: 8)
                        )
                    }
                    .padding(.bottom, 30)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .onAppear {
                appeared = true
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    pulse = true
                }
            }
        }
    }

    // MARK: - PreferenceKey for bottom detection
    private struct BottomMarkerKey: PreferenceKey {
        static var defaultValue: CGFloat = .greatestFiniteMagnitude
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
        }
    }

    struct FengShuiTip {
        let title: String
        let description: String
        let icon: String
    }

    let tips: [FengShuiTip] = [
        FengShuiTip(title: "Clear Out What You Don’t Need", description: "Too much clutter disrupts the flow of energy. Letting go of unused or unnecessary items creates spaciousness and clarity, both visually and emotionally.", icon: "trash"),
        FengShuiTip(title: "Let the Light In", description: "Sunlight uplifts and energizes any space. Use windows, sheer curtains, or mirrors to brighten dark corners—but be mindful of mirror placement to avoid bouncing energy harshly.", icon: "sun.max"),
        FengShuiTip(title: "Add Natural Life", description: "Houseplants with soft, rounded leaves—like jade or pothos—bring calming, nourishing energy. These plants promote vitality and groundedness.", icon: "leaf"),
        FengShuiTip(title: "Maintain Easy Movement", description: "Keep entrances and pathways clear. Avoid placing large furniture near doorways to let energy (and people) flow freely.", icon: "arrow.right.circle"),
        FengShuiTip(title: "Choose Empowering Positions", description: "Place your bed, desk, or stove in the spot farthest away from the door, but not directly aligned.", icon: "bed.double"),
        FengShuiTip(title: "Repair What’s Broken", description: "Damaged items can subtly drain energy. Fix or replace broken mirrors, squeaky doors, or cracked furniture to restore harmony.", icon: "wrench.and.screwdriver"),
        FengShuiTip(title: "Use Color Intentionally", description: "Reflect areas of your life you want to strengthen through color.", icon: "paintpalette"),
        FengShuiTip(title: "Strengthen the Entry Point", description: "Your front door sets the tone for your home’s energy. Keep it clutter-free, inviting, and well-lit.", icon: "door.left.hand.open"),
        FengShuiTip(title: "Balance the Five Elements", description: "Incorporate earth, metal, water, wood, and fire throughout your space. A balanced mix supports holistic harmony.", icon: "flame")
    ]
}
