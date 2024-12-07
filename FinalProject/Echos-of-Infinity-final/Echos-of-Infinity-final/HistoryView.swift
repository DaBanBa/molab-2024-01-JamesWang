//
//  HistoryView.swift
//  The Echos of Infinity
//
//  Created by James Wang on 11/28/24.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var appState: AppState
    @State private var stories: [(id: String, title: String, isFinished: Bool)] = []
    @State private var dataButtons: [String] = []
    @State private var initStory: [String] = []
    @State private var imageUrl: [String] = []
    @State private var storyId: String = ""
    @State private var navigateToContentView = false
    @State private var isAwaitingResponse = false
    @State private var numberOfStoriesCount = ""
    @State private var storyTitle: String = ""
    @State private var choices: [String] = []
    
    var body: some View {
        VStack {
            List(stories, id: \.id) { story in
                Button(action: {
                    expandToEdit(id: story.id)
                }) {
                    HStack {
                        Text(story.title)
                            .font(.custom("BodoniModa9pt-Regular", size: 18))
                            .foregroundColor(.black)
                        Spacer()
                        Text(story.isFinished ? "Finished" : "In Progress")
                            .foregroundColor(story.isFinished ? .green : .orange)
                            .font(.custom("BodoniModa9pt-Regular", size: 18))
                    }.padding(.top, 16)
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.black)
                }.disabled(isAwaitingResponse)
                .swipeActions {
                    Button(role: .destructive) {
                        deleteStory(id: story.id)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }.listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            }.frame(height: 300)
            .listRowBackground(Color.white)
            .environment(\.colorScheme, .light)
            .background(Color.white)
            .scrollContentBackground(.hidden)
            .navigationDestination(isPresented: $navigateToContentView) {
                ContentView(dataButtons: dataButtons, story: initStory, choices: choices, imageUrl: imageUrl, storyId: storyId, storyTitle: storyTitle)
                    .transition(.opacity)
            }.navigationBarBackButtonHidden(true)
        }
        .background(Color.white)
        .onAppear {
            askHistory()
        }
    }
    
    private func expandToEdit(id: String) {
        guard let email = appState.userEmail else {
            print("Error: User not logged in.")
            return
        }
        
        isAwaitingResponse = true
        
        let payload: [String: Any] = [
            "email": email,
            "id": id,
        ]
        
        ServerConnection.shared.serverConnection(payload: payload, endpoint: "getSingleStory") { response in
            DispatchQueue.main.async {
                isAwaitingResponse = false
                if let response = response {
                    if let data = response.data(using: .utf8),
                       let json = try? JSONSerialization.jsonObject(with: data, options: []),
                        let dictionary = json as? [String: Any] {
                            let storyId = dictionary["storyId"] as? String ?? ""
                            let choices = dictionary["choices"] as? [String] ?? []
                            let wholeStory = dictionary["WholeStory"] as? [String] ?? []
                            let images = dictionary["images"] as? [String] ?? []
                            let title = dictionary["storyTitle"] as? String ?? ""
                            let choiceses = dictionary["oldChoices"] as? [String] ?? []
                            self.dataButtons = choices
                            self.initStory = wholeStory
                            self.imageUrl = images
                            self.choices = choiceses
                            self.storyId = storyId
                            self.storyTitle = title
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
    
    private func deleteStory(id: String) {
        guard let email = appState.userEmail else {
            print("Error: User not logged in.")
            return
        }
        
        let payload: [String: Any] = [
            "email": email,
            "storyId": id,
        ]
        
        ServerConnection.shared.serverConnection(payload: payload, endpoint: "deleteStory") { _ in
            DispatchQueue.main.async {
                print("Deleted story: \(id)")
            }
        }
    }
    
    private func askHistory() {
        guard let email = appState.userEmail else {
            print("Error: User not logged in.")
            return
        }
        
        let payload: [String: Any] = [
            "email": email,
        ]
        
        ServerConnection.shared.serverConnection(payload: payload, endpoint: "getPersonalHistory") { response in
            DispatchQueue.main.async {
                if let response = response {
                    if let data = response.data(using: .utf8),
                       let json = try? JSONSerialization.jsonObject(with: data, options: []),
                       let dictionary = json as? [String: Any],
                       let personalStoriesArray = dictionary["personalStories"] as? [[String: Any]] {
                       self.stories = personalStoriesArray.compactMap { storyDict in
                           if let storyid = storyDict["storyId"] as? String,
                              let title = storyDict["storyTitle"] as? String,
                              let isFinished = storyDict["isFinished"] as? Bool {
                               return (id: storyid, title: title, isFinished: isFinished)
                           }
                           return nil
                       }
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
