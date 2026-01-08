//
//  PlayOptionTile.swift
//  quantchimp
//
//  Game mode selection tile using Theme tokens
//

import SwiftUI

struct PlayOptionTile: View {
    let icon: String
    let emoji: String
    let title: String
    let subtitle: String
    let isCompleted: Bool
    let color: Color
    var isDisabled: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: {
            Haptic.light()
            action()
        }) {
            HStack(spacing: Spacing.md) {
                // Emoji icon with subtle background
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 50, height: 50)

                    Text(emoji)
                        .font(.system(size: 26))
                }

                // Text content
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(title)
                        .font(Typography.headline)
                        .foregroundColor(isDisabled ? Theme.textTertiary : Theme.textPrimary)

                    Text(subtitle)
                        .font(Typography.caption)
                        .foregroundColor(isDisabled ? Theme.textTertiary : Theme.textSecondary)
                }

                Spacer()

                // Status indicator
                if isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(Theme.success)
                } else if !isDisabled {
                    Image(systemName: "chevron.right")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(Theme.textTertiary)
                }
            }
            .padding(.horizontal, Spacing.md)
            .padding(.vertical, Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: Radius.lg)
                    .fill(Theme.surface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: Radius.lg)
                    .stroke(
                        isCompleted ? Theme.success.opacity(0.3) : Theme.surfaceBorder,
                        lineWidth: 1
                    )
            )
        }
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.6 : 1)
        .pressable()
    }
}

#Preview {
    VStack(spacing: Spacing.smd) {
        PlayOptionTile(
            icon: "brain.head.profile",
            emoji: "🧠",
            title: "Daily Puzzle",
            subtitle: "Ready to play",
            isCompleted: false,
            color: Theme.daily
        ) {}

        PlayOptionTile(
            icon: "timer",
            emoji: "⚡",
            title: "Arithmetic Sprint",
            subtitle: "Completed",
            isCompleted: true,
            color: Theme.sprint
        ) {}

        PlayOptionTile(
            icon: "trophy.fill",
            emoji: "🏆",
            title: "Tournaments",
            subtitle: "Coming soon",
            isCompleted: false,
            color: Theme.xp,
            isDisabled: true
        ) {}
    }
    .padding(Spacing.lg)
    .background(Theme.background)
}
