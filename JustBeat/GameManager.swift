//
// JustBeat
// Created by: onee on 2024/7/12
//

import Foundation
import AVKit

class GameManager : ObservableObject {
    let songPlayer = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "Gokuraku Jodo", withExtension: "m4a")!)
    
    static let shared = GameManager()
    
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
