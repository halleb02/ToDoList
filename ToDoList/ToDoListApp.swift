//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by Halle Black on 10/31/24.
//



import SwiftUI
import Firebase

@main
struct ToDoListApp: App {
    @StateObject private var authViewModel = AuthViewModel()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if authViewModel.isUserAuthenticated {
                    ContentView()
                        .environmentObject(authViewModel)
                } else {
                    AuthView()
                        .environmentObject(authViewModel)
                }
            }
        }
    }
}
