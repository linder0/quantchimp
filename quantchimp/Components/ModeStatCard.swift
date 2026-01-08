//
//  ModeStatCard.swift
//  quantchimp
//
//  Mode statistics card using Theme tokens
//

import SwiftUI

struct ModeStatCard: View {
    let mode: GameMode
    let completed: Int
    let accuracy: Double

    var body: some View {
        HStack(spacing: Spacing.md) {
            ZStack {
                Circle()
                    .fill(mode.color.opacity(0.15))
                    .frame(width: 48, height: 48)

                Image(systemName: mode.icon)
                    .font(.title3)
                    .foregroundColor(mode.color)
            }

            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(mode.rawValue)
                    .font(Typography.headline)
                    .foregroundColor(Theme.textPrimary)

                Text("\(completed) completed")
                    .font(Typography.caption)
                    .foregroundColor(Theme.textSecondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: Spacing.xs) {
                Text(String(format: "%.0f%%", accuracy))
                    .font(Typography.heading3)
                    .foregroundColor(mode.color)

                Text("accuracy")
                    .font(Typography.caption)
                    .foregroundColor(Theme.textSecondary)
            }
        }
        .padding(Spacing.md)
        .cardStyle()
    }
}

#Preview {
    VStack(spacing: Spacing.smd) {
        ModeStatCard(mode: .daily, completed: 15, accuracy: 85)
        ModeStatCard(mode: .sprint, completed: 23, accuracy: 72)
    }
    .padding(Spacing.lg)
    .background(Theme.background)
}
