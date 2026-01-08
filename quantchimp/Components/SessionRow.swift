//
//  SessionRow.swift
//  quantchimp
//
//  Created by Linda Xue on 1/8/26.
//

import SwiftUI

struct SessionRow: View {
    let session: SessionRecord

    private var dateString: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: session.date, relativeTo: Date())
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: session.mode.icon)
                .font(.headline)
                .foregroundColor(session.mode.color)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 2) {
                Text(session.mode.rawValue)
                    .font(.subheadline)
                    .fontWeight(.medium)

                Text(dateString)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text("\(session.correctCount)/\(session.questionsAnswered)")
                    .font(.subheadline)
                    .fontWeight(.medium)

                Text("+\(session.xpEarned) XP")
                    .font(.caption)
                    .foregroundColor(.orange)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

#Preview {
    VStack(spacing: 8) {
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
    .padding()
    .background(Color(.systemGray6))
}
