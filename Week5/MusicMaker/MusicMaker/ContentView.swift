//
//  ContentView.swift
//  Shared
//
//  Created by James on 10.10.2024.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("currentWord") var currentWord: String = "none"
    @AppStorage("guesses") var guesses:String = "none"
    @State private var showPopup = false
    @State private var userInput: String = ""
    @State private var backgroundColor: Color = Color.white
    
    var wordList: [String] = [
        "happy", "cat", "apple", "grape", "mango",
        "peach", "berry", "cherry", "plum", "melon",
        "lemon", "orange", "kiwi", "pearl", "stone",
        "table", "chair", "glass", "light", "music",
        "water", "bread", "pasta", "dance", "laugh",
        "smile", "house", "paint", "brush", "color",
        "world", "field"
    ]

    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                HStack {
                    ForEach(Array(currentWord), id: \.self) { letter in
                        Text(guesses.contains(letter) ? String(letter) : "_")
                            .font(.largeTitle)
                            .padding(.horizontal)
                    }
                }
                
                Spacer()
                
                TextField("What's your guess", text: $userInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 80)
                    .multilineTextAlignment(.center)
                    .autocorrectionDisabled(true)
                    .onChange(of: userInput) { newValue in
                        if newValue.count > currentWord.count {
                            userInput = String(newValue.prefix(currentWord.count))
                        }
                    }
                
                Button("Check") {
                    print("checking")
                    userInput = userInput.lowercased()
                    guessLetter(userInput)
                    userInput = ""
                }
                .padding()
                .disabled(userInput.count != currentWord.count)
                
                Spacer()
            }
            .background(backgroundColor)
            .onAppear {
                initializeGame()
            }
            
            if showPopup {
                VStack {
                    Text("You Got It! The Word is \(currentWord)!")
                        .font(.headline)
                    Button("Next Word") {
                        showPopup = false
                        newWord()
                    }
                }
                .frame(width: 300, height: 200)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 20)
            }
        }
    }
    
    func initializeGame() {
        if currentWord == "none" {
            if let randomWord = wordList.randomElement() {
                currentWord = randomWord
                guesses = String(repeating: "_", count: currentWord.count)
            }
        }
    }
    
    func yeee(){
        showPopup = true
    }
    
    func newWord(){
        if let randomWord = wordList.randomElement() {
            currentWord = randomWord
            guesses = String(repeating: "_", count: currentWord.count)
        }
    }
    
    func guessLetter(_ guess: String) {
        print("matching")
        let trueLetters = Array(currentWord)
        let guessLetters = Array(guess)
        var guessesLetters = Array(guesses)
        for i in 0..<guessLetters.count {
            if trueLetters[i] == guessLetters[i] {
                guessesLetters[i] = guessLetters[i]
            }
        }
        print("responding")
        guesses = String(guessesLetters)
        if(!guesses.contains("_")){
            yeee()
            changeBackgroundColor(to: Color.green)
        }else{
            changeBackgroundColor(to: Color.pink)
        }
    }
    
    func changeBackgroundColor(to color: Color) {
        backgroundColor = color
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            backgroundColor = Color.white
        }
    }
}

#Preview {
    ContentView()
}
