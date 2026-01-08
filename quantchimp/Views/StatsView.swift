//
//  StatsView.swift
//  quantchimp
//
//  Statistics view using Theme tokens
//

import SwiftUI

struct StatsView: View {
    @EnvironmentObject var statsManager: StatsManager
    @EnvironmentObject var appState: AppState

    var body: some View {
        ScrollableViewWithHeader(title: "Stats", headerColor: Theme.surfaceElevated) {
            VStack(spacing: Spacing.lg) {
                // Summary section
                summarySection

                // Mode breakdown
                modeBreakdownSection

                // Session history
                sessionHistorySection

                Spacer(minLength: 40)
            }
            .padding(Spacing.md)
        }
    }

    private var summarySection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Overview")
                .font(Typography.headline)
                .foregroundColor(Theme.textPrimary)

            HStack(spacing: Spacing.smd) {
                StatCard(
                    icon: "questionmark.circle.fill",
                    value: "\(statsManager.totalQuestions)",
                    label: "Questions",
                    color: Theme.sprint
                )

                StatCard(
                    icon: "checkmark.circle.fill",
                    value: "\(statsManager.totalCorrect)",
                    label: "Correct",
                    color: Theme.success
                )

                StatCard(
                    icon: "percent",
                    value: String(format: "%.0f%%", statsManager.overallAccuracy),
                    label: "Accuracy",
                    color: Theme.level
                )
            }
        }
    }

    private var modeBreakdownSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("By Mode")
                .font(Typography.headline)
                .foregroundColor(Theme.textPrimary)

            VStack(spacing: Spacing.smd) {
                ModeStatCard(
                    mode: .daily,
                    completed: statsManager.dailyCompleted,
                    accuracy: statsManager.dailyAccuracy
                )

                ModeStatCard(
                    mode: .sprint,
                    completed: statsManager.sprintCompleted,
                    accuracy: statsManager.sprintAccuracy
                )
            }
        }
    }

    private var sessionHistorySection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Recent Sessions")
                .font(Typography.headline)
                .foregroundColor(Theme.textPrimary)

            if statsManager.recentSessions.isEmpty {
                VStack(spacing: Spacing.smd) {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.system(size: 40))
                        .foregroundColor(Theme.textSecondary)

                    Text("No sessions yet")
                        .font(Typography.bodyBold)
                        .foregroundColor(Theme.textSecondary)

                    Text("Complete a puzzle or sprint to see your history here.")
                        .font(Typography.caption)
                        .foregroundColor(Theme.textTertiary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(Spacing.xl)
                .cardStyle()
            } else {
                VStack(spacing: Spacing.sm) {
                    ForEach(statsManager.recentSessions) { session in
                        SessionRow(session: session)
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        StatsView()
            .environmentObject(StatsManager())
            .environmentObject(AppState())
    }
}
