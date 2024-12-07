//
//  RootView.swift
//  The Echos of Infinity
//
//  Created by James Wang on 11/24/24.
//
import SwiftUI
import KeychainAccess

struct RootView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationStack{
            if isTokenValid() && appState.userEmail != nil {
                MainView()
                    .transition(.opacity)
            } else {
                LoginInView()
                    .transition(.opacity)
            }
        }.navigationBarBackButtonHidden(true)
        .animation(.easeInOut, value: isTokenValid() && appState.userEmail != nil)
    }
    private func isTokenValid() -> Bool {
        let keychain = Keychain(service: "DaBanBaMolab.The-Echos-of-Infinity.auth")
        do {
            if let token = try keychain.get("jwtToken"), !token.isEmpty {
                return true
            }
        } catch {
            print("Error fetching token from Keychain: \(error.localizedDescription)")
        }
        return false
    }
}
