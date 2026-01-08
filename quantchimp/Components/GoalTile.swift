//
//  GoalTile.swift
//  quantchimp
//
//  Goal selection tile using Theme tokens
//

import SwiftUI

struct GoalTile: View {
    let goal: UserGoal
    let isSelected: Bool
    let onTap: () -> Void

    private var goalColor: Color {
        switch goal.color {
        case "purple": return Theme.level
        case "blue": return Theme.sprint
        case "orange": return Theme.accent
        case "green": return Theme.success
        default: return Theme.accent
        }
    }

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: Spacing.md) {
                // Icon
                ZStack {
                    Circle()
                        .fill(goalColor.opacity(0.15))
                        .frame(width: 52, height: 52)

                    Image(systemName: goal.icon)
                        .font(.title2)
                        .foregroundColor(goalColor)
                }

                // Text
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(goal.rawValue)
                        .font(Typography.headline)
                        .foregroundColor(Theme.textPrimary)

                    Text(goal.description)
                        .font(Typography.caption)
                        .foregroundColor(Theme.textSecondary)
                        .lineLimit(2)
                }

                Spacer()

                // Selection indicator
                ZStack {
                    Circle()
                        .stroke(isSelected ? goalColor : Theme.textTertiary, lineWidth: 2)
                        .frame(width: 24, height: 24)

                    if isSelected {
                        Circle()
                            .fill(goalColor)
                            .frame(width: 14, height: 14)
                    }
                }
            }
            .padding(Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: Radius.lg)
                    .fill(Theme.surface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: Radius.lg)
                    .stroke(isSelected ? goalColor : Theme.surfaceBorder, lineWidth: isSelected ? 2 : 1)
            )
            .shadow(
                color: isSelected ? goalColor.opacity(0.2) : Shadow.sm.color,
                radius: isSelected ? 8 : Shadow.sm.radius,
                x: 0,
                y: isSelected ? 4 : Shadow.sm.y
            )
        }
        .buttonStyle(.plain)
        .pressable()
        .animation(Motion.spring, value: isSelected)
    }
}

#Preview {
    VStack(spacing: Spacing.smd) {
        GoalTile(goal: .quantCareer, isSelected: true) {}
        GoalTile(goal: .interviewPrep, isSelected: false) {}
    }
    .padding(Spacing.lg)
    .background(Theme.background)
}
