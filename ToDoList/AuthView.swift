//
//  AuthView.swift
//  ToDoList
//
//  Created by Halle Black on 11/16/24.
//


import SwiftUI
import FirebaseAuth


struct AuthView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    
    @State private var email = ""
    @State private var password = ""
    @State private var isSignUp = false
    @State private var navigateToContentView = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                if let errorMessage = authViewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Button(action: {
                    if isSignUp {
                        authViewModel.registerUser(email: email, password: password) { success in
                            if success {
                                navigateToContentView = true
                            }
                        }
                    } else {
                        signInAndNavigate()
                    }
                }) {
                    Text(isSignUp ? "Sign Up" : "Sign In")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button(action: {
                    isSignUp.toggle()
                }) {
                    Text(isSignUp ? "Already have an account? Sign In" : "Don't have an account? Sign Up")
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                NavigationStack {
                    NavigationLink(value: navigateToContentView) {
                        Text("Go to ContentView")
                    }
                    .navigationDestination(for: Bool.self) { value in
                        if value {
                            ContentView().environmentObject(authViewModel)
                        }
                    }
                }


            }
            .padding()
            .navigationTitle(isSignUp ? "Register" : "Sign In")
        }
    }

    private func signInAndNavigate() {
        authViewModel.signInUser(email: email, password: password) { success in
            if success {
                navigateToContentView = true
            }
        }
    }
}
