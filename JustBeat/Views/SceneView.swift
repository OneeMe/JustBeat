//
//  SceneView.swift
//  JustBeat
//
//  Created by xuchi on 2024/8/16.
//

import SwiftUI

struct SceneView: View {
    @StateObject var gameManager: GameManager = GameManager.shared

    var body: some View {
        VStack {
            Picker("Select Game Scene", selection: $gameManager.gameScene) {
                ForEach(GameScene.allCases) { scene in
                    Text(scene.rawValue).tag(scene)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            ToggleImmersiveSpaceButton()
        }
        .padding()
        .glassBackgroundEffect()
    }
}

#Preview {
    SceneView()
}
