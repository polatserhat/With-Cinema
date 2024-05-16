// ProfileView.swift
// WithCinema
//
// Created by Serhat on 13.05.24.
//



import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ProfileView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var userName = ""
    @State private var userSurname = ""

    var body: some View {
        NavigationView {
            VStack {
                if let user = Auth.auth().currentUser {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .padding(.top, 20)

                    VStack(spacing: 10) {
                        Text("Email: \(user.email ?? "Unknown")")
                            .font(.title2)
                            .fontWeight(.medium)

                        Text("Name: \(userName)")
                            .font(.title2)
                            .fontWeight(.medium)

                        Text("Surname: \(userSurname)")
                            .font(.title2)
                            .fontWeight(.medium)
                    }
                    .padding(.top, 20)

                    Spacer()

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
            .onAppear {
                fetchUserDetails()
            }
        }
    }

    private func fetchUserDetails() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                userName = data?["name"] as? String ?? "Not set"
                userSurname = data?["surname"] as? String ?? "Not set"
            } else {
                print("Document does not exist")
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(AuthManager.shared)
    }
}
