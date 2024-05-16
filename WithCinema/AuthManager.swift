//
//  AuthManager.swift
//  WithCinema
//
//  Created by Serhat  on 13.05.24.
//

import Foundation
import FirebaseAuth
import Combine
import FirebaseFirestore

class AuthManager: ObservableObject {
    @Published var isLoggedin: Bool = false

    static let shared = AuthManager()

    init() {
        isLoggedin = Auth.auth().currentUser != nil
    }

    public func createUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            DispatchQueue.main.async {
                if let user = authResult?.user, error == nil {
                    print("User created: \(user.email ?? "Unknown")")
                    self.isLoggedin = true
                    completion(true)
                } else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
                    completion(false)
                }
            }
        }
    }

    public func loginUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            DispatchQueue.main.async {
                if let user = authResult?.user, error == nil {
                    print("User logged in: \(user.email ?? "Unknown")")
                    self.isLoggedin = true
                    completion(true)
                } else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
                    completion(false)
                }
            }
        }
    }

    public func logout() {
        do {
            try Auth.auth().signOut()
            self.isLoggedin = false
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

extension AuthManager {
    func createUserWithDetails(email: String, password: String, name: String, surname: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard let user = authResult?.user, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion(false)
                return
            }
            
            // Save additional details in Firestore
            let db = Firestore.firestore()
            db.collection("users").document(user.uid).setData([
                "name": name,
                "surname": surname,
                "email": email
            ]) { error in
                if let error = error {
                    print("Error saving user details: \(error.localizedDescription)")
                    completion(false)
                } else {
                    print("User created: \(user.email ?? "unknown") with name \(name) \(surname)")
                    completion(true)
                }
            }
        }
    }
}
