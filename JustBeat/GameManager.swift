//
// JustBeat
// Created by: onee on 2024/7/12
//

import AVKit
import Foundation
import RealityKit
import RealityKitContent
import Spatial

class GameManager: ObservableObject {
    let root = Entity()

    static let shared = GameManager()

    func start() {
        songPlayer.volume = 0.6
        songPlayer.numberOfLoops = 0
        songPlayer.currentTime = 0
        songPlayer.play()
        Task { @MainActor in
            self.scheduleTasks(notes: songInfo.notes)
        }
    }

    func stop() {
        songPlayer.stop()
        Task { @MainActor in
            self.cancelAllTasks()
        }
    }

    // MARK: Private

    private let songPlayer = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "Gokuraku Jodo", withExtension: "m4a")!)
    private let songInfo: Stage! = parseJSON()!
    private var boxTemplate: Entity?
    private var tasks: [DispatchWorkItem] = []

    private init() {
        Task { @MainActor in
            if let box = try? await Entity(named: "Box", in: realityKitContentBundle) {
                boxTemplate = box
            }
        }
    }

    @MainActor
    private func scheduleTasks(notes: [Note]) {
        for note in notes {
            let createTask = DispatchWorkItem {
                let box = self.spawnBox(note: note)
                let destroyTask = DispatchWorkItem {
                    box.removeFromParent()
                }
                self.tasks.append(destroyTask)
                DispatchQueue.main.asyncAfter(deadline: .now() + BoxSpawnParameters.lifeTime) {
                    destroyTask.perform()
                }
            }
            tasks.append(createTask)
            DispatchQueue.main.asyncAfter(deadline: .now() + note.time * 0.5 - BoxSpawnParameters.lifeTime / 2) {
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
            z: -6.0
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
    
    static var lifeTime = 4.0
}
