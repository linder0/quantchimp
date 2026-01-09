//
//  ArithmeticSprintFlowView.swift
//  quantchimp
//
//  Full-screen modal flow for Arithmetic Sprint (Setup -> Play -> Results)
//

import SwiftUI

struct ArithmeticSprintFlowView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var statsManager: StatsManager

    @State private var phase: SprintPhase = .setup
    @State private var selectedDifficulty: Difficulty = .medium
    @State private var selectedDuration: Duration = .blitz
    @State private var selectedOperations: Set<ArithmeticQuestion.Operation> = Set(ArithmeticQuestion.Operation.allCases)

    // Results data
    @State private var correctCount = 0
    @State private var totalAttempts = 0

    enum SprintPhase {
        case setup
        case playing
        case results
    }

    var body: some View {
        ZStack {
            Theme.background
                .ignoresSafeArea()

            switch phase {
            case .setup:
                setupPhase
                    .transition(.opacity)

            case .playing:
                SprintGameView(
                    difficulty: selectedDifficulty,
                    duration: selectedDuration,
                    operations: selectedOperations,
                    onComplete: { correct, total in
                        correctCount = correct
                        totalAttempts = total
                        withAnimation(Motion.spring) {
                            phase = .results
                        }
                    },
                    onExit: {
                        dismiss()
                    }
                )
                .transition(.opacity)

            case .results:
                SprintResultView(
                    correctCount: correctCount,
                    totalAttempts: totalAttempts,
                    difficulty: selectedDifficulty,
                    duration: selectedDuration,
                    onDismiss: {
                        dismiss()
                    },
                    onPlayAgain: {
                        // Reset and go back to setup
                        correctCount = 0
                        totalAttempts = 0
                        withAnimation(Motion.spring) {
                            phase = .setup
                        }
                    }
                )
                .transition(.opacity)
            }
        }
    }

    // MARK: - Setup Phase

    private var setupPhase: some View {
        VStack(spacing: Spacing.smd) {
            // Header with close button
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Theme.textSecondary)
                        .frame(width: 36, height: 36)
                        .background(Theme.surfaceElevated)
                        .clipShape(Circle())
                }

                Spacer()

                // Header icon and title
                HStack(spacing: Spacing.sm) {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 18))
                        .foregroundColor(Theme.sprint)
                    Text("Arithmetic Sprint")
                        .font(Typography.headline)
                        .foregroundColor(Theme.textPrimary)
                }

                Spacer()

                Color.clear.frame(width: 36, height: 36)
            }
            .padding(.horizontal, Spacing.md)
            .padding(.top, Spacing.md)

            // Difficulty selector
            difficultySection
                .padding(.horizontal, Spacing.md)

            // Difficulty info card
            difficultyInfoCard
                .padding(.horizontal, Spacing.md)

            // Duration selector
            durationSection
                .padding(.horizontal, Spacing.md)

            // Operations selector
            operationsSection
                .padding(.horizontal, Spacing.md)

            Spacer()

            // Start button
            PrimaryButton(
                title: "Start Sprint",
                color: Theme.sprint,
                isEnabled: !selectedOperations.isEmpty
            ) {
                withAnimation(Motion.spring) {
                    phase = .playing
                }
            }
            .padding(.horizontal, Spacing.md)
            .padding(.bottom, Spacing.lg)
        }
    }

    // MARK: - Difficulty Section

    private var difficultySection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Difficulty")
                .font(Typography.label)
                .foregroundColor(Theme.textSecondary)

            HStack(spacing: Spacing.sm) {
                ForEach(Difficulty.allCases, id: \.self) { difficulty in
                    Button {
                        Haptic.selection()
                        Sound.select()
                        withAnimation(Motion.snappy) {
                            selectedDifficulty = difficulty
                        }
                    } label: {
                        Text(difficulty.rawValue)
                            .font(Typography.label)
                            .foregroundColor(selectedDifficulty == difficulty ? Theme.background : difficulty.color)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(
                                RoundedRectangle(cornerRadius: Radius.md)
                                    .fill(selectedDifficulty == difficulty ? difficulty.color : Theme.surface)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - Difficulty Info Card

    private var difficultyInfoCard: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            infoRow(label: "Addition", value: selectedDifficulty.additionDescription)
            infoRow(label: "Subtraction", value: selectedDifficulty.subtractionDescription)
            infoRow(label: "Multiplication", value: selectedDifficulty.multiplicationDescription)
            infoRow(label: "Division", value: selectedDifficulty.divisionDescription)
        }
        .padding(Spacing.smd)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: Radius.md)
                .fill(Theme.surface)
        )
    }

    private func infoRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(Typography.caption)
                .foregroundColor(Theme.textPrimary)

            Spacer()

            Text(value)
                .font(Typography.caption)
                .foregroundColor(Theme.textSecondary)
        }
    }

    // MARK: - Duration Section

    private var durationSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Duration")
                .font(Typography.label)
                .foregroundColor(Theme.textSecondary)

            HStack(spacing: Spacing.sm) {
                ForEach(Duration.allCases, id: \.self) { duration in
                    Button {
                        Haptic.selection()
                        Sound.select()
                        withAnimation(Motion.snappy) {
                            selectedDuration = duration
                        }
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: duration.icon)
                                .font(.system(size: 18))

                            Text(duration.displayTime)
                                .font(Typography.caption)
                        }
                        .foregroundColor(selectedDuration == duration ? .white : Theme.textPrimary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(
                            RoundedRectangle(cornerRadius: Radius.md)
                                .fill(selectedDuration == duration ? Theme.sprint : Theme.surface)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - Operations Section

    private var operationsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Operations")
                .font(Typography.label)
                .foregroundColor(Theme.textSecondary)

            HStack(spacing: Spacing.sm) {
                ForEach(ArithmeticQuestion.Operation.allCases, id: \.self) { operation in
                    Button {
                        Haptic.selection()
                        Sound.select()
                        withAnimation(Motion.snappy) {
                            toggleOperation(operation)
                        }
                    } label: {
                        Text(operation.rawValue)
                            .font(.system(size: 28, weight: .medium))
                            .foregroundColor(selectedOperations.contains(operation) ? .white : Theme.textTertiary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: Radius.md)
                                    .fill(selectedOperations.contains(operation) ? Theme.sprint : Theme.surface)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func toggleOperation(_ operation: ArithmeticQuestion.Operation) {
        if selectedOperations.contains(operation) {
            if selectedOperations.count > 1 {
                selectedOperations.remove(operation)
            }
        } else {
            selectedOperations.insert(operation)
        }
    }
}

// MARK: - Sprint Game View (Playing Phase)

struct SprintGameView: View {
    @EnvironmentObject var appState: AppState

    let difficulty: Difficulty
    let duration: Duration
    let operations: Set<ArithmeticQuestion.Operation>
    let onComplete: (Int, Int) -> Void
    let onExit: () -> Void

    @State private var timeRemaining: Int
    @State private var currentQuestion: ArithmeticQuestion
    @State private var userAnswer = ""
    @State private var correctCount = 0
    @State private var totalAttempts = 0
    @State private var showFeedback: FeedbackType? = nil
    @State private var showExitConfirmation = false
    @State private var timerTask: Task<Void, Never>?

    @FocusState private var isInputFocused: Bool

    enum FeedbackType {
        case correct, incorrect
    }

    init(
        difficulty: Difficulty,
        duration: Duration,
        operations: Set<ArithmeticQuestion.Operation>,
        onComplete: @escaping (Int, Int) -> Void,
        onExit: @escaping () -> Void
    ) {
        self.difficulty = difficulty
        self.duration = duration
        self.operations = operations
        self.onComplete = onComplete
        self.onExit = onExit
        self._timeRemaining = State(initialValue: duration.seconds)
        self._currentQuestion = State(initialValue: ArithmeticQuestion.generate(difficulty: difficulty, operations: operations))
    }

    var body: some View {
        VStack(spacing: 0) {
            // Top bar
            HStack {
                Button {
                    showExitConfirmation = true
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Theme.textSecondary)
                        .frame(width: 40, height: 40)
                        .background(Theme.surfaceElevated)
                        .clipShape(Circle())
                }

                Spacer()

                timerView

                Spacer()

                scoreView
            }
            .padding(.horizontal, Spacing.md)
            .padding(.top, Spacing.lg)

            Spacer()

            // Question
            VStack(spacing: Spacing.md) {
                Text(currentQuestion.displayText)
                    .font(Typography.displayLarge)
                    .foregroundColor(Theme.textPrimary)

                Text("= ?")
                    .font(Typography.heading1)
                    .foregroundColor(Theme.textSecondary)
            }

            // Feedback
            if let feedback = showFeedback {
                HStack {
                    Image(systemName: feedback == .correct ? "checkmark.circle.fill" : "xmark.circle.fill")
                    Text(feedback == .correct ? "Correct!" : "Try again!")
                }
                .font(Typography.headline)
                .foregroundColor(feedback == .correct ? Theme.success : Theme.error)
                .padding(Spacing.md)
                .background(feedback == .correct ? Theme.success.opacity(0.15) : Theme.error.opacity(0.15))
                .cornerRadius(Radius.md)
                .padding(.top, Spacing.md)
                .transition(.scale.combined(with: .opacity))
            }

            Spacer()

            // Input
            VStack(spacing: Spacing.md) {
                TextField("", text: $userAnswer)
                    .font(Typography.displaySmall)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numbersAndPunctuation)
                    .focused($isInputFocused)
                    .padding(Spacing.lg)
                    .background(Theme.surface)
                    .cornerRadius(Radius.lg)
                    .overlay(
                        RoundedRectangle(cornerRadius: Radius.lg)
                            .stroke(Theme.sprint.opacity(0.5), lineWidth: 2)
                    )
                    .foregroundColor(Theme.textPrimary)
                    .onSubmit {
                        submitAnswer()
                    }

                PrimaryButton(title: "Submit", color: Theme.sprint) {
                    submitAnswer()
                }
            }
            .padding(.horizontal, Spacing.md)
            .padding(.bottom, Spacing.xl)
        }
        .alert("Exit Sprint?", isPresented: $showExitConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Exit", role: .destructive) {
                timerTask?.cancel()
                onExit()
            }
        } message: {
            Text("Your progress will be lost.")
        }
        .onAppear {
            startTimer()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isInputFocused = true
            }
        }
        .onDisappear {
            timerTask?.cancel()
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

    private func startTimer() {
        // Play start sound
        Sound.start()

        timerTask = Task {
            while !Task.isCancelled && timeRemaining > 0 {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                if !Task.isCancelled {
                    await MainActor.run {
                        timeRemaining -= 1

                        // Countdown sounds and haptics for last 10 seconds
                        if timeRemaining <= 10 && timeRemaining > 0 {
                            Sound.tick()
                            if timeRemaining == 10 {
                                Haptic.warning()
                            }
                        }

                        if timeRemaining == 0 {
                            Haptic.success()
                            Sound.gameOver()
                            onComplete(correctCount, totalAttempts)
                        }
                    }
                }
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
            Sound.success()
        } else {
            Haptic.warning()
            Sound.error()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation {
                showFeedback = nil
            }
            userAnswer = ""
            currentQuestion = ArithmeticQuestion.generate(difficulty: difficulty, operations: operations)
        }
    }
}

#Preview {
    ArithmeticSprintFlowView()
        .environmentObject(AppState())
        .environmentObject(StatsManager())
}
