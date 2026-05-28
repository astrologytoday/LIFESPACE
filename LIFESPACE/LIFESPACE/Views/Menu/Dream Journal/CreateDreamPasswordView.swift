import SwiftUI

struct CreateDreamPasswordView: View {
    @EnvironmentObject var navModel: NavigationModel
    @AppStorage("dreamPasswordCreated") private var dreamPasswordCreated = false

    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var secretQuestion: String = ""
    @State private var secretAnswer: String = ""
    @State private var errorMessage: String?

    var body: some View {
        ZStack {
            // Burnt paper gradient background
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.8, green: 0.7, blue: 0.5),
                                            Color(red: 0.5, green: 0.3, blue: 0.2)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("Create Journal Password")
                    .font(.custom("IM FELL DW Pica", size: 22))
                    .foregroundColor(.white)

                SecureField("Enter Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                SecureField("Confirm Password", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                TextField("Secret Question (e.g., First Pet's Name?)", text: $secretQuestion)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                TextField("Answer to Secret Question", text: $secretAnswer)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.top, 4)
                }

                Button("Set Password") {
                    createPassword()
                }
                .foregroundColor(.white)
                .padding(.horizontal, 30)
                .padding(.vertical, 10)
                .background(Color.brown)
                .cornerRadius(10)
            }
            .padding()
        }
    }

    private func createPassword() {
        guard !password.isEmpty,
              !confirmPassword.isEmpty,
              !secretQuestion.isEmpty,
              !secretAnswer.isEmpty else {
            errorMessage = "Please fill in all fields."
            return
        }

        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }

        KeychainHelper.savePassword(password)
        KeychainHelper.saveSecretQuestion(secretQuestion)
        KeychainHelper.saveSecretAnswer(secretAnswer)

        dreamPasswordCreated = true
        navModel.push("DreamPasswordView")
    }
}

