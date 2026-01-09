//
//  ArithmeticQuestion.swift
//  quantchimp
//
//  Created by Linda Xue on 1/8/26.
//

import Foundation

struct ArithmeticQuestion {
    let num1: Int
    let num2: Int
    let operation: Operation

    enum Operation: String, CaseIterable, Identifiable {
        case add = "+"
        case subtract = "−"
        case multiply = "×"
        case divide = "÷"

        var id: String { rawValue }

        var displayName: String {
            switch self {
            case .add: return "addition"
            case .subtract: return "subtraction"
            case .multiply: return "multiplication"
            case .divide: return "division"
            }
        }
    }

    var displayText: String {
        "\(num1) \(operation.rawValue) \(num2)"
    }

    var correctAnswer: Int {
        switch operation {
        case .add: return num1 + num2
        case .subtract: return num1 - num2
        case .multiply: return num1 * num2
        case .divide: return num1 / num2
        }
    }

    static func generate(difficulty: Difficulty, operations: Set<Operation>) -> ArithmeticQuestion {
        // Ensure at least one operation is selected, default to all if empty
        let availableOps = operations.isEmpty ? Set(Operation.allCases) : operations
        let operation = availableOps.randomElement()!

        var num1: Int
        var num2: Int

        switch operation {
        case .add:
            num1 = Int.random(in: difficulty.addSubRange)
            num2 = Int.random(in: difficulty.addSubRange)

        case .subtract:
            num1 = Int.random(in: difficulty.addSubRange)
            num2 = Int.random(in: difficulty.addSubRange)
            // Ensure positive result
            if num2 > num1 {
                swap(&num1, &num2)
            }

        case .multiply:
            num1 = Int.random(in: difficulty.multiplyRange1)
            num2 = Int.random(in: difficulty.multiplyRange2)

        case .divide:
            // Division is reverse multiplication: generate a × b = c, then ask c ÷ b = ?
            let factor1 = Int.random(in: difficulty.multiplyRange1)
            let factor2 = Int.random(in: difficulty.multiplyRange2)
            num1 = factor1 * factor2  // This is the dividend
            num2 = factor2            // This is the divisor
            // Answer will be factor1
        }

        return ArithmeticQuestion(num1: num1, num2: num2, operation: operation)
    }

    // Legacy method for backwards compatibility
    static func generate(difficulty: Difficulty) -> ArithmeticQuestion {
        return generate(difficulty: difficulty, operations: Set(Operation.allCases))
    }
}
