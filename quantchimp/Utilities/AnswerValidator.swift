//
//  AnswerValidator.swift
//  quantchimp
//
//  Answer validation utilities for puzzle and question checking
//

import Foundation

/// Utility for validating user answers against correct answers
enum AnswerValidator {

    /// Checks if a user's answer matches the correct answer
    /// - Parameters:
    ///   - userAnswer: The answer provided by the user
    ///   - correctAnswer: The correct answer to compare against
    /// - Returns: True if the answers match (allowing for various formats)
    static func isCorrect(userAnswer: String, correctAnswer: String) -> Bool {
        let user = userAnswer.trimmingCharacters(in: .whitespaces).lowercased()
        let correct = correctAnswer.trimmingCharacters(in: .whitespaces).lowercased()

        // Exact match
        if user == correct {
            return true
        }

        // Remove spaces and compare
        let userNoSpaces = user.replacingOccurrences(of: " ", with: "")
        let correctNoSpaces = correct.replacingOccurrences(of: " ", with: "")
        if userNoSpaces == correctNoSpaces {
            return true
        }

        // Handle numeric answers
        if let userNum = parseNumber(user), let correctNum = parseNumber(correct) {
            if abs(userNum - correctNum) < 0.01 {
                return true
            }
        }

        // Handle fraction inputs
        if let userFraction = parseFraction(user), let correctFraction = parseFraction(correct) {
            if abs(userFraction - correctFraction) < 0.0001 {
                return true
            }
        }

        // Check if correct answer starts with ≈ (approximate)
        if correct.hasPrefix("≈") {
            let approxValue = correct.replacingOccurrences(of: "≈", with: "").trimmingCharacters(in: .whitespaces)
            if user == approxValue || userNoSpaces == approxValue.replacingOccurrences(of: " ", with: "") {
                return true
            }
            if let userNum = parseNumber(user), let correctNum = parseNumber(approxValue) {
                // Allow 5% tolerance for approximate answers
                if abs(userNum - correctNum) < correctNum * 0.05 {
                    return true
                }
            }
        }

        return false
    }

    /// Parse a string into a number, handling both decimals and fractions
    /// - Parameter string: The string to parse
    /// - Returns: The numeric value, or nil if parsing fails
    static func parseNumber(_ string: String) -> Double? {
        if let num = Double(string) {
            return num
        }
        if let fraction = parseFraction(string) {
            return fraction
        }
        return nil
    }

    /// Parse a fraction string (e.g., "1/2") into a decimal value
    /// - Parameter string: The fraction string to parse
    /// - Returns: The decimal value of the fraction, or nil if invalid
    static func parseFraction(_ string: String) -> Double? {
        let parts = string.split(separator: "/")
        if parts.count == 2,
           let numerator = Double(parts[0].trimmingCharacters(in: .whitespaces)),
           let denominator = Double(parts[1].trimmingCharacters(in: .whitespaces)),
           denominator != 0 {
            return numerator / denominator
        }
        return nil
    }
}
