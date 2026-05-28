import SwiftUI

struct GlutamateView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var appeared = false

    var body: some View {
        ZStack(alignment: .topLeading) {
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
                VStack(alignment: .leading, spacing: 20) {
                    Text("Glutamate: The Gas")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(radius: 4)

                    Group {
                        Text("What It Is & What It Does")
                            .font(.title2).bold()
                            .foregroundColor(.white)

                        Text("Glutamate is the brain’s primary excitatory neurotransmitter responsible for ") +
                        Text("neural excitation and cognition.").bold()

                        Text("The foundational ingredients for glutamate production are ") +
                        Text("glutamine, magnesium, glycine and antioxidants.").bold()

                        Text("Low glutamate is linked to low motivation, poor concentration, and memory problems.")
                            .fixedSize(horizontal: false, vertical: true)

                        Text("Too much glutamate may lead to anxiety, restlessness, headaches, insomnia or neuroinflammation.")
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .foregroundColor(.white.opacity(0.95))

                    Group {
                        Text("Foods That Support Glutamate Production")
                            .font(.title2).bold()
                            .foregroundColor(.white)

                        Text("Fruits:").bold() + Text(" avocado, blueberries, pomegranate")
                        Text("Vegetables:").bold() + Text(" spinach, beets, broccoli")
                        Text("Dairy:").bold() + Text(" kefir, goat cheese, Greek yogurt")
                        Text("Grain:").bold() + Text(" quinoa, brown rice, steel cut oats")
                        Text("Oils & Butter:").bold() + Text(" pumpkin seed oil, hemp seed oil, coconut oil")
                        Text("Meat:").bold() + Text(" chicken thighs, liver, beef shank")
                        Text("Fish:").bold() + Text(" salmon, sardines, mackerel")
                        Text("Herbs, Spices & Sweetener:").bold() + Text(" turmeric, ginger, cinnamon")
                        Text("Sauces & Broth:").bold() + Text(" bone broth, miso, tahini")
                        Text("Nuts, Seeds & Beans:").bold() + Text(" pumpkin seeds, chia seeds, lentils")
                    }
                    .foregroundColor(.white.opacity(0.95))
                }
                .padding(.horizontal, 24)
                .padding(.top, 64)
                .padding(.bottom, 160)
                .opacity(appeared ? 1 : 0)
                .animation(.easeInOut(duration: 0.6), value: appeared)
            }

            BackButtonView(customTarget: "EatingTipsView")
                .padding(.top, 12)
                .padding(.leading, 56)

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        navModel.push("HomeView")
                    }) {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.white.opacity(0.9),
                                        Color.white.opacity(0.6)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .frame(width: 60, height: 60)
                                .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 6)

                            Image(systemName: "house.fill")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(Color(red: 0.10, green: 0.45, blue: 0.45))
                        }
                    }
                    .padding(.trailing, 22)
                    .padding(.bottom, 22)
                }
            }
        }
        .onAppear { appeared = true }
        .transition(.opacity)
    }
}

