//
//  AlbumView.swift
//  JustBeat
//
//  Created by xuchi on 2024/8/13.
//

import SwiftUI

struct AlbumView: View {
    
    @StateObject var gameManager: GameManager = GameManager.shared
    
    let tileWidth: CGFloat = 220
    let tilePadding: CGFloat = 20
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(0 ..< songs.count, id: \.self) { index in
                    VStack {
                        RoundedRectangle(cornerRadius: 20).fill(Color.gray)
                            .overlay(GeometryReader { geometry in
                                Image(songs[index].songName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geometry.size.width, height: geometry.size.height)
                                    .cornerRadius(20)
                            })
                            .frame(width: 250, height: 250)
                        
                        Text(songs[index].songName)
                            .font(.title)
                    }
                    .onTapGesture {
                        print ("tap on index: \(index)")
                        self.gameManager.selectedSong = songs[index]
                        self.gameManager.gameScene = songs[index].defaultGameScene
                    }
                    .padding()
                    .glassBackgroundEffect()
                }
            }
        }
        .frame(height: 350)
    }
}

#Preview {
    AlbumView()
}
