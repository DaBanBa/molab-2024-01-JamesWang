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
            "Arcane": true,
            "Social Divide": false,
            "Power": false,
            "Emotional Bonds": false,
            "Magical World": false,
            "Holy Artifact": false,
            "Time Travel": false,
            "Cyberpunk": false,
            "Supernatural Phenomena": false,
            "Secret Laboratory": false,
            "War Battlefield": false,
            "Medieval Castle": false,
            "Age of Exploration": false,
            "Royal Romance": false,
            "AI Awakening": false,
            "Modern City": false,
        ],
        descriptions: [String: String] = [
            "Arcane": "Piltover, the 'City of Progress,' is a beacon of innovation and prosperity, powered by Hextech, a fusion of magic and technology that revolutionizes daily life and drives its economic dominance. Towering above, Piltover's wealth contrasts sharply with Zaun, the oppressed undercity below, where unregulated factories, toxic fumes, and rampant poverty define life. Despite its struggles, Zaun fosters resilience and ingenuity, creating Shimmer, a dangerous substance that amplifies physical abilities but at great cost.The divide between Piltover and Zaun highlights themes of inequality, exploitation, and rebellion, as both cities grapple with the consequences of their technological advancements. Amid this tension, Arcane weaves personal stories of ambition, loyalty, and loss, exploring the human cost of progress and the struggle for power in a fractured world.",
            "Power": "A central theme of the world, explored through the dynamics of control, influence, and technological supremacy.",
            "Emotional Bonds": "The personal relationships and connections tested by the harsh and divided society",
            "Magical World": "A realm brimming with enchanted forests, mystical creatures, and ancient spells, where magic is woven into the fabric of everyday life.",
            "Holy Artifact": "An object of immense power and divine origin, sought after by heroes and villains alike, capable of altering the fate of entire civilizations.",
            "Time Travel": "The ability to traverse different timelines, unveiling mysteries of the past and shaping the future while grappling with the consequences of altered history.",
            "Cyberpunk": "A gritty and neon-drenched world dominated by advanced technology, where corporate power clashes with the struggles of the underprivileged.",
            "Supernatural Phenomena": "Unexplained events that defy the laws of nature, from ghostly apparitions to strange cosmic forces, challenging the boundaries of reality.",
            "Secret Laboratory": "A hidden facility where groundbreaking experiments blur the line between science and madness, often holding secrets too dangerous for the world to know.",
            "War Battlefield": "A sprawling landscape scarred by conflict, where warriors clash over ideals, resources, and survival, leaving behind tales of heroism and tragedy.",
            "Medieval Castle": "A towering fortress surrounded by lush landscapes, serving as both a symbol of power and a stage for political intrigue and hidden secrets.",
            "Age of Exploration": "An era of daring voyages across uncharted seas, uncovering new lands, cultures, and opportunities amidst the dangers of the unknown.",
            "Royal Romance": "A tale of forbidden love and heartfelt connections amidst the grandeur and constraints of royal duties, blending passion with political stakes.",
            "AI Awakening": "The moment artificial intelligence surpasses its creators, gaining self-awareness and challenging humanity's understanding of life and ethics.",
            "Modern City": "A bustling urban landscape alive with skyscrapers, diverse cultures, and the ceaseless rhythm of innovation, where dreams and challenges collide.",
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
                                        .font(.custom("BodoniModa9pt-Regular", size: 14))
                                    Text(tags[tag]! ? "-" : "+")
                                        .font(.custom("BodoniModa9pt-Regular", size: 14))
                                }
                                .padding(.horizontal, 15)
                                .padding(.vertical, 8)
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
                    .padding(.bottom, 248)
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
