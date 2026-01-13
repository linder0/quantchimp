//
//  SessionRow.swift
//  quantchimp
//
//  Session history row using Theme tokens
//

import SwiftUI

struct SessionRow: View {
    let session: SessionRecord

    /// Calculate star rating based on accuracy (1-3 stars)
    private var starRating: Int {
        let accuracy = session.accuracy
        if accuracy >= 90 { return 3 }
        if accuracy >= 70 { return 2 }
        if accuracy > 0 { return 1 }
        return 0
    }

    /// Performance color based on accuracy
    private var performanceColor: Color {
        let accuracy = session.accuracy
        if accuracy >= 90 { return Theme.success }
        if accuracy >= 70 { return Theme.xp }
        return Theme.streak
    }

    var body: some View {
        HStack(spacing: Spacing.smd) {
            // Mode icon
            Image(session.mode.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)

            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(session.mode.rawValue)
                    .font(Typography.bodyBold as Font)
                    .foregroundColor(Theme.textPrimary)

                Text(session.date.relativeString)
                    .font(Typography.caption as Font)
                    .foregroundColor(Theme.textSecondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: Spacing.sm) {
                // Star rating
                HStack(spacing: 2) {
                    ForEach(0..<3, id: \.self) { index in
                        Image(systemName: index < starRating ? "star.fill" : "star")
                            .font(.system(size: 12))
                            .foregroundColor(index < starRating ? performanceColor : Theme.textTertiary.opacity(0.5))
                    }
                }

                // Score
                Text("\(session.correctCount)/\(session.questionsAnswered)")
                    .font(Typography.label as Font)
                    .foregroundColor(Theme.textPrimary)

                // XP with glow
                Text("+\(session.xpEarned) XP")
                    .font(Typography.caption as Font)
                    .foregroundColor(Theme.xp)
                    .shadow(color: Theme.xp.opacity(0.4), radius: 4, x: 0, y: 0)
            }
        }
        .padding(Spacing.smd)
        .background(Theme.surface)
        .cornerRadius(Radius.md)
        .overlay(
            RoundedRectangle(cornerRadius: Radius.md)
                .stroke(Theme.surfaceBorder, lineWidth: 1)
        )
        .surfaceShadow()
    }
}

#Preview("Session Rows") {
    VStack(spacing: Spacing.sm) {
        // 3 stars - excellent (90%+)
        SessionRow(session: SessionRecord(
            mode: .daily,
            questionsAnswered: 5,
            correctCount: 5,
            xpEarned: 50
        ))

        // 2 stars - good (70-89%)
        SessionRow(session: SessionRecord(
            mode: .sprint,
            questionsAnswered: 20,
            correctCount: 16,
            xpEarned: 160
        ))

        // 1 star - needs practice (<70%)
        SessionRow(session: SessionRecord(
            mode: .sprint,
            questionsAnswered: 20,
            correctCount: 10,
            xpEarned: 100
        ))
    }
    .padding(Spacing.lg)
    .background(Theme.background)
}
