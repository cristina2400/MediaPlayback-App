//  ContentView.swift
//  Media Playback App
//
//  Created by Cristina Ciobanu on 26/03/2024.
//

import SwiftUI
import AVKit
import AVFoundation





struct Video: Identifiable, Decodable {
    let id = UUID()
    let name: String
    let fileName: String
    let image: String
    let fileType: String
    
    enum CodingKeys: String, CodingKey {
           case name, fileName, image, fileType  //to fix the id
       }
}


struct ContentView: View {
    
    
    
    @Environment(\.scenePhase) var scenePhase
    @State var player = AVPlayer()
    @State private var selectedVideo: Video?
    let videos: [Video] = load("videos.json")

    init() {
        configureAudioSession()
    }

// FIRST VERSION - ADDING THE VIDEOS HERE MANNUALY //
    
//    let videos = [
//        Video(name: "Karol G - Contigo", fileName: "video1", image: "karolg"),
//        Video(name: "Ariana Grande - ", fileName: "video2", image: "ariana"),
//        Video(name: "Kali Uchis - ", fileName: "video3", image: "kali")
//
//    ]

    var body: some View {
        
        NavigationStack {
            ZStack {
                
                Color.accentColor.ignoresSafeArea()
                
                VStack (spacing: 0){
                    
                         ScrollView(.horizontal, showsIndicators: false) {
                             HStack {
                                 ForEach(videos) { video in
                                     Button(action: {
                                                   playVideo(video)
                                               }) {
                                                   VideoCardView(video: video)
                                               }
//                                     VideoCardView(video: video)
//                                         .onTapGesture {           //previous problem
//                                             playVideo(video)
//                                         }
                                 }
                                 
                             }
                             
                         }
                    Spacer()
                         

                    
                    if selectedVideo != nil {
                                        VideoPlayer(player: player)
                                            .frame(height: 250)
                                            .cornerRadius(20)
                                            .background(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .fill(Color.black.opacity(0.7))
                                                    .frame(height: 250)
                                                   
                                            )
                                            .padding()
                                    }
                    
                    
                     }
                .frame(height: 550)
                .padding()
                .navigationTitle("Media Playback")
            }
            
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            switch newPhase {
            case .active:
                print("The app is Active")
                configureAudioSession()
            case .inactive:
                print("The app is Inactive")
                
            case .background:
                print("The app has moved to the Background")
                
            @unknown default:
                break
            }
        }

        
    }
    
    func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
            print("Audio session is now active and configured for playback.")
        } catch {
            print("Failed to configure audio session. Error: \(error)")
        }
    }
    
    func playVideo(_ video: Video) {

   

      
        // Pause the current video if it's playing
        self.player.pause()
        
        if let videoUrl = Bundle.main.url(forResource: video.fileName, withExtension: video.fileType) {
            let newPlayer = AVPlayer(url: videoUrl)
            self.player = newPlayer
            self.player.play()
            selectedVideo = video
        }
    }
    
  
    
    
    
}
    
    



struct VideoCardView: View {
    var video: Video

    var body: some View {
        ZStack {
            ZStack(alignment: .bottomLeading) {
                Image(video.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 160, height: 250)
                    .cornerRadius(25)
                
                VStack(alignment: .leading){
                    Text(video.name)
                        .lineLimit(3)
                        .padding([.leading, .bottom, .trailing],7)
                        .frame(width: 160, alignment: .leading)
                    
                 
                }
                .foregroundStyle(Color.white)
                .shadow(radius: 20)
                .padding()
            }
            
            Image(systemName: "play.fill")
                .foregroundStyle(.white)
                .font(.title)
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(50)
        }
    }
}





#Preview {
    ContentView()
}

