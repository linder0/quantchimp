//
//  DateFormatting.swift
//  quantchimp
//
//  Shared date formatting utilities
//

import Foundation

// MARK: - Shared Formatters

/// Shared formatters to avoid repeated instantiation
enum DateFormatters {
    /// Relative date formatter (e.g., "2h ago", "yesterday")
    static let relative: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter
    }()

    /// Full date formatter
    static let fullDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    /// Time only formatter
    static let timeOnly: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
}

// MARK: - Date Extension

extension Date {
    /// Returns relative time string (e.g., "2h ago")
    var relativeString: String {
        DateFormatters.relative.localizedString(for: self, relativeTo: Date())
    }

    /// Returns full date string
    var fullDateString: String {
        DateFormatters.fullDate.string(from: self)
    }

    /// Returns time only string
    var timeString: String {
        DateFormatters.timeOnly.string(from: self)
    }
}
