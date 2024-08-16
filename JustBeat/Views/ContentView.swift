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
            TitleView()
            SongView()
            SceneView()
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
