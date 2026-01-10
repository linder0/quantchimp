//
//  UserProfile.swift
//  quantchimp
//
//  Created by Linda Xue on 1/8/26.
//

import Foundation

// MARK: - User Goal

enum UserGoal: String, Codable, CaseIterable, Identifiable {
    case quantCareer = "Become a Quant"
    case interviewPrep = "Ace Interviews"
    case mentalMath = "Sharpen Mental Math"
    case brainTraining = "Daily Brain Training"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .quantCareer: return "chart.line.uptrend.xyaxis"
        case .interviewPrep: return "person.badge.shield.checkmark"
        case .mentalMath: return "function"
        case .brainTraining: return "brain.head.profile"
        }
    }

    var color: String {
        switch self {
        case .quantCareer: return "purple"
        case .interviewPrep: return "blue"
        case .mentalMath: return "orange"
        case .brainTraining: return "green"
        }
    }

    var description: String {
        switch self {
        case .quantCareer:
            return "Master the quantitative skills needed for a career in finance"
        case .interviewPrep:
            return "Prepare for technical interviews with speed and accuracy"
        case .mentalMath:
            return "Build lightning-fast mental calculation abilities"
        case .brainTraining:
            return "Keep your mind sharp with daily cognitive exercises"
        }
    }
}

// MARK: - Reminder Preset

enum ReminderPreset: String, Codable, CaseIterable, Identifiable {
    case morning = "Morning"
    case afternoon = "Afternoon"
    case evening = "Evening"
    case custom = "Custom Time"
    case none = "No Reminders"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .morning: return "sunrise.fill"
        case .afternoon: return "sun.max.fill"
        case .evening: return "sunset.fill"
        case .custom: return "clock.fill"
        case .none: return "bell.slash.fill"
        }
    }

    var defaultHour: Int? {
        switch self {
        case .morning: return 8
        case .afternoon: return 13
        case .evening: return 19
        case .custom, .none: return nil
        }
    }

    var timeDescription: String {
        switch self {
        case .morning: return "8:00 AM"
        case .afternoon: return "1:00 PM"
        case .evening: return "7:00 PM"
        case .custom: return "Pick a time"
        case .none: return "Disabled"
        }
    }
}

// MARK: - User Profile

struct UserProfile: Codable {
    var displayName: String
    var avatarImage: String
    var soundEnabled: Bool
    var hapticsEnabled: Bool

    // Onboarding fields
    var goal: UserGoal?
    var dailyGoalMinutes: Int
    var reminderTime: Date?
    var reminderPreset: ReminderPreset?

    static let `default` = UserProfile(
        displayName: "Player",
        avatarImage: "avatar_default",
        soundEnabled: true,
        hapticsEnabled: true,
        goal: nil,
        dailyGoalMinutes: 10,
        reminderTime: nil,
        reminderPreset: nil
    )

    static let avatarOptions = [
        "avatar_default",
        "avatar_thinking",
        "avatar_excited",
        "avatar_cool",
        "avatar_champion",
        "avatar_ninja",
        "avatar_scientist",
        "avatar_wizard",
        "avatar_astronaut",
        "avatar_pirate"
    ]
}
