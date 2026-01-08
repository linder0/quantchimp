//
//  SprintPlayView.swift
//  quantchimp
//
//  Sprint game play view using Theme tokens
//

import SwiftUI
import Combine

struct SprintPlayView: View {
    @EnvironmentObject var appState: AppState
    let difficulty: Difficulty
    @Binding var navigationPath: NavigationPath

    @State private var timeRemaining = 60
    @State private var currentQuestion: ArithmeticQuestion
    @State private var userAnswer = ""
    @State private var correctCount = 0
    @State private var totalAttempts = 0
    @State private var showFeedback: FeedbackType? = nil
    @State private var showResults = false
    @State private var showExitConfirmation = false
    @State private var timerCancellable: AnyCancellable?

    @FocusState private var isInputFocused: Bool

    enum FeedbackType {
        case correct, incorrect
    }

    init(difficulty: Difficulty, navigationPath: Binding<NavigationPath>) {
        self.difficulty = difficulty
        self._navigationPath = navigationPath
        self._currentQuestion = State(initialValue: ArithmeticQuestion.generate(difficulty: difficulty))
    }

    var body: some View {
        VStack(spacing: Spacing.lg) {
            // Timer and score
            HStack {
                timerView
                Spacer()
                scoreView
            }
            .padding(.horizontal, Spacing.md)

            Spacer()

            // Question display
            questionView

            // Feedback overlay
            if let feedback = showFeedback {
                feedbackView(feedback)
            }

            Spacer()

            // Answer input
            inputView
        }
        .padding(Spacing.md)
        .background(Theme.background)
        .navigationTitle("Sprint")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    showExitConfirmation = true
                } label: {
                    HStack(spacing: Spacing.xs) {
                        Image(systemName: "xmark.circle.fill")
                        Text("Exit")
                    }
                    .font(Typography.caption)
                    .foregroundColor(Theme.textSecondary)
                }
            }
        }
        .alert("Exit Sprint?", isPresented: $showExitConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Exit", role: .destructive) {
                timerCancellable?.cancel()
                navigationPath = NavigationPath()
            }
        } message: {
            Text("Your progress will be lost. Are you sure you want to exit?")
        }
        .onAppear {
            startTimer()
            isInputFocused = true
        }
        .onDisappear {
            timerCancellable?.cancel()
        }
        .navigationDestination(isPresented: $showResults) {
            SprintResultView(
                correctCount: correctCount,
                totalAttempts: totalAttempts,
                difficulty: difficulty,
                navigationPath: $navigationPath
            )
        }
    }

    private var timerView: some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: "timer")
                .foregroundColor(timeRemaining <= 10 ? Theme.error : Theme.sprint)

            Text("\(timeRemaining)s")
                .font(Typography.heading3)
                .foregroundColor(timeRemaining <= 10 ? Theme.error : Theme.textPrimary)
                .monospacedDigit()
        }
        .padding(.horizontal, Spacing.md)
        .padding(.vertical, Spacing.sm)
        .background(timeRemaining <= 10 ? Theme.error.opacity(0.15) : Theme.sprint.opacity(0.15))
        .cornerRadius(Radius.md)
    }

    private var scoreView: some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(Theme.success)

            Text("\(correctCount)")
                .font(Typography.heading3)
                .foregroundColor(Theme.textPrimary)
                .monospacedDigit()
        }
        .padding(.horizontal, Spacing.md)
        .padding(.vertical, Spacing.sm)
        .background(Theme.success.opacity(0.15))
        .cornerRadius(Radius.md)
    }

    private var questionView: some View {
        VStack(spacing: Spacing.md) {
            Text(currentQuestion.displayText)
                .font(Typography.displayMedium)
                .foregroundColor(Theme.textPrimary)

            Text("= ?")
                .font(Typography.heading2)
                .foregroundColor(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(Spacing.xl)
        .cardElevated(cornerRadius: Radius.xl)
    }

    private func feedbackView(_ feedback: FeedbackType) -> some View {
        HStack {
            Image(systemName: feedback == .correct ? "checkmark.circle.fill" : "xmark.circle.fill")
            Text(feedback == .correct ? "Correct!" : "Try again!")
        }
        .font(Typography.headline)
        .foregroundColor(feedback == .correct ? Theme.success : Theme.error)
        .padding(Spacing.md)
        .background(feedback == .correct ? Theme.success.opacity(0.15) : Theme.error.opacity(0.15))
        .cornerRadius(Radius.md)
        .transition(.scale.combined(with: .opacity))
    }

    private var inputView: some View {
        VStack(spacing: Spacing.md) {
            TextField("Your answer", text: $userAnswer)
                .font(Typography.heading2)
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .focused($isInputFocused)
                .padding(Spacing.md)
                .background(Theme.surface)
                .cornerRadius(Radius.lg)
                .overlay(
                    RoundedRectangle(cornerRadius: Radius.lg)
                        .stroke(Theme.sprint.opacity(0.3), lineWidth: 2)
                )
                .foregroundColor(Theme.textPrimary)

            PrimaryButton(title: "Submit", color: Theme.sprint) {
                submitAnswer()
            }
        }
        .padding(.bottom, Spacing.lg)
    }

    private func startTimer() {
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    timerCancellable?.cancel()
                    showResults = true
                }
            }
    }

    private func submitAnswer() {
        guard let answer = Int(userAnswer.trimmingCharacters(in: .whitespaces)) else {
            return
        }

        totalAttempts += 1

        let isCorrect = answer == currentQuestion.correctAnswer

        withAnimation(Motion.spring) {
            showFeedback = isCorrect ? .correct : .incorrect
        }

        if isCorrect {
            correctCount += 1
            Haptic.success()
        } else {
            Haptic.warning()
        }

        // Clear and generate next question
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation {
                showFeedback = nil
            }
            userAnswer = ""
            currentQuestion = ArithmeticQuestion.generate(difficulty: difficulty)
        }
    }
}

#Preview {
    NavigationStack {
        SprintPlayView(difficulty: .easy, navigationPath: .constant(NavigationPath()))
            .environmentObject(AppState())
    }
}
