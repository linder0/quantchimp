//
//  SessionRecord.swift
//  quantchimp
//
//  Session record model using Theme colors
//

import Foundation
import SwiftUI

enum GameMode: String, Codable, CaseIterable, Identifiable {
    case daily = "Daily Puzzle"
    case sprint = "Sprint"
    case tournament = "Tournaments"
    case challenge = "Challenge a Friend"
    
    var id: String { rawValue }

    var icon: String {
        switch self {
        case .daily: return "brain.head.profile"
        case .sprint: return "timer"
        case .tournament: return "trophy"
        case .challenge: return "person.2"
        }
    }

    var imageName: String {
        switch self {
        case .daily: return "monkey_daily_puzzle"
        case .sprint: return "monkey_sprint"
        case .tournament: return "monkey_tournament"
        case .challenge: return "monkey_challenge"
        }
    }

    var color: Color {
        switch self {
        case .daily: return Theme.daily
        case .sprint: return Theme.sprint
        case .tournament: return Theme.level
        case .challenge: return Theme.accent
        }
    }
    
    /// Vertical offset for the monkey image in the card
    var imageOffset: CGFloat {
        switch self {
        case .daily: return 10
        case .sprint: return 20
        case .tournament: return 15
        case .challenge: return 15
        }
    }
    
    /// Size of the monkey image
    var imageSize: CGFloat {
        switch self {
        case .daily: return 140
        case .sprint: return 160
        case .tournament: return 140
        case .challenge: return 140
        }
    }
    
    /// Whether this game mode is currently enabled
    var isEnabled: Bool {
        switch self {
        case .daily, .sprint: return true
        case .tournament, .challenge: return false
        }
    }
    
    /// Get the subtitle text for this game mode
    /// - Parameter appState: The app state to check completion status
    /// - Returns: The subtitle string
    func subtitle(for appState: AppState) -> String {
        switch self {
        case .daily:
            return appState.completedDailyToday ? "Completed" : "Ready to play"
        case .sprint:
            return "Speed challenge"
        case .tournament:
            return "Coming soon"
        case .challenge:
            return "Coming soon"
        }
    }
    
    /// Check if the mode has been completed (for showing checkmark)
    /// - Parameter appState: The app state to check completion status
    /// - Returns: True if completed
    func isCompleted(for appState: AppState) -> Bool {
        switch self {
        case .daily:
            return appState.completedDailyToday
        default:
            return false
        }
    }
    
    /// Returns only the enabled game modes suitable for card display
    static var activeModesForCards: [GameMode] {
        [.daily, .sprint]
    }
    
    /// Returns only the disabled game modes suitable for tile display
    static var disabledModesForTiles: [GameMode] {
        [.tournament, .challenge]
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
