//
//  Model.swift
//

import Foundation

class Document: ObservableObject {
    @Published var model: Model
    // @Published var items:[ItemModel]
    
    // file name to store JSON for model items
    let saveFileName = "model.json"
    
    // true to initialize model items with sample items
    let initSampleItems = true
    
    init() {
        print("Model init")
        
        // For testing:
//         remove(fileName: saveFileName)
        
        model = Model(JSONfileName: saveFileName);
        if initSampleItems && model.items.isEmpty {
            model.items = []
            var guesses = ""
            var currentWord = ""
            if let randomWord = wordList.randomElement() {
                currentWord = randomWord
                guesses = String(repeating: "_", count: randomWord.count)
            }
            addItem(currentWord: currentWord, guesses: guesses);
            saveModel();
        }
    }
    
    func addItem() {
        var guesses = ""
        var currentWord = ""
        if let randomWord = wordList.randomElement() {
            currentWord = randomWord
            guesses = String(repeating: "_", count: randomWord.count)
        }
        let item = ItemModel(id: UUID(), currentWord: currentWord, guesses: guesses);
        model.addItem(item: item);
        saveModel();
    }
    
    func addItem(currentWord:String, guesses:String) {
        let item = ItemModel(id: UUID(), currentWord: currentWord, guesses: guesses);
        model.addItem(item: item);
        saveModel();
    }
    
    func addItem(item: ItemModel) {
        model.addItem(item: item);
        saveModel();
    }
    
    func updateItem(){
        saveModel();
    }

    func updateItem(item: ItemModel) {
        model.updateItem(item: item);
        saveModel();
    }
    
    func deleteItem(id: UUID) {
        model.deleteItem(id: id)
        saveModel();
    }
    
    func saveModel() {
        print("Document saveModel")
        model.saveAsJSON(fileName: saveFileName)
    }
}

var wordList: [String] = [
    "happy", "cat", "apple", "grape", "mango",
    "peach", "berry", "cherry", "plum", "melon",
    "lemon", "orange", "kiwi", "pearl", "stone",
    "table", "chair", "glass", "light", "music",
    "water", "bread", "pasta", "dance", "laugh",
    "smile", "house", "paint", "brush", "color",
    "world", "field"
]
