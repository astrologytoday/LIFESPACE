import SwiftUI

struct StatsSetupView: View {
    @EnvironmentObject var navModel: NavigationModel
    @EnvironmentObject var userProfile: UserProfileModel
    @AppStorage("returnToConfirmation") private var returnToConfirmation: Bool = false

    // Local states
    @State private var selectedGender: String = ""
    @State private var selectedAge = 18
    @State private var selectedHeight = "5'6\""
    @State private var selectedWeight = 150
    @State private var selectedDrinks = "0"
    @State private var selectedSmoking = "non-smoker"

    @State private var showTitle = false

    // Height options from 2'0" to 8'11"
    var heightOptions: [String] {
        var heights: [String] = []
        for feet in 2...8 {
            for inches in 0..<12 {
                heights.append("\(feet)'\(inches)\"")
            }
        }
        return heights
    }

    let drinksOptions = ["0", "3–5", "6–11", "12+"]
    let smokingOptions = ["smoker", "vape user", "non-smoker"]

    var allFieldsComplete: Bool {
        !selectedGender.isEmpty
    }

    var body: some View {
        ZStack {
            // Background
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

            VStack(spacing: 20) {
                // Title
                Text("BIOMETRIC DATA")
                    .font(Font.custom("Avenir", size: 26).weight(.bold))
                    .foregroundColor(.white)
                    .padding(.top, 50)
                    .opacity(showTitle ? 1 : 0)
                    .animation(.easeInOut(duration: 1.0), value: showTitle)

                // Gender Picker
                HStack(spacing: 20) {
                    genderSquare(symbol: "♀", color: .pink, gender: "female")
                    genderSquare(symbol: "♂", color: .blue, gender: "male")
                    genderSquare(symbol: "⚧", color: .purple, gender: "non-binary")
                }
                .padding(.bottom, 10)

                // Wheel Pickers
                VStack(spacing: 12) {
                    wheelPicker(title: "age", selection: $selectedAge, range: 10...100, suffix: " yrs")
                    wheelPicker(title: "height", selection: $selectedHeight, options: heightOptions)
                    wheelPicker(title: "weight", selection: $selectedWeight, range: 50...1000, suffix: " lbs")
                    wheelPicker(title: "drinks per week", selection: $selectedDrinks, options: drinksOptions)
                    wheelPicker(title: "smoking status", selection: $selectedSmoking, options: smokingOptions)
                }

                Text("Scroll each picker wheel to choose your information")
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.top, 8)

                Spacer()

                // Forward Button
                if allFieldsComplete {
                    Button(action: {
                        userProfile.gender = selectedGender
                        userProfile.age = "\(selectedAge)"
                        userProfile.height = selectedHeight
                        userProfile.weight = "\(selectedWeight)"
                        userProfile.drinksPerWeek = selectedDrinks
                        userProfile.smokingStatus = selectedSmoking

                        if returnToConfirmation {
                            returnToConfirmation = false
                            navModel.push("SetupConfirmationView")
                        } else {
                            navModel.push("FitnessSetupView")
                        }
                    }) {
                        Image(systemName: "arrow.right.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                            .padding(.bottom, 30)
                    }
                }
            }
            .onAppear {
                showTitle = true

                // Restore saved values if editing
                if !userProfile.gender.isEmpty { selectedGender = userProfile.gender }
                if let age = Int(userProfile.age) { selectedAge = age }
                if !userProfile.height.isEmpty { selectedHeight = userProfile.height }
                if let weight = Int(userProfile.weight) { selectedWeight = weight }
                if !userProfile.drinksPerWeek.isEmpty { selectedDrinks = userProfile.drinksPerWeek }
                if !userProfile.smokingStatus.isEmpty { selectedSmoking = userProfile.smokingStatus }
            }
        }
    }

    // MARK: - Gender Button
    func genderSquare(symbol: String, color: Color, gender: String) -> some View {
        Button(action: {
            selectedGender = gender
        }) {
            Text(symbol)
                .font(.system(size: 40))
                .frame(width: 80, height: 80)
                .background(color.opacity(selectedGender == gender ? 0.5 : 0.2))
                .foregroundColor(.white)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(selectedGender == gender ? Color.white : Color.clear, lineWidth: 2)
                )
        }
    }

    // MARK: - Wheel Picker (Int)
    func wheelPicker(title: String, selection: Binding<Int>, range: ClosedRange<Int>, suffix: String = "") -> some View {
        VStack(spacing: 2) {
            Text("CHOOSE YOUR \(title.uppercased())")
                .font(.caption)
                .foregroundColor(.white)

            Picker(selection: selection, label: Text("")) {
                ForEach(range, id: \.self) { value in
                    Text("\(value)\(suffix)").tag(value)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(height: 60)
            .clipped()
        }
        .padding(.horizontal)
    }

    // MARK: - Wheel Picker (String)
    func wheelPicker(title: String, selection: Binding<String>, options: [String]) -> some View {
        VStack(spacing: 2) {
            Text("CHOOSE YOUR \(title.uppercased())")
                .font(.caption)
                .foregroundColor(.white)

            Picker(selection: selection, label: Text("")) {
                ForEach(options, id: \.self) { option in
                    Text(option.capitalized).tag(option)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(height: 60)
            .clipped()
        }
        .padding(.horizontal)
    }
}

