//
//  DailyGoalView.swift
//  quantchimp
//
//  Created by Linda Xue on 1/8/26.
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
            VStack(spacing: 32) {
                // Header
                VStack(spacing: 12) {
                    Text("Set Your Daily Goal")
                        .font(.system(size: 28, weight: .bold, design: .rounded))

                    Text("Consistency is key! Set a realistic daily goal and we'll help you stay on track.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                }
                .padding(.top, 40)

                // Daily minutes section
                dailyMinutesSection
                    .padding(.horizontal, 24)

                // Reminder section
                reminderSection
                    .padding(.horizontal, 24)

                Spacer(minLength: 100)
            }
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 12) {
                PrimaryButton(title: "Continue") {
                    saveSettings()
                    onContinue()
                }

                Button {
                    onBack()
                } label: {
                    Text("Back")
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: [Color(.systemBackground).opacity(0), Color(.systemBackground)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
        .opacity(contentOpacity)
        .onAppear {
            withAnimation(.easeOut(duration: 0.4)) {
                contentOpacity = 1.0
            }
        }
        .sheet(isPresented: $showTimePicker) {
            TimePickerSheet(selectedTime: $customTime)
        }
    }

    private var dailyMinutesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Daily Training Time")
                .font(.headline)

            VStack(spacing: 16) {
                // Visual display
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 12)
                        .frame(width: 140, height: 140)

                    Circle()
                        .trim(from: 0, to: CGFloat(dailyMinutes / 30))
                        .stroke(
                            LinearGradient(
                                colors: [.orange, .yellow],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 12, lineCap: .round)
                        )
                        .frame(width: 140, height: 140)
                        .rotationEffect(.degrees(-90))
                        .animation(.spring(response: 0.4), value: dailyMinutes)

                    VStack(spacing: 4) {
                        Text("\(Int(dailyMinutes))")
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .foregroundColor(.orange)
                        Text("minutes")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity)

                // Option buttons
                HStack(spacing: 8) {
                    ForEach(minuteOptions, id: \.self) { minutes in
                        Button {
                            withAnimation(.spring(response: 0.3)) {
                                dailyMinutes = Double(minutes)
                            }
                        } label: {
                            Text("\(minutes)")
                                .font(.headline)
                                .foregroundColor(Int(dailyMinutes) == minutes ? .white : .primary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Int(dailyMinutes) == minutes ? Color.orange : Color(.systemGray5))
                                )
                        }
                    }
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
            )
        }
    }

    private var reminderSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Daily Reminder")
                .font(.headline)

            VStack(spacing: 0) {
                ForEach(ReminderPreset.allCases) { preset in
                    Button {
                        withAnimation(.spring(response: 0.3)) {
                            selectedPreset = preset
                            if preset == .custom {
                                showTimePicker = true
                            }
                        }
                    } label: {
                        HStack(spacing: 16) {
                            Image(systemName: preset.icon)
                                .font(.title3)
                                .foregroundColor(presetColor(for: preset))
                                .frame(width: 28)

                            Text(preset.rawValue)
                                .font(.body)
                                .foregroundColor(.primary)

                            Spacer()

                            if preset == .custom && selectedPreset == .custom {
                                Text(formattedCustomTime)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            } else if preset != .custom && preset != .none {
                                Text(preset.timeDescription)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }

                            // Selection indicator
                            ZStack {
                                Circle()
                                    .stroke(selectedPreset == preset ? Color.orange : Color.gray.opacity(0.3), lineWidth: 2)
                                    .frame(width: 22, height: 22)

                                if selectedPreset == preset {
                                    Circle()
                                        .fill(Color.orange)
                                        .frame(width: 12, height: 12)
                                }
                            }
                        }
                        .padding(.vertical, 14)
                        .padding(.horizontal, 16)
                    }
                    .buttonStyle(.plain)

                    if preset != ReminderPreset.allCases.last {
                        Divider()
                            .padding(.leading, 56)
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
            )
        }
    }

    private var formattedCustomTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: customTime)
    }

    private func presetColor(for preset: ReminderPreset) -> Color {
        switch preset {
        case .morning: return .orange
        case .afternoon: return .yellow
        case .evening: return .purple
        case .custom: return .blue
        case .none: return .gray
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
                .padding()

                Spacer()
            }
            .navigationTitle("Choose Time")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(.orange)
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
