//
//  StatsView.swift
//  quantchimp
//
//  Created by Linda Xue on 1/8/26.
//

import SwiftUI

struct StatsView: View {
    @EnvironmentObject var statsManager: StatsManager
    @EnvironmentObject var appState: AppState

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Summary section
                summarySection

                // Mode breakdown
                modeBreakdownSection

                // Session history
                sessionHistorySection

                Spacer(minLength: 40)
            }
            .padding()
        }
        .background(Color(.systemGray6).ignoresSafeArea())
        .navigationBarHidden(true)
    }

    private var summarySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Overview")
                .font(.headline)

            HStack(spacing: 12) {
                StatCard(
                    icon: "questionmark.circle.fill",
                    value: "\(statsManager.totalQuestions)",
                    label: "Questions",
                    color: .blue
                )

                StatCard(
                    icon: "checkmark.circle.fill",
                    value: "\(statsManager.totalCorrect)",
                    label: "Correct",
                    color: .green
                )

                StatCard(
                    icon: "percent",
                    value: String(format: "%.0f%%", statsManager.overallAccuracy),
                    label: "Accuracy",
                    color: .purple
                )
            }

        }
    }

    private var modeBreakdownSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("By Mode")
                .font(.headline)

            VStack(spacing: 12) {
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
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Sessions")
                .font(.headline)

            if statsManager.recentSessions.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.system(size: 40))
                        .foregroundColor(.secondary)

                    Text("No sessions yet")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text("Complete a puzzle or sprint to see your history here.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(32)
                .cardStyle()
            } else {
                VStack(spacing: 8) {
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
