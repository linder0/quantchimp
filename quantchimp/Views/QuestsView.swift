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
                ForEach(QuestManager.allQuests) { quest in
                    let progress = quest.currentProgress(appState: appState, statsManager: statsManager)
                    let isUnlocked = quest.isUnlocked(appState: appState, statsManager: statsManager)

                    AchievementCard(
                        icon: quest.icon,
                        title: quest.title,
                        description: quest.description,
                        isUnlocked: isUnlocked,
                        progress: isUnlocked ? nil : Double(progress) / Double(quest.totalRequired),
                        progressTotal: quest.totalRequired,
                        color: quest.color
                    )
                }
            }
        }
    }
}

// MARK: - Achievement Card Component
struct AchievementCard: View {
    let icon: String
    let title: String
    let description: String
    let isUnlocked: Bool
    var progress: Double? = nil
    var progressTotal: Int = 100
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
                HStack(alignment: .center, spacing: Spacing.sm) {
                    Text(title)
                        .font(Typography.bodyBold as Font)
                        .foregroundColor(isUnlocked ? color : Theme.textSecondary)
                        .lineLimit(1)

                    Spacer(minLength: 0)

                    // XP reward badge if unlocked
                    if isUnlocked {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .font(.caption)
                                .foregroundColor(Theme.xp)
                            Text("+200")
                                .font(Typography.caption as Font)
                                .foregroundColor(Theme.textPrimary)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Theme.xp.opacity(0.15))
                        .cornerRadius(Radius.sm)
                        .fixedSize()
                    }
                }

                Text(description)
                    .font(Typography.caption as Font)
                    .foregroundColor(Theme.textTertiary)
                    .lineLimit(2)

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
