import CoreImage
import CoreImage.CIFilterBuiltins
import PhotosUI
import SwiftUI

import UIKit

struct ContentView: View {
    @State private var processedImage: Image?
    @State private var processingImage: UIImage?
    @State private var selectedItem: PhotosPickerItem?
    @State private var emoji: String = "😄"
    @State private var fontSize: CGFloat = 200
    @State private var positionX: CGFloat = 0.5
    @State private var positionY: CGFloat = 0.5
    var body: some View {
        NavigationStack {
            VStack {
                PhotosPicker(selection: $selectedItem) {
                    if let processedImage {
                        processedImage
                            .resizable()
                            .scaledToFit()
                    } else {
                        ContentUnavailableView("No picture", systemImage: "photo.badge.plus", description: Text("Tap to import a photo"))
                    }
                }
                .buttonStyle(.plain)
                .onChange(of: selectedItem, loadImage)
                if processingImage != nil {
                    VStack(spacing: 20) {
                        HStack {
                            Text("Emoji: ")
                            TextField("Enter emoji", text: $emoji)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 100)
                        }
                        VStack {
                            Text("Font Size: \(Int(fontSize))")
                            Slider(value: $fontSize, in: 20...1000, step: 1)
                                .padding(.horizontal)
                        }
                        VStack {
                            Text("X: \(Int(positionX * 100))%")
                            Slider(value: $positionX, in: 0...1, step: 0.01)
                                .padding(.horizontal)

                            Text("Y: \(Int(positionX * 100))%")
                            Slider(value: $positionY, in: 0...1, step: 0.01)
                                .padding(.horizontal)
                        }
                        Button("Update Image") {
                            if let uiImage = processingImage {
                                if let imageWithEmoji = addEmojiToImage(uiImage: uiImage, emoji: emoji, positionX: positionX, positionY: positionY, fontSize: fontSize) {
                                    processedImage = Image(uiImage: imageWithEmoji)
                                }
                            }
                        }
                        .padding()
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(.top)
                }
            }
        }
    }

    func loadImage() {
        Task {
            guard let imageData = try await selectedItem?.loadTransferable(type: Data.self),
                  let uiImage = UIImage(data: imageData) else {
                return
            }
            processingImage = uiImage
            if let imageWithEmoji = addEmojiToImage(uiImage: uiImage, emoji: emoji, positionX: positionX, positionY: positionY, fontSize: fontSize) {
                processedImage = Image(uiImage: imageWithEmoji)
            } else {
                processedImage = Image(uiImage: uiImage)
            }
        }
    }
    
    func addEmojiToImage(uiImage: UIImage, emoji: String, positionX: CGFloat, positionY: CGFloat, fontSize: CGFloat) -> UIImage? {
        let emojiLabel = UILabel()
        emojiLabel.text = emoji
        emojiLabel.font = UIFont.systemFont(ofSize: fontSize)
        emojiLabel.sizeToFit()
        let renderer = UIGraphicsImageRenderer(size: uiImage.size)

        let newImage = renderer.image { context in
            uiImage.draw(in: CGRect(origin: .zero, size: uiImage.size))
//            let emojiPosition = CGPoint(x: positionX * uiImage.size.width - emojiLabel.frame.width / 2, y: positionY * uiImage.size.height - emojiLabel.frame.height / 2)
//            print(emojiPosition)
//            let emojiRect = CGRect(origin: emojiPosition, size: emojiLabel.bounds.size)
//            print(emojiRect)
//            emojiLabel.draw(emojiRect)
            
            let emojiAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: fontSize)
            ]
            let attributedString = NSAttributedString(string: emoji, attributes: emojiAttributes)
            let emojiSize = attributedString.size()
            let emojiPosition = CGPoint(
                x: positionX * uiImage.size.width - emojiSize.width / 2,
                y: positionY * uiImage.size.height - emojiSize.height / 2
            )
            attributedString.draw(at: emojiPosition)
        }
        return newImage
    }
}

#Preview {
    ContentView()
}
