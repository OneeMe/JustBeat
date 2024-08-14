//
// JustBeat
// Created by: onee on 2024/7/12
//

import Foundation

public enum BeatmapColumn: Int {
    case leftmost = 0
    case left = 1
    case right = 2
    case rightmost = 3
}

public enum BeatmapRow: Int {
    case bottom = 0
    case middle = 1
    case top = 2
}

// 定义 Note 模型
struct Note: Decodable {
    enum LineIndex: Int, Decodable {
        case leftmost = 0
        case left = 1
        case right = 2
        case rightmost = 3

        var column: BeatmapColumn {
            switch self {
            case .leftmost:
                return .leftmost
            case .left:
                return .left
            case .right:
                return .right
            case .rightmost:
                return .rightmost
            }
        }
    }
    
    enum LineLayer: Int, Decodable {
        case bottom = 0
        case middle = 1
        case top = 2

        var row: BeatmapRow {
            switch self {
            case .bottom:
                return .bottom
            case .middle:
                return .middle
            case .top:
                return .top
            }
        }
    }

    let time: Double
    let lineIndex: LineIndex
    let lineLayer: LineLayer
    let type: Int
    let cutDirection: Int

    // 自定义键名映射
    enum CodingKeys: String, CodingKey {
        case time = "_time"
        case lineIndex = "_lineIndex"
        case lineLayer = "_lineLayer"
        case type = "_type"
        case cutDirection = "_cutDirection"
    }
}

// 定义 Obstacle 模型
struct Obstacle: Codable {
    let time: Double
    let lineIndex: Int
    let type: Int
    let duration: Double
    let width: Int

    // 自定义键名映射
    enum CodingKeys: String, CodingKey {
        case time = "_time"
        case lineIndex = "_lineIndex"
        case type = "_type"
        case duration = "_duration"
        case width = "_width"
    }
}

// 定义主模型
struct Stage: Decodable {
    let version: String
    let events: [String] // 假设 events 是一个字符串数组，根据实际情况调整
    let notes: [Note]
    let obstacles: [Obstacle]

    // 自定义键名映射
    enum CodingKeys: String, CodingKey {
        case version = "_version"
        case events = "_events"
        case notes = "_notes"
        case obstacles = "_obstacles"
    }
}
