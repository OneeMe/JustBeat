//
// JustBeat
// Created by: onee on 2024/7/12
//

import ARKit
import AVKit
import Foundation
import RealityKit
import RealityKitContent
import Spatial
import SwiftUI

let BOX_ENTITY_NAME = "Box"
let GLOVE_ENTITY_NAME_SUFFIX = "Glove"
let songs = [
    Song(songName: "2077", defaultGameScene: .cyberpunk),
    Song(songName: "Missing U", defaultGameScene: .painting),
    Song(songName: "SaintPerros", defaultGameScene: .cartoon),
]

class GameManager: ObservableObject {
    let root = Entity()
    let skyBox = Entity()
    
    @Published var isReady = false
    @Published var selectedSong: Song = songs.first!
    @Published var gameScene: GameScene = .cyberpunk
    
    static let shared = GameManager()

    func start() {
        let startTime = DispatchTime.now()
        self.selectedSong.songPlayer.volume = 0.6
        self.selectedSong.songPlayer.numberOfLoops = 0
        self.selectedSong.songPlayer.currentTime = 0
        self.selectedSong.songPlayer.play()
        Task { @MainActor in
            self.scheduleTasks(notes: self.selectedSong.songStage.notes, startTime: startTime)
            if self.dataProvidersAreSupported && self.isHandsReady {
                try await self.session.run([self.handTracking])
                await self.processHandUpdates()
            }
        }
    }

    func stop() {
        self.selectedSong.songPlayer.stop()
        colisionSubs?.cancel()
        Task { @MainActor in
            self.cancelAllTasks()
        }
        for entity in root.children {
            entity.removeFromParent()
        }
    }

    func handleCollision(content: RealityViewContent) {
        colisionSubs = content.subscribe(to: CollisionEvents.Began.self) { collisionEvent in
            let a = collisionEvent.entityA
            let b = collisionEvent.entityB
            var box: Entity!
            if a.name.hasSuffix(GLOVE_ENTITY_NAME_SUFFIX) && b.name == BOX_ENTITY_NAME {
                box = b
            } else if a.name == BOX_ENTITY_NAME && b.name.hasSuffix(GLOVE_ENTITY_NAME_SUFFIX) {
                box = a
            } else {
                return
            }
            self.handleCollidedBox(box: box)
        }
    }
    
    func handleCollidedBox(box: Entity) {
        guard let parent = box.parent?.parent, let audio = hitAudio, let audioEntity = parent.findEntity(named: "SpatialAudio"), let particleEmitter = parent.findEntity(named: "ParticleEmitter") else {
            return
        }
        parent.stopAllAnimations()
        audioEntity.playAudio(audio)
        particleEmitter.components[ParticleEmitterComponent.self]?.burst()
        box.removeFromParent()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            parent.removeFromParent()
        }
    }

    // MARK: Private - Collision

    private var colisionSubs: EventSubscription?
    private var hitAudio: AudioFileResource?

    // MARK: Private - Hands

    private var leftHand: Entity?
    private var rightHand: Entity?
    private let session = ARKitSession()
    private let handTracking = HandTrackingProvider()

    private var dataProvidersAreSupported: Bool {
        HandTrackingProvider.isSupported
    }

    private var isHandsReady: Bool {
        handTracking.state == .initialized
    }

    private func processHandUpdates() async {
        for await update in handTracking.anchorUpdates {
            let handAnchor = update.anchor
            guard
                handAnchor.isTracked,
                let handEntity = handAnchor.handSkeleton?.joint(.wrist),
                handEntity.isTracked else { continue }

            let originFromIndexFingerTip = handAnchor.originFromAnchorTransform * handEntity.anchorFromJointTransform

            var entity: Entity!
            if handAnchor.chirality == .left {
                entity = leftHand
            } else {
                entity = rightHand
            }
            if await entity.parent == nil {
                await root.addChild(entity)
            }
            await entity.setTransformMatrix(originFromIndexFingerTip, relativeTo: nil)
        }
    }

    // MARK: Private
    private var boxTemplate: Entity?
    private var tasks: [DispatchWorkItem] = []

    private init() {
        Task { @MainActor in
            boxTemplate = try? await Entity(named: "Box", in: realityKitContentBundle)
            leftHand = try? await Entity(named: "LeftGlove", in: realityKitContentBundle)
            rightHand = try? await Entity(named: "RightGlove", in: realityKitContentBundle)
            hitAudio = try? await AudioFileResource(
                named: "hit.mp3",
                configuration: .init(shouldLoop: false)
            )
            isReady = true
        }
    }

    @MainActor
    private func scheduleTasks(notes: [Note], startTime: DispatchTime) {
        // get current time
        for note in notes {
            let createTask = DispatchWorkItem {
                let box = self.spawnBox(note: note)
//                let hitTask = DispatchWorkItem {
//                    guard let audio = self.hitAudio, let audioEntity = box.findEntity(named: "SpatialAudio") else {
//                        return
//                    }
//                    audioEntity.playAudio(audio)
//                    box.components[OpacityComponent.self] = OpacityComponent(opacity: 0.1)
//                }
                let destroyTask = DispatchWorkItem {
                    box.removeFromParent()
                }
//                self.tasks.append(hitTask)
                self.tasks.append(destroyTask)
//                DispatchQueue.main.asyncAfter(deadline: .now() + BoxSpawnParameters.lifeTime / 2) {
//                    hitTask.perform()
//                    let duration = Date().timeIntervalSince(startDate)
//                    print("hit at \(duration  * 2) beat")
//                }
                DispatchQueue.main.asyncAfter(deadline: .now() + BoxSpawnParameters.lifeTime) {
                    destroyTask.perform()
                }
            }
            tasks.append(createTask)
            DispatchQueue.main.asyncAfter(deadline: startTime + note.time * 0.5 - BoxSpawnParameters.lifeTime / 2) {
                createTask.perform()
            }
        }
    }

    private func cancelAllTasks() {
        for task in tasks {
            task.cancel()
        }
        tasks.removeAll()
    }

    @MainActor
    private func spawnBox(note: Note) -> Entity {
        guard let boxTemplate = boxTemplate else {
            fatalError("box template is nil.")
        }
        let box = boxTemplate.clone(recursive: true)

        let start = generateStart(note: note)

        box.position = simd_float(start.vector + .init(x: 0, y: 0, z: -0.7))

        let animation = generateBoxMovementAnimation(start: start)

        box.playAnimation(animation, transitionDuration: 1.0, startsPaused: false)

        root.addChild(box)

        return box
    }

    private func generateStart(note: Note) -> Point3D {
        var x = 0.0
        switch note.lineIndex {
            case .leftmost:
                x = -0.3
            case .left:
                x = -0.3
            case .right:
                x = 0.3
            case .rightmost:
                x = 0.3
        }
        var y = 0.0
        switch note.lineLayer {
            case .bottom:
                y = 1.1
            case .middle:
                y = 1.5
            case .top:
                y = 1.9
        }
        return Point3D(
            x: x,
            y: y,
            z: -(BoxSpawnParameters.deltaZ / 2) - 0.5
        )
    }

    private func generateBoxMovementAnimation(start: Point3D) -> AnimationResource {
        let end = Point3D(
            x: start.x + BoxSpawnParameters.deltaX,
            y: start.y + BoxSpawnParameters.deltaY,
            z: start.z + BoxSpawnParameters.deltaZ
        )

        let line = FromToByAnimation<Transform>(
            name: "line",
            from: .init(scale: .init(repeating: 1), translation: simd_float(start.vector)),
            to: .init(scale: .init(repeating: 1), translation: simd_float(end.vector)),
            duration: BoxSpawnParameters.lifeTime,
            bindTarget: .transform
        )

        let animation = try! AnimationResource
            .generate(with: line)
        return animation
    }
}

enum BoxSpawnParameters {
    static var deltaX = 0.02
    static var deltaY = -0.12
    static var deltaZ = 12.0

    static var lifeTime = 3.0
}
