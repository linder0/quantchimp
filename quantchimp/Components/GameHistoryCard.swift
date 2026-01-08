//
//  GameHistoryCard.swift
//  quantchimp
//
//  Created by Linda Xue on 1/8/26.
//

import SwiftUI

struct GameHistoryCard: View {
    let session: SessionRecord

    private var relativeTime: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: session.date, relativeTo: Date())
    }

    private var accuracyColor: Color {
        if session.accuracy >= 90 {
            return .green
        } else if session.accuracy >= 70 {
            return .orange
        } else {
            return .red
        }
    }

    var body: some View {
        HStack(spacing: 16) {
            // Mode icon
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(session.mode.color.opacity(0.15))
                    .frame(width: 56, height: 56)

                Image(systemName: session.mode.icon)
                    .font(.title2)
                    .foregroundColor(session.mode.color)
            }

            // Session details
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(session.mode.rawValue)
                        .font(.headline)
                        .foregroundColor(.primary)

                    Spacer()

                    Text(relativeTime)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                HStack(spacing: 12) {
                    // Score
                    Label("\(session.correctCount)/\(session.questionsAnswered)", systemImage: "checkmark.circle.fill")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    // Accuracy
                    Text(String(format: "%.0f%%", session.accuracy))
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(accuracyColor)
                }

            }
        }
        .padding()
        .cardStyle()
    }
}

#Preview {
    VStack(spacing: 12) {
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
    .padding()
    .background(Color(.systemGray6))
}
