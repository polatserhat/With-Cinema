
// ProfileView.swift
// WithCinema
//
// Created by Serhat on 13.05.24.
//




import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        NavigationView {
            VStack {
                if let user = Auth.auth().currentUser {
                    // Profile Picture Placeholder
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .padding(.top, 20)

                    // User Details
                    VStack(spacing: 10) {
                        Text("Email: \(user.email ?? "Unknown")")
                            .font(.title2)
                            .fontWeight(.medium)

                       
                        Text("Name: \(UserDefaults.standard.string(forKey: "userName") ?? "Not set")")
                            .font(.title2)
                            .fontWeight(.medium)

                        Text("Surname: \(UserDefaults.standard.string(forKey: "userSurname") ?? "Not set")")
                            .font(.title2)
                            .fontWeight(.medium)
                    }
                    .padding(.top, 20)

                    Spacer()

                    // Logout Button
                    Button("Log Out") {
                        authManager.logout()
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.red)
                    .cornerRadius(8)
                    .padding(.bottom, 20)
                } else {
                    Spacer()
                    Text("Not logged in")
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(UIColor.systemBackground))
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(.dark)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(AuthManager.shared)
    }
}
