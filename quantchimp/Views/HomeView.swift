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
    @State private var showSprintFlow = false

    // Header transition thresholds
    private let collapseThreshold: CGFloat = 60

    private var isCollapsed: Bool {
        scrollOffset < -collapseThreshold
    }

    private var collapseProgress: CGFloat {
        guard scrollOffset < 0 else { return 0 }
        return min(1, abs(scrollOffset) / collapseThreshold)
    }

    var body: some View {
        ZStack(alignment: .top) {
            // Main scrollable content
            ScrollView {
                VStack(spacing: 0) {
                    // Invisible scroll tracker
                    GeometryReader { geometry in
                        Color.clear
                            .preference(
                                key: ScrollOffsetPreferenceKey.self,
                                value: geometry.frame(in: .named("homeScroll")).minY
                            )
                    }
                    .frame(height: 0)

                    // Spacer for header
                    Spacer()
                        .frame(height: isCollapsed ? 120 : 180)

                    VStack(spacing: Spacing.lg) {
                        // Game modes section
                        gameModesSection

                        // Game history section
                        gameHistorySection

                        Spacer(minLength: 20)
                    }
                    .padding(Spacing.md)
                }
            }
            .scrollIndicators(.hidden)
            .coordinateSpace(name: "homeScroll")
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                scrollOffset = value
            }
            .background(Theme.background.ignoresSafeArea())

            // Transforming header
            transformingHeader
        }
        .navigationBarHidden(true)
        .ignoresSafeArea(edges: .top)
        .navigationDestination(for: NavigationDestination.self) { destination in
            switch destination {
            case .dailyPuzzle:
                DailyPuzzleView(navigationPath: $navigationPath)
            case .arithmeticSetup:
                // Handled by sheet presentation now
                EmptyView()
            }
        }
        .fullScreenCover(isPresented: $showSprintFlow) {
            ArithmeticSprintFlowView()
        }
    }

    // MARK: - Transforming Header

    private var transformingHeader: some View {
        VStack(spacing: 0) {
            // Header content
            HStack(spacing: Spacing.smd) {
                // Avatar - shrinks on collapse
                Image(appState.userProfile.avatarImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: isCollapsed ? 40 : 64, height: isCollapsed ? 40 : 64)

                // Info section
                VStack(alignment: .leading, spacing: isCollapsed ? 2 : Spacing.xs) {
                    Text(appState.userProfile.displayName)
                        .font(isCollapsed ? Typography.headline : Typography.heading2)
                        .foregroundColor(Theme.textPrimary)

                    if !isCollapsed {
                        Text("Level \(appState.currentLevel)")
                            .font(Typography.caption)
                            .foregroundColor(Theme.textSecondary)
                    }
                }

                Spacer()

                // Streak badge
                HStack(spacing: Spacing.xs) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: isCollapsed ? 12 : 14))
                        .foregroundColor(Theme.streak)

                    Text("\(appState.streak)")
                        .font(isCollapsed ? Typography.caption : Typography.label)
                        .foregroundColor(Theme.textPrimary)
                }
                .padding(.horizontal, isCollapsed ? 10 : 14)
                .padding(.vertical, isCollapsed ? 6 : 8)
                .background(
                    Capsule()
                        .fill(Theme.streak.opacity(0.15))
                )

                // XP Badge
                HStack(spacing: Spacing.xs) {
                    Image(systemName: "star.fill")
                        .font(.system(size: isCollapsed ? 12 : 14))
                        .foregroundColor(Theme.xp)

                    Text("\(appState.xp) XP")
                        .font(isCollapsed ? Typography.caption : Typography.label)
                        .foregroundColor(Theme.textPrimary)
                }
                .padding(.horizontal, isCollapsed ? 10 : 14)
                .padding(.vertical, isCollapsed ? 6 : 8)
                .background(
                    Capsule()
                        .fill(Theme.xp.opacity(0.15))
                )
            }
            .padding(.horizontal, Spacing.md)
            .padding(.top, 60)
            .padding(.bottom, isCollapsed ? 10 : Spacing.md)
            .frame(maxWidth: .infinity)
            .background(Theme.surfaceElevated.overlay(Color.white.opacity(0.05)))
            .ignoresSafeArea(edges: .top)
            .shadow(
                color: isCollapsed ? Shadow.md.color : .clear,
                radius: isCollapsed ? Shadow.md.radius : 0,
                x: 0,
                y: isCollapsed ? Shadow.md.y : 0
            )

            // XP Progress bar - only when expanded
            if !isCollapsed {
                VStack(spacing: Spacing.xs) {
                    XPBarCompact(progress: appState.xpProgressInLevel)

                    HStack {
                        Text("\(appState.xpToNextLevel) XP to Level \(appState.currentLevel + 1)")
                            .font(Typography.captionSmall)
                            .foregroundColor(Theme.textSecondary)

                        Spacer()
                    }
                }
                .padding(.horizontal, Spacing.md)
                .padding(.bottom, Spacing.smd)
                .background(Theme.surfaceElevated.overlay(Color.white.opacity(0.05)))
                .opacity(1 - collapseProgress)
            }
        }
        .animation(Motion.ease(Motion.quick), value: isCollapsed)
    }

    private var gameModesSection: some View {
        VStack(alignment: .leading, spacing: Spacing.smd) {
            Text("PLAY")
                .font(Typography.headline)
                .foregroundColor(Theme.textPrimary)

            // Active game modes - side by side cards
            HStack(spacing: Spacing.smd) {
                PlayOptionCard(
                    imageName: "monkey_daily_puzzle",
                    title: "Daily Puzzle",
                    subtitle: appState.completedDailyToday ? "Completed" : "Ready to play",
                    isCompleted: appState.completedDailyToday,
                    imageOffset: 10
                ) {
                    navigationPath.append(NavigationDestination.dailyPuzzle)
                }

                PlayOptionCard(
                    imageName: "monkey_sprint",
                    title: "Sprint",
                    subtitle: "Speed challenge",
                    imageOffset: 20,
                    imageSize: 160
                ) {
                    showSprintFlow = true
                }
            }

            // Future modes (disabled)
            PlayOptionTile(
                imageName: "monkey_tournament",
                title: "Tournaments",
                subtitle: "Coming soon",
                isDisabled: true
            ) {}

            PlayOptionTile(
                imageName: "monkey_challenge",
                title: "Challenge a Friend",
                subtitle: "Coming soon",
                isDisabled: true
            ) {}
        }
    }

    private var gameHistorySection: some View {
        VStack(alignment: .leading, spacing: Spacing.smd) {
            Text("RECENT GAMES")
                .font(Typography.headline)
                .foregroundColor(Theme.textPrimary)

            if statsManager.sessionHistory.isEmpty {
                // Empty state
                VStack(spacing: Spacing.md) {
                    Image("monkey_no_games")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)

                    Text("No games yet")
                        .font(Typography.headline)
                        .foregroundColor(Theme.textPrimary)

                    Text("Choose a game mode above to start!")
                        .font(Typography.caption)
                        .foregroundColor(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.xl)
                .cardStyle()
            } else {
                // Game history cards
                LazyVStack(spacing: Spacing.smd) {
                    ForEach(statsManager.recentSessions) { session in
                        GameHistoryCard(session: session)
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
