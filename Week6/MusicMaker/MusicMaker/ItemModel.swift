//
//  Item.swift
//

import Foundation

struct ItemModel : Identifiable, Codable {
    var id = UUID()
    var currentWord:String = ""
    var guesses:String = ""
    
    func compareGuesses()  -> Bool {
        if self.guesses == self.currentWord{
            return true
        }else {
            return false
        }
    }
    
    mutating func changeGuesses(guess: String){
        self.guesses = guess
    }
}

