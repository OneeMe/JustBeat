//
// JustBeat
// Created by: onee on 2024/7/12
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    
    @StateObject var gameManager: GameManager = GameManager.shared

    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            if let immersiveContentEntity = try? await Entity(named: "Immersive", in: realityKitContentBundle) {
                content.add(immersiveContentEntity)
                content.add(gameManager.root)
            }
        }
        .onAppear() {
            gameManager.start()
        }
        .onDisappear() {
            gameManager.stop()
        }
    }
}

#Preview(immersionStyle: .full) {
    ImmersiveView()
        .environment(AppModel())
}
