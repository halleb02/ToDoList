//
//  LoginView.swift
//  ToDoList
//
//  Created by Halle Black on 11/17/24.
//


import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var isSignUpMode = false

    var body: some View {
        VStack {
            Text(isSignUpMode ? "Sign Up" : "Login")
                .font(.largeTitle)
                .bold()
                .padding()

            TextField("Email", text: $email)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            if let errorMessage = authViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Button(action: {
                if isSignUpMode {
                    authViewModel.registerUser(email: email, password: password) { success in
                        if success {
                            print("Sign up successful")
                        } else {
                            print("Sign up failed")
                        }
                    }
                } else {
                    authViewModel.signInUser(email: email, password: password) { success in
                        if success {
                            print("Login successful")
                        } else {
                            print("Login failed")
                        }
                    }
                }
            }) {
                Text(isSignUpMode ? "Sign Up" : "Login")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding()

            Button(action: {
                isSignUpMode.toggle()
            }) {
                Text(isSignUpMode ? "Already have an account? Login" : "Don't have an account? Sign Up")
                    .foregroundColor(.blue)
            }
            .padding()
        }
        .padding()
    }
}
