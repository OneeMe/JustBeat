//
// JustBeat
// Created by: onee on 2024/7/12
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    
    @StateObject var gameManager: GameManager = GameManager.shared
    @State var contentEntity = Entity()
    
    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            if let immersiveContentEntity = try? await Entity(named: "Immersive", in: realityKitContentBundle) {
                contentEntity = immersiveContentEntity
                await switchSkybox()
                
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
    
    func switchSkybox() async {
        if let skybox = contentEntity.findEntity(named: "SkySphere"), let skyboxModel = skybox as? ModelEntity {
            if var skyboxMaterial = skyboxModel.model?.materials.first as? ShaderGraphMaterial {
                guard let texture = try? await TextureResource(named: gameManager.gameScene.rawValue) else {
                    fatalError("Unable to load texture.")
                }
                try? skyboxMaterial.setParameter(name: "SkySphere_Texture", value: .textureResource(texture))
                skyboxModel.model?.materials = [skyboxMaterial]
            }
        }
    }
}

#Preview(immersionStyle: .full) {
    ImmersiveView()
        .environment(AppModel())
}
