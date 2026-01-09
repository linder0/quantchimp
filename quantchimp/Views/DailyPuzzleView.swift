//
//  DailyPuzzleView.swift
//  quantchimp
//
//  Daily puzzle view for open-ended quant questions
//

import SwiftUI

struct DailyPuzzleView: View {
    @EnvironmentObject var appState: AppState
    @Binding var navigationPath: NavigationPath

    @State private var userAnswer: String = ""
    @State private var hasSubmitted = false
    @State private var showResult = false
    @State private var isCorrect = false
    @FocusState private var isInputFocused: Bool

    private var todaysPuzzle: DailyProblem {
        DailyPuzzleBank.getTodaysPuzzle()
    }

    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.lg) {
                // Difficulty badge
                difficultyBadge

                // Problem card
                problemCard

                // Answer input
                answerInput

                // Submit button
                if !hasSubmitted {
                    submitButton
                }

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
                userAnswer: userAnswer,
                navigationPath: $navigationPath
            )
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isInputFocused = true
            }
        }
    }

    private var difficultyBadge: some View {
        HStack {
            Spacer()

            HStack(spacing: Spacing.xs) {
                Image(systemName: "chart.bar.fill")
                    .font(.caption2)
                Text("Difficulty: \(todaysPuzzle.difficulty)/10")
                    .font(Typography.captionSmall)
            }
            .foregroundColor(difficultyColor)
            .padding(.horizontal, Spacing.sm)
            .padding(.vertical, Spacing.xs)
            .background(difficultyColor.opacity(0.15))
            .clipShape(Capsule())
        }
    }

    private var difficultyColor: Color {
        switch todaysPuzzle.difficulty {
        case 1...3: return Theme.success
        case 4...6: return Theme.warning
        default: return Theme.error
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
                .font(Typography.body)
                .foregroundColor(Theme.textPrimary)
                .lineSpacing(6)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.lg)
        .cardElevated(cornerRadius: Radius.xlg)
    }

    private var answerInput: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Your Answer")
                .font(Typography.label)
                .foregroundColor(Theme.textSecondary)

            HStack {
                TextField("Enter your answer...", text: $userAnswer)
                    .font(Typography.heading3)
                    .foregroundColor(Theme.textPrimary)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .focused($isInputFocused)
                    .disabled(hasSubmitted)
                    .onSubmit {
                        submitAnswer()
                    }

                if !userAnswer.isEmpty && !hasSubmitted {
                    Button {
                        userAnswer = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Theme.textTertiary)
                    }
                }
            }
            .padding(Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: Radius.lg)
                    .fill(hasSubmitted ? (isCorrect ? Theme.success.opacity(0.15) : Theme.error.opacity(0.15)) : Theme.surfaceElevated)
            )
            .overlay(
                RoundedRectangle(cornerRadius: Radius.lg)
                    .stroke(hasSubmitted ? (isCorrect ? Theme.success : Theme.error) : Theme.surfaceBorder, lineWidth: hasSubmitted ? 2 : 1)
            )

            if hasSubmitted {
                HStack(spacing: Spacing.xs) {
                    Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                    Text(isCorrect ? "Correct!" : "Incorrect")
                }
                .font(Typography.bodyBold)
                .foregroundColor(isCorrect ? Theme.success : Theme.error)

                if !isCorrect {
                    Text("Answer: \(todaysPuzzle.answer)")
                        .font(Typography.body)
                        .foregroundColor(Theme.textSecondary)
                }
            }
        }
    }

    private var submitButton: some View {
        PrimaryButton(
            title: "Submit Answer",
            color: Theme.daily,
            isEnabled: !userAnswer.trimmingCharacters(in: .whitespaces).isEmpty
        ) {
            submitAnswer()
        }
    }

    private func submitAnswer() {
        guard !userAnswer.trimmingCharacters(in: .whitespaces).isEmpty, !hasSubmitted else { return }

        isInputFocused = false

        // Check answer (normalized comparison)
        isCorrect = checkAnswer(userAnswer: userAnswer, correctAnswer: todaysPuzzle.answer)

        withAnimation(Motion.spring) {
            hasSubmitted = true
        }

        // Haptic and sound feedback
        if isCorrect {
            Haptic.success()
            Sound.success()
        } else {
            Haptic.error()
            Sound.error()
        }

        // Navigate to result after feedback
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            showResult = true
        }
    }

    /// Checks if user's answer matches the correct answer
    /// Handles common variations (spacing, case, approximate values)
    private func checkAnswer(userAnswer: String, correctAnswer: String) -> Bool {
        let user = userAnswer.trimmingCharacters(in: .whitespaces).lowercased()
        let correct = correctAnswer.trimmingCharacters(in: .whitespaces).lowercased()

        // Exact match
        if user == correct {
            return true
        }

        // Remove spaces and compare
        let userNoSpaces = user.replacingOccurrences(of: " ", with: "")
        let correctNoSpaces = correct.replacingOccurrences(of: " ", with: "")
        if userNoSpaces == correctNoSpaces {
            return true
        }

        // Handle numeric answers
        if let userNum = parseNumber(user), let correctNum = parseNumber(correct) {
            // Allow small tolerance for decimal answers
            if abs(userNum - correctNum) < 0.01 {
                return true
            }
        }

        // Handle fraction inputs (e.g., "21/32" should match)
        if let userFraction = parseFraction(user), let correctFraction = parseFraction(correct) {
            if abs(userFraction - correctFraction) < 0.0001 {
                return true
            }
        }

        // Check if correct answer starts with ≈ (approximate)
        if correct.hasPrefix("≈") {
            let approxValue = correct.replacingOccurrences(of: "≈", with: "").trimmingCharacters(in: .whitespaces)
            if user == approxValue || userNoSpaces == approxValue.replacingOccurrences(of: " ", with: "") {
                return true
            }
            if let userNum = parseNumber(user), let correctNum = parseNumber(approxValue) {
                if abs(userNum - correctNum) < correctNum * 0.05 { // 5% tolerance
                    return true
                }
            }
        }

        return false
    }

    private func parseNumber(_ string: String) -> Double? {
        // Try parsing as double directly
        if let num = Double(string) {
            return num
        }

        // Try parsing fraction
        if let fraction = parseFraction(string) {
            return fraction
        }

        return nil
    }

    private func parseFraction(_ string: String) -> Double? {
        let parts = string.split(separator: "/")
        if parts.count == 2,
           let numerator = Double(parts[0].trimmingCharacters(in: .whitespaces)),
           let denominator = Double(parts[1].trimmingCharacters(in: .whitespaces)),
           denominator != 0 {
            return numerator / denominator
        }
        return nil
    }
}

#Preview {
    NavigationStack {
        DailyPuzzleView(navigationPath: .constant(NavigationPath()))
            .environmentObject(AppState())
    }
}
