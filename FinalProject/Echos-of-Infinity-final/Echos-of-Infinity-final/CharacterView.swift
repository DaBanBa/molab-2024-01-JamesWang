//
//  EchosMenu.swift
//  The Echos of Infinity
//
//  Created by James Wang on 11/23/24.
//

import SwiftUI

struct CharacterView: View {
    @EnvironmentObject var appState: AppState
    
    @State private var storyText = "This is story between both the people high up and down low. "
    @State private var characterSelections: [String: Bool] = [
        "Viktor": false,
        "Ekko": false,
        "Jayce": false,
        "Violet": false,
        "Jinx": true,
        "Silco": false,
    ]
    
    @State private var characterRenaming: [String: String] = [
        "Viktor": "Viktor",
        "Ekko": "Ekko",
        "Jayce": "Jayce",
        "Violet": "Violet",
        "Jinx": "Jinx",
        "Silco": "Silco",
    ]
    
    let characterImages = [
        "Viktor": "Viktor",
        "Ekko": "Ekko",
        "Jayce": "Jayce",
        "Violet": "Violet",
        "Jinx": "Jinx",
        "Silco": "Silco",
    ]
    
    let characterInfo: [String: String] = [
        "Viktor": "The Idealistic Creator",
        "Ekko": "Timeless Rebel",
        "Jayce": "The Visionary Innovator",
        "Violet": "The Unyielding Fist",
        "Jinx": "The Chaotic Dreamer",
        "Silco": "The Undercity Mastermind",
    ]
    
    @State private var tags: [String: Bool]
    
    @State private var descriptions: [String: String]

    @State private var storyTitle: String
    @State private var navigateToContentView = false
    @State private var dataButtons: [String] = []
    @State private var initStory: [String] = []
    @State private var imageUrl: [String] = []
    @State private var storyId: String = ""
    @State private var navigateToBackstory = false
    @State private var isAwaitingResponse = false
    @State private var navigateToMainView = false
    @ObservedObject private var keyboardResponder = KeyboardResponder()
    
    init(tags: [String: Bool], descriptions: [String: String], storyTitle: String, storyText: String) {
        self._tags = State(initialValue: tags)
        self._descriptions = State(initialValue: descriptions)
        self._storyTitle = State(initialValue: storyTitle)
        self._storyText = State(initialValue: storyText)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Button(action: {
                        navigateToMainView = true
                    }) {
                        Image("Back")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 48)
                    }
                    Spacer()
                    Text("Character Selection")
                        .font(.custom("BodoniModa9pt-Regular", size: 20))
                        .padding(.top)
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical)
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        LazyVGrid(
                            columns: [GridItem(.flexible()), GridItem(.flexible())],
                            spacing: 12
                        ) {
                            ForEach(Array(characterSelections.keys), id: \.self) { character in
                                    VStack(spacing: 8) {
                                        if let imageName = characterImages[character] {
                                            Image(imageName)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(maxWidth: .infinity)
                                                .onTapGesture {
                                                    characterSelections[character]?.toggle()
                                                }
                                                .cornerRadius(8)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .stroke((characterSelections[character]! ? Color.green : Color.gray.opacity(0.3)), lineWidth: 2)
                                                )
                                                .frame(width: 100, height: 133)
                                        }
                                        
                                        TextField(
                                            "Enter name",
                                            text: Binding(
                                                get: { characterRenaming[character] ?? "" },
                                                set: { characterRenaming[character] = $0 }
                                            )
                                        )
                                        .font(.custom("BodoniModa9pt-Regular", size: 20))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        Rectangle()
                                            .frame(height: 1)
                                            .foregroundColor(.black)
                                        Text(characterInfo[character] ?? "None")
                                        .font(.custom("BodoniModa9pt-Regular", size: 14))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.gray)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    }
                                    .frame(width: max(geometry.size.width / 2 - 32, 0))
                            }
                        }
                        .padding()
                    }
                }.padding(8)
                
                HStack(spacing: 0) {
                    if isAwaitingResponse {
                        Button(action: {}) {
                            Text("Generating")
                                .font(.custom("BodoniModa9pt-Regular", size: 20))
                                .padding(24)
                                .frame(maxWidth: .infinity)
                                .background(isAwaitingResponse ? Color.gray : Color.black)
                                .foregroundColor(.white)
                                .clipShape(
                                    CustomCorners(topLeft: 38, topRight: 38, bottomRight: 38, bottomLeft: 38)
                                )
                        }
                        .disabled(true)
                    }else {
                        Button(action: {
                            backToBackStory()
                        }) {
                            Text("Back")
                                .font(.custom("BodoniModa9pt-Regular", size: 20))
                                .padding(24)
                                .frame(width: 100)
                                .background(isAwaitingResponse ? Color.gray : Color.black)
                                .foregroundColor(.white)
                                .clipShape(
                                    CustomCorners(topLeft: 38, topRight: 0, bottomRight: 0, bottomLeft: 38)
                                )
                        }.disabled(isAwaitingResponse)
                            .transition(.opacity)
                            .navigationDestination(isPresented: $navigateToBackstory) {
                                MenuView(tags: tags, descriptions: descriptions, storyTitle: storyTitle, storyText: storyText)
                                    .transition(.opacity)
                            }
                        
                        Button(action: {
                            initStoryAtServer()
                        }) {
                            Text("Begin")
                                .font(.custom("BodoniModa9pt-Regular", size: 20))
                                .padding(24)
                                .frame(maxWidth: .infinity)
                                .background(isAwaitingResponse ? Color.gray : Color(hex: "#effab0"))
                                .foregroundColor(isAwaitingResponse ? Color.white : Color.black)
                                .clipShape(
                                    CustomCorners(topLeft: 0, topRight: 38, bottomRight: 38, bottomLeft: 0)
                                )
                        }.disabled(isAwaitingResponse)
                            .transition(.opacity)
                            .navigationDestination(isPresented: $navigateToContentView) {
                                ContentView(dataButtons: dataButtons, story: initStory, choices: [], imageUrl: imageUrl, storyId: storyId, storyTitle: storyTitle)
                                    .transition(.opacity)
                            }
                            .navigationDestination(isPresented: $navigateToMainView) {
                                MainView()
                                    .transition(.opacity)
                            }
                    }
                }
                .padding(.bottom, 20)
                .padding(.horizontal, 24)
                .edgesIgnoringSafeArea(.bottom)
            }
            .padding(.bottom, keyboardResponder.currentHeight)
            .animation(.easeInOut(duration: 0.3), value: keyboardResponder.currentHeight)
            .background(Color.white)
            .foregroundColor(Color.black)
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarBackButtonHidden(true)
            .onTapGesture {
                dismissKeyboard()
            }
        }
    }

    
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
        
    private func backToBackStory(){
        navigateToBackstory = true
    }
    
    private func initStoryAtServer() {
        guard let email = appState.userEmail else {
            print("Error: User not logged in.")
            return
        }
        
        isAwaitingResponse = true
        
        let selectedCharacters = characterSelections.filter { $0.value }.map { $0.key }
        var differentKeyValuesAsString: [String] {
            characterRenaming
                .filter { key, value in key != value }
                .map { "\($0.key):\($0.value)" }
        }
        
        var bgStory = tags.filter { $0.value }
                        .keys
                        .compactMap { descriptions[$0] }
                        .joined(separator: " ")
        
        bgStory += storyText
        
        let payload: [String: Any] = [
            "email": email,
            "initStory": bgStory,
            "storyTitle": storyTitle,
            "selectedCharacters": selectedCharacters.joined(separator: ", "),
            "renamingCharacters": differentKeyValuesAsString.joined(separator: ", "),
        ]
        
        ServerConnection.shared.serverConnection(payload: payload, endpoint: "initStory") { response in
            DispatchQueue.main.async {
                isAwaitingResponse = false
                if let response = response {
                    if let data = response.data(using: .utf8),
                       let json = try? JSONSerialization.jsonObject(with: data, options: []),
                       let dictionary = json as? [String: Any] {
                        if let values = dictionary["values"] as? [String] {
                            self.dataButtons = values
                        }
                        if let storyBg = dictionary["storyBG"] as? String {
                            self.initStory.append(storyBg)
                        }
                        if let charInfo = dictionary["characterDetails"] as? String {
                            self.initStory.append(charInfo)
                        }
                        if let story = dictionary["story"] as? String {
                            self.initStory.append(story)
                            print(story)
                        }
                        if let image = dictionary["imageUrl"] as? String {
                            self.imageUrl.append(image)
                        }
                        if let storyId = dictionary["storyId"] as? String {
                            self.storyId = storyId
                        }
                        if let title = dictionary["storyTitle"] as? String {
                            self.storyTitle = title 
                        }
                        self.navigateToContentView = true
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
