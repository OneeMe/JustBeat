//
// JustBeat
// Created by: onee on 2024/7/12
//

import Foundation
import AVKit
import RealityKit
import RealityKitContent

class GameManager : ObservableObject {
    let songPlayer = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "Gokuraku Jodo", withExtension: "m4a")!)
    let root = Entity()
    
    static let shared = GameManager()
    
    private init() {
        Task { @MainActor in
            if let box = try? await Entity(named: "Box", in: realityKitContentBundle) {
                box.position = [1.0, 1.5, -1.5]
                root.addChild(box)
            }
        }
    }
    
    func start() {
        songPlayer.volume = 0.6
        songPlayer.numberOfLoops = 0
        songPlayer.currentTime = 0
        songPlayer.play()
    }
    
    func stop() {
        songPlayer.stop()
    }
}
