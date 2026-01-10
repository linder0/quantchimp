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
    var imageOffset: CGFloat = 20
    var imageSize: CGFloat = 140
    let action: () -> Void

    @State private var isPressed = false
    private let pressDepth: CGFloat = 4

    var body: some View {
        ZStack(alignment: .top) {
            // Shadow card underneath (golden tint)
            RoundedRectangle(cornerRadius: Radius.lg)
                .fill(Theme.xp.opacity(0.6))
                .offset(y: pressDepth)

            // Main card content
            VStack(spacing: 0) {
                // Image area
                ZStack(alignment: .topTrailing) {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(height: imageSize)
                        .offset(y: imageOffset)

                    // Completed checkmark
                    if isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(Theme.success)
                            .padding(Spacing.sm)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 150)
                .clipped()

                // Text area with top border
                VStack(spacing: Spacing.xs) {
                    Text(title)
                        .font(Typography.headline)
                        .foregroundColor(Theme.textPrimary)

                    Text(subtitle)
                        .font(Typography.caption)
                        .foregroundColor(Theme.textSecondary)
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
            .offset(y: isPressed ? pressDepth : 0)
            .animation(.easeOut(duration: 0.08), value: isPressed)
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressed {
                        isPressed = true
                        Haptic.light()
                    }
                }
                .onEnded { _ in
                    isPressed = false
                    action()
                }
        )
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
