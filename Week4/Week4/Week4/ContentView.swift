//
//  ContentView.swift
//  Week4
//
//  Created by James Wang on 10/3/24.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var soundIndex = 0
    @State private var audioEngine = AVAudioEngine()
    @State private var playerNode = AVAudioPlayerNode()
    @State private var amplitude: Float = 0.0
    @State private var isTapInstalled = false
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                NavigationLink(value: "Happy.mp3") {
                    Text("Happy")
                }
                NavigationLink(value: "Hype.mp3") {
                    Text("Hype")
                }
                NavigationLink(value: "Energetic.mp3") {
                    Text("Energetic")
                }
                Spacer()
            }
            .navigationTitle("How You Feeling?")
            .navigationDestination(for: String.self) { soundfile in
                TimelineView(.animation) { context in
                    VStack {
                        Spacer()
                        Rectangle()
                        .fill(Color.blue)
                        .frame(width: 100, height: CGFloat(min(max(amplitude, 0.0), 3.0) * 1000))
                        .padding()
                        HStack {
                            Button("Play") {
                                playSound(soundfile)
                            }
                            Button("Stop") {
                                stopSound()
                            }
                        }
                        Text(soundfile)
                    }
                }
                .onDisappear {
                    stopSound()
                }
            }
        }
    }
    
    func playSound(_ fileName: String) {
        removeTap();
        
        let path = Bundle.main.path(forResource: fileName, ofType: nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            let audioFile = try AVAudioFile(forReading: url)
                
            audioEngine.attach(playerNode)
            let mainMixer = audioEngine.mainMixerNode
            audioEngine.connect(playerNode, to: mainMixer, format: audioFile.processingFormat)
            playerNode.scheduleFile(audioFile, at: nil){
                DispatchQueue.main.async {
                    removeTap()
                }
            }
            try audioEngine.start()
            playerNode.play()
            
            
            mainMixer.installTap(onBus: 0, bufferSize: 1024, format: mainMixer.outputFormat(forBus: 0)) { buffer, time in
                amplitude = self.getAmplitude(from: buffer)
            }
            isTapInstalled = true;
        } catch {
            print("err")
        }
    }
        
    func stopSound() {
        playerNode.stop()
        audioEngine.stop()
        removeTap()
    }
    
    func removeTap() {
        if isTapInstalled {
            audioEngine.mainMixerNode.removeTap(onBus: 0)
            isTapInstalled = false
        }
    }
    
    func getAmplitude(from buffer: AVAudioPCMBuffer) -> Float {
        guard let channelData = buffer.floatChannelData else { return 0.0 }
            
        let channelDataValue = channelData.pointee
        let frameLength = Int(buffer.frameLength)
        var howLoud: Float = 0.0
            
        for frame in 0..<frameLength {
            let sample = channelDataValue[frame]
            howLoud += sample * sample
        }
        howLoud = sqrt(howLoud / Float(frameLength))
        return howLoud
    }
}

#Preview {
    ContentView()
}
