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

    private var collapseProgress: CGFloat {
        guard scrollOffset < 0 else { return 0 }
        return min(1, abs(scrollOffset) / collapseThreshold)
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
                    // Spacer for header with scroll tracking
                    Color.clear
                        .frame(height: 180)
                        .overlay(
                            GeometryReader { geometry in
                                Color.clear
                                    .onAppear {
                                        initialScrollOffset = geometry.frame(in: .global).minY
                                    }
                                    .onChange(of: geometry.frame(in: .global).minY) { _, newValue in
                                        scrollOffset = newValue - initialScrollOffset
                                    }
                            }
                        )

                    VStack(spacing: Spacing.md) {
                        // Streak/activity section
                        weeklyActivitySection

                        // Game modes section
                        gameModesSection

                        // Game history section
                        gameHistorySection
                    }
                    .padding(Spacing.md)
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

    private var profileColor: Color {
        Color(hex: appState.userProfile.profileColor.hex)
    }

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

                    // Level text - always render, fade out smoothly
                    Text("Level \(appState.currentLevel)")
                        .font(Typography.caption)
                        .foregroundColor(.white.opacity(0.8))
                        .opacity(1 - collapseProgress)
                        .frame(height: lerp(18, 0, collapseProgress), alignment: .top)
                        .clipped()
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
            .padding(.bottom, lerp(Spacing.md, 10, collapseProgress))
            .frame(maxWidth: .infinity)

            // XP Progress bar - always render, fade out smoothly
            VStack(spacing: Spacing.xs) {
                XPBarCompact(progress: appState.xpProgressInLevel)

                HStack {
                    Text("\(appState.xpToNextLevel) XP to Level \(appState.currentLevel + 1)")
                        .font(Typography.captionSmall)
                        .foregroundColor(.white.opacity(0.8))

                    Spacer()
                }
            }
            .padding(.horizontal, Spacing.md)
            .padding(.bottom, Spacing.smd)
            .opacity(1 - collapseProgress)
            .frame(height: lerp(50, 0, collapseProgress), alignment: .top)
            .clipped()
        }
        .background(profileColor)
        .ignoresSafeArea(edges: .top)
        .shadow(
            color: Shadow.md.color.opacity(Double(collapseProgress)),
            radius: lerp(0, Shadow.md.radius, collapseProgress),
            x: 0,
            y: lerp(0, Shadow.md.y, collapseProgress)
        )
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

            // Future modes (disabled)
            ForEach(GameMode.disabledModesForTiles) { mode in
                PlayOptionTile(
                    imageName: mode.imageName,
                    title: mode.rawValue,
                    subtitle: mode.subtitle(for: appState),
                    isDisabled: true
                ) {}
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

    private var weeklyActivitySection: some View {
        VStack(alignment: .leading, spacing: Spacing.smd) {
            SectionHeader(title: "Weekly Activity")

            weeklyActivityCard
        }
    }

    private var weeklyActivityCard: some View {
        let days = ["M", "T", "W", "T", "F", "S", "S"]
        let activity = statsManager.weeklyActivity

        return VStack(spacing: Spacing.sm) {
            // Streak count header
            HStack {
                Image(systemName: "flame.fill")
                    .foregroundColor(Theme.streak)
                Text("\(statsManager.currentStreak) day streak")
                    .font(Typography.label as Font)
                    .foregroundColor(Theme.textPrimary)
                Spacer()
            }

            // Days of week
            HStack(spacing: 0) {
                ForEach(0..<7, id: \.self) { index in
                    weeklyDayView(index: index, days: days, activity: activity)
                }
            }
        }
        .padding(Spacing.md)
        .background(
            LinearGradient(
                colors: [Theme.streak.opacity(0.06), Theme.streak.opacity(0.02)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cardStyle()
    }

    @ViewBuilder
    private func weeklyDayView(index: Int, days: [String], activity: [Bool]) -> some View {
        let isActive = index < activity.count && activity[index]

        VStack(spacing: Spacing.xs) {
            Text(days[index])
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(Theme.textTertiary)

            ZStack {
                Circle()
                    .fill(isActive ? Theme.streak : Theme.surfaceElevated)
                    .frame(width: 32, height: 32)

                if isActive {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var gameHistorySection: some View {
        VStack(alignment: .leading, spacing: Spacing.smd) {
            SectionHeader(title: "Recent Sessions")

            if statsManager.sessionHistory.isEmpty {
                // Empty state
                VStack(spacing: Spacing.md) {
                    Image("monkey_no_sessions")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)

                    Text("No sessions yet")
                        .font(Typography.headline)
                        .foregroundColor(Theme.textPrimary)

                    Text("Choose a mode above to start!")
                        .font(Typography.caption)
                        .foregroundColor(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.xl)
                .cardStyle()
            } else {
                // Session history
                LazyVStack(spacing: Spacing.sm) {
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
        HomeView(navigationPath: .constant(NavigationPath()))
            .environmentObject(AppState())
            .environmentObject(StatsManager())
    }
}
