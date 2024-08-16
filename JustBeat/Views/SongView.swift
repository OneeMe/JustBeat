//
//  SongView.swift
//  JustBeat
//
//  Created by xuchi on 2024/8/13.
//

import SwiftUI

struct SongView: View {
    
    @StateObject var gameManager: GameManager = GameManager.shared
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(0 ..< songs.count, id: \.self) { index in
                    VStack {
                        Image(songs[index].songName)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(30)
                        
                        Text(songs[index].songName)
                            .font(.title)
                    }
                    .padding()
                    .glassBackgroundEffect()
                    .onTapGesture {
                        self.gameManager.selectedSong = songs[index]
                        self.gameManager.gameScene = songs[index].defaultGameScene
                    }
                }
            }
        }
        .frame(height: 350)
    }
}

#Preview {
    SongView()
}
