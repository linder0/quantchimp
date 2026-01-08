//
//  DailyPuzzleView.swift
//  quantchimp
//
//  Created by Linda Xue on 1/8/26.
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
            VStack(spacing: 24) {
                // Problem card
                problemCard

                // Answer choices
                answerChoices

                Spacer(minLength: 40)
            }
            .padding()
        }
        .background(Color(.systemGray6))
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
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "brain.head.profile")
                    .font(.title2)
                    .foregroundColor(.purple)

                Text("Today's Challenge")
                    .font(.headline)
                    .foregroundColor(.purple)
            }

            Text(todaysPuzzle.prompt)
                .font(.title3)
                .fontWeight(.medium)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .cardStyle(cornerRadius: 20, shadowRadius: 10)
    }

    private var answerChoices: some View {
        VStack(spacing: 12) {
            ForEach(0..<todaysPuzzle.choices.count, id: \.self) { index in
                AnswerButton(
                    text: todaysPuzzle.choices[index],
                    index: index,
                    selectedAnswer: $selectedAnswer,
                    hasSubmitted: hasSubmitted,
                    correctIndex: todaysPuzzle.correctIndex
                ) {
                    if !hasSubmitted {
                        // Haptic feedback
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()

                        withAnimation(.spring(response: 0.3)) {
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
        let feedback = UINotificationFeedbackGenerator()
        feedback.notificationOccurred(isCorrect ? .success : .error)

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
