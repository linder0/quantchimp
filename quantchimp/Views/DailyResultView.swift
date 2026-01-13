//
//  DailyResultView.swift
//  quantchimp
//
//  Daily result view - immersive full-screen experience
//

import SwiftUI

struct DailyResultView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var statsManager: StatsManager
    @Environment(\.dismiss) private var dismiss

    let problem: DailyProblem
    let isCorrect: Bool
    let userAnswer: String

    @State private var hasUpdatedStats = false

    private var xpEarned: Int {
        isCorrect && !appState.completedDailyToday ? 50 : 0
    }

    var body: some View {
        ZStack {
            Theme.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    Spacer()

                    Text("Result")
                        .font(Typography.headline)
                        .foregroundColor(Theme.textPrimary)

                    Spacer()
                }
                .padding(.horizontal, Spacing.md)
                .padding(.top, Spacing.lg)

                Spacer()

                // Result content
                VStack(spacing: Spacing.lg) {
                    // Result header
                    resultHeader

                    // XP earned
                    if xpEarned > 0 {
                        xpBadge
                    }

                    // Your answer vs correct answer
                    answersComparison
                        .padding(.horizontal, Spacing.md)

                    // Explanation card
                    explanationCard
                        .padding(.horizontal, Spacing.md)
                }

                Spacer()

                // Done button
                PrimaryButton(title: "Done", color: isCorrect ? Theme.success : Theme.accent) {
                    // Dismiss both the result view and the puzzle view
                    dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        dismiss()
                    }
                }
                .padding(.horizontal, Spacing.md)
                .padding(.bottom, Spacing.lg)
            }
        }
        .onAppear {
            updateStatsIfNeeded()
        }
    }

    private var resultHeader: some View {
        VStack(spacing: Spacing.md) {
            // Monkey based on result
            Image(isCorrect ? "monkey_excellent" : "monkey_practice")
                .resizable()
                .scaledToFit()
                .frame(height: 120)

            Text(isCorrect ? "Correct!" : "Incorrect")
                .font(Typography.displaySmall)
                .foregroundColor(isCorrect ? Theme.success : Theme.error)

            if isCorrect && appState.streak > 0 {
                HStack(spacing: Spacing.xs) {
                    Image(systemName: "flame.fill")
                        .foregroundColor(Theme.streak)
                    Text("\(appState.streak) day streak!")
                        .font(Typography.bodyBold)
                        .foregroundColor(Theme.streak)
                }
            }
        }
    }

    private var xpBadge: some View {
        XPEarnedBadge(xpEarned: xpEarned, style: .compact)
    }

    private var answersComparison: some View {
        VStack(spacing: Spacing.smd) {
            // Your answer
            HStack {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("Your Answer")
                        .font(Typography.caption)
                        .foregroundColor(Theme.textSecondary)

                    Text(userAnswer)
                        .font(Typography.heading3)
                        .foregroundColor(isCorrect ? Theme.success : Theme.error)
                }

                Spacer()

                Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(isCorrect ? Theme.success : Theme.error)
            }
            .padding(Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: Radius.lg)
                    .fill(isCorrect ? Theme.success.opacity(0.1) : Theme.error.opacity(0.1))
            )

            // Correct answer (show if incorrect)
            if !isCorrect {
                HStack {
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        Text("Correct Answer")
                            .font(Typography.caption)
                            .foregroundColor(Theme.textSecondary)

                        Text(problem.answer)
                            .font(Typography.heading3)
                            .foregroundColor(Theme.success)
                    }

                    Spacer()

                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(Theme.success)
                }
                .padding(Spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: Radius.lg)
                        .fill(Theme.success.opacity(0.1))
                )
            }
        }
    }

    private var explanationCard: some View {
        VStack(alignment: .leading, spacing: Spacing.smd) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(Theme.xp)
                Text("Explanation")
                    .font(Typography.headline)
                    .foregroundColor(Theme.textPrimary)
            }

            Text(problem.explanation)
                .font(Typography.body)
                .foregroundColor(Theme.textSecondary)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: Radius.xlg)
                .fill(Theme.surface)
        )
    }

    private func updateStatsIfNeeded() {
        guard !hasUpdatedStats else { return }
        hasUpdatedStats = true

        if isCorrect {
            appState.updateStreakAndXPForDaily()
            Sound.celebration()
        }

        // Record session to stats
        let session = SessionRecord(
            mode: .daily,
            questionsAnswered: 1,
            correctCount: isCorrect ? 1 : 0,
            xpEarned: xpEarned
        )
        statsManager.recordSession(session)
    }
}

#Preview {
    DailyResultView(
        problem: DailyPuzzleBank.puzzles[0],
        isCorrect: true,
        userAnswer: "21/32"
    )
    .environmentObject(AppState())
    .environmentObject(StatsManager())
}
