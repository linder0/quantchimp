//
//  NotificationManager.swift
//  quantchimp
//
//  Created by Linda Xue on 1/8/26.
//

import Foundation
import UserNotifications

actor NotificationManager {
    static let shared = NotificationManager()

    private let notificationCenter = UNUserNotificationCenter.current()
    private let dailyReminderIdentifier = "quantchimp.daily.reminder"

    private init() {}

    // MARK: - Authorization

    func requestAuthorization() async -> Bool {
        do {
            let granted = try await notificationCenter.requestAuthorization(options: [.alert, .sound, .badge])
            return granted
        } catch {
            print("Notification authorization error: \(error)")
            return false
        }
    }

    func checkAuthorizationStatus() async -> UNAuthorizationStatus {
        let settings = await notificationCenter.notificationSettings()
        return settings.authorizationStatus
    }

    // MARK: - Schedule Daily Reminder

    func scheduleDaily(at time: Date) async {
        // First, request authorization if not already granted
        let status = await checkAuthorizationStatus()

        if status == .notDetermined {
            let granted = await requestAuthorization()
            if !granted {
                return
            }
        } else if status == .denied {
            return
        }

        // Cancel any existing daily reminders
        await cancelDailyReminder()

        // Create notification content
        let content = UNMutableNotificationContent()
        content.title = "Time to Train! 🐵"
        content.body = getRandomReminderMessage()
        content.sound = .default
        content.badge = 1

        // Extract hour and minute from the time
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: time)

        // Create trigger for daily notification
        var triggerComponents = DateComponents()
        triggerComponents.hour = components.hour
        triggerComponents.minute = components.minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: true)

        // Create request
        let request = UNNotificationRequest(
            identifier: dailyReminderIdentifier,
            content: content,
            trigger: trigger
        )

        // Schedule
        do {
            try await notificationCenter.add(request)
            print("Daily reminder scheduled for \(components.hour ?? 0):\(components.minute ?? 0)")
        } catch {
            print("Failed to schedule notification: \(error)")
        }
    }

    // MARK: - Cancel Notifications

    func cancelDailyReminder() async {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [dailyReminderIdentifier])
    }

    func cancelAllNotifications() async {
        notificationCenter.removeAllPendingNotificationRequests()
    }

    // MARK: - Helper Methods

    private func getRandomReminderMessage() -> String {
        let messages = [
            "Your brain is waiting for its daily workout!",
            "A quick session keeps the mind sharp.",
            "Ready to crush some numbers?",
            "Your streak is counting on you!",
            "Let's get those neurons firing!",
            "Time for your daily brain gains!",
            "Just 5 minutes can make a difference!",
            "The chimp is ready. Are you?",
            "Keep your mental math skills sharp!",
            "Don't break your streak—let's go!"
        ]
        return messages.randomElement() ?? messages[0]
    }
}

