//
//  ContentView.swift
//  Shared
//
//  Created by James on 10/10/2024.
//

import SwiftUI

@main
struct MusicMaker: App {
    
    @StateObject var document = Document()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(document)
        }
    }
}
