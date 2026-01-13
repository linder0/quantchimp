//
//  StatsManager.swift
//  quantchimp
//
//  Created by Linda Xue on 1/8/26.
//

import Foundation
import Combine

@MainActor
class StatsManager: ObservableObject {
    // MARK: - UserDefaults Keys
    private enum Keys {
        static let sessionHistory = "quantchimp_sessionHistory"
        static let totalQuestions = "quantchimp_totalQuestions"
        static let totalCorrect = "quantchimp_totalCorrect"
        static let dailyCompleted = "quantchimp_dailyCompleted"
        static let sprintCompleted = "quantchimp_sprintCompleted"
    }

    // MARK: - Published Properties
    @Published private(set) var sessionHistory: [SessionRecord] = []
    @Published private(set) var totalQuestions: Int = 0
    @Published private(set) var totalCorrect: Int = 0
    @Published private(set) var dailyCompleted: Int = 0
    @Published private(set) var sprintCompleted: Int = 0

    // MARK: - Computed Properties
    var overallAccuracy: Double {
        calculateAccuracy(correct: totalCorrect, total: totalQuestions)
    }

    var dailyAccuracy: Double {
        let dailySessions = sessionHistory.filter { $0.mode == .daily }
        let questions = dailySessions.reduce(0) { $0 + $1.questionsAnswered }
        let correct = dailySessions.reduce(0) { $0 + $1.correctCount }
        return calculateAccuracy(correct: correct, total: questions)
    }

    var sprintAccuracy: Double {
        let sprintSessions = sessionHistory.filter { $0.mode == .sprint }
        let questions = sprintSessions.reduce(0) { $0 + $1.questionsAnswered }
        let correct = sprintSessions.reduce(0) { $0 + $1.correctCount }
        return calculateAccuracy(correct: correct, total: questions)
    }

    var totalXPEarned: Int {
        sessionHistory.reduce(0) { $0 + $1.xpEarned }
    }

    var recentSessions: [SessionRecord] {
        Array(sessionHistory.prefix(20))
    }

    /// Returns an array of 7 booleans for the current week (Mon-Sun), true if played that day
    var weeklyActivity: [Bool] {
        let calendar = Calendar.current
        let weekStart = DateHelpers.startOfWeek()

        var activity: [Bool] = []
        for dayOffset in 0..<7 {
            guard let day = calendar.date(byAdding: .day, value: dayOffset, to: weekStart) else {
                activity.append(false)
                continue
            }
            let dayStart = DateHelpers.startOfDay(for: day)
            let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart) ?? dayStart

            // Check if any session exists on this day
            let hasSession = sessionHistory.contains { session in
                session.date >= dayStart && session.date < dayEnd
            }
            activity.append(hasSession)
        }
        return activity
    }

    /// Current streak count (consecutive days played ending today or yesterday)
    var currentStreak: Int {
        let calendar = Calendar.current
        let today = DateHelpers.startOfDay()

        var streak = 0
        var checkDate = today

        // Check if we played today first
        let playedToday = sessionHistory.contains { session in
            DateHelpers.isDate(session.date, inSameDayAs: today)
        }

        // If we didn't play today, start checking from yesterday
        if !playedToday {
            checkDate = calendar.date(byAdding: .day, value: -1, to: today) ?? today
            // If we didn't play yesterday either, streak is 0
            let playedYesterday = sessionHistory.contains { session in
                DateHelpers.isDate(session.date, inSameDayAs: checkDate)
            }
            if !playedYesterday {
                return 0
            }
        }

        // Count consecutive days backwards
        while true {
            let hasSession = sessionHistory.contains { session in
                DateHelpers.isDate(session.date, inSameDayAs: checkDate)
            }

            if hasSession {
                streak += 1
                checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate) ?? checkDate
            } else {
                break
            }
        }

        return streak
    }

    // MARK: - Initialization
    init() {
        loadStats()
    }

    // MARK: - Public Methods
    func recordSession(_ record: SessionRecord) {
        sessionHistory.insert(record, at: 0)
        totalQuestions += record.questionsAnswered
        totalCorrect += record.correctCount

        switch record.mode {
        case .daily:
            dailyCompleted += 1
        case .sprint:
            sprintCompleted += 1
        case .tournament:
            break // Future mode - not yet implemented
        case .challenge:
            break // Future mode - not yet implemented
        }

        saveStats()
    }

    // MARK: - Persistence
    private func loadStats() {
        totalQuestions = UserDefaults.standard.integer(forKey: Keys.totalQuestions)
        totalCorrect = UserDefaults.standard.integer(forKey: Keys.totalCorrect)
        dailyCompleted = UserDefaults.standard.integer(forKey: Keys.dailyCompleted)
        sprintCompleted = UserDefaults.standard.integer(forKey: Keys.sprintCompleted)

        if let data = UserDefaults.standard.data(forKey: Keys.sessionHistory),
           let decoded = try? JSONDecoder().decode([SessionRecord].self, from: data) {
            sessionHistory = decoded
        }
    }

    private func saveStats() {
        UserDefaults.standard.set(totalQuestions, forKey: Keys.totalQuestions)
        UserDefaults.standard.set(totalCorrect, forKey: Keys.totalCorrect)
        UserDefaults.standard.set(dailyCompleted, forKey: Keys.dailyCompleted)
        UserDefaults.standard.set(sprintCompleted, forKey: Keys.sprintCompleted)

        // Only keep last 100 sessions to prevent unbounded growth
        let sessionsToSave = Array(sessionHistory.prefix(100))
        if let encoded = try? JSONEncoder().encode(sessionsToSave) {
            UserDefaults.standard.set(encoded, forKey: Keys.sessionHistory)
        }
    }
}
