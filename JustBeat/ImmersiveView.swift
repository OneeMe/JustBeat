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
                gameManager.handleCollision(content: content)
            }
        }
        .onAppear() {
            gameManager.start()
        }
        .onDisappear() {
            gameManager.stop()
        }
        .gesture(SpatialTapGesture().targetedToAnyEntity().onEnded({ value in
            if value.entity.name == BOX_ENTITY_NAME {
                gameManager.handleCollidedBox(box: value.entity)
            }
        }))
    }
}

#Preview(immersionStyle: .full) {
    ImmersiveView()
        .environment(AppModel())
}
