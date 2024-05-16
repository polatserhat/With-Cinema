// LoginView.swift
// WithCinema
//
// Created by Serhat on 13.05.24.
//
import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isAttemptingLogin = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showingSignUp = false  // This will control the display of the SignUpView
    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Welcome to WithCinema")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)

                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 24)

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 24)

                if isAttemptingLogin {
                    ProgressView()
                } else {
                    Button("Log In", action: loginUser)
                        .buttonStyle(RoundedRectangleButtonStyle(backgroundColor: Color.blue))

                    Button("Sign Up") {
                        showingSignUp = true  // Set this to true to navigate to SignUpView
                    }
                    .buttonStyle(RoundedRectangleButtonStyle(backgroundColor: Color.green))
                }
                NavigationLink(destination: SignUpView(), isActive: $showingSignUp) { EmptyView() }
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            .cornerRadius(10)
            .shadow(color: .gray.opacity(0.4), radius: 10, x: 0, y: 10)
            .navigationTitle("Login")
            .navigationBarHidden(true)
            .alert(isPresented: $showError) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
        .preferredColorScheme(.dark)
    }

    private func loginUser() {
        isAttemptingLogin = true
        authManager.loginUser(email: email, password: password) { success in
            isAttemptingLogin = false
            if !success {
                showError = true
                errorMessage = "Failed to login. Please check your credentials and try again."
            }
        }
    }
}
// Custom Button Style for Rounded Rectangular Buttons
struct RoundedRectangleButtonStyle: ButtonStyle {
    var backgroundColor: Color

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .background(backgroundColor)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.easeOut, value: configuration.isPressed)
    }
}

// SwiftUI Preview Provider
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(AuthManager.shared)
    }
}