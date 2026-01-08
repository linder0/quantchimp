//
//  SessionRecord.swift
//  quantchimp
//
//  Created by Linda Xue on 1/8/26.
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
        case .daily: return .purple
        case .sprint: return .blue
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
        guard questionsAnswered > 0 else { return 0 }
        return Double(correctCount) / Double(questionsAnswered) * 100
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
