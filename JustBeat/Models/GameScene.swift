//
//  GameScene.swift
//  JustBeat
//
//  Created by xuchi on 2024/8/13.
//

import Foundation

enum GameScene: String, CaseIterable, Identifiable {
    case cyberpunk = "Cyberpunk"
    case painting = "VanGogh"
    case cartoon = "Cartoon"
    
    var id: String {
        self.rawValue
    }
}
