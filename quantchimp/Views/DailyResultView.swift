//
//  DailyResultView.swift
//  quantchimp
//
//  Daily result view using Theme tokens
//

import SwiftUI

struct DailyResultView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var statsManager: StatsManager
    let problem: DailyProblem
    let isCorrect: Bool
    @Binding var navigationPath: NavigationPath

    @State private var hasUpdatedStats = false
    @State private var showXPAnimation = false

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

                // Explanation card
                explanationCard

                // Correct answer
                correctAnswerCard

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
        HStack(spacing: Spacing.sm) {
            Image(systemName: "star.fill")
                .foregroundColor(Theme.xp)

            Text("+\(xpEarned) XP")
                .font(Typography.headline)
                .foregroundColor(Theme.textPrimary)
        }
        .padding(.horizontal, Spacing.lg)
        .padding(.vertical, Spacing.smd)
        .background(Theme.xp.opacity(0.2))
        .cornerRadius(Radius.full)
        .scaleEffect(showXPAnimation ? 1.1 : 1.0)
        .animation(Motion.bounce, value: showXPAnimation)
        .onAppear {
            withAnimation(Motion.ease(Motion.normal).delay(0.2)) {
                showXPAnimation = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    showXPAnimation = false
                }
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

    private var correctAnswerCard: some View {
        VStack(alignment: .leading, spacing: Spacing.smd) {
            Text("Correct Answer")
                .font(Typography.headline)
                .foregroundColor(Theme.success)

            Text(problem.choices[problem.correctIndex])
                .font(Typography.heading3)
                .foregroundColor(Theme.textPrimary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.lg)
        .background(Theme.success.opacity(0.1))
        .overlay(
            RoundedRectangle(cornerRadius: Radius.lg)
                .stroke(Theme.success.opacity(0.3), lineWidth: 2)
        )
        .cornerRadius(Radius.lg)
    }

    private func updateStatsIfNeeded() {
        guard !hasUpdatedStats else { return }
        hasUpdatedStats = true

        if isCorrect {
            appState.updateStreakAndXPForDaily()
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
            navigationPath: .constant(NavigationPath())
        )
        .environmentObject(AppState())
        .environmentObject(StatsManager())
    }
}
