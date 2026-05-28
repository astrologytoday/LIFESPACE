import SwiftUI

struct DreamPasswordView: View {
    @EnvironmentObject var navModel: NavigationModel
    @AppStorage("dreamPasswordCreated") private var dreamPasswordCreated: Bool = false
    @State private var enteredPassword: String = ""
    @State private var showError = false
    @State private var showSecretQuestionPrompt = false
    @State private var secretAnswerInput: String = ""
    @State private var wrongSecretAnswer = false
    
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
            
            // Main content
            VStack(spacing: 20) {
                Text("Enter Password")
                    .font(.custom("IM FELL DW Pica", size: 28))
                    .foregroundColor(.white)
                
                SecureField("Password", text: $enteredPassword)
                    .font(.custom("IM FELL DW Pica", size: 18))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                if showError {
                    Text("Incorrect password.")
                        .font(.custom("IM FELL DW Pica", size: 14))
                        .foregroundColor(.red)
                }
                
                Button("Unlock Journal") {
                    verifyPassword()
                }
                .font(.custom("IM FELL DW Pica", size: 18))
                .foregroundColor(.white)
                .padding(.horizontal, 30)
                .padding(.vertical, 10)
                .background(Color.brown)
                .cornerRadius(10)
                
                Button("Change Password") {
                    showSecretQuestionPrompt = true
                }
                .font(.custom("IM FELL DW Pica", size: 20))
                .foregroundColor(.white)
                .padding(.top, 8)
                
                if wrongSecretAnswer {
                    Text("Incorrect answer.")
                        .font(.custom("IM FELL DW Pica", size: 14))
                        .foregroundColor(.red)
                }
            }
            .padding()
            .alert("Reset Password", isPresented: $showSecretQuestionPrompt) {
                TextField("Answer", text: $secretAnswerInput)
                Button("Submit", action: validateSecretAnswer)
                Button("Cancel", role: .cancel) { }
            } message: {
                Text(KeychainHelper.getSecretQuestion() ?? "What is your secret answer?")
            }
            .font(.custom("IM FELL DW Pica", size: 16))
        }
        // Custom back button in the TRUE top-left corner of the screen
        .overlay(
            Button(action: {
                navModel.pop()  // Replace with your actual pop method if different
            }) {
                Image(systemName: "chevron.left")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                    .padding(12)
                    .clipShape(Circle())
            }
            .padding(.leading, 20)
            .padding(.top, 6),  // Adjust if needed for status bar / notch
            alignment: .topLeading
        )
        // Hide default system back button
        .navigationBarBackButtonHidden(true)
    }
    
    private func verifyPassword() {
        guard let savedPassword = KeychainHelper.getPassword(),
              enteredPassword == savedPassword else {
            showError = true
            return
        }
        navModel.push("ChooseJournalView")
    }
    
    private func validateSecretAnswer() {
        let savedAnswer = KeychainHelper.getSecretAnswer()?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let userAnswer = secretAnswerInput.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if savedAnswer == userAnswer {
            wrongSecretAnswer = false
            navModel.push("CreateDreamPasswordView")
        } else {
            wrongSecretAnswer = true
        }
    }
}
