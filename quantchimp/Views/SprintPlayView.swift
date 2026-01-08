//
//  SprintPlayView.swift
//  quantchimp
//
//  Created by Linda Xue on 1/8/26.
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
        VStack(spacing: 24) {
            // Timer and score
            HStack {
                timerView
                Spacer()
                scoreView
            }
            .padding(.horizontal)

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
        .padding()
        .background(Color(.systemGray6))
        .navigationTitle("Sprint")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    showExitConfirmation = true
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "xmark.circle.fill")
                        Text("Exit")
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
            }
        }
        .alert("Exit Sprint?", isPresented: $showExitConfirmation) {
            Button("Cancel", role: .cancel) {
                // Resume - do nothing
            }
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
        HStack(spacing: 8) {
            Image(systemName: "timer")
                .foregroundColor(timeRemaining <= 10 ? .red : .blue)

            Text("\(timeRemaining)s")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(timeRemaining <= 10 ? .red : .primary)
                .monospacedDigit()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(timeRemaining <= 10 ? Color.red.opacity(0.1) : Color.blue.opacity(0.1))
        .cornerRadius(12)
    }

    private var scoreView: some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)

            Text("\(correctCount)")
                .font(.title2)
                .fontWeight(.bold)
                .monospacedDigit()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.green.opacity(0.1))
        .cornerRadius(12)
    }

    private var questionView: some View {
        VStack(spacing: 16) {
            Text(currentQuestion.displayText)
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundColor(.primary)

            Text("= ?")
                .font(.title)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(40)
        .cardStyle(cornerRadius: 24, shadowRadius: 10)
    }

    private func feedbackView(_ feedback: FeedbackType) -> some View {
        HStack {
            Image(systemName: feedback == .correct ? "checkmark.circle.fill" : "xmark.circle.fill")
            Text(feedback == .correct ? "Correct!" : "Try again!")
        }
        .font(.headline)
        .foregroundColor(feedback == .correct ? .green : .red)
        .padding()
        .background(feedback == .correct ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
        .cornerRadius(12)
        .transition(.scale.combined(with: .opacity))
    }

    private var inputView: some View {
        VStack(spacing: 16) {
            TextField("Your answer", text: $userAnswer)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .focused($isInputFocused)
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.blue.opacity(0.3), lineWidth: 2)
                )

            PrimaryButton(title: "Submit", color: .blue) {
                submitAnswer()
            }
        }
        .padding(.bottom, 20)
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

        withAnimation(.spring(response: 0.3)) {
            showFeedback = isCorrect ? .correct : .incorrect
        }

        if isCorrect {
            correctCount += 1
            let feedback = UINotificationFeedbackGenerator()
            feedback.notificationOccurred(.success)
        } else {
            let feedback = UINotificationFeedbackGenerator()
            feedback.notificationOccurred(.warning)
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
