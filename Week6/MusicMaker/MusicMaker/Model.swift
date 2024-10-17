//
//  Model.swift
//  ImageEditDemo
//
//  Created by jht2 on 10/14/23.
//

import SwiftUI

struct Model: Codable {
    var items: [ItemModel]
    
    init () {
        items = [];
    }
    
    mutating func addItem(item: ItemModel) {
        items.append(item)
    }
    
    mutating func updateItem(item: ItemModel) {
        if let index = findIndex(item.id) {
            items[index] = item;
        }
    }
    
    mutating func deleteItem(id: UUID) {
        if let index = findIndex(id) {
            items.remove(at: index)
        }
    }
    
    func findIndex(_ id: UUID) -> Int? {
        return items.firstIndex { item in item.id == id }
    }
    
}

