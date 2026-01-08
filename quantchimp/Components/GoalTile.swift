//
//  GoalTile.swift
//  quantchimp
//
//  Created by Linda Xue on 1/8/26.
//

import SwiftUI

struct GoalTile: View {
    let goal: UserGoal
    let isSelected: Bool
    let onTap: () -> Void

    private var goalColor: Color {
        switch goal.color {
        case "purple": return .purple
        case "blue": return .blue
        case "orange": return .orange
        case "green": return .green
        default: return .orange
        }
    }

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Icon
                ZStack {
                    Circle()
                        .fill(goalColor.opacity(0.15))
                        .frame(width: 56, height: 56)

                    Image(systemName: goal.icon)
                        .font(.title2)
                        .foregroundColor(goalColor)
                }

                // Text
                VStack(alignment: .leading, spacing: 4) {
                    Text(goal.rawValue)
                        .font(.headline)
                        .foregroundColor(.primary)

                    Text(goal.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }

                Spacer()

                // Selection indicator
                ZStack {
                    Circle()
                        .stroke(isSelected ? goalColor : Color.gray.opacity(0.3), lineWidth: 2)
                        .frame(width: 24, height: 24)

                    if isSelected {
                        Circle()
                            .fill(goalColor)
                            .frame(width: 14, height: 14)
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(color: isSelected ? goalColor.opacity(0.2) : .black.opacity(0.05), radius: 8, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? goalColor : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: 12) {
        GoalTile(goal: .quantCareer, isSelected: true) {}
        GoalTile(goal: .interviewPrep, isSelected: false) {}
    }
    .padding()
    .background(Color(.systemGray6))
}
