//
//  AuthViewModel.swift
//  ToDoList
//
//  Created by Halle Black on 11/16/24.
//


import SwiftUI
import FirebaseAuth


class AuthViewModel: ObservableObject {
    @Published var isUserAuthenticated: Bool = false
    @Published var errorMessage: String?

    init() {
        self.isUserAuthenticated = Auth.auth().currentUser != nil
    }

    func signInUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    completion(false)
                } else {
                    self.isUserAuthenticated = true
                    completion(true)
                }
            }
        }
    }

    func registerUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    completion(false)
                } else {
                    self.isUserAuthenticated = true
                    completion(true)
                }
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            self.isUserAuthenticated = false
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
