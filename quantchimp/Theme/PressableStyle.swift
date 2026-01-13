//
//  PressableStyle.swift
//  quantchimp
//
//  Reusable press animation modifier for interactive elements
//

import SwiftUI

// MARK: - Pressable Modifier

/// Adds press-down scale animation to any view
struct PressableModifier: ViewModifier {
    var scale: CGFloat
    var animation: Animation

    @State private var isPressed = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? scale : 1.0)
            .animation(animation, value: isPressed)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in isPressed = true }
                    .onEnded { _ in isPressed = false }
            )
    }
}

// MARK: - View Extension

extension View {
    /// Apply press-down scale animation
    /// - Parameters:
    ///   - scale: Scale factor when pressed (default: 0.98)
    ///   - animation: Animation to use (default: Motion.snappy)
    func pressable(scale: CGFloat = 0.98, animation: Animation = Motion.snappy) -> some View {
        modifier(PressableModifier(scale: scale, animation: animation))
    }
}

// MARK: - Preview

#Preview("Pressable") {
    VStack(spacing: Spacing.lg) {
        Text("Press Me")
            .font(Typography.headline)
            .foregroundColor(Theme.textPrimary)
            .padding(Spacing.md)
            .cardStyle()
            .pressable()

        Text("Smaller Scale")
            .font(Typography.headline)
            .foregroundColor(Theme.textPrimary)
            .padding(Spacing.md)
            .cardStyle()
            .pressable(scale: 0.95)
    }
    .padding(Spacing.lg)
    .background(Theme.background)
}

