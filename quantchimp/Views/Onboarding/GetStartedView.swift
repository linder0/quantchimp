//
//  GetStartedView.swift
//  quantchimp
//
//  Get started onboarding using Theme tokens
//

import SwiftUI

struct GetStartedView: View {
    @EnvironmentObject var appState: AppState
    let selectedGoal: UserGoal?
    let onComplete: () -> Void
    let onBack: () -> Void

    @State private var contentOpacity: Double = 0
    @State private var mascotScale: CGFloat = 0.5

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // Celebration mascot
            ZStack {
                // Glow effect
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Theme.accent.opacity(0.3),
                                Theme.accent.opacity(0.1),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 60,
                            endRadius: 140
                        )
                    )
                    .frame(width: 280, height: 280)

                Image("monkey_excellent")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 180)
            }
            .scaleEffect(mascotScale)

            Spacer()
                .frame(height: 40)

            // Title
            VStack(spacing: Spacing.smd) {
                Text("You're All Set!")
                    .font(Typography.displayMedium)
                    .foregroundStyle(Theme.accentGradient)

                Text("Your training journey begins now")
                    .font(Typography.heading3)
                    .foregroundColor(Theme.textPrimary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, Spacing.xl)

            Spacer()

            // Navigation buttons
            VStack(spacing: Spacing.smd) {
                PrimaryButton(title: "Start Training") {
                    onComplete()
                }

                TertiaryButton(title: "Back") {
                    onBack()
                }
            }
            .padding(.horizontal, Spacing.lg)
            .padding(.bottom, Spacing.lg)
        }
        .opacity(contentOpacity)
        .background(Theme.background)
        .onAppear {
            startAnimations()
        }
    }

    private var summaryCard: some View {
        VStack(spacing: Spacing.md) {
            // Goal
            if let goal = selectedGoal {
                SummaryRow(
                    icon: goal.icon,
                    iconColor: goalColor(for: goal),
                    label: "Goal",
                    value: goal.rawValue
                )

                Divider()
                    .background(Theme.surfaceBorder)
            }

            // Daily goal
            SummaryRow(
                icon: "clock.fill",
                iconColor: Theme.accent,
                label: "Daily Goal",
                value: "\(appState.userProfile.dailyGoalMinutes) minutes"
            )

            // Reminder
            if let preset = appState.userProfile.reminderPreset, preset != .none {
                Divider()
                    .background(Theme.surfaceBorder)

                SummaryRow(
                    icon: "bell.fill",
                    iconColor: Theme.level,
                    label: "Reminder",
                    value: reminderDescription
                )
            }
        }
        .padding(Spacing.lg)
        .cardStyle(hasBorder: false)
    }

    private var reminderDescription: String {
        guard let preset = appState.userProfile.reminderPreset else { return "None" }

        if preset == .custom, let time = appState.userProfile.reminderTime {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter.string(from: time)
        }

        return preset.timeDescription
    }

    private func goalColor(for goal: UserGoal) -> Color {
        switch goal.color {
        case "purple": return Theme.level
        case "blue": return Theme.sprint
        case "orange": return Theme.accent
        case "green": return Theme.success
        default: return Theme.accent
        }
    }

    private func startAnimations() {
        // Content fade in
        withAnimation(Motion.ease(Motion.smooth)) {
            contentOpacity = 1.0
        }

        // Mascot entrance
        withAnimation(Motion.bounce.delay(0.2)) {
            mascotScale = 1.0
        }

        // Play celebration sound and haptic
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            Sound.celebration()
            Haptic.success()
        }
    }
}

// MARK: - Summary Row

struct SummaryRow: View {
    let icon: String
    let iconColor: Color
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: Spacing.md) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(iconColor)
                .frame(width: 28)

            Text(label)
                .font(Typography.body)
                .foregroundColor(Theme.textSecondary)

            Spacer()

            Text(value)
                .font(Typography.bodyBold)
                .foregroundColor(Theme.textPrimary)
        }
    }
}

#Preview {
    GetStartedView(
        selectedGoal: .quantCareer,
        onComplete: {},
        onBack: {}
    )
    .environmentObject(AppState())
}
