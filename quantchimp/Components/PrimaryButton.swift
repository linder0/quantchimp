//
//  PrimaryButton.swift
//  quantchimp
//
//  Button components using Theme tokens
//

import SwiftUI

// MARK: - Primary Button

/// Main call-to-action button with accent color and glow effect
struct PrimaryButton: View {
    let title: String
    var color: Color = Theme.accent
    var isEnabled: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: {
            Haptic.medium()
            Sound.tap()
            action()
        }) {
            Text(title)
                .font(Typography.headline)
                .foregroundColor(color == Theme.accent ? Theme.background : .white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: Radius.md)
                        .fill(color)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: Radius.md)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1 : 0.5)
        .shadow(color: color.opacity(0.3), radius: 10, x: 0, y: 6)
        .pressable(scale: 0.97)
    }
}

// MARK: - Secondary Button

/// Outline/ghost button for secondary actions
struct SecondaryButton: View {
    let title: String
    var color: Color = Theme.textSecondary
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(Typography.headline)
                .foregroundColor(color)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: Radius.md)
                        .fill(Theme.surfaceElevated)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: Radius.md)
                        .stroke(Theme.surfaceBorder, lineWidth: 1)
                )
        }
        .pressable()
    }
}

// MARK: - Tertiary Button (Text only)

/// Minimal text button for less prominent actions
struct TertiaryButton: View {
    let title: String
    var color: Color = Theme.textSecondary
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(Typography.bodyBold)
                .foregroundColor(color)
        }
    }
}

// MARK: - Icon Button

/// Circular button with icon
struct IconButton: View {
    let icon: String
    var color: Color = Theme.textPrimary
    var backgroundColor: Color = Theme.surface
    var size: CGFloat = 44
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: size * 0.4, weight: .semibold))
                .foregroundColor(color)
                .frame(width: size, height: size)
                .background(
                    Circle()
                        .fill(backgroundColor)
                )
                .overlay(
                    Circle()
                        .stroke(Theme.surfaceBorder, lineWidth: 1)
                )
        }
        .pressable(scale: 0.9)
    }
}

// MARK: - Pill Button

/// Compact pill-shaped button for inline actions
struct PillButton: View {
    let title: String
    var icon: String? = nil
    var color: Color = Theme.accent
    var isSmall: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.xs) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: isSmall ? 12 : 14, weight: .semibold))
                }

                Text(title)
                    .font(isSmall ? Typography.caption : Typography.label)
            }
            .foregroundColor(color == Theme.accent ? Theme.background : .white)
            .padding(.horizontal, isSmall ? Spacing.sm : Spacing.smd)
            .padding(.vertical, isSmall ? Spacing.xs : Spacing.sm)
            .background(
                Capsule()
                    .fill(color)
            )
        }
        .pressable(scale: 0.95)
    }
}

// MARK: - Preview

#Preview("Button Styles") {
    VStack(spacing: Spacing.lg) {
        PrimaryButton(title: "Continue") {}

        PrimaryButton(title: "Start Sprint", color: Theme.sprint) {}

        PrimaryButton(title: "Disabled", isEnabled: false) {}

        SecondaryButton(title: "Back Home") {}

        TertiaryButton(title: "Skip for now") {}

        HStack(spacing: Spacing.md) {
            IconButton(icon: "xmark") {}
            IconButton(icon: "gear", color: Theme.accent) {}
            IconButton(icon: "arrow.left", backgroundColor: Theme.surfaceElevated) {}
        }

        HStack(spacing: Spacing.sm) {
            PillButton(title: "Easy", color: Theme.success) {}
            PillButton(title: "Medium", icon: "flame", color: Theme.streak) {}
            PillButton(title: "Tag", color: Theme.level, isSmall: true) {}
        }
    }
    .padding(Spacing.lg)
    .background(Theme.background)
}
