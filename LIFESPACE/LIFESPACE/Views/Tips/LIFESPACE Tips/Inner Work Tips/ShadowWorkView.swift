import SwiftUI

struct ShadowWorkView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var shadowModel: ShadowWorkModel

    @State private var showContent = false

    var body: some View {
        ZStack {
            // Background Gradient
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

                    // Title
                    Text("SHADOW WORK")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .white.opacity(0.28), radius: 10, x: 0, y: 0)
                        .shadow(color: .black.opacity(0.30), radius: 3, x: 0, y: 2)
                        .shadow(color: .white.opacity(0.7), radius: 10)
                        .frame(maxWidth: .infinity, alignment: .center)

                    // Intro
                    Group {
                        Text("Confront your shadow.")
                            .font(.title2.bold())
                            .foregroundColor(.white)

                        Text("List three traits that describe the parts of you that feel unacceptable, embarrassing, or negative.")
                            .foregroundColor(.white.opacity(0.9))
                            .font(.system(size: 18))

                        Text("Sit with your shadow and reflect on how you can channel that energy in a positive way.")
                            .foregroundColor(.white.opacity(0.9))
                            .font(.system(size: 18))
                    }

                    Divider().background(Color.white.opacity(0.5))

                    // Trait Inputs (persist automatically via ShadowWorkModel)
                    ForEach(0..<3, id: \.self) { index in
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Shadow Trait \(index + 1)")
                                .font(.headline)
                                .foregroundColor(.white)

                            TextField("e.g. taboos, vengeful, anger", text: bindingForTrait(index))
                                .padding()
                                .background(Color.white.opacity(0.15))
                                .cornerRadius(12)
                                .foregroundColor(.white)
                        }
                    }

                    // Reflection Prompt
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Reflection Space")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.top)

                        Text("Think deeply about how you are going to use these traits to your advantage.")
                            .foregroundColor(.white.opacity(0.85))
                            .font(.system(size: 16))

                        Text("Ask yourself:")
                            .foregroundColor(.white.opacity(0.85))
                            .font(.system(size: 16))

                        VStack(alignment: .leading, spacing: 6) {
                            Text("• Why do I carry this trait?")
                            Text("• Is this trait hurting me? Should I try to change?")
                            Text("• Can this part of me be useful or meaningful in some way?")
                        }
                        .foregroundColor(.white.opacity(0.8))
                        .font(.system(size: 16))
                    }

                    // Done Button
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            navModel.pop()
                        }
                    }) {
                        Text("Done Reflecting")
                            .font(.headline)
                            .foregroundColor(.teal)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(14)
                    }
                    .padding(.top, 20)
                }
                .padding()
                .opacity(showContent ? 1 : 0)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                showContent = true
            }
        }
    }

    // Safe binding so we never crash if the array somehow isn't sized correctly
    private func bindingForTrait(_ index: Int) -> Binding<String> {
        Binding(
            get: {
                guard shadowModel.shadowTraits.indices.contains(index) else { return "" }
                return shadowModel.shadowTraits[index]
            },
            set: { newValue in
                // Ensure array is at least length 3
                if shadowModel.shadowTraits.count < 3 {
                    shadowModel.shadowTraits = Array(shadowModel.shadowTraits.prefix(3)) + Array(repeating: "", count: max(0, 3 - shadowModel.shadowTraits.count))
                }
                shadowModel.shadowTraits[index] = newValue
            }
        )
    }
}
