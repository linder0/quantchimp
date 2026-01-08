//
//  Difficulty.swift
//  quantchimp
//
//  Created by Linda Xue on 1/8/26.
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
        case .easy: return .green
        case .medium: return .orange
        case .hard: return .red
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
