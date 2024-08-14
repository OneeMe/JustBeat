//
//  AlbumView.swift
//  JustBeat
//
//  Created by xuchi on 2024/8/13.
//

import SwiftUI

struct AlbumView: View {
    @State private var scrollEffectValue: Double = 13
    @State private var activePageIndex: Int = 0
    @StateObject var gameManager: GameManager = GameManager.shared
    
    let tileWidth: CGFloat = 220
    let tilePadding: CGFloat = 20
    
    var body: some View {
        PagingScrollView(activePageIndex: self.$activePageIndex, tileWidth:self.tileWidth, tilePadding: self.tilePadding){
            ForEach(0 ..< songs.count, id: \.self) { index in
                GeometryReader { geometry2 in
                    TileView(name: songs[index].songName)
                        .rotation3DEffect(Angle(degrees: Double((geometry2.frame(in: .global).minX - self.tileWidth*0.5) / -10 )), axis: (x: 0, y: 1, z: 0))
                        .onTapGesture {
                            print ("tap on index: \(index)")
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
    AlbumView()
}
