//
//  EchosMenu.swift
//  The Echos of Infinity
//
//  Created by James Wang on 11/23/24.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject var appState: AppState
    
    
    @State private var storyText: String
    @State private var tags: [String: Bool]
    @State private var descriptions: [String: String]
    @State private var storyTitle: String
    
    @State private var dataButtons: [String] = []
    @State private var initStory: [String] = []
    @State private var imageUrl: [String] = []
    @State private var storyId: String = ""
    @State private var navigateToCharacterView = false
    @State private var navigateToMainView = false
    
    init(
        tags: [String: Bool] = [
            "Piltover": true,
            "Zaun": true,
            "Hextech": false,
            "Social Divide": false,
            "Power": false,
            "Inequality": false,
            "Emotional Bonds": false
        ],
        descriptions: [String: String] = [
            "Piltover": "The City of Progress, a gleaming metropolis of innovation, wealth, and prosperity, fueled by advanced technology and Hextech.",
            "Zaun": "An oppressed undercity beneath Piltover, engulfed in toxic fumes, rampant poverty, and crime, highlighting the stark social divide.",
            "Hextech": "A magical energy harnessed for engineering marvels, driving the technological advancements of Piltover.",
            "Social Divide": "The growing tension between the wealthy elite of Piltover and the exploited inhabitants of Zaun, emphasizing themes of inequality.",
            "Power": "A central theme of the world, explored through the dynamics of control, influence, and technological supremacy.",
            "Inequality": "A critical issue rooted in the disparity between Piltover's prosperity and Zaun's suffering.",
            "Emotional Bonds": "The personal relationships and connections tested by the harsh and divided society of Piltover and Zaun."
        ],
        storyTitle: String = "The Hero's Journey",
        storyText: String = "This is story between both the people high up and down low. "
    ) {
        self._tags = State(initialValue: tags)
        self.descriptions = descriptions
        self._storyTitle = State(initialValue: storyTitle)
        self._storyText = State(initialValue: storyText)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack{
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
                    Text("World Setting")
                        .font(.custom("BodoniModa9pt-Regular", size: 20))
                        .padding(.top)
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        TextEditor(text: $storyTitle)
                            .scrollContentBackground(.hidden)
                            .frame(height: 32)
                            .font(.custom("BodoniModa9pt-Regular", size: 18))
                            .foregroundColor(Color.black)
                            .onTapGesture {
                                dismissKeyboard()
                            }
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.black)
                        
                        _FlexibleView(
                            availableWidth: geometry.size.width,
                            data: tags.keys.sorted(),
                            spacing: 10,
                            alignment: .leading
                        ) { tag in
                            Button(action: {
                                tags[tag]?.toggle()
                            }) {
                                HStack {
                                    Text(tag)
                                        .font(.custom("BodoniModa9pt-Regular", size: 18))
                                    Text(tags[tag]! ? "-" : "+")
                                        .font(.custom("BodoniModa9pt-Regular", size: 18))
                                }
                                .padding(.horizontal, 15)
                                .padding(.vertical, 10)
                                .background(tags[tag]! ? Color(hex: "#effab0") : Color.gray.opacity(0.5))
                                .foregroundColor(tags[tag]! ? Color.black : Color.white)
                                .cornerRadius(20)
                            }
                        }
                        
                        TextEditor(text: $storyText)
                            .scrollContentBackground(.hidden)
                            .padding()
                            .font(.custom("BodoniModa9pt-Regular", size: 18))
                            .frame(height: 240)
                            .foregroundColor(Color.black)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1)
                            ).onTapGesture {
                                dismissKeyboard()
                            }
                    }
                    .padding(.horizontal)
                }
                
                VStack(spacing: 8) {
                    Button(action: {
                        goToCharacters()
                    }) {
                        Text("Continue")
                            .padding(24)
                            .font(.custom("BodoniModa9pt-Regular", size: 20))
                            .frame(maxWidth: .infinity)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(48)
                            .padding(.horizontal)
                    }
                    .navigationDestination(isPresented: $navigateToCharacterView) {
                        CharacterView(tags: tags, descriptions: descriptions, storyTitle: storyTitle, storyText: storyText)
                            .transition(.opacity)
                    }
                    .navigationDestination(isPresented: $navigateToMainView) {
                        MainView()
                            .transition(.opacity)
                    }
                }
                .padding(.bottom, 20)
                .edgesIgnoringSafeArea(.bottom)
            }
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
        
    private func goToCharacters() {
        print(storyTitle)
        navigateToCharacterView = true
    }
}
