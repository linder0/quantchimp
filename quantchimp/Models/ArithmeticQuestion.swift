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

    enum Operation: String, CaseIterable {
        case add = "+"
        case subtract = "−"
        case multiply = "×"

        static func random(for difficulty: Difficulty) -> Operation {
            if difficulty == .easy {
                return [.add, .subtract].randomElement()!
            }
            return allCases.randomElement()!
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
        }
    }

    static func generate(difficulty: Difficulty) -> ArithmeticQuestion {
        let range = difficulty.range
        let operation = Operation.random(for: difficulty)

        var num1 = Int.random(in: range)
        var num2 = Int.random(in: range)

        // For subtraction, ensure positive result
        if operation == .subtract && num2 > num1 {
            swap(&num1, &num2)
        }

        // For multiplication on hard mode, use smaller numbers
        if operation == .multiply && difficulty == .hard {
            num1 = Int.random(in: 2...15)
            num2 = Int.random(in: 2...15)
        }

        return ArithmeticQuestion(num1: num1, num2: num2, operation: operation)
    }
}
