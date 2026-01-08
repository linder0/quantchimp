//
//  DailyGoalView.swift
//  quantchimp
//
//  Daily goal onboarding using Theme tokens
//

import SwiftUI

struct DailyGoalView: View {
    @EnvironmentObject var appState: AppState
    let onContinue: () -> Void
    let onBack: () -> Void

    @State private var dailyMinutes: Double = 10
    @State private var selectedPreset: ReminderPreset = .morning
    @State private var customTime: Date = {
        var components = DateComponents()
        components.hour = 9
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }()
    @State private var showTimePicker: Bool = false
    @State private var contentOpacity: Double = 0

    private let minuteOptions = [5, 10, 15, 20, 30]

    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.xl) {
                // Header
                VStack(spacing: Spacing.smd) {
                    Text("Set Your Daily Goal")
                        .font(Typography.heading1)
                        .foregroundColor(Theme.textPrimary)

                    Text("Consistency is key! Set a realistic daily goal and we'll help you stay on track.")
                        .font(Typography.body)
                        .foregroundColor(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Spacing.md)
                }
                .padding(.top, Spacing.xl)

                // Daily minutes section
                dailyMinutesSection
                    .padding(.horizontal, Spacing.lg)

                // Reminder section
                reminderSection
                    .padding(.horizontal, Spacing.lg)

                Spacer(minLength: 100)
            }
        }
        .scrollIndicators(.hidden)
        .background(Theme.background)
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: Spacing.smd) {
                PrimaryButton(title: "Continue") {
                    saveSettings()
                    onContinue()
                }

                TertiaryButton(title: "Back") {
                    onBack()
                }
            }
            .padding(.horizontal, Spacing.lg)
            .padding(.vertical, Spacing.md)
            .background(
                LinearGradient(
                    colors: [Theme.background.opacity(0), Theme.background],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
        .opacity(contentOpacity)
        .onAppear {
            withAnimation(Motion.ease(Motion.smooth)) {
                contentOpacity = 1.0
            }
        }
        .sheet(isPresented: $showTimePicker) {
            TimePickerSheet(selectedTime: $customTime)
        }
    }

    private var dailyMinutesSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Daily Training Time")
                .font(Typography.headline)
                .foregroundColor(Theme.textPrimary)

            VStack(spacing: Spacing.md) {
                // Visual display
                ZStack {
                    Circle()
                        .stroke(Theme.surfaceElevated, lineWidth: 12)
                        .frame(width: 140, height: 140)

                    Circle()
                        .trim(from: 0, to: CGFloat(dailyMinutes / 30))
                        .stroke(Theme.accentGradient, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                        .frame(width: 140, height: 140)
                        .rotationEffect(.degrees(-90))
                        .animation(Motion.spring, value: dailyMinutes)

                    VStack(spacing: Spacing.xs) {
                        Text("\(Int(dailyMinutes))")
                            .font(Typography.displayMedium)
                            .foregroundColor(Theme.accent)
                        Text("minutes")
                            .font(Typography.caption)
                            .foregroundColor(Theme.textSecondary)
                    }
                }
                .frame(maxWidth: .infinity)

                // Option buttons
                HStack(spacing: Spacing.sm) {
                    ForEach(minuteOptions, id: \.self) { minutes in
                        Button {
                            withAnimation(Motion.spring) {
                                dailyMinutes = Double(minutes)
                            }
                        } label: {
                            Text("\(minutes)")
                                .font(Typography.headline)
                                .foregroundColor(Int(dailyMinutes) == minutes ? Theme.background : Theme.textPrimary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, Spacing.smd)
                                .background(
                                    RoundedRectangle(cornerRadius: Radius.md)
                                        .fill(Int(dailyMinutes) == minutes ? Theme.accent : Theme.surfaceElevated)
                                )
                        }
                    }
                }
            }
            .padding(Spacing.lg)
            .cardStyle(cornerRadius: Radius.lg)
        }
    }

    private var reminderSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Daily Reminder")
                .font(Typography.headline)
                .foregroundColor(Theme.textPrimary)

            VStack(spacing: 0) {
                ForEach(ReminderPreset.allCases) { preset in
                    Button {
                        withAnimation(Motion.spring) {
                            selectedPreset = preset
                            if preset == .custom {
                                showTimePicker = true
                            }
                        }
                    } label: {
                        HStack(spacing: Spacing.md) {
                            Image(systemName: preset.icon)
                                .font(.title3)
                                .foregroundColor(presetColor(for: preset))
                                .frame(width: 28)

                            Text(preset.rawValue)
                                .font(Typography.body)
                                .foregroundColor(Theme.textPrimary)

                            Spacer()

                            if preset == .custom && selectedPreset == .custom {
                                Text(formattedCustomTime)
                                    .font(Typography.caption)
                                    .foregroundColor(Theme.textSecondary)
                            } else if preset != .custom && preset != .none {
                                Text(preset.timeDescription)
                                    .font(Typography.caption)
                                    .foregroundColor(Theme.textSecondary)
                            }

                            // Selection indicator
                            ZStack {
                                Circle()
                                    .stroke(selectedPreset == preset ? Theme.accent : Theme.textTertiary, lineWidth: 2)
                                    .frame(width: 22, height: 22)

                                if selectedPreset == preset {
                                    Circle()
                                        .fill(Theme.accent)
                                        .frame(width: 12, height: 12)
                                }
                            }
                        }
                        .padding(.vertical, Spacing.smd)
                        .padding(.horizontal, Spacing.md)
                    }
                    .buttonStyle(.plain)

                    if preset != ReminderPreset.allCases.last {
                        Divider()
                            .background(Theme.surfaceBorder)
                            .padding(.leading, 56)
                    }
                }
            }
            .cardStyle(cornerRadius: Radius.lg)
        }
    }

    private var formattedCustomTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: customTime)
    }

    private func presetColor(for preset: ReminderPreset) -> Color {
        switch preset {
        case .morning: return Theme.accent
        case .afternoon: return Theme.xp
        case .evening: return Theme.level
        case .custom: return Theme.sprint
        case .none: return Theme.textTertiary
        }
    }

    private func saveSettings() {
        appState.userProfile.dailyGoalMinutes = Int(dailyMinutes)
        appState.userProfile.reminderPreset = selectedPreset

        // Set reminder time based on preset
        if selectedPreset == .custom {
            appState.userProfile.reminderTime = customTime
        } else if let hour = selectedPreset.defaultHour {
            var components = DateComponents()
            components.hour = hour
            components.minute = 0
            appState.userProfile.reminderTime = Calendar.current.date(from: components)
        } else {
            appState.userProfile.reminderTime = nil
        }

        // Schedule notifications if a reminder is set
        if selectedPreset != .none, let reminderTime = appState.userProfile.reminderTime {
            Task {
                await NotificationManager.shared.scheduleDaily(at: reminderTime)
            }
        }
    }
}

// MARK: - Time Picker Sheet

struct TimePickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedTime: Date

    var body: some View {
        NavigationStack {
            VStack {
                DatePicker(
                    "Select Time",
                    selection: $selectedTime,
                    displayedComponents: .hourAndMinute
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                .padding(Spacing.md)

                Spacer()
            }
            .background(Theme.background)
            .navigationTitle("Choose Time")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(Typography.headline)
                    .foregroundColor(Theme.accent)
                }
            }
        }
        .presentationDetents([.medium])
    }
}

#Preview {
    DailyGoalView(onContinue: {}, onBack: {})
        .environmentObject(AppState())
}
