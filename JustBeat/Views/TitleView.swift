//
//  TitleView.swift
//  JustBeat
//
//  Created by xuchi on 2024/8/16.
//

import SwiftUI

struct TitleView: View {
    var body: some View {
        HStack {
            Text("Just")
                .font(.system(size: 70, weight: .thin))
                .shadow(color: .red, radius: 5)
                .shadow(color: .red, radius: 5)
                .shadow(color: .red, radius: 50)
            
            Text("Beat")
                .font(.system(size: 70, weight: .thin))
                .shadow(color: .blue, radius: 5)
                .shadow(color: .blue, radius: 5)
                .shadow(color: .blue, radius: 50)
        }
        .padding()
    }
}

#Preview {
    TitleView()
}
