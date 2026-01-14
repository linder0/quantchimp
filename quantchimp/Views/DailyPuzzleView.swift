//
//  DailyPuzzleView.swift
//  quantchimp
//
//  Daily puzzle view - immersive full-screen experience
//

import SwiftUI

struct DailyPuzzleView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss

    @State private var userAnswer: String = ""
    @State private var hasSubmitted = false
    @State private var showResult = false
    @State private var isCorrect = false
    @State private var showHint = false
    @FocusState private var isInputFocused: Bool

    private var todaysPuzzle: DailyProblem {
        DailyPuzzleBank.getTodaysPuzzle()
    }

    /// Generate a hint from the explanation if no explicit hint is provided
    private var hintText: String {
        if let hint = todaysPuzzle.hint {
            return hint
        }
        // Use first sentence of explanation as fallback hint
        let explanation = todaysPuzzle.explanation
        if let dotIndex = explanation.firstIndex(of: ".") {
            return String(explanation[...dotIndex])
        }
        return "Think about the problem step by step."
    }

    var body: some View {
        ZStack {
            Theme.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                header
                    .padding(.top, Spacing.md)

                Spacer()

                // Question content
                VStack(spacing: Spacing.lg) {
                    // Puzzle image (if available)
                    if let imageName = todaysPuzzle.imageName {
                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 200, maxHeight: 160)
                            .padding(.bottom, Spacing.sm)
                    }

                    Text(todaysPuzzle.prompt)
                        .font(Typography.heading3)
                        .foregroundColor(Theme.textPrimary)
                        .lineSpacing(8)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Spacing.lg)

                    // Hint section (appears when hint button is tapped)
                    if showHint {
                        Text(hintText)
                            .font(Typography.body)
                            .foregroundColor(Theme.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(Spacing.md)
                            .background(
                                RoundedRectangle(cornerRadius: Radius.md)
                                    .fill(Theme.surface)
                            )
                            .padding(.horizontal, Spacing.lg)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }

                Spacer()

                // Answer section
                VStack(spacing: Spacing.md) {
                    answerInput

                    if !hasSubmitted {
                        submitButton
                    }
                }
                .padding(.horizontal, Spacing.md)
                .padding(.bottom, Spacing.lg)
            }
        }
        .fullScreenCover(isPresented: $showResult) {
            DailyResultView(
                problem: todaysPuzzle,
                isCorrect: isCorrect,
                userAnswer: userAnswer
            )
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isInputFocused = true
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        ModalHeader(title: "Daily Puzzle") {
            dismiss()
        } trailing: {
            // Hint button - fades when used
            Button {
                if !showHint && !hasSubmitted {
                    withAnimation(Motion.spring) {
                        showHint = true
                    }
                    Haptic.light()
                }
            } label: {
                Image("icon_hint")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    .opacity(showHint ? 0.3 : 1.0)
            }
            .disabled(showHint || hasSubmitted)
        }
    }

    // MARK: - Answer Input

    private var answerInput: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
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
            .padding(Spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: Radius.lg)
                    .fill(hasSubmitted ? (isCorrect ? Theme.success.opacity(0.15) : Theme.error.opacity(0.15)) : Theme.surface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: Radius.lg)
                    .stroke(hasSubmitted ? (isCorrect ? Theme.success : Theme.error) : Theme.daily.opacity(0.5), lineWidth: 2)
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

    // MARK: - Submit Button

    private var submitButton: some View {
        PrimaryButton(
            title: "Submit Answer",
            color: Theme.daily,
            isEnabled: !userAnswer.trimmingCharacters(in: .whitespaces).isEmpty
        ) {
            submitAnswer()
        }
    }

    // MARK: - Actions

    private func submitAnswer() {
        guard !userAnswer.trimmingCharacters(in: .whitespaces).isEmpty, !hasSubmitted else { return }

        isInputFocused = false

        // Check answer using AnswerValidator
        isCorrect = AnswerValidator.isCorrect(userAnswer: userAnswer, correctAnswer: todaysPuzzle.answer)

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
}

#Preview {
    DailyPuzzleView()
        .environmentObject(AppState())
}
