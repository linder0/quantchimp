//
//  HomeView.swift
//  quantchimp
//
//  Home screen using Theme tokens
//

import SwiftUI
import Combine

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var statsManager: StatsManager
    @Binding var navigationPath: NavigationPath
    @State private var scrollOffset: CGFloat = 0
    @State private var initialScrollOffset: CGFloat = 0
    @State private var showSprintFlow = false
    @State private var showDailyPuzzle = false
    @State private var showPokerSprint = false
    @State private var countdownText: String = ""

    // Timer to update countdown every second
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

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
                        .frame(height: 220) // Reduced from 250 for tighter spacing
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
                    .padding(.top, Spacing.xs)
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
        .fullScreenCover(isPresented: $showPokerSprint) {
            PokerSprintFlowView()
        }
        .onAppear {
            updateCountdown()
        }
        .onReceive(timer) { _ in
            updateCountdown()
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
                .fixedSize()
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
                .fixedSize()
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
            SectionHeader(title: "Classic")

            // Daily and Sprint modes - side by side cards
            HStack(spacing: Spacing.smd) {
                ForEach([GameMode.daily, GameMode.sprint], id: \.self) { mode in
                    PlayOptionCard(
                        imageName: mode.imageName,
                        title: mode.rawValue,
                        subtitle: mode.subtitle(for: appState),
                        isCompleted: mode.isCompleted(for: appState),
                        isDisabled: mode == .daily && appState.completedDailyToday,
                        countdownText: mode == .daily && appState.completedDailyToday ? countdownText : nil,
                        imageOffset: mode.imageOffset,
                        imageSize: mode.imageSize
                    ) {
                        handleGameModeSelection(mode)
                    }
                }
            }

            // Poker section
            SectionHeader(title: "Poker")
                .padding(.top, Spacing.md)

            HStack(spacing: Spacing.smd) {
                PlayOptionCard(
                    imageName: GameMode.poker.imageName,
                    title: GameMode.poker.rawValue,
                    subtitle: GameMode.poker.subtitle(for: appState),
                    isCompleted: false,
                    imageOffset: GameMode.poker.imageOffset,
                    imageSize: GameMode.poker.imageSize
                ) {
                    handleGameModeSelection(.poker)
                }

                // Empty spacer to match the 2-column layout
                Color.clear
                    .frame(maxWidth: .infinity)
            }
        }
    }

    private func handleGameModeSelection(_ mode: GameMode) {
        switch mode {
        case .daily:
            if !appState.completedDailyToday {
                showDailyPuzzle = true
            }
        case .sprint:
            showSprintFlow = true
        case .poker:
            showPokerSprint = true
        case .tournament, .challenge:
            break // Disabled modes
        }
    }

    private func updateCountdown() {
        let timeRemaining = DateHelpers.timeUntilMidnight()
        countdownText = DateHelpers.formatCountdown(timeRemaining)
    }

    private var featuredQuestCard: some View {
        let quest = QuestManager.closestIncompleteQuest(appState: appState, statsManager: statsManager)
        let progress = quest.currentProgress(appState: appState, statsManager: statsManager)

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
                .fixedSize()
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
                                width: geometry.size.width * CGFloat(min(progress, quest.totalRequired)) / CGFloat(quest.totalRequired),
                                height: 6
                            )
                    }
                }
                .frame(height: 6)

                Text("\(progress)/\(quest.totalRequired)")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                    .fixedSize()
            }
        }
        .padding(.horizontal, Spacing.md)
    }

}

#Preview {
    NavigationStack {
        HomeView(navigationPath: .constant(NavigationPath()))
            .environmentObject(AppState())
            .environmentObject(StatsManager())
    }
}
