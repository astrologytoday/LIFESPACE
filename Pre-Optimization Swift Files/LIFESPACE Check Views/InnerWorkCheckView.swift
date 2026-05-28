import SwiftUI

struct InnerWorkCheckView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var userProfile: UserProfileModel
    @EnvironmentObject var lifespaceLog: LifespaceLogModel

    @State private var selectedOptions: Set<String> = []

    var body: some View {
        ZStack {
            // Teal gradient background
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
                Text("Have you been practicing your Inner Work?")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top, 60)

                // Bubble grid of options (keep spacing like before)
                let columns = [GridItem(.adaptive(minimum: 120), spacing: 20)]

                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(userProfile.innerWorkOptions, id: \.self) { option in
                            Button(action: {
                                if selectedOptions.contains(option) {
                                    selectedOptions.remove(option)
                                } else {
                                    selectedOptions.insert(option)
                                }
                            }) {
                                Text(option)
                                    .font(.custom("Avenir", size: 16))
                                    .foregroundColor(.white)
                                    .lineLimit(1)                 // ✅ prevent "thera / py"
                                    .minimumScaleFactor(0.90)     // ✅ keep text mostly same size
                                    .allowsTightening(true)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .frame(maxWidth: .infinity, minHeight: 44)
                                    .background(
                                        selectedOptions.contains(option)
                                            ? Color.white.opacity(0.3)
                                            : Color.white.opacity(0.15)
                                    )
                                    .clipShape(Capsule())
                                    .overlay(
                                        Capsule()
                                            .stroke(Color.white.opacity(0.5), lineWidth: 1)
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                }

                Spacer()

                Button(action: {
                    let yesCount = selectedOptions.isEmpty ? 0 : 1
                    let questionCount = 1

                    lifespaceLog.addEntry(
                        LifespaceLogEntry(
                            type: .lifespace,
                            module: .innerWork,
                            questionCount: questionCount,
                            yesCount: yesCount
                        )
                    )

                    navModel.push("FitnessCheckView")
                }) {
                    Text("Next")
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                }
            }
        }
    }
}
