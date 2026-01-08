//
//  DailyPuzzleView.swift
//  quantchimp
//
//  Daily puzzle view using Theme tokens
//

import SwiftUI

struct DailyPuzzleView: View {
    @EnvironmentObject var appState: AppState
    @Binding var navigationPath: NavigationPath

    @State private var selectedAnswer: Int? = nil
    @State private var hasSubmitted = false
    @State private var showResult = false

    private var todaysPuzzle: DailyProblem {
        DailyPuzzleBank.getTodaysPuzzle()
    }

    private var isCorrect: Bool {
        selectedAnswer == todaysPuzzle.correctIndex
    }

    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.lg) {
                // Problem card
                problemCard

                // Answer choices
                answerChoices

                Spacer(minLength: 40)
            }
            .padding(Spacing.md)
        }
        .scrollIndicators(.hidden)
        .background(Theme.background)
        .navigationTitle("Daily Puzzle")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showResult) {
            DailyResultView(
                problem: todaysPuzzle,
                isCorrect: isCorrect,
                navigationPath: $navigationPath
            )
        }
    }

    private var problemCard: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack {
                Image(systemName: "brain.head.profile")
                    .font(.title2)
                    .foregroundColor(Theme.daily)

                Text("Today's Challenge")
                    .font(Typography.headline)
                    .foregroundColor(Theme.daily)
            }

            Text(todaysPuzzle.prompt)
                .font(Typography.heading3)
                .foregroundColor(Theme.textPrimary)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.lg)
        .cardElevated(cornerRadius: Radius.xlg)
    }

    private var answerChoices: some View {
        VStack(spacing: Spacing.smd) {
            ForEach(0..<todaysPuzzle.choices.count, id: \.self) { index in
                AnswerButton(
                    text: todaysPuzzle.choices[index],
                    index: index,
                    selectedAnswer: $selectedAnswer,
                    hasSubmitted: hasSubmitted,
                    correctIndex: todaysPuzzle.correctIndex
                ) {
                    if !hasSubmitted {
                        Haptic.light()

                        withAnimation(Motion.spring) {
                            selectedAnswer = index
                        }

                        // Auto-submit after selection with a brief delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            submitAnswer()
                        }
                    }
                }
            }
        }
    }

    private func submitAnswer() {
        guard selectedAnswer != nil, !hasSubmitted else { return }

        withAnimation {
            hasSubmitted = true
        }

        // Haptic feedback for result
        if isCorrect {
            Haptic.success()
        } else {
            Haptic.error()
        }

        // Navigate to result after feedback
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            showResult = true
        }
    }
}

#Preview {
    NavigationStack {
        DailyPuzzleView(navigationPath: .constant(NavigationPath()))
            .environmentObject(AppState())
    }
}
