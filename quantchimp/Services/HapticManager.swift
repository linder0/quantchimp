//
//  HapticManager.swift
//  quantchimp
//
//  Centralized haptic feedback manager
//

import UIKit

/// Centralized haptic feedback for consistent tactile responses
enum Haptic {

    // MARK: - Impact Feedback

    /// Light impact - for selection, toggles
    static func light() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    /// Medium impact - for button presses, confirmations
    static func medium() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }

    /// Heavy impact - for significant actions
    static func heavy() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
    }

    /// Soft impact - subtle feedback
    static func soft() {
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
    }

    /// Rigid impact - sharp feedback
    static func rigid() {
        UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
    }

    // MARK: - Notification Feedback

    /// Success notification - for correct answers, completions
    static func success() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    /// Warning notification - for incorrect attempts
    static func warning() {
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
    }

    /// Error notification - for failures, errors
    static func error() {
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }

    // MARK: - Selection Feedback

    /// Selection changed - for picker/segmented control changes
    static func selection() {
        UISelectionFeedbackGenerator().selectionChanged()
    }
}

