//
//  XPEarnedBadge.swift
//  quantchimp
//
//  Reusable XP earned badge with animation for result views
//

import SwiftUI

/// Animated XP badge shown on result screens
struct XPEarnedBadge: View {
    let xpEarned: Int
    var style: Style = .large

    @State private var showAnimation = false

    enum Style {
        case large   // For result screens
        case compact // For inline use
    }

    var body: some View {
        HStack(spacing: style == .large ? Spacing.sm : Spacing.xs) {
            Image(systemName: "star.fill")
                .font(style == .large ? .title : .body)
                .foregroundColor(Theme.xp)

            Text("+\(xpEarned) XP")
                .font(style == .large ? Typography.heading2 : Typography.headline)
                .foregroundColor(Theme.textPrimary)
        }
        .padding(.horizontal, style == .large ? Spacing.lg : Spacing.smd)
        .padding(.vertical, style == .large ? Spacing.lg : Spacing.smd)
        .background(
            Group {
                if style == .large {
                    LinearGradient(
                        colors: [Theme.xp.opacity(0.2), Theme.accent.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                } else {
                    Theme.xp.opacity(0.2)
                }
            }
        )
        .cornerRadius(style == .large ? Radius.lg : Radius.full)
        .overlay(
            RoundedRectangle(cornerRadius: style == .large ? Radius.lg : Radius.full)
                .stroke(Theme.xp.opacity(0.3), lineWidth: 1)
        )
        .scaleEffect(showAnimation ? 1.1 : 1.0)
        .animation(Motion.bounce, value: showAnimation)
        .onAppear {
            withAnimation(Motion.ease(Motion.normal).delay(0.3)) {
                showAnimation = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                withAnimation {
                    showAnimation = false
                }
            }
        }
    }
}

#Preview("XP Badges") {
    VStack(spacing: Spacing.lg) {
        XPEarnedBadge(xpEarned: 150, style: .large)
        XPEarnedBadge(xpEarned: 50, style: .compact)
    }
    .padding(Spacing.lg)
    .background(Theme.background)
}
