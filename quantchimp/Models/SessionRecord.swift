//
//  SessionRecord.swift
//  quantchimp
//
//  Session record model using Theme colors
//

import Foundation
import SwiftUI

enum GameMode: String, Codable, CaseIterable {
    case daily = "Daily Puzzle"
    case sprint = "Arithmetic Sprint"

    var icon: String {
        switch self {
        case .daily: return "brain.head.profile"
        case .sprint: return "timer"
        }
    }

    var color: Color {
        switch self {
        case .daily: return Theme.daily
        case .sprint: return Theme.sprint
        }
    }
}

struct SessionRecord: Identifiable, Codable {
    let id: UUID
    let date: Date
    let mode: GameMode
    let questionsAnswered: Int
    let correctCount: Int
    let xpEarned: Int

    var accuracy: Double {
        calculateAccuracy(correct: correctCount, total: questionsAnswered)
    }

    init(mode: GameMode, questionsAnswered: Int, correctCount: Int, xpEarned: Int) {
        self.id = UUID()
        self.date = Date()
        self.mode = mode
        self.questionsAnswered = questionsAnswered
        self.correctCount = correctCount
        self.xpEarned = xpEarned
    }
}
