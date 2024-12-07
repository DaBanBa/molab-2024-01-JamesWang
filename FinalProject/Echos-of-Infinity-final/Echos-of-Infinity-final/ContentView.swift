import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    
    @State private var navigateToMainView = false
    @State var dataButtons: [String]
    @State var story: [String]
    @State var choices: [String]
    @State var imageUrl: [String]
    @State var storyId: String
    @State var storyTitle: String
    @State private var isAwaitingResponse = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Button(action: {
                        navigateToMainView = true
                    }) {
                        Image("Back")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 48)
                    }.navigationDestination(isPresented: $navigateToMainView) {
                        MainView()
                            .transition(.opacity)
                    }.navigationBarBackButtonHidden(true)
                    Spacer()
                    Text(storyTitle)
                        .font(.custom("BodoniModa9pt-Regular", size: 20))
                        .padding(.top)
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical)
                
                ScrollViewReader { proxy in
                    ScrollView {
                        ForEach(0..<story.count, id: \.self) { index in
                            storyItemView(for: index, geometry: geometry)
                                .id(index)
                        }
                    }
                    .onAppear {
                        if let lastIndex = story.indices.last {
                            withAnimation {
                                proxy.scrollTo(lastIndex, anchor: .bottom)
                            }
                        }
                    }
                    .onChange(of: story.count) {
                        if let lastIndex = story.indices.last {
                            withAnimation {
                                proxy.scrollTo(lastIndex, anchor: .bottom)
                            }
                        }
                    }
                }
                
                VStack {
                    if isAwaitingResponse {
                            Button(action: {}) {
                                Text("Generating")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.black)
                                    .foregroundColor(Color.white)
                                    .cornerRadius(48)
                                    .padding(.horizontal, 12)
                                    .font(.custom("BodoniModa9pt-Regular", size: 14))
                            }
                            .disabled(true)
                            .transition(.opacity)
                    } else {
                        ForEach(dataButtons.indices, id: \.self) { index in
                            Button(action: {
                                var buttonText = dataButtons[index]
                                if buttonText == "Back to Menu" {
                                    navigateToMainView = true
                                }else {
                                    if buttonText.hasPrefix("e: ") {
                                        buttonText = String(buttonText.dropFirst(3))
                                    }
                                    sendDataToServer(dataButtons[index])
                                }
                            }) {
                                let isEnding = dataButtons[index].hasPrefix("e: ")
                                let displayText = isEnding ? String(dataButtons[index].dropFirst(3)) : dataButtons[index]
                                Text("\(displayText)")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(isAwaitingResponse ? Color.gray : (isEnding ? Color(hex: "#e67168") : Color(hex: "#282828")))
                                    .foregroundColor(isAwaitingResponse ? Color.gray.opacity(0.6) : Color(hex: "#ecf0e3"))
                                    .cornerRadius(48)
                                    .padding(.horizontal, 12)
                                    .font(.custom("BodoniModa9pt-Regular", size: 14))
                            }.disabled(isAwaitingResponse)
                            .transition(.opacity)
                        }
                    }
                }.animation(.easeInOut(duration: 0.3), value: isAwaitingResponse)
                .padding()
            }
            .background(Color.white)
            .foregroundColor(Color.black)
        }
    }
    
    private func storyItemView(for index: Int, geometry: GeometryProxy) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            if index >= 3 {
                let choiceIndex = index - 3
                if choices.indices.contains(choiceIndex){
                    let choiceText = cleanChoiceText(choices[choiceIndex])
                    Text(choiceText)
                        .font(.custom("BodoniModa9pt-Regular", size: 20))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.3))
                }
            }
            if index == 0 {
                Text("World")
                    .font(.custom("BodoniModa9pt-Regular", size: 20))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.3))
            }
            if index == 1 {
                Text("Characters")
                    .font(.custom("BodoniModa9pt-Regular", size: 20))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.3))
            }
            Text(story[index])
                .font(.custom("BodoniModa9pt-Regular", size: 20))
                .padding()
                .background(index < 2 ? Color.gray.opacity(0.3) : Color.white)
            if index >= 2 {
                let imageIndex = index - 2
                if imageIndex < imageUrl.count {
                    let urlString = imageUrl[imageIndex]
                    if urlString == "NSFW" {
                        Text("Image is NSFW")
                            .foregroundColor(.red)
                            .padding()
                    } else if let url = URL(string: urlString) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geometry.size.width - 24)
                                    .padding(.horizontal, 12)
                            case .failure:
                                Text("Failed to load image")
                                    .foregroundColor(.red)
                            @unknown default:
                                Text("Unknown error")
                            }
                        }
                    }
                }
            }
        }
    }
    
    func cleanChoiceText(_ text: String) -> String {
        if text.hasPrefix("e: ") {
            return String(text.dropFirst(3))
        }
        return text
    }

    
    private func sendDataToServer(_ choice: String) {
        guard let email = appState.userEmail else {
            print("Error: User not logged in.")
            return
        }
        
        isAwaitingResponse = true
        choices.append(choice)
        let payload: [String: Any] = [
            "email": email,
            "storyId": storyId,
            "UserChoice": choice
        ]
        
        ServerConnection.shared.serverConnection(payload: payload, endpoint: "data") { response in
            DispatchQueue.main.async {
                isAwaitingResponse = false
                if let response = response {
                    if let data = response.data(using: .utf8),
                       let json = try? JSONSerialization.jsonObject(with: data, options: []),
                       let dictionary = json as? [String: Any] {
                        if let values = dictionary["values"] as? [String] {
                            self.dataButtons = values
                        }
                        if let storyText = dictionary["story"] as? String {
                            self.story.append(storyText)
                        }
                        if let image = dictionary["imageUrl"] as? String {
                            self.imageUrl.append(image)
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
