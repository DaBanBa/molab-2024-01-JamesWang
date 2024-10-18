//
//  ContentView.swift
//  Shared
//
//  Created by James on 10/10/2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var document:Document
    @State private var showPopup = false
    @State private var userInput: String = ""
    @State private var backgroundColor: Color = Color.white

    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                HStack {
                    ForEach(Array(document.model.items.last?.currentWord ?? ""), id: \.self) { letter in
                        Text((document.model.items.last?.guesses ?? "").contains(letter) ? String(letter) : "_")
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
                        if newValue.count > (document.model.items.last?.currentWord ?? "").count {
                            userInput = String(newValue.prefix(document.model.items.last?.currentWord.count ?? 0))
                        }
                    }
                
                Button("Check") {
                    print("checking")
                    userInput = userInput.lowercased()
                    guessLetter(userInput)
                    userInput = ""
                }
                .padding()
                .disabled(userInput.count != document.model.items.last?.currentWord.count)
                
                Spacer()
            }
            .background(backgroundColor)
            
            if showPopup {
                VStack {
                    Text("You Got It! The Word is \(document.model.items.last?.currentWord ?? "")!")
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
    
    func yeee(){
        showPopup = true
    }
    
    func newWord(){
        document.addItem()
    }
    
    func guessLetter(_ guess: String) {
        print("matching")
        let trueLetters = Array(document.model.items.last?.currentWord ?? "")
        let guessLetters = Array(guess)
        var guessesLetters = Array(document.model.items.last?.guesses ?? "")
        for i in 0..<guessLetters.count {
            if trueLetters[i] == guessLetters[i] {
                guessesLetters[i] = guessLetters[i]
            }
        }
        print("responding")
        if let lastItem = document.model.items.indices.last {
            document.model.items[lastItem].changeGuesses(guess: String(guessLetters))
        }
        
        document.updateItem()
        
        print("\(document.model.items.last?.currentWord ?? "errCW")")
        print("\(document.model.items.last?.guesses ?? "errGU")")
        
        if(document.model.items.last?.compareGuesses() ?? false){
            print("\(document.model.items.last?.compareGuesses() ?? false)")
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let model = Document()
        ContentView()
            .environmentObject(model)
    }
}
