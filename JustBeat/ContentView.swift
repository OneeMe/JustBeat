//
// JustBeat
// Created by: onee on 2024/7/12
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    
    @StateObject var gameManager: GameManager = GameManager.shared
    
    var body: some View {
        VStack {
            Text("Just Beat")
                .font(.title)
            
            Picker("Select Game Scene", selection: $gameManager.gameScene) {
                ForEach(GameScene.allCases) { scene in
                    Text(scene.rawValue).tag(scene)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            ToggleImmersiveSpaceButton()
        }
        .padding()
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
