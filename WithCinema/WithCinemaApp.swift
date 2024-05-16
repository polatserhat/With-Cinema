//
//  WithCinemaApp.swift
//  WithCinema
//
//  Created by Serhat  on 13.03.24.
//
import SwiftUI
import Firebase

@main
struct WithCinemaApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var authManager = AuthManager.shared  // Initialize the AuthManager

    var body: some Scene {
        WindowGroup {
            if authManager.isLoggedin {
                ContentView()
                    .environmentObject(authManager)  // Provide AuthManager to ContentView
            } else {
                LoginView()
                    .environmentObject(authManager)  // Provide AuthManager to LoginView
            }
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

