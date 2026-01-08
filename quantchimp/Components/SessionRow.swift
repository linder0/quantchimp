//
//  SessionRow.swift
//  quantchimp
//
//  Session history row using Theme tokens
//

import SwiftUI

struct SessionRow: View {
    let session: SessionRecord

    var body: some View {
        HStack(spacing: Spacing.smd) {
            Image(systemName: session.mode.icon)
                .font(Typography.headline)
                .foregroundColor(session.mode.color)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(session.mode.rawValue)
                    .font(Typography.bodyBold)
                    .foregroundColor(Theme.textPrimary)

                Text(session.date.relativeString)
                    .font(Typography.caption)
                    .foregroundColor(Theme.textSecondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: Spacing.xs) {
                Text("\(session.correctCount)/\(session.questionsAnswered)")
                    .font(Typography.bodyBold)
                    .foregroundColor(Theme.textPrimary)

                Text("+\(session.xpEarned) XP")
                    .font(Typography.caption)
                    .foregroundColor(Theme.xp)
            }
        }
        .padding(Spacing.md)
        .cardStyle(cornerRadius: Radius.md)
    }
}

#Preview {
    VStack(spacing: Spacing.sm) {
        SessionRow(session: SessionRecord(
            mode: .daily,
            questionsAnswered: 5,
            correctCount: 4,
            xpEarned: 50
        ))

        SessionRow(session: SessionRecord(
            mode: .sprint,
            questionsAnswered: 20,
            correctCount: 18,
            xpEarned: 180
        ))
    }
    .padding(Spacing.lg)
    .background(Theme.background)
}
