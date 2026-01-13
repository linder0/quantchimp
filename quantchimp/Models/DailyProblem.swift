//
//  DailyProblem.swift
//  quantchimp
//
//  Created by Linda Xue on 1/8/26.
//

import Foundation

struct DailyProblem: Identifiable {
    let id: Int
    let prompt: String
    let answer: String
    let explanation: String
    let hint: String?
    let imageName: String?  // Custom illustration for the puzzle
    let difficulty: Int  // 1-10 scale

    // Legacy support for multiple choice (deprecated)
    let choices: [String]?
    let correctIndex: Int?

    /// Creates an open-ended question (new format)
    init(id: Int, prompt: String, answer: String, explanation: String, difficulty: Int, hint: String? = nil, imageName: String? = nil) {
        self.id = id
        self.prompt = prompt
        self.answer = answer
        self.explanation = explanation
        self.hint = hint
        self.imageName = imageName
        self.difficulty = difficulty
        self.choices = nil
        self.correctIndex = nil
    }

    /// Creates a multiple choice question (legacy format)
    init(id: Int, prompt: String, choices: [String], correctIndex: Int, explanation: String) {
        self.id = id
        self.prompt = prompt
        self.choices = choices
        self.correctIndex = correctIndex
        self.explanation = explanation
        self.hint = nil
        self.imageName = nil
        self.answer = choices[correctIndex]
        self.difficulty = 5  // Default difficulty
    }

    /// Whether this is an open-ended question
    var isOpenEnded: Bool {
        choices == nil
    }

    /// Difficulty as a display string (e.g., "Easy", "Medium", "Hard")
    var difficultyLabel: String {
        switch difficulty {
        case 1...3: return "Easy"
        case 4...6: return "Medium"
        case 7...10: return "Hard"
        default: return "Medium"
        }
    }
}
