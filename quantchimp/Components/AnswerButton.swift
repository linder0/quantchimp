//
//  AnswerButton.swift
//  quantchimp
//
//  Created by Linda Xue on 1/8/26.
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

    private var backgroundColor: Color {
        guard hasSubmitted else {
            return selectedAnswer == index ? Color.orange.opacity(0.2) : Color(.systemBackground)
        }

        if index == correctIndex {
            return Color.green.opacity(0.2)
        } else if selectedAnswer == index {
            return Color.red.opacity(0.2)
        }
        return Color(.systemBackground)
    }

    private var borderColor: Color {
        guard hasSubmitted else {
            return selectedAnswer == index ? .orange : Color(.systemGray4)
        }

        if index == correctIndex {
            return .green
        } else if selectedAnswer == index {
            return .red
        }
        return Color(.systemGray4)
    }

    var body: some View {
        Button(action: action) {
            HStack {
                Text(Self.labels[index])
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(borderColor)
                    .frame(width: 32, height: 32)
                    .background(borderColor.opacity(0.1))
                    .clipShape(Circle())

                Text(text)
                    .font(.body)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)

                Spacer()

                if hasSubmitted {
                    if index == correctIndex {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    } else if selectedAnswer == index {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                    }
                }
            }
            .padding()
            .background(backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderColor, lineWidth: 2)
            )
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
        .disabled(hasSubmitted)
    }
}

#Preview {
    VStack(spacing: 12) {
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
    }
    .padding()
}
