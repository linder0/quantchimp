//
//  Duration.swift
//  quantchimp
//
//  Sprint duration options
//

import SwiftUI

enum Duration: String, CaseIterable {
    case bullet = "Bullet"
    case blitz = "Blitz"
    case rapid = "Rapid"

    var seconds: Int {
        switch self {
        case .bullet: return 60
        case .blitz: return 120
        case .rapid: return 180
        }
    }

    var displayTime: String {
        switch self {
        case .bullet: return "1 min"
        case .blitz: return "2 min"
        case .rapid: return "3 min"
        }
    }

    var icon: String {
        switch self {
        case .bullet: return "hare.fill"
        case .blitz: return "bolt.fill"
        case .rapid: return "clock.fill"
        }
    }
}
