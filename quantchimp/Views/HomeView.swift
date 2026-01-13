//
//  HomeView.swift
//  quantchimp
//
//  Home screen using Theme tokens
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var statsManager: StatsManager
    @Binding var navigationPath: NavigationPath
    @State private var scrollOffset: CGFloat = 0
    @State private var initialScrollOffset: CGFloat = 0
    @State private var showSprintFlow = false
    @State private var showDailyPuzzle = false

    // Header transition thresholds
    private let collapseThreshold: CGFloat = 60

    private var isCollapsed: Bool {
        scrollOffset < -collapseThreshold
    }

    // DISABLED: Header transform
    private var collapseProgress: CGFloat {
        return 0 // Always return 0 to disable transform
        // guard scrollOffset < 0 else { return 0 }
        // return min(1, abs(scrollOffset) / collapseThreshold)
    }

    // Linear interpolation helper for smooth transitions
    private func lerp(_ a: CGFloat, _ b: CGFloat, _ t: CGFloat) -> CGFloat {
        a + (b - a) * t
    }

    var body: some View {
        ZStack(alignment: .top) {
            // Main scrollable content
            ScrollView {
                VStack(spacing: 0) {
                    // Spacer for header - DISABLED scroll tracking
                    Color.clear
                        .frame(height: 250) // Fixed height when transform is disabled
                        // DISABLED: Scroll tracking for header transform
                        // .overlay(
                        //     GeometryReader { geometry in
                        //         Color.clear
                        //             .onAppear {
                        //                 initialScrollOffset = geometry.frame(in: .global).minY
                        //             }
                        //             .onChange(of: geometry.frame(in: .global).minY) { _, newValue in
                        //                 scrollOffset = newValue - initialScrollOffset
                        //             }
                        //     }
                        // )

                    VStack(spacing: Spacing.md) {
                        // Game modes section
                        gameModesSection
                    }
                    .padding(.horizontal, Spacing.md)
                    .padding(.top, Spacing.md)
                    .padding(.bottom, Spacing.lg)
                }
            }
            .scrollIndicators(.hidden)
            .background(Theme.background.ignoresSafeArea(edges: .top))

            // Transforming header
            transformingHeader
        }
        .navigationBarHidden(true)
        .ignoresSafeArea(edges: .top)
        .navigationDestination(for: NavigationDestination.self) { destination in
            switch destination {
            case .dailyPuzzle:
                // Now handled by fullScreenCover
                EmptyView()
            case .arithmeticSetup:
                // Handled by sheet presentation now
                EmptyView()
            }
        }
        .fullScreenCover(isPresented: $showSprintFlow) {
            ArithmeticSprintFlowView()
        }
        .fullScreenCover(isPresented: $showDailyPuzzle) {
            DailyPuzzleView()
        }
    }

    // MARK: - Transforming Header

    // Smooth scale factor for badges (1.0 -> 0.85)
    private var badgeScale: CGFloat {
        lerp(1.0, 0.85, collapseProgress)
    }

    private var transformingHeader: some View {
        VStack(spacing: 0) {
            // Header content
            HStack(spacing: Spacing.smd) {
                // Avatar - shrinks smoothly on collapse using scaleEffect
                Image(appState.userProfile.avatarImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64, height: 64)
                    .scaleEffect(lerp(1.0, 0.625, collapseProgress)) // 64 -> 40
                    .frame(
                        width: lerp(64, 40, collapseProgress),
                        height: lerp(64, 40, collapseProgress)
                    )

                // Info section
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(appState.userProfile.displayName)
                        .font(Typography.heading2)
                        .scaleEffect(lerp(1.0, 0.8, collapseProgress), anchor: .leading)
                        .foregroundColor(.white)
                }

                Spacer()

                // Streak badge - use scaleEffect for synchronized shrinking
                HStack(spacing: Spacing.xs) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 14))
                        .foregroundColor(Theme.streak)

                    Text("\(appState.streak)")
                        .font(Typography.label)
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(.white.opacity(0.2))
                )
                .scaleEffect(badgeScale)

                // XP Badge - use scaleEffect for synchronized shrinking
                HStack(spacing: Spacing.xs) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 14))
                        .foregroundColor(Theme.xp)

                    Text("\(appState.xp) XP")
                        .font(Typography.label)
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(.white.opacity(0.2))
                )
                .scaleEffect(badgeScale)
            }
            .padding(.horizontal, Spacing.md)
            .padding(.top, 60)
            .padding(.bottom, Spacing.md)
            .frame(maxWidth: .infinity)

            // Quest Suggestion Card - DISABLED transform
            featuredQuestCard
                .padding(.bottom, Spacing.lg)
                // DISABLED: Transform effects
                // .scaleEffect(x: 1.0, y: lerp(1.0, 0.0, collapseProgress), anchor: .top)
                // .opacity(lerp(1.0, 0.0, collapseProgress))
                // .frame(height: lerp(50, 0, collapseProgress))
        }
        .background(Theme.accent)
        .ignoresSafeArea(edges: .top)
        // DISABLED: Shadow animation during header transform
        // .shadow(
        //     color: Shadow.md.color.opacity(Double(collapseProgress)),
        //     radius: lerp(0, Shadow.md.radius, collapseProgress),
        //     x: 0,
        //     y: lerp(0, Shadow.md.y, collapseProgress)
        // )
    }

    private var gameModesSection: some View {
        VStack(alignment: .leading, spacing: Spacing.smd) {
            SectionHeader(title: "Play")

            // Active game modes - side by side cards
            HStack(spacing: Spacing.smd) {
                ForEach(GameMode.activeModesForCards) { mode in
                    PlayOptionCard(
                        imageName: mode.imageName,
                        title: mode.rawValue,
                        subtitle: mode.subtitle(for: appState),
                        isCompleted: mode.isCompleted(for: appState),
                        imageOffset: mode.imageOffset,
                        imageSize: mode.imageSize
                    ) {
                        handleGameModeSelection(mode)
                    }
                }
            }
        }
    }

    private func handleGameModeSelection(_ mode: GameMode) {
        switch mode {
        case .daily:
            showDailyPuzzle = true
        case .sprint:
            showSprintFlow = true
        case .tournament, .challenge:
            break // Disabled modes
        }
    }

    private var featuredQuestCard: some View {
        let quest = closestQuest

        return VStack(alignment: .leading, spacing: Spacing.xs) {
            // Title and reward
            HStack {
                Text(quest.title)
                    .font(Typography.bodyBold)
                    .foregroundColor(.white)

                Spacer()

                // XP reward
                HStack(spacing: Spacing.xs) {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundColor(Theme.xp)
                    Text("+\(quest.xpReward)")
                        .font(Typography.caption)
                        .foregroundColor(.white)
                }
            }

            // Progress bar
            HStack(spacing: Spacing.xs) {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        // Background
                        RoundedRectangle(cornerRadius: Radius.sm)
                            .fill(.white.opacity(0.2))
                            .frame(height: 6)

                        // Progress
                        RoundedRectangle(cornerRadius: Radius.sm)
                            .fill(.white)
                            .frame(
                                width: geometry.size.width * CGFloat(min(quest.progress, quest.total)) / CGFloat(quest.total),
                                height: 6
                            )
                    }
                }
                .frame(height: 6)

                Text("\(quest.progress)/\(quest.total)")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                    .frame(width: 35)
            }
        }
        .padding(.horizontal, Spacing.md)
    }

    private struct QuestInfo {
        let icon: String
        let title: String
        let description: String
        let progress: Int
        let total: Int
        let xpReward: Int
        var progressPercentage: Double {
            Double(progress) / Double(total)
        }
    }

    private var closestQuest: QuestInfo {
        let totalQuestionsAnswered = statsManager.sessionHistory.reduce(0) { $0 + $1.questionsAnswered }

        let quests = [
            QuestInfo(
                icon: "flame.fill",
                title: "Week Warrior",
                description: "Maintain a 7-day streak",
                progress: statsManager.currentStreak,
                total: 7,
                xpReward: 100
            ),
            QuestInfo(
                icon: "bolt.fill",
                title: "Speed Demon",
                description: "Complete 10 sprint sessions",
                progress: statsManager.sprintCompleted,
                total: 10,
                xpReward: 150
            ),
            QuestInfo(
                icon: "100.square.fill",
                title: "Century Club",
                description: "Answer 100 questions",
                progress: totalQuestionsAnswered,
                total: 100,
                xpReward: 200
            ),
            QuestInfo(
                icon: "trophy.fill",
                title: "XP Master",
                description: "Earn 2000 XP",
                progress: appState.xp,
                total: 2000,
                xpReward: 500
            )
        ]

        // Find the incomplete quest with the highest progress percentage
        let incompleteQuests = quests.filter { $0.progress < $0.total }

        return incompleteQuests.max(by: { $0.progressPercentage < $1.progressPercentage })
            ?? quests.first! // Fallback to first quest if all are complete
    }

}

#Preview {
    NavigationStack {
        HomeView(navigationPath: .constant(NavigationPath()))
            .environmentObject(AppState())
            .environmentObject(StatsManager())
    }
}
