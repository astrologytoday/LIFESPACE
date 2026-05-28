import SwiftUI

struct LifestyleSurveyView: View {
    @EnvironmentObject var navModel: NavigationModel
    @State private var showOptions = false
    @AppStorage("lifestyleSurveyLastCompletedDate") private var lifestyleSurveyLastCompletedDate: String = ""

    let options = [18, 36, 54, 72]

    // Check if the survey was completed today
    private var completedToday: Bool {
        let today = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
        return lifestyleSurveyLastCompletedDate == today
    }

    var body: some View {
        ZStack {
            // 🔷 Teal gradient background
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
                if completedToday {
                    // ✅ Already completed today – show message and home button ONLY
                    VStack(spacing: 18) {
                        Text("You have already completed the Lifestyle Survey today!")
                            .font(.title)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.vertical, 12)
                        Button(action: {
                            navModel.push("HomeView")
                        }) {
                            Image(systemName: "house.fill")
                                .font(.title)
                                .foregroundColor(.teal)
                                .frame(width: 56, height: 56)
                                .background(Color.white)
                                .cornerRadius(12)
                        }
                        .padding(.top, 8)
                    }
                    .opacity(showOptions ? 1 : 0)
                    .animation(.easeIn(duration: 1.0), value: showOptions)
                } else {
                    // 🏷 Title
                    Text("How many questions?")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .opacity(showOptions ? 1 : 0)
                        .animation(.easeIn(duration: 1.0), value: showOptions)
                    
                    // 🔘 Options row
                    HStack(spacing: 20) {
                        ForEach(options, id: \.self) { count in
                            Button(action: {
                                navModel.push("LifestyleSurveyLoadingView_\(count)")
                            }) {
                                Text("\(count)")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .frame(width: 70, height: 70)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.white.opacity(0.2))
                                    )
                            }
                            .opacity(showOptions ? 1 : 0)
                            .animation(.easeIn(duration: 0.5).delay(Double(options.firstIndex(of: count)!) * 0.2), value: showOptions)
                        }
                    }
                }
            }
            .onAppear {
                showOptions = true
            }
        }
    }
}

