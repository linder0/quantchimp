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

    var color: Color {
        switch self {
        case .easy: return Theme.success
        case .medium: return Theme.warning
        case .hard: return Theme.error
        }
    }

    /// Monkey mascot image name for each difficulty
    var imageName: String {
        switch self {
        case .easy: return "monkey_practice"
        case .medium: return "monkey_good"
        case .hard: return "monkey_great"
        }
    }

    // MARK: - Addition/Subtraction Ranges

    var addSubRange: ClosedRange<Int> {
        switch self {
        case .easy: return 2...60
        case .medium: return 2...100
        case .hard: return 2...300
        }
    }

    // MARK: - Multiplication Ranges

    /// First operand range for multiplication
    var multiplyRange1: ClosedRange<Int> {
        switch self {
        case .easy: return 2...12
        case .medium: return 2...12
        case .hard: return 2...20
        }
    }

    /// Second operand range for multiplication
    var multiplyRange2: ClosedRange<Int> {
        switch self {
        case .easy: return 2...20
        case .medium: return 2...100
        case .hard: return 2...200
        }
    }

    // MARK: - Display Info

    var additionDescription: String {
        "(\(addSubRange.lowerBound)-\(addSubRange.upperBound))"
    }

    var subtractionDescription: String {
        "(\(addSubRange.lowerBound)-\(addSubRange.upperBound))"
    }

    var multiplicationDescription: String {
        "(\(multiplyRange1.lowerBound)-\(multiplyRange1.upperBound)) × (\(multiplyRange2.lowerBound)-\(multiplyRange2.upperBound))"
    }

    var divisionDescription: String {
        "inverse of ×"
    }

    var isDefault: Bool {
        self == .medium
    }
}

