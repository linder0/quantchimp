//
//  Quest.swift
//  quantchimp
//
//  Centralized quest/achievement model
//

import Foundation
import SwiftUI

struct Quest: Identifiable {
    let id: String
    let icon: String
    let title: String
    let description: String
    let xpReward: Int
    let color: Color
    let progressProvider: (AppState, StatsManager) -> Int
    let totalRequired: Int

    /// Current progress for this quest
    func currentProgress(appState: AppState, statsManager: StatsManager) -> Int {
        progressProvider(appState, statsManager)
    }

    /// Whether this quest is unlocked/completed
    func isUnlocked(appState: AppState, statsManager: StatsManager) -> Bool {
        currentProgress(appState: appState, statsManager: statsManager) >= totalRequired
    }

    /// Progress percentage (0.0 to 1.0)
    func progressPercentage(appState: AppState, statsManager: StatsManager) -> Double {
        let progress = currentProgress(appState: appState, statsManager: statsManager)
        return Double(progress) / Double(totalRequired)
    }
}
