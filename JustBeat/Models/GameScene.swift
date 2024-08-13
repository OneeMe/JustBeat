//
//  GameScene.swift
//  JustBeat
//
//  Created by xuchi on 2024/8/13.
//

import Foundation

enum GameScene: String, CaseIterable, Identifiable {
    case cyberpunk = "CyberpunkSkybox"
    case painting = "VanGoghSkybox"
    case cartoon = "CartoonSkybox"
    
    var id: String {
        self.rawValue
    }
}
