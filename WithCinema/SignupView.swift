// SignupView.swift
// WithCinema
//
// Created by Serhat on 13.05.24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SignUpView: View {
    @EnvironmentObject var authManager: AuthManager
    @Binding var isPresentingSignUp: Bool
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
                    .foregroundColor(.white)  // Ensure text is white for better visibility in dark mode

                TextField("Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 24)
                    .foregroundColor(.white)

                TextField("Surname", text: $surname)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 24)
                    .foregroundColor(.white)

                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 24)
                    .foregroundColor(.white)

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 24)
                    .foregroundColor(.white)

                if isAttemptingSignUp {
                    ProgressView()
                } else {
                    Button("Sign Up", action: signUp)
                        .buttonStyle(RoundedRectangleButtonStyle(backgroundColor: Color.blue))
                }
            }
            .background(Color(UIColor.systemBackground))
           // .padding()
            //.background(Color.black)  // Explicitly set the background to black
            //.cornerRadius(10)
            //.shadow(color: .gray.opacity(0.4), radius: 10, x: 0, y: 10)
            .navigationTitle("Sign Up")
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $showError) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
        .preferredColorScheme(.dark)
    }

    private func signUp() {
        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters."
            showError = true
            return
        }

        isAttemptingSignUp = true
        authManager.createUserWithDetails(email: email, password: password, name: name, surname: surname) { success in
            isAttemptingSignUp = false
            if success {
                self.isPresentingSignUp = false  // Dismiss the sign-up view on successful registration
            } else {
                showError = true
                errorMessage = "Failed to create account. Please try again."
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(isPresentingSignUp: .constant(true)).environmentObject(AuthManager.shared)
    }
}
