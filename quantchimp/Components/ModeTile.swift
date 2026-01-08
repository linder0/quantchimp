//
//  ModeTile.swift
//  quantchimp
//
//  Created by Linda Xue on 1/8/26.
//

import SwiftUI

struct ModeTile: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    var isCompleted: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 56, height: 56)

                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(color)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)

                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()

                if isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.green)
                } else {
                    Image(systemName: "chevron.right")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .cardStyle()
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: 16) {
        ModeTile(
            title: "Daily Puzzle",
            subtitle: "Ready",
            icon: "brain.head.profile",
            color: .purple
        ) {}

        ModeTile(
            title: "Daily Puzzle",
            subtitle: "Completed",
            icon: "brain.head.profile",
            color: .purple,
            isCompleted: true
        ) {}

        ModeTile(
            title: "Arithmetic Sprint",
            subtitle: "60 second challenge",
            icon: "timer",
            color: .blue
        ) {}
    }
    .padding()
    .background(Color(.systemGray6))
}
