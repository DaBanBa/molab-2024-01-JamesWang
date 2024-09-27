//
//  ContentView.swift
//  Week3
//
//  Created by James Wang on 9/26/24.
//

import SwiftUI

struct ContentView: View {
    @State private var userInput = ""
    var rowInp: Int {
        if userInput.count >= 2  {
            let firstChar = userInput[userInput.startIndex]
            if let returnInt = Int(String(firstChar)) {
                return returnInt
            }
        }
        return 0
    }
    var colInp: Int {
        if userInput.count >= 2 {
            let firstChar = userInput[userInput.index(before: userInput.endIndex)]
            if let returnInt = Int(String(firstChar)) {
                return returnInt
            }
        }
        return 0
    }
    private var emojiList = ["🌑", "🌒", "🌓", "🌔", "🌕"]
    var body: some View {
        NavigationStack{
            Form{
                VStack {
                    Section{
                        TextField("Enter A Random 2 Digit Number", text: $userInput)
                            .keyboardType(.numberPad)
                            .onSubmit {
                                if userInput.count > 2 {
                                    userInput = String(userInput.prefix(2))
                                }
                            }
                    }
                    VStack(spacing: 5) {
                        ForEach(0..<10, id: \.self) { row in
                            HStack(spacing: 5) {
                                ForEach(0..<10, id: \.self) { col in
                                    let randomEmoji = emojiForPosition(row: row + 1, col: col + 1)
                                    Text(randomEmoji)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }.navigationTitle("Art Generation")
        }
    }
    func emojiForPosition(row: Int, col: Int) -> String {
        if(rowInp != 0 && colInp != 0){
            let absRowDif = abs(rowInp - row)
            let absColDif = abs(colInp - col)
            let division = 2.0
            let absTotalDif = Int(ceil(Double(absRowDif + absColDif) / division))
            if absTotalDif >= 5{
                return emojiList[0]
            } else{
                return emojiList[4-absTotalDif]
            }
        }else {
            return emojiList[0]
        }
    }
}

#Preview {
    ContentView()
}
