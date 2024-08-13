//
//  TileView.swift
//  JustBeat
//
//  Created by xuchi on 2024/8/13.
//

import SwiftUI

struct TileView: View {
    let name: String
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 20).fill(Color.gray)
                .overlay(GeometryReader { geometry in
                    Image(name)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .cornerRadius(20)
                })
                .frame(width: 250, height: 250)
            
            Text(name)
                .font(.title)
        }
        .padding()
        .glassBackgroundEffect()

    }
}
