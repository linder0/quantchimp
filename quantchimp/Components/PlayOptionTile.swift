//
//  PlayOptionTile.swift
//  quantchimp
//
//  Created by Linda Xue on 1/8/26.
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
        Button(action: action) {
            HStack(spacing: 16) {
                // Emoji icon
                Text(emoji)
                    .font(.system(size: 32))
                    .frame(width: 50, height: 50)

                // Text content
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(isDisabled ? .white.opacity(0.4) : .white)

                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(isDisabled ? .white.opacity(0.3) : .white.opacity(0.6))
                }

                Spacer()

                // Status indicator
                if isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.green)
                } else if !isDisabled {
                    Image(systemName: "chevron.right")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.white.opacity(0.4))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(red: 0.2, green: 0.2, blue: 0.24))
            )
        }
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.6 : 1)
    }
}

#Preview {
    ZStack {
        Color(red: 0.12, green: 0.12, blue: 0.14)
            .ignoresSafeArea()

        VStack(spacing: 12) {
            PlayOptionTile(
                icon: "brain.head.profile",
                emoji: "🧠",
                title: "Daily Puzzle",
                subtitle: "Ready to play",
                isCompleted: false,
                color: .purple
            ) {}

            PlayOptionTile(
                icon: "timer",
                emoji: "⚡",
                title: "Arithmetic Sprint",
                subtitle: "Completed",
                isCompleted: true,
                color: .blue
            ) {}

            PlayOptionTile(
                icon: "trophy.fill",
                emoji: "🏆",
                title: "Tournaments",
                subtitle: "Coming soon",
                isCompleted: false,
                color: .yellow,
                isDisabled: true
            ) {}
        }
        .padding()
    }
}
