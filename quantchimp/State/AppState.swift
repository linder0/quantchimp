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
        static let friends = "quantchimp_friends"
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
            syncThemeColor()
        }
    }

    @Published var hasCompletedOnboarding: Bool {
        didSet { UserDefaults.standard.set(hasCompletedOnboarding, forKey: Keys.hasCompletedOnboarding) }
    }

    @Published var friends: [Friend] = [] {
        didSet { saveFriends() }
    }

    // MARK: - Computed Properties
    var completedDailyToday: Bool {
        guard let lastDate = lastDailyCompletedDate else { return false }
        return DateHelpers.isSameDay(lastDate, Date())
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

        // Load friends
        if let data = UserDefaults.standard.data(forKey: Keys.friends),
           let decoded = try? JSONDecoder().decode([Friend].self, from: data) {
            self.friends = decoded
        }

        // Sync audio settings on launch
        syncAudioSettings()

        // Sync theme color on launch
        syncThemeColor()
    }

    /// Sync sound settings with SoundManager
    private func syncAudioSettings() {
        SoundManager.shared.setSoundsEnabled(userProfile.soundEnabled)
    }

    /// Sync theme color with ThemeManager
    private func syncThemeColor() {
        ThemeManager.shared.setAccentColor(userProfile.profileColor)
    }

    // MARK: - Streak Logic
    func updateStreakAndXPForDaily() {
        guard !completedDailyToday else { return }

        if let last = lastDailyCompletedDate, DateHelpers.isYesterday(last) {
            streak += 1
        } else {
            streak = 1
        }

        bestStreak = max(bestStreak, streak)
        lastDailyCompletedDate = Date()
        xp += 50
    }

    func addArithmeticXP(correctCount: Int) {
        xp += calculateXPEarned(correctCount: correctCount)
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

    // MARK: - Friends
    func addFriend(_ friend: Friend) {
        friends.append(friend)
    }

    func removeFriend(_ friend: Friend) {
        friends.removeAll { $0.id == friend.id }
    }

    var hasFriends: Bool {
        !friends.isEmpty
    }

    private func saveFriends() {
        if let encoded = try? JSONEncoder().encode(friends) {
            UserDefaults.standard.set(encoded, forKey: Keys.friends)
        }
    }
}
