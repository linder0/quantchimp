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
    @State private var selectedOperations: Set<ArithmeticQuestion.Operation> = Set(ArithmeticQuestion.Operation.allCases)

    // Fixed duration: all sprints are 60 seconds
    private let sprintDuration: Duration = .bullet

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
                    duration: sprintDuration,
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
                    duration: sprintDuration,
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
        VStack(spacing: 0) {
            // Header with close button
            HStack {
                IconButton(icon: "xmark", backgroundColor: Theme.surfaceElevated, size: 36) {
                    dismiss()
                }

                Spacer()

                // Header title
                Text("Arithmetic Sprint")
                    .font(Typography.headline)
                    .foregroundColor(Theme.textPrimary)

                Spacer()

                Color.clear.frame(width: 36, height: 36)
            }
            .padding(.horizontal, Spacing.md)
            .padding(.top, Spacing.md)
            .padding(.bottom, Spacing.sm)

            // Difficulty carousel - takes flexible space
            DifficultyCarousel(selectedDifficulty: $selectedDifficulty, selectedOperations: selectedOperations)

            // Bottom controls - fixed height section
            VStack(spacing: Spacing.smd) {
                // Operations row (1x4)
                operationsRow

                // Start button - stylized
                startSprintButton
            }
            .padding(.horizontal, Spacing.md)
            .padding(.top, Spacing.smd)
            .padding(.bottom, Spacing.lg)
        }
    }

    // MARK: - Start Sprint Button

    private var startSprintButton: some View {
        Button {
            Haptic.medium()
            Sound.tap()
            withAnimation(Motion.spring) {
                phase = .playing
            }
        } label: {
            HStack(spacing: Spacing.sm) {
                Image(systemName: "play.fill")
                    .font(.system(size: 18, weight: .bold))

                Text("Start Sprint")
                    .font(Typography.headline)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.md + 2)
            .background(
                ZStack {
                    // Gradient background
                    RoundedRectangle(cornerRadius: Radius.lg)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Theme.sprint,
                                    Theme.sprint.opacity(0.8),
                                    Color(red: 0.2, green: 0.5, blue: 0.9)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                    // Inner highlight
                    RoundedRectangle(cornerRadius: Radius.lg)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.4),
                                    Color.white.opacity(0.1),
                                    Color.clear
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                }
            )
            .shadow(color: Theme.sprint.opacity(0.5), radius: 16, x: 0, y: 8)
            .shadow(color: Theme.sprint.opacity(0.3), radius: 4, x: 0, y: 2)
        }
        .disabled(selectedOperations.isEmpty)
        .opacity(selectedOperations.isEmpty ? 0.5 : 1.0)
        .pressable(scale: 0.97)
    }

    // MARK: - Operations Row (1x4)

    private var operationsRow: some View {
        HStack(spacing: Spacing.sm) {
            ForEach(ArithmeticQuestion.Operation.allCases, id: \.self) { operation in
                operationToggle(operation)
            }
        }
    }

    private func operationToggle(_ operation: ArithmeticQuestion.Operation) -> some View {
        let isSelected = selectedOperations.contains(operation)

        return Button {
            Haptic.selection()
            Sound.select()
            withAnimation(Motion.snappy) {
                toggleOperation(operation)
            }
        } label: {
            Image(operation.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .frame(height: 64)
                .background(
                    RoundedRectangle(cornerRadius: Radius.md)
                        .fill(Theme.surface)
                )
                .opacity(isSelected ? 1.0 : 0.35)
        }
        .buttonStyle(.plain)
    }

    private func toggleOperation(_ operation: ArithmeticQuestion.Operation) {
        if selectedOperations.contains(operation) {
            // Only remove if there's at least one other operation selected
            if selectedOperations.count > 1 {
                selectedOperations.remove(operation)
            }
        } else {
            selectedOperations.insert(operation)
        }
    }
}

// MARK: - Difficulty Carousel

struct DifficultyCarousel: View {
    @Binding var selectedDifficulty: Difficulty
    let selectedOperations: Set<ArithmeticQuestion.Operation>

    private var currentIndex: Int {
        Difficulty.allCases.firstIndex(of: selectedDifficulty) ?? 1
    }

    private var canGoBack: Bool {
        currentIndex > 0
    }

    private var canGoForward: Bool {
        currentIndex < Difficulty.allCases.count - 1
    }

    var body: some View {
        VStack(spacing: Spacing.smd) {
            // Swipeable card carousel
            TabView(selection: $selectedDifficulty) {
                ForEach(Difficulty.allCases, id: \.self) { difficulty in
                    DifficultyCard(difficulty: difficulty, selectedOperations: selectedOperations)
                        .tag(difficulty)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .onChange(of: selectedDifficulty) { _, _ in
                Haptic.selection()
                Sound.select()
            }

            // Navigation row with arrows and dots - BELOW the card
            HStack(spacing: Spacing.lg) {
                // Left arrow
                Button {
                    if canGoBack {
                        Haptic.selection()
                        Sound.select()
                        withAnimation(Motion.snappy) {
                            selectedDifficulty = Difficulty.allCases[currentIndex - 1]
                        }
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(canGoBack ? Theme.textPrimary : Theme.textTertiary.opacity(0.3))
                        .frame(width: 36, height: 36)
                        .background(Theme.surfaceElevated)
                        .clipShape(Circle())
                }
                .disabled(!canGoBack)

                // Page dots
                HStack(spacing: Spacing.sm) {
                    ForEach(Difficulty.allCases, id: \.self) { difficulty in
                        Circle()
                            .fill(selectedDifficulty == difficulty ? difficulty.color : Theme.textTertiary.opacity(0.4))
                            .frame(width: selectedDifficulty == difficulty ? 10 : 8, height: selectedDifficulty == difficulty ? 10 : 8)
                            .animation(Motion.snappy, value: selectedDifficulty)
                            .onTapGesture {
                                Haptic.selection()
                                Sound.select()
                                withAnimation(Motion.snappy) {
                                    selectedDifficulty = difficulty
                                }
                            }
                    }
                }

                // Right arrow
                Button {
                    if canGoForward {
                        Haptic.selection()
                        Sound.select()
                        withAnimation(Motion.snappy) {
                            selectedDifficulty = Difficulty.allCases[currentIndex + 1]
                        }
                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(canGoForward ? Theme.textPrimary : Theme.textTertiary.opacity(0.3))
                        .frame(width: 36, height: 36)
                        .background(Theme.surfaceElevated)
                        .clipShape(Circle())
                }
                .disabled(!canGoForward)
            }
        }
    }
}

// MARK: - Difficulty Card

struct DifficultyCard: View {
    let difficulty: Difficulty
    let selectedOperations: Set<ArithmeticQuestion.Operation>

    var body: some View {
        ZStack(alignment: .bottom) {
            // Monkey mascot image - always anchored at bottom, fixed position
            Image(difficulty.imageName)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .padding(.horizontal, Spacing.lg)
                .padding(.bottom, Spacing.md)

            // Content overlay
            VStack(spacing: 0) {
                // Title with difficulty color - ON TOP
                Text(difficulty.rawValue.uppercased())
                    .font(Typography.displaySmall)
                    .foregroundColor(difficulty.color)
                    .padding(.top, Spacing.lg)

                // Number range info - dynamic based on selected operations
                VStack(spacing: Spacing.xs) {
                    // Show Addition row if addition is selected
                    if selectedOperations.contains(.add) {
                        difficultyInfoRow(label: "Addition", value: difficulty.additionDescription)
                    }

                    // Show Subtraction row if subtraction is selected
                    if selectedOperations.contains(.subtract) {
                        difficultyInfoRow(label: "Subtraction", value: difficulty.subtractionDescription)
                    }

                    // Show Multiply row if multiplication is selected
                    if selectedOperations.contains(.multiply) {
                        difficultyInfoRow(label: "Multiplication", value: difficulty.multiplicationDescription)
                    }

                    // Show Divide row if division is selected
                    if selectedOperations.contains(.divide) {
                        difficultyInfoRow(label: "Division", value: difficulty.divisionDescription)
                    }
                }
                .padding(.horizontal, Spacing.lg)
                .padding(.top, Spacing.md)

                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: Radius.xlg)
                .fill(Theme.surface)
        )
        .padding(.horizontal, Spacing.md)
    }

    private func difficultyInfoRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(Typography.caption)
                .foregroundColor(Theme.textSecondary)

            Spacer()

            Text(value)
                .font(Typography.label)
                .foregroundColor(Theme.textPrimary)
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
                IconButton(icon: "xmark", backgroundColor: Theme.surfaceElevated, size: 40) {
                    showExitConfirmation = true
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
        HStack(spacing: Spacing.xs) {
            Image(systemName: "timer")
                .font(.system(size: 20))
                .foregroundColor(timeRemaining <= 10 ? Theme.error : Theme.sprint)

            Text("\(timeRemaining)s")
                .font(Typography.heading3)
                .foregroundColor(timeRemaining <= 10 ? Theme.error : Theme.textPrimary)
                .monospacedDigit()
        }
    }

    private var scoreView: some View {
        HStack(spacing: Spacing.xs) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 20))
                .foregroundColor(Theme.success)

            Text("\(correctCount)")
                .font(Typography.heading3)
                .foregroundColor(Theme.textPrimary)
                .monospacedDigit()
        }
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
