//
//  PlayOptionTile.swift
//  quantchimp
//
//  Game mode selection tile using Theme tokens
//

import SwiftUI

// MARK: - Large Card Style (for active game modes)
struct PlayOptionCard: View {
    let imageName: String
    let title: String
    let subtitle: String
    var isCompleted: Bool = false
    var isDisabled: Bool = false
    var countdownText: String? = nil
    var imageOffset: CGFloat = 20
    var imageSize: CGFloat = 140
    let action: () -> Void

    private let pressDepth: CGFloat = 4

    var body: some View {
        Button(action: {
            guard !isDisabled else { return }
            Haptic.light()
            action()
        }) {
            ZStack(alignment: .top) {
                // Shadow card underneath (lighter grey)
                RoundedRectangle(cornerRadius: Radius.lg)
                    .fill(Theme.surfaceElevated)
                    .offset(y: pressDepth)

                // Main card content
                VStack(spacing: 0) {
                    // Image area
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(height: imageSize)
                        .offset(y: imageOffset)
                        .opacity(isDisabled ? 0.4 : 1.0)
                        .frame(maxWidth: .infinity)
                        .frame(height: 150)
                        .clipped()

                    // Text area with top border
                    VStack(spacing: Spacing.xs) {
                        Text(title)
                            .font(Typography.headline)
                            .foregroundColor(isDisabled ? Theme.textTertiary : Theme.textPrimary)

                        Text(subtitle)
                            .font(Typography.caption)
                            .foregroundColor(isDisabled ? Theme.textTertiary : Theme.textSecondary)
                    }
                    .padding(.top, Spacing.lg)
                    .padding(.bottom, Spacing.md)
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.05))
                    .overlay(
                        Rectangle()
                            .fill(Theme.surfaceBorder)
                            .frame(height: 1),
                        alignment: .top
                    )
                }
                .background(Theme.surfaceElevated)
                .clipShape(RoundedRectangle(cornerRadius: Radius.lg))

                // Timer overlay (when disabled)
                if let countdownText = countdownText, isDisabled {
                    ZStack {
                        RoundedRectangle(cornerRadius: Radius.lg)
                            .fill(Color.black.opacity(0.3))

                        HStack(spacing: Spacing.xs) {
                            Image(systemName: "clock.fill")
                                .font(.title3)
                                .foregroundColor(.white)
                            Text(countdownText)
                                .font(Typography.headline)
                                .foregroundColor(.white)
                        }
                    }
                }
            }
        }
        .buttonStyle(.plain)
        .pressable(scale: isDisabled ? 1.0 : 0.97)
        .opacity(isDisabled ? 0.6 : 1.0)
    }
}

// MARK: - Compact Row Style (for disabled/coming soon modes)
struct PlayOptionTile: View {
    let imageName: String
    let title: String
    let subtitle: String
    var isCompleted: Bool = false
    var isDisabled: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: {
            Haptic.light()
            action()
        }) {
            HStack(spacing: Spacing.md) {
                // Monkey image
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 44, height: 44)
                    .opacity(isDisabled ? 0.5 : 1)

                // Text content
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(title)
                        .font(Typography.bodyBold)
                        .foregroundColor(isDisabled ? Theme.textTertiary : Theme.textPrimary)

                    Text(subtitle)
                        .font(Typography.caption)
                        .foregroundColor(isDisabled ? Theme.textTertiary : Theme.textSecondary)
                }

                Spacer()

                // Status indicator
                if isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(Theme.success)
                } else if isDisabled {
                    Image(systemName: "lock.fill")
                        .font(.subheadline)
                        .foregroundColor(Theme.textTertiary)
                } else {
                    Image(systemName: "chevron.right")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(Theme.textTertiary)
                }
            }
            .padding(Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: Radius.md)
                    .fill(Theme.surfaceElevated)
            )
        }
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.7 : 1)
        .pressable()
    }
}

#Preview {
    VStack(spacing: Spacing.smd) {
        // Card style for active modes
        HStack(spacing: Spacing.smd) {
            PlayOptionCard(
                imageName: "monkey_daily_puzzle",
                title: "Daily Puzzle",
                subtitle: "Ready to play",
                imageOffset: 10
            ) {}

            PlayOptionCard(
                imageName: "monkey_sprint",
                title: "Sprint",
                subtitle: "Speed challenge",
                isCompleted: true,
                imageOffset: 20
            ) {}
        }

        // Row style for disabled modes
        PlayOptionTile(
            imageName: "monkey_tournament",
            title: "Tournaments",
            subtitle: "Coming soon",
            isDisabled: true
        ) {}
    }
    .padding(Spacing.lg)
    .background(Theme.background)
}
