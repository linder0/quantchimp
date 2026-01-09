//
//  AppState.swift
//  quantchimp
//
//  Created by Linda Xue on 1/8/26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class AppState: ObservableObject {
    // MARK: - UserDefaults Keys
    private enum Keys {
        static let xp = "quantchimp_xp"
        static let streak = "quantchimp_streak"
        static let bestStreak = "quantchimp_bestStreak"
        static let lastDailyCompletedDate = "quantchimp_lastDailyCompletedDate"
        static let userProfile = "quantchimp_userProfile"
        static let hasCompletedOnboarding = "quantchimp_hasCompletedOnboarding"
    }

    // MARK: - Published Properties
    @Published var xp: Int {
        didSet { UserDefaults.standard.set(xp, forKey: Keys.xp) }
    }

    @Published var streak: Int {
        didSet { UserDefaults.standard.set(streak, forKey: Keys.streak) }
    }

    @Published var bestStreak: Int {
        didSet { UserDefaults.standard.set(bestStreak, forKey: Keys.bestStreak) }
    }

    @Published var lastDailyCompletedDate: Date? {
        didSet { UserDefaults.standard.set(lastDailyCompletedDate, forKey: Keys.lastDailyCompletedDate) }
    }

    @Published var userProfile: UserProfile {
        didSet {
            saveUserProfile()
            syncAudioSettings()
        }
    }

    @Published var hasCompletedOnboarding: Bool {
        didSet { UserDefaults.standard.set(hasCompletedOnboarding, forKey: Keys.hasCompletedOnboarding) }
    }

    // MARK: - Computed Properties
    var completedDailyToday: Bool {
        guard let lastDate = lastDailyCompletedDate else { return false }
        return isSameDay(lastDate, Date())
    }

    var currentLevel: Int {
        return xp / 200 + 1
    }

    var xpProgressInLevel: Double {
        let xpInCurrentLevel = xp % 200
        return Double(xpInCurrentLevel) / 200.0
    }

    var xpToNextLevel: Int {
        return 200 - (xp % 200)
    }

    // MARK: - Initialization
    init() {
        self.xp = UserDefaults.standard.integer(forKey: Keys.xp)
        self.streak = UserDefaults.standard.integer(forKey: Keys.streak)
        self.bestStreak = UserDefaults.standard.integer(forKey: Keys.bestStreak)
        self.lastDailyCompletedDate = UserDefaults.standard.object(forKey: Keys.lastDailyCompletedDate) as? Date
        self.hasCompletedOnboarding = UserDefaults.standard.bool(forKey: Keys.hasCompletedOnboarding)

        // Load user profile
        if let data = UserDefaults.standard.data(forKey: Keys.userProfile),
           let decoded = try? JSONDecoder().decode(UserProfile.self, from: data) {
            self.userProfile = decoded
        } else {
            self.userProfile = UserProfile.default
        }

        // Sync audio settings on launch
        syncAudioSettings()
    }

    /// Sync sound settings with SoundManager
    private func syncAudioSettings() {
        SoundManager.shared.setSoundsEnabled(userProfile.soundEnabled)
    }

    // MARK: - Streak Logic
    func updateStreakAndXPForDaily() {
        guard !completedDailyToday else { return }

        if let last = lastDailyCompletedDate, isYesterday(last) {
            streak += 1
        } else {
            streak = 1
        }

        bestStreak = max(bestStreak, streak)
        lastDailyCompletedDate = Date()
        xp += 50
    }

    func addArithmeticXP(correctCount: Int) {
        let earned = min(correctCount * 10, 200)
        xp += earned
    }

    // MARK: - Date Helpers
    private func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        Calendar.current.isDate(date1, inSameDayAs: date2)
    }

    private func isYesterday(_ date: Date) -> Bool {
        Calendar.current.isDateInYesterday(date)
    }

    // MARK: - Onboarding
    func completeOnboarding() {
        hasCompletedOnboarding = true
    }

    // MARK: - Profile Persistence
    private func saveUserProfile() {
        if let encoded = try? JSONEncoder().encode(userProfile) {
            UserDefaults.standard.set(encoded, forKey: Keys.userProfile)
        }
    }
}
