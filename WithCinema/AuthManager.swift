//
//  AuthManager.swift
//  WithCinema
//
//  Created by Serhat  on 13.05.24.
//

import Foundation
// AuthManager.swift

import FirebaseAuth
import Combine

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
