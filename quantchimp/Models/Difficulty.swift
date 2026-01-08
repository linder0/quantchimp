//
//  Difficulty.swift
//  quantchimp
//
//  Difficulty levels using Theme colors
//

import SwiftUI

enum Difficulty: String, CaseIterable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"

    var range: ClosedRange<Int> {
        switch self {
        case .easy: return 1...10
        case .medium: return 10...50
        case .hard: return 50...100
        }
    }

    var color: Color {
        switch self {
        case .easy: return Theme.success
        case .medium: return Theme.warning
        case .hard: return Theme.error
        }
    }

    var description: String {
        switch self {
        case .easy: return "Numbers 1-10"
        case .medium: return "Numbers 10-50"
        case .hard: return "Numbers 50-100"
        }
    }
}
