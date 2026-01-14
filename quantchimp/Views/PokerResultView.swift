//
//  PokerResultView.swift
//  quantchimp
//
//  Poker sprint result view - Full screen immersive modal
//

import SwiftUI

struct PokerResultView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var statsManager: StatsManager

    let correctCount: Int
    let totalAttempts: Int
    let difficulty: Difficulty
    let duration: Duration
    let onDismiss: () -> Void
    let onPlayAgain: () -> Void

    @State private var hasUpdatedXP = false
    @State private var showContent = false

    private var accuracy: Double {
        calculateAccuracy(correct: correctCount, total: totalAttempts)
    }

    private var xpEarned: Int {
        // Difficulty multiplier for poker
        let multiplier: Int
        switch difficulty {
        case .easy: multiplier = 5
        case .medium: multiplier = 8
        case .hard: multiplier = 12
        }
        return correctCount * multiplier
    }

    private var performance: PerformanceEvaluator.PerformanceResult {
        PerformanceEvaluator.evaluate(correctCount: correctCount)
    }

    var body: some View {
        ZStack {
            Theme.background
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: Spacing.lg) {
                    // Close button
                    HStack {
                        Spacer()
                        Button {
                            onDismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Theme.textSecondary)
                                .frame(width: 40, height: 40)
                                .background(Theme.surfaceElevated)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.top, Spacing.lg)

                    // Result header
                    resultHeader

                    // Stats grid
                    statsGrid

                    // XP earned
                    xpCard

                    Spacer(minLength: 40)

                    // Action buttons
                    actionButtons
                }
                .padding(.horizontal, Spacing.md)
                .padding(.bottom, Spacing.xl)
            }
            .scrollIndicators(.hidden)
            .opacity(showContent ? 1 : 0)
            .scaleEffect(showContent ? 1 : 0.9)
        }
        .onAppear {
            updateXPIfNeeded()
            withAnimation(Motion.spring.delay(0.1)) {
                showContent = true
            }
        }
    }

    private var resultHeader: some View {
        VStack(spacing: Spacing.md) {
            Image(performance.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)

            Text("Poker Sprint Complete!")
                .font(Typography.displaySmall)
                .foregroundColor(Theme.textPrimary)

            Text(performance.message)
                .font(Typography.heading3)
                .foregroundColor(Theme.textSecondary)

            // Duration info
            Text("\(duration.displayTime) • \(difficulty.rawValue)")
                .font(Typography.caption)
                .foregroundColor(Theme.textTertiary)
        }
        .padding(.top, Spacing.md)
    }

    private var statsGrid: some View {
        HStack(spacing: Spacing.smd) {
            StatCardLarge(
                icon: "checkmark.circle.fill",
                value: "\(correctCount)",
                label: "Correct",
                color: Theme.success
            )

            StatCardLarge(
                icon: "percent",
                value: formatAccuracy(accuracy),
                label: "Accuracy",
                color: Theme.accent
            )

            StatCardLarge(
                icon: "number",
                value: "\(totalAttempts)",
                label: "Attempts",
                color: Theme.level
            )
        }
    }

    private var xpCard: some View {
        XPEarnedBadge(xpEarned: xpEarned, style: .large)
            .frame(maxWidth: .infinity)
    }

    private var actionButtons: some View {
        VStack(spacing: Spacing.smd) {
            PrimaryButton(title: "Play Again", color: Theme.accent) {
                onPlayAgain()
            }

            SecondaryButton(title: "Back Home") {
                onDismiss()
            }
        }
    }

    private func updateXPIfNeeded() {
        guard !hasUpdatedXP else { return }
        hasUpdatedXP = true
        appState.xp += xpEarned

        // Play celebration sound for good performance
        if PerformanceEvaluator.shouldCelebrate(correctCount: correctCount) {
            Sound.celebration()
        }

        // Record session to stats (use sprint mode for now, could add poker mode later)
        let session = SessionRecord(
            mode: .sprint,
            questionsAnswered: totalAttempts,
            correctCount: correctCount,
            xpEarned: xpEarned
        )
        statsManager.recordSession(session)
    }
}

#Preview {
    PokerResultView(
        correctCount: 12,
        totalAttempts: 15,
        difficulty: .medium,
        duration: .bullet,
        onDismiss: {},
        onPlayAgain: {}
    )
    .environmentObject(AppState())
    .environmentObject(StatsManager())
}
