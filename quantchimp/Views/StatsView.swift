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
        VStack(spacing: 0) {
            // Custom header matching Friends style
            statsHeader

            // Content area
            ScrollView {
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
            .scrollIndicators(.hidden)
            .background(Theme.background)
        }
        .background(Theme.background.ignoresSafeArea())
    }

    // MARK: - Header
    private var statsHeader: some View {
        HStack(alignment: .bottom, spacing: 0) {
            // Text on left
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text("Stats")
                    .font(Typography.heading1)
                    .foregroundColor(.white)

                Text("Track your progress")
                    .font(Typography.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(.leading, Spacing.md)
            .padding(.bottom, Spacing.lg)

            Spacer()

            // Monkey on right - bigger to fill space
            Image("monkey_great")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .offset(x: -Spacing.md, y: -Spacing.sm)
        }
        .padding(.top, 56)
        .padding(.leading, Spacing.md)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [Theme.level, Theme.level.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea(edges: .top)
        )
        .clipped()
    }

    private var summarySection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("OVERVIEW")
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
                    value: formatAccuracy(statsManager.overallAccuracy),
                    label: "Accuracy",
                    color: Theme.level
                )
            }
        }
    }

    private var modeBreakdownSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("BY MODE")
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
            Text("RECENT SESSIONS")
                .font(Typography.headline)
                .foregroundColor(Theme.textPrimary)

            if statsManager.recentSessions.isEmpty {
                VStack(spacing: Spacing.smd) {
                    Image("monkey_no_sessions")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)

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
