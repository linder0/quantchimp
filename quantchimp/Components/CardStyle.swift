//
//  CardStyle.swift
//  quantchimp
//
//  Card styling system using Theme tokens
//

import SwiftUI

// MARK: - Card Style Modifier

/// Standard card modifier with surface background and shadow
struct CardStyle: ViewModifier {
    var cornerRadius: CGFloat = Radius.lg
    var hasBorder: Bool = true

    func body(content: Content) -> some View {
        content
            .background(Theme.surface)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(hasBorder ? Theme.surfaceBorder : .clear, lineWidth: 1)
            )
            .surfaceShadow()
    }
}

/// Elevated card modifier with gradient background
struct CardElevatedStyle: ViewModifier {
    var cornerRadius: CGFloat = Radius.lg

    func body(content: Content) -> some View {
        content
            .background(Theme.surfaceGradient)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Theme.surfaceBorder, lineWidth: 1)
            )
            .shadow(
                color: Shadow.md.color,
                radius: Shadow.md.radius,
                x: Shadow.md.x,
                y: Shadow.md.y
            )
    }
}

/// Glass-morphism card style
struct CardGlassStyle: ViewModifier {
    var cornerRadius: CGFloat = Radius.lg

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Theme.surface.opacity(0.7))
                    .background(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(.ultraThinMaterial)
                    )
            )
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.15),
                                Color.white.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
    }
}

// MARK: - View Extensions

extension View {
    /// Apply standard card styling
    func cardStyle(cornerRadius: CGFloat = Radius.lg, hasBorder: Bool = true) -> some View {
        modifier(CardStyle(cornerRadius: cornerRadius, hasBorder: hasBorder))
    }

    /// Apply elevated card styling with gradient
    func cardElevated(cornerRadius: CGFloat = Radius.lg) -> some View {
        modifier(CardElevatedStyle(cornerRadius: cornerRadius))
    }

    /// Apply glass-morphism card styling
    func cardGlass(cornerRadius: CGFloat = Radius.lg) -> some View {
        modifier(CardGlassStyle(cornerRadius: cornerRadius))
    }
}

// MARK: - Preview

#Preview("Card Styles") {
    VStack(spacing: Spacing.lg) {
        Text("Standard Card")
            .font(Typography.headline)
            .foregroundColor(Theme.textPrimary)
            .padding(Spacing.md)
            .frame(maxWidth: .infinity)
            .cardStyle()

        Text("Elevated Card")
            .font(Typography.headline)
            .foregroundColor(Theme.textPrimary)
            .padding(Spacing.md)
            .frame(maxWidth: .infinity)
            .cardElevated()

        Text("Glass Card")
            .font(Typography.headline)
            .foregroundColor(Theme.textPrimary)
            .padding(Spacing.md)
            .frame(maxWidth: .infinity)
            .cardGlass()
    }
    .padding(Spacing.lg)
    .background(Theme.background)
}
