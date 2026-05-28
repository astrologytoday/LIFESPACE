import SwiftUI

struct WeightTrackerView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var model: WeightLogModel  // ✅ shared instance

    @State private var weightText: String = ""
    @State private var showDuplicateAlert = false // ✅ Optional alert

    var body: some View {
        ZStack {
            // 🌊 LIFESPACE Gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.35, green: 0.80, blue: 0.75),
                    Color(red: 0.20, green: 0.65, blue: 0.60),
                    Color(red: 0.10, green: 0.45, blue: 0.45)
                ]),
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                    BackButtonView()
                        .padding(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Enter Today’s Weight")
                    .font(.custom("Avenir-Heavy", size: 28))
                    .foregroundColor(.white)

                TextField("lbs", text: $weightText)
                    .keyboardType(.decimalPad)
                    .padding()
                    .frame(width: 140)
                    .background(Color.white)
                    .cornerRadius(10)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)

                Button(action: handleSubmit) {
                    Text("ENTER")
                        .font(.custom("Avenir-Heavy", size: 18))
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 30)
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(12)
                }

                Spacer()
            }
            .padding()
            .alert("You already entered your weight today.", isPresented: $showDuplicateAlert) {
                Button("OK", role: .cancel) { }
            }
        }
    }

    private func handleSubmit() {
        guard let weight = Double(weightText), weight > 0 else { return }

        if model.hasEntryForToday() {
            showDuplicateAlert = true
            return
        }

        model.addEntry(date: Date(), weight: weight)
        navModel.push("AnalyticsView")
    }
}

