//
//  MathHelpers.swift
//  quantchimp
//
//  Common math utility functions
//

import Foundation

/// Calculates accuracy percentage from correct/total counts
/// - Parameters:
///   - correct: Number of correct answers
///   - total: Total number of questions
/// - Returns: Accuracy as percentage (0-100), or 0 if total is 0
func calculateAccuracy(correct: Int, total: Int) -> Double {
    guard total > 0 else { return 0 }
    return Double(correct) / Double(total) * 100
}

/// Formats accuracy for display
/// - Parameter accuracy: Accuracy value (0-100)
/// - Returns: Formatted string like "85%"
func formatAccuracy(_ accuracy: Double) -> String {
    String(format: "%.0f%%", accuracy)
}

/// Calculates XP earned from correct answers (capped at 200)
/// - Parameter correctCount: Number of correct answers
/// - Returns: XP earned (10 per correct, max 200)
func calculateXPEarned(correctCount: Int) -> Int {
    min(correctCount * 10, 200)
}
