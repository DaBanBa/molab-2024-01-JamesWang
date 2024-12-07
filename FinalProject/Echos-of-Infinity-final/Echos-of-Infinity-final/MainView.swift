//
//  MainView.swift
//  The Echos of Infinity
//
//  Created by James Wang on 11/24/24.
//

import SwiftUI
import KeychainAccess

struct MainView: View {
    @EnvironmentObject var appState: AppState
    @State private var navigateToMenuView = false
    @State private var Warning = ""
    @State private var isAwaitingResponse = false
    @State private var dataButtons: [String] = []
    @State private var initStory: [String] = []
    @State private var imageUrl: [String] = []
    @State private var storyId: String = ""
    @State private var storyTitle: String = ""
    @State private var navigateToContentView = false
    @State private var showHistory = false
    @State private var navigateToMainView = false
    @State private var IsLoggedOut = false
    @State private var choices: [String] = []

    var body: some View {
        ZStack {
            Image("background2")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        showHistory.toggle()
                    }
                }
            
            VStack {
                HStack {
                    Button(action: {
                        logout()
                    }) {
                        Text("Logout")
                            .font(.custom("BodoniModa9pt-Regular", size: 20))
                            .foregroundColor(.black)
                            .padding()
                            .cornerRadius(8)
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 50)
                
                Spacer()
                if !showHistory {
                    VStack(spacing: 24) {
                        Text(Warning)
                            .font(.custom("BodoniModa9pt-Regular", size: 13))
                            .foregroundColor(Color.red)
                            .padding()
                        Button(action: {
                            continueLastStory()
                        }) {
                            Text("Continue")
                                .font(.custom("BodoniModa9pt-Regular", size: 20))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.black)
                                .cornerRadius(48)
                        }.disabled(isAwaitingResponse)
                        .navigationDestination(isPresented: $navigateToContentView) {
                            ContentView(dataButtons: dataButtons, story: initStory, choices: choices, imageUrl: imageUrl, storyId: storyId, storyTitle: storyTitle)
                                .transition(.opacity)
                        }.navigationBarBackButtonHidden(true)
                        .animation(.easeInOut, value: navigateToContentView)
                        
                        Button(action: {
                            getRemainingInventory()
                        }) {
                            Text("Create")
                                .font(.custom("BodoniModa9pt-Regular", size: 20))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity-20)
                                .padding()
                                .background(Color.black)
                                .cornerRadius(48)
                        }.disabled(isAwaitingResponse)
                        .navigationDestination(isPresented: $navigateToMenuView) {
                                MenuView()
                                .transition(.opacity)
                        }.navigationBarBackButtonHidden(true)
                        .navigationDestination(isPresented: $IsLoggedOut) {
                                RootView()
                                .transition(.opacity)
                        }.navigationBarBackButtonHidden(true)
                    }.padding(56)
                }
                    VStack{
                    Button(action: {
                        withAnimation {
                            showHistory.toggle()
                        }
                    }) {
                        Text("HISTORY")
                            .font(.custom("BodoniModa9pt-Regular", size: 20))
                            .foregroundColor(.black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(48)
                            .padding(.horizontal, 20)
                    }
                        if showHistory {
                            HistoryView()
                                .transition(.move(edge: .bottom))
                        }
                    }.padding(.bottom, 32)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(48)
                    .overlay(
                        RoundedRectangle(cornerRadius: 48)
                            .stroke(Color.black, lineWidth: 2)
                    )
            }
        }
    }
    
    private func continueLastStory() {
        guard let email = appState.userEmail else {
            print("Error: User not logged in.")
            return
        }
        
        isAwaitingResponse = true
        
        let payload: [String: Any] = [
            "email": email,
            "id": "mostRecent",
        ]
        
        ServerConnection.shared.serverConnection(payload: payload, endpoint: "getSingleStory") { response in
            DispatchQueue.main.async {
                isAwaitingResponse = false
                if let response = response {
                    if let data = response.data(using: .utf8),
                       let json = try? JSONSerialization.jsonObject(with: data, options: []),
                        let dictionary = json as? [String: Any] {
                            let storyId = dictionary["storyId"] as? String ?? ""
                            let choices = dictionary["choices"] as? [String] ?? []
                            let wholeStory = dictionary["WholeStory"] as? [String] ?? []
                            let images = dictionary["images"] as? [String] ?? []
                            let title = dictionary["storyTitle"] as? String ?? ""
                        let choiceses = dictionary["oldChoices"] as? [String] ?? []
                                if storyId == "NoStoryFound"{
                                    getRemainingInventory()
                                }else {
                                    self.dataButtons = choices
                                    self.choices = choiceses
                                    self.initStory = wholeStory
                                    self.imageUrl = images
                                    self.storyId = storyId
                                    self.storyTitle = title
                                    self.navigateToContentView = true
                                }
                    } else {
                        print("Failed to parse JSON")
                    }
                } else {
                    print("No response from server")
                }
            }
        }
    }

    private func logout() {
        let keychain = Keychain(service: "DaBanBaMolab.The-Echos-of-Infinity.auth")
        do {
            try keychain.remove("jwtToken")
        } catch {
            print("Error clearing Keychain: \(error.localizedDescription)")
        }
        appState.userEmail = nil
        IsLoggedOut = true
    }
    
    private func getRemainingInventory() {
        guard let email = appState.userEmail else {
            print("Error: User not logged in.")
            return
        }
        
        isAwaitingResponse = true
        
        let payload: [String: Any] = [
            "email": email,
        ]
        
        ServerConnection.shared.serverConnection(payload: payload, endpoint: "getRemainingInventory" ) { response in
            DispatchQueue.main.async {
                isAwaitingResponse = false
                if let response = response {
                    if let data = response.data(using: .utf8),
                       let json = try? JSONSerialization.jsonObject(with: data, options: []),
                       let dictionary = json as? [String: Any] {
                        if let values = dictionary["permissionToAdd"] as? Bool {
                            if values == true {
                                self.navigateToMenuView = true
                            }else {
                                self.navigateToMenuView = false
                                Warning = "You Have Reached Your Limit! Considering Upgrading your plan or delete previous stories!"
                            }
                        }
                    } else {
                        print("Failed to parse JSON")
                    }
                } else {
                    print("No response from server")
                }
            }
        }
    }
}
