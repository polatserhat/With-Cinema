// SignupView.swift
// WithCinema
//
// Created by Serhat on 13.05.24.
//



import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var name = ""
    @State private var surname = ""
    @State private var email = ""
    @State private var password = ""
    @State private var isAttemptingSignUp = false
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Create Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)

                TextField("Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 24)

                TextField("Surname", text: $surname)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 24)

                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 24)

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 24)

                if isAttemptingSignUp {
                    ProgressView()
                } else {
                    Button("Sign Up", action: signUp)
                        .buttonStyle(RoundedRectangleButtonStyle(backgroundColor: Color.blue))
                }
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            .cornerRadius(10)
            .shadow(color: .gray.opacity(0.4), radius: 10, x: 0, y: 10)
            .navigationTitle("Sign Up")
            .alert(isPresented: $showError) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
        .preferredColorScheme(.dark)
    }

    private func signUp() {
        isAttemptingSignUp = true
        authManager.createUser(email: email, password: password) { success in
            isAttemptingSignUp = false
            if success {
                // Optionally navigate back or handle the UI post-sign-up
            } else {
                showError = true
                errorMessage = "Failed to create account. Please try again."
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView().environmentObject(AuthManager.shared)
    }
}
