//
//  GameHistoryCard.swift
//  quantchimp
//
//  Game session history card using Theme tokens
//

import SwiftUI

struct GameHistoryCard: View {
    let session: SessionRecord

    private var accuracyColor: Color {
        if session.accuracy >= 90 {
            return Theme.success
        } else if session.accuracy >= 70 {
            return Theme.warning
        } else {
            return Theme.error
        }
    }

    var body: some View {
        HStack(spacing: Spacing.md) {
            // Mode icon
            ZStack {
                RoundedRectangle(cornerRadius: Radius.md)
                    .fill(session.mode.color.opacity(0.15))
                    .frame(width: 52, height: 52)

                Image(systemName: session.mode.icon)
                    .font(.title2)
                    .foregroundColor(session.mode.color)
            }

            // Session details
            VStack(alignment: .leading, spacing: Spacing.xs) {
                HStack {
                    Text(session.mode.rawValue)
                        .font(Typography.headline)
                        .foregroundColor(Theme.textPrimary)

                    Spacer()

                    Text(session.date.relativeString)
                        .font(Typography.caption)
                        .foregroundColor(Theme.textTertiary)
                }

                HStack(spacing: Spacing.smd) {
                    // Score
                    Label("\(session.correctCount)/\(session.questionsAnswered)", systemImage: "checkmark.circle.fill")
                        .font(Typography.caption)
                        .foregroundColor(Theme.textSecondary)

                    // Accuracy
                    Text(formatAccuracy(session.accuracy))
                        .font(Typography.label)
                        .foregroundColor(accuracyColor)
                }
            }
        }
        .padding(Spacing.md)
        .cardStyle()
    }
}

#Preview("Game History") {
    VStack(spacing: Spacing.smd) {
        GameHistoryCard(session: SessionRecord(
            mode: .sprint,
            questionsAnswered: 20,
            correctCount: 18,
            xpEarned: 50
        ))

        GameHistoryCard(session: SessionRecord(
            mode: .daily,
            questionsAnswered: 5,
            correctCount: 5,
            xpEarned: 50
        ))
    }
    .padding(Spacing.lg)
    .background(Theme.background)
}
