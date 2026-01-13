//
//  QuestsView.swift
//  quantchimp
//
//  Achievements and quests tracking
//

import SwiftUI

struct QuestsView: View {
    @EnvironmentObject var statsManager: StatsManager
    @EnvironmentObject var appState: AppState

    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.lg) {
                achievementsSection
                Spacer(minLength: 40)
            }
            .padding(.horizontal, Spacing.md)
            .padding(.top, Spacing.md)
        }
        .scrollIndicators(.hidden)
        .background(Theme.background)
        .safeAreaInset(edge: .top, spacing: 0) {
            SimplePageHeader(title: "Quests")
        }
        .navigationBarHidden(true)
    }

    // MARK: - Sections
    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            VStack(spacing: Spacing.smd) {
                // Beginner achievements
                AchievementCard(
                    icon: "avatar_excited",
                    title: "First Steps",
                    description: "Complete your first puzzle",
                    isUnlocked: statsManager.sessionHistory.count > 0,
                    color: Theme.daily
                )

                AchievementCard(
                    icon: "avatar_ninja",
                    title: "Week Warrior",
                    description: "Maintain a 7 day streak",
                    isUnlocked: statsManager.currentStreak >= 7,
                    progress: Double(statsManager.currentStreak) / 7.0,
                    color: Theme.streak
                )

                AchievementCard(
                    icon: "avatar_champion",
                    title: "Perfect Score",
                    description: "Complete a session with 100% accuracy",
                    isUnlocked: statsManager.sessionHistory.contains { session in
                        session.questionsAnswered > 0 && session.correctCount == session.questionsAnswered
                    },
                    color: Theme.success
                )

                AchievementCard(
                    icon: "monkey_sprint",
                    title: "Speed Demon",
                    description: "Complete 10 sprint sessions",
                    isUnlocked: statsManager.sprintCompleted >= 10,
                    progress: Double(statsManager.sprintCompleted) / 10.0,
                    color: Theme.sprint
                )

                AchievementCard(
                    icon: "avatar_scientist",
                    title: "Century Club",
                    description: "Answer 100 questions",
                    isUnlocked: totalQuestionsAnswered >= 100,
                    progress: Double(totalQuestionsAnswered) / 100.0,
                    color: Theme.level
                )

                AchievementCard(
                    icon: "avatar_wizard",
                    title: "XP Master",
                    description: "Earn 2000 XP",
                    isUnlocked: appState.xp >= 2000,
                    progress: Double(appState.xp) / 2000.0,
                    color: Theme.xp
                )
            }
        }
    }

    // MARK: - Helpers
    private var totalQuestionsAnswered: Int {
        statsManager.sessionHistory.reduce(0) { $0 + $1.questionsAnswered }
    }
}

// MARK: - Achievement Card Component
struct AchievementCard: View {
    let icon: String
    let title: String
    let description: String
    let isUnlocked: Bool
    var progress: Double? = nil
    let color: Color

    var body: some View {
        HStack(spacing: Spacing.md) {
            // Icon
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 56, height: 56)
                .opacity(isUnlocked ? 1.0 : 0.5)

            // Content
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(title)
                    .font(Typography.bodyBold as Font)
                    .foregroundColor(isUnlocked ? color : Theme.textSecondary)

                Text(description)
                    .font(Typography.caption as Font)
                    .foregroundColor(Theme.textTertiary)

                // Progress bar if not unlocked and progress available
                if !isUnlocked, let progress = progress, progress > 0 {
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            // Background
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Theme.surfaceElevated)
                                .frame(height: 4)

                            // Progress
                            RoundedRectangle(cornerRadius: 2)
                                .fill(color)
                                .frame(width: geometry.size.width * min(1.0, progress), height: 4)
                        }
                    }
                    .frame(height: 4)
                }
            }

            Spacer()

            // Checkmark if unlocked
            if isUnlocked {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(Theme.success)
            }
        }
        .padding(Spacing.md)
        .background(Theme.surfaceElevated)
        .cornerRadius(Spacing.md)
        .opacity(isUnlocked ? 1.0 : 0.7)
    }
}

#Preview {
    NavigationStack {
        QuestsView()
            .environmentObject(StatsManager())
            .environmentObject(AppState())
    }
}
