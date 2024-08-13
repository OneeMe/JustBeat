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
    
    let tileWidth: CGFloat = 220
    let tilePadding: CGFloat = 20
    
    let imageNames = ["Pink-Floyd-Dark-Side-of-the-Moon", "1971-Whos-Next", "Beatles-Abbey-Road", "Carole-King-Tapestry", "Nirvana-Nevermind"]
    
    var body: some View {
        PagingScrollView(activePageIndex: self.$activePageIndex, tileWidth:self.tileWidth, tilePadding: self.tilePadding){
            ForEach(0 ..< self.imageNames.count, id: \.self) { index in
                GeometryReader { geometry2 in
                    TileView(name: imageNames[index])
                        .rotation3DEffect(Angle(degrees: Double((geometry2.frame(in: .global).minX - self.tileWidth*0.5) / -10 )), axis: (x: 0, y: 1, z: 0))
                        .onTapGesture {
                            print ("tap on index: \(index)")
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
