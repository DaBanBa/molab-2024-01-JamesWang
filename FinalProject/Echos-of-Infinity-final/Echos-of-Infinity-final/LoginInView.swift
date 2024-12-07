//
//  FrontView.swift
//  The Echos of Infinity
//
//  Created by James Wang on 11/24/24.
//

import SwiftUI
import KeychainAccess

struct LoginInView: View {
    @EnvironmentObject var appState: AppState

    @State private var email = "DaBanBa"
    @State private var password = "myNameIsJames"
    @State private var isLoginMode = true
    @State private var message = ""
    @State private var isAwaitingResponse = false

    let keychain = Keychain(service: "DaBanBaMolab.The-Echos-of-Infinity.auth")

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            Text(isLoginMode ? "LOGIN" : "REGISTER")
                .font(.custom("BodoniModa9pt-Regular", size: 64))
                .bold()
                .foregroundColor(Color.black)
                .frame(maxWidth: .infinity, alignment: .center)
                .onTapGesture {
                    dismissKeyboard()
                }

            VStack(alignment: .leading, spacing: 5) {
                TextField("Username", text: $email)
                    .font(.custom("BodoniModa9pt-Regular", size: 18))
                    .autocapitalization(.none)
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.black)

                SecureField("Password", text: $password)
                    .font(.custom("BodoniModa9pt-Regular", size: 18))
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.black)
            }.foregroundColor(Color.black)
            .padding(.horizontal, 40)

            Button(action: {
                isLoginMode ? login() : register()
            }) {
                Text(isLoginMode ? "Login" : "Register")
                    .foregroundColor(.white)
                    .font(.custom("BodoniModa9pt-Regular", size: 18))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(48)
            }.disabled(isAwaitingResponse)
                .padding()
                .onTapGesture {
                    dismissKeyboard()
                }

            Button(action: {
                isLoginMode.toggle()
            }) {
                Text(isLoginMode ? "Switch to Register" : "Switch to Login")
                    .foregroundColor(.black)
                    .font(.custom("BodoniModa9pt-Regular", size: 18))
            }.onTapGesture {
                dismissKeyboard()
            }

            Text(message)
                .foregroundColor(.black)
                .onTapGesture {
                    dismissKeyboard()
                }
                .font(.custom("BodoniModa9pt-Regular", size: 18))
        }.onTapGesture {
            dismissKeyboard()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .onTapGesture {
                    dismissKeyboard()
                }
        )
    }

    private func register() {
        guard !email.isEmpty, !password.isEmpty else {
            message = "All fields are required."
            return
        }
        
        isAwaitingResponse = true

        let payload: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        ServerConnection.shared.serverConnection(payload: payload, endpoint: "register") { response in
            DispatchQueue.main.async {
                self.isAwaitingResponse = false
                if let response = response {
                    if let data = response.data(using: .utf8),
                       let json = try? JSONSerialization.jsonObject(with: data, options: []),
                       let dictionary = json as? [String: Any] {
                        if let message = dictionary["message"] as? String, message.contains("User registered successfully") {
                            self.message = "Registration successful. You can now log in."
                            self.isLoginMode = true
                        } else {
                            self.message = "Try A Different Username or Password!"
                        }
                    } else {
                        self.message = "Invalid server response."
                    }
                } else {
                    self.message = "No response from server."
                }
            }
        }
    }
    
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    private func login() {
        guard !email.isEmpty, !password.isEmpty else {
            message = "Email and password are required."
            return
        }
        
        isAwaitingResponse = true

        let payload: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        ServerConnection.shared.serverConnection(payload: payload, endpoint: "login") { response in
            DispatchQueue.main.async {
                self.isAwaitingResponse = false
                if let response = response {
                    if let data = response.data(using: .utf8),
                       let json = try? JSONSerialization.jsonObject(with: data, options: []),
                       let dictionary = json as? [String: Any] {
                        if let token = dictionary["token"] as? String {
                            self.saveToken(token: token)
                            self.appState.userEmail = self.email
                            self.message = "Login successful."
                        } else {
                            self.message = "Your Username or Password is incorrect, try again!"
                        }
                    } else {
                        self.message = "Invalid server response."
                    }
                } else {
                    self.message = "No response from server."
                }
            }
        }
    }

    private func saveToken(token: String) {
        keychain["jwtToken"] = token
    }

    private func loadToken() -> String? {
        return keychain["jwtToken"]
    }
}
