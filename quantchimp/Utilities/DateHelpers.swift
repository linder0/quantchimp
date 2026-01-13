//
//  DateHelpers.swift
//  quantchimp
//
//  Centralized date utility functions
//

import Foundation

/// Centralized date helpers for consistent date operations
enum DateHelpers {

    /// Check if two dates are on the same day
    /// - Parameters:
    ///   - date1: First date to compare
    ///   - date2: Second date to compare
    /// - Returns: True if both dates are on the same calendar day
    static func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        Calendar.current.isDate(date1, inSameDayAs: date2)
    }

    /// Check if a date was yesterday
    /// - Parameter date: Date to check
    /// - Returns: True if the date is yesterday
    static func isYesterday(_ date: Date) -> Bool {
        Calendar.current.isDateInYesterday(date)
    }

    /// Get the start of the week (Monday) for a given date
    /// - Parameter date: The reference date (defaults to today)
    /// - Returns: The start of the week (Monday at 00:00)
    static func startOfWeek(from date: Date = Date()) -> Date {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: date)

        let weekday = calendar.component(.weekday, from: today)
        // Adjust to Monday (weekday 2 in US calendar)
        let daysToSubtract = (weekday + 5) % 7  // Convert to Mon=0
        return calendar.date(byAdding: .day, value: -daysToSubtract, to: today) ?? today
    }

    /// Check if a date is on the same day as another date
    /// - Parameters:
    ///   - date: The date to check
    ///   - otherDate: The date to compare against
    /// - Returns: True if both dates are on the same calendar day
    static func isDate(_ date: Date, inSameDayAs otherDate: Date) -> Bool {
        Calendar.current.isDate(date, inSameDayAs: otherDate)
    }

    /// Get the start of day for a given date
    /// - Parameter date: The date (defaults to today)
    /// - Returns: The date at 00:00:00
    static func startOfDay(for date: Date = Date()) -> Date {
        Calendar.current.startOfDay(for: date)
    }
}
