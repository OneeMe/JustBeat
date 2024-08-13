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

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
