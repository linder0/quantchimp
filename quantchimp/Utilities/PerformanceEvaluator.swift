//
//  PerformanceEvaluator.swift
//  quantchimp
//
//  Centralized performance evaluation logic
//

import Foundation

enum PerformanceEvaluator {

    struct PerformanceResult {
        let message: String
        let imageName: String
        let tier: PerformanceTier
    }

    enum PerformanceTier {
        case outstanding
        case excellent
        case great
        case good
        case practice
    }

    /// Evaluate performance based on correct answer count
    /// - Parameter correctCount: Number of correct answers
    /// - Returns: Performance result with message and image
    static func evaluate(correctCount: Int) -> PerformanceResult {
        if correctCount >= 20 {
            return PerformanceResult(
                message: "Outstanding!",
                imageName: "monkey_outstanding",
                tier: .outstanding
            )
        } else if correctCount >= 15 {
            return PerformanceResult(
                message: "Excellent!",
                imageName: "monkey_excellent",
                tier: .excellent
            )
        } else if correctCount >= 10 {
            return PerformanceResult(
                message: "Great job!",
                imageName: "monkey_great",
                tier: .great
            )
        } else if correctCount >= 5 {
            return PerformanceResult(
                message: "Good effort!",
                imageName: "monkey_good",
                tier: .good
            )
        } else {
            return PerformanceResult(
                message: "Keep practicing!",
                imageName: "monkey_practice",
                tier: .practice
            )
        }
    }

    /// Check if performance warrants celebration sound
    /// - Parameter correctCount: Number of correct answers
    /// - Returns: True if should play celebration
    static func shouldCelebrate(correctCount: Int) -> Bool {
        correctCount >= 5
    }
}
