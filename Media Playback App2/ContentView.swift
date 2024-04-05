//
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
    
    @State var player = AVPlayer()
    @State private var selectedVideo: Video?
    
    let videos: [Video] = load("videos.json")

   
    
// FIRST VERSION - ADDING THE VIDEOS HERE MANNUALY //
    
//    let videos = [
//        Video(name: "Karol G - Contigo", fileName: "latinmusic", image: "contigo"),
//        Video(name: "Video 2", fileName: "video2", image: "contigo"),
//        Video(name: "Video 3", fileName: "video3", image: "contigo")
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
                         
                
//                         if let selectedVideo = selectedVideo {
//                             VideoPlayer(player: player)
//                                 .onAppear {
//                                     playVideo(selectedVideo)
//                                 }
//                         }
                    
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
        
        
        
    }
    
    
    func playVideo(_ video: Video) {
        setupBackgroundAudio()
      
        // Pause the current video if it's playing
        self.player.pause()
        
        if let videoUrl = Bundle.main.url(forResource: video.fileName, withExtension: video.fileType) {
            let newPlayer = AVPlayer(url: videoUrl)
            self.player = newPlayer
            self.player.play()
            selectedVideo = video
        }
    }
    
    private func setupBackgroundAudio() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set audio session category. Make sure to handle this properly.")
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

