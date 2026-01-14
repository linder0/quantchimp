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

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: Spacing.md) {
                // Monkey graphic
                Image(goal.monkeyImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 56, height: 56)

                // Text - Only the title
                Text(goal.rawValue)
                    .font(Typography.headline)
                    .foregroundColor(Theme.textPrimary)

                Spacer()

                // Selection indicator
                ZStack {
                    Circle()
                        .stroke(isSelected ? Theme.accent : Theme.textTertiary, lineWidth: 2)
                        .frame(width: 26, height: 26)

                    if isSelected {
                        Circle()
                            .fill(Theme.accent)
                            .frame(width: 16, height: 16)
                    }
                }
            }
            .padding(Spacing.lg)
            .frame(minHeight: 84)
            .background(
                RoundedRectangle(cornerRadius: Radius.lg)
                    .fill(Theme.surface)
            )
            .shadow(
                color: Shadow.sm.color,
                radius: Shadow.sm.radius,
                x: 0,
                y: Shadow.sm.y
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
