//
//  QuestManager.swift
//  quantchimp
//
//  Centralized quest definitions and logic
//

import Foundation
import SwiftUI

enum QuestManager {

    /// All available quests in the game
    static let allQuests: [Quest] = [
        Quest(
            id: "first_steps",
            icon: "avatar_excited",
            title: "First Steps",
            description: "Complete your first puzzle",
            xpReward: 200,
            color: Theme.daily,
            progressProvider: { _, statsManager in
                statsManager.sessionHistory.count
            },
            totalRequired: 1
        ),

        Quest(
            id: "week_warrior",
            icon: "avatar_ninja",
            title: "Week Warrior",
            description: "Maintain a 7 day streak",
            xpReward: 200,
            color: Theme.streak,
            progressProvider: { _, statsManager in
                statsManager.currentStreak
            },
            totalRequired: 7
        ),

        Quest(
            id: "perfect_score",
            icon: "avatar_champion",
            title: "Perfect Score",
            description: "Complete a session with 100% accuracy",
            xpReward: 200,
            color: Theme.success,
            progressProvider: { _, statsManager in
                statsManager.sessionHistory.contains { session in
                    session.questionsAnswered > 0 && session.correctCount == session.questionsAnswered
                } ? 1 : 0
            },
            totalRequired: 1
        ),

        Quest(
            id: "speed_demon",
            icon: "monkey_sprint",
            title: "Speed Demon",
            description: "Complete 10 sprint sessions",
            xpReward: 200,
            color: Theme.sprint,
            progressProvider: { _, statsManager in
                statsManager.sprintCompleted
            },
            totalRequired: 10
        ),

        Quest(
            id: "century_club",
            icon: "avatar_scientist",
            title: "Century Club",
            description: "Answer 100 questions",
            xpReward: 200,
            color: Theme.level,
            progressProvider: { _, statsManager in
                statsManager.sessionHistory.reduce(0) { $0 + $1.questionsAnswered }
            },
            totalRequired: 100
        ),

        Quest(
            id: "xp_master",
            icon: "avatar_wizard",
            title: "XP Master",
            description: "Earn 2000 XP",
            xpReward: 200,
            color: Theme.xp,
            progressProvider: { appState, _ in
                appState.xp
            },
            totalRequired: 2000
        )
    ]

    /// Get the closest incomplete quest (highest progress percentage)
    static func closestIncompleteQuest(appState: AppState, statsManager: StatsManager) -> Quest {
        let incompleteQuests = allQuests.filter { !$0.isUnlocked(appState: appState, statsManager: statsManager) }

        return incompleteQuests.max(by: {
            $0.progressPercentage(appState: appState, statsManager: statsManager) <
            $1.progressPercentage(appState: appState, statsManager: statsManager)
        }) ?? allQuests.first!
    }
}
