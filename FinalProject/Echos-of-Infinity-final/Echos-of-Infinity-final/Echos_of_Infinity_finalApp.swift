//
//  Echos_of_Infinity_finalApp.swift
//  Echos-of-Infinity-final
//
//  Created by James Wang on 12/2/24.
//

import SwiftUI
import KeychainAccess
import Combine

class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var userEmail: String? = nil
}

@main
struct The_Echos_of_InfinityApp: App {
    @StateObject private var appState = AppState()
    let keychain = Keychain(service: "DaBanBaMolab.The-Echos-of-Infinity.auth")

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
                .onAppear {
                    checkLoginStatus()
                }
        }
    }

    private func checkLoginStatus() {
        if let token = keychain["jwtToken"], !token.isEmpty {
            appState.isLoggedIn = true
            print("true")
        } else {
            appState.isLoggedIn = false
            print("false")
        }
    }
}
