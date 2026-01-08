//
//  AnswerButton.swift
//  quantchimp
//
//  Answer option button with selection states and feedback
//

import SwiftUI

struct AnswerButton: View {
    let text: String
    let index: Int
    @Binding var selectedAnswer: Int?
    let hasSubmitted: Bool
    let correctIndex: Int
    let action: () -> Void

    private static let labels = ["A", "B", "C", "D"]

    @State private var showPulse = false

    private var isSelected: Bool {
        selectedAnswer == index
    }

    private var isCorrect: Bool {
        index == correctIndex
    }

    private var isWrong: Bool {
        hasSubmitted && isSelected && !isCorrect
    }

    private var backgroundColor: Color {
        guard hasSubmitted else {
            return isSelected ? Theme.accent.opacity(0.15) : Theme.surface
        }

        if isCorrect {
            return Theme.success.opacity(0.15)
        } else if isWrong {
            return Theme.error.opacity(0.15)
        }
        return Theme.surface
    }

    private var borderColor: Color {
        guard hasSubmitted else {
            return isSelected ? Theme.accent : Theme.surfaceBorder
        }

        if isCorrect {
            return Theme.success
        } else if isWrong {
            return Theme.error
        }
        return Theme.surfaceBorder
    }

    private var labelColor: Color {
        guard hasSubmitted else {
            return isSelected ? Theme.accent : Theme.textSecondary
        }

        if isCorrect {
            return Theme.success
        } else if isWrong {
            return Theme.error
        }
        return Theme.textSecondary
    }

    var body: some View {
        Button(action: {
            Haptic.light()
            action()
        }) {
            HStack(spacing: Spacing.smd) {
                // Letter badge
                Text(Self.labels[index])
                    .font(Typography.headline)
                    .foregroundColor(labelColor)
                    .frame(width: 36, height: 36)
                    .background(
                        Circle()
                            .fill(labelColor.opacity(0.1))
                    )
                    .overlay(
                        Circle()
                            .stroke(labelColor.opacity(0.3), lineWidth: 1)
                    )

                // Answer text
                Text(text)
                    .font(Typography.body)
                    .foregroundColor(Theme.textPrimary)
                    .multilineTextAlignment(.leading)

                Spacer()

                // Result indicator
                if hasSubmitted {
                    if isCorrect {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title3)
                            .foregroundColor(Theme.success)
                            .transition(.scale.combined(with: .opacity))
                    } else if isWrong {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .foregroundColor(Theme.error)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
            }
            .padding(Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: Radius.md)
                    .fill(backgroundColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: Radius.md)
                    .stroke(borderColor, lineWidth: hasSubmitted || isSelected ? 2 : 1)
            )
            .overlay(
                // Pulse effect on correct answer
                RoundedRectangle(cornerRadius: Radius.md)
                    .stroke(Theme.success, lineWidth: 3)
                    .opacity(showPulse ? 0 : 1)
                    .scaleEffect(showPulse ? 1.05 : 1)
                    .animation(
                        showPulse ? Animation.easeOut(duration: 0.6) : nil,
                        value: showPulse
                    )
            )
        }
        .buttonStyle(.plain)
        .disabled(hasSubmitted)
        .pressable()
        .animation(Motion.spring, value: hasSubmitted)
        .onChange(of: hasSubmitted) { _, newValue in
            if newValue && isCorrect {
                showPulse = true
            }
        }
    }
}

#Preview {
    VStack(spacing: Spacing.smd) {
        AnswerButton(
            text: "Option A - Not selected",
            index: 0,
            selectedAnswer: .constant(nil),
            hasSubmitted: false,
            correctIndex: 1
        ) {}

        AnswerButton(
            text: "Option B - Selected",
            index: 1,
            selectedAnswer: .constant(1),
            hasSubmitted: false,
            correctIndex: 1
        ) {}

        AnswerButton(
            text: "Option C - Correct (submitted)",
            index: 2,
            selectedAnswer: .constant(0),
            hasSubmitted: true,
            correctIndex: 2
        ) {}

        AnswerButton(
            text: "Option D - Wrong (submitted)",
            index: 0,
            selectedAnswer: .constant(0),
            hasSubmitted: true,
            correctIndex: 2
        ) {}
    }
    .padding(Spacing.lg)
    .background(Theme.background)
}
