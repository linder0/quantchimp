//
//  DailyResultView.swift
//  quantchimp
//
//  Created by Linda Xue on 1/8/26.
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
            VStack(spacing: 24) {
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
                PrimaryButton(title: "Done", color: isCorrect ? .green : .orange) {
                    // Go back to home
                    navigationPath = NavigationPath()
                }
                .padding(.bottom, 20)
            }
            .padding()
        }
        .background(Color(.systemGray6))
        .navigationTitle("Result")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            updateStatsIfNeeded()
        }
    }

    private var resultHeader: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(isCorrect ? Color.green.opacity(0.15) : Color.red.opacity(0.15))
                    .frame(width: 100, height: 100)

                Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(isCorrect ? .green : .red)
            }

            Text(isCorrect ? "Correct!" : "Incorrect")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(isCorrect ? .green : .red)

            if isCorrect && appState.streak > 0 {
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                    Text("\(appState.streak) day streak!")
                        .fontWeight(.medium)
                        .foregroundColor(.orange)
                }
            }
        }
        .padding(.top, 20)
    }

    private var xpBadge: some View {
        HStack(spacing: 8) {
            Image(systemName: "star.fill")
                .foregroundColor(.yellow)

            Text("+\(xpEarned) XP")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color.yellow.opacity(0.2))
        .cornerRadius(20)
        .scaleEffect(showXPAnimation ? 1.1 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: showXPAnimation)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.3).delay(0.2)) {
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
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.yellow)
                Text("Explanation")
                    .font(.headline)
            }

            Text(problem.explanation)
                .font(.body)
                .foregroundColor(.secondary)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .cardStyle()
    }

    private var correctAnswerCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Correct Answer")
                .font(.headline)
                .foregroundColor(.green)

            Text(problem.choices[problem.correctIndex])
                .font(.title3)
                .fontWeight(.medium)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(Color.green.opacity(0.1))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.green.opacity(0.3), lineWidth: 2)
        )
        .cornerRadius(16)
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
