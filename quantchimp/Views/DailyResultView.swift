//
//  DailyResultView.swift
//  quantchimp
//
//  Daily result view for open-ended quant questions
//

import SwiftUI

struct DailyResultView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var statsManager: StatsManager
    let problem: DailyProblem
    let isCorrect: Bool
    let userAnswer: String
    @Binding var navigationPath: NavigationPath

    @State private var hasUpdatedStats = false

    private var xpEarned: Int {
        isCorrect && !appState.completedDailyToday ? 50 : 0
    }

    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.lg) {
                // Result header
                resultHeader

                // XP earned
                if xpEarned > 0 {
                    xpBadge
                }

                // Your answer vs correct answer
                answersComparison

                // Explanation card
                explanationCard

                Spacer(minLength: 40)

                // Done button
                PrimaryButton(title: "Done", color: isCorrect ? Theme.success : Theme.accent) {
                    navigationPath = NavigationPath()
                }
                .padding(.bottom, Spacing.lg)
            }
            .padding(Spacing.md)
        }
        .scrollIndicators(.hidden)
        .background(Theme.background)
        .navigationTitle("Result")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            updateStatsIfNeeded()
        }
    }

    private var resultHeader: some View {
        VStack(spacing: Spacing.md) {
            ZStack {
                Circle()
                    .fill(isCorrect ? Theme.success.opacity(0.15) : Theme.error.opacity(0.15))
                    .frame(width: 100, height: 100)

                Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(isCorrect ? Theme.success : Theme.error)
            }

            Text(isCorrect ? "Correct!" : "Incorrect")
                .font(Typography.heading1)
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
        .padding(.top, Spacing.lg)
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
            .background(isCorrect ? Theme.success.opacity(0.1) : Theme.error.opacity(0.1))
            .cornerRadius(Radius.lg)

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
                .background(Theme.success.opacity(0.1))
                .cornerRadius(Radius.lg)
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
        .cardStyle()
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
    NavigationStack {
        DailyResultView(
            problem: DailyPuzzleBank.puzzles[0],
            isCorrect: true,
            userAnswer: "21/32",
            navigationPath: .constant(NavigationPath())
        )
        .environmentObject(AppState())
        .environmentObject(StatsManager())
    }
}
