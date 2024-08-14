//
// JustBeat
// Created by: onee on 2024/8/14
//

import Foundation
import AVFAudio

struct Song {
    let songName: String
    let defaultGameScene: GameScene
    let songPlayer: AVAudioPlayer
    let songStage: Stage
    
    init(songName: String, defaultGameScene: GameScene) {
        self.songName = songName
        self.defaultGameScene = defaultGameScene
        self.songPlayer =  try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: self.songName, withExtension: "mp3")!)
        let url = Bundle.main.url(forResource: self.songName, withExtension: "json")!
        let data = try! Data(contentsOf: url)
        self.songStage = try! JSONDecoder().decode(Stage.self, from: data)
    }
}
