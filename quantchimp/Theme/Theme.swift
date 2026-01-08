//
//  Theme.swift
//  quantchimp
//
//  Design System - Color tokens, spacing, radius, and motion definitions
//

import SwiftUI

// MARK: - Color Tokens

/// Semantic color tokens for the QuantChimp design system
/// Dark-mode-first design: "Bloomberg Terminal meets Duolingo"
enum Theme {

    // MARK: - Background Colors

    /// App background - Near-black slate
    static let background = Color(hex: "0F1115")

    /// Cards, elevated elements - Dark gray
    static let surface = Color(hex: "1A1D24")

    /// Modals, popovers - Lighter slate
    static let surfaceElevated = Color(hex: "242830")

    /// Subtle surface border for depth
    static let surfaceBorder = Color.white.opacity(0.08)

    // MARK: - Text Colors

    /// Primary text - Off-white
    static let textPrimary = Color(hex: "F2F4F7")

    /// Secondary/muted text - Gray
    static let textSecondary = Color(hex: "8B95A5")

    /// Tertiary text - Dimmer gray
    static let textTertiary = Color(hex: "5C6370")

    // MARK: - Accent Colors

    /// Brand accent color - Electric amber
    static let accent = Color(hex: "FFB800")

    /// Accent gradient for XP bars, highlights
    static let accentGradient = LinearGradient(
        colors: [Color(hex: "FFB800"), Color(hex: "FFD54F")],
        startPoint: .leading,
        endPoint: .trailing
    )

    /// Secondary accent for variety
    static let accentSecondary = Color(hex: "6366F1") // Indigo

    // MARK: - Semantic Colors

    /// Correct answers - Mint green
    static let success = Color(hex: "10B981")

    /// Wrong answers - Coral red
    static let error = Color(hex: "EF4444")

    /// Warnings, caution - Amber
    static let warning = Color(hex: "F59E0B")

    // MARK: - Gamification Colors

    /// Streak indicators - Flame orange
    static let streak = Color(hex: "FF6B35")

    /// XP indicators - Golden yellow
    static let xp = Color(hex: "FBBF24")

    /// Level/rank - Purple
    static let level = Color(hex: "A855F7")

    /// Daily challenge - Teal
    static let daily = Color(hex: "14B8A6")

    /// Sprint mode - Electric blue
    static let sprint = Color(hex: "3B82F6")

    // MARK: - Gradients

    /// Premium background gradient (subtle)
    static let backgroundGradient = LinearGradient(
        colors: [
            Color(hex: "0F1115"),
            Color(hex: "131620")
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    /// Success gradient for celebrations
    static let successGradient = LinearGradient(
        colors: [Color(hex: "10B981"), Color(hex: "34D399")],
        startPoint: .leading,
        endPoint: .trailing
    )

    /// XP/streak gradient
    static let streakGradient = LinearGradient(
        colors: [Color(hex: "FF6B35"), Color(hex: "FBBF24")],
        startPoint: .leading,
        endPoint: .trailing
    )

    /// Card surface gradient (subtle depth)
    static let surfaceGradient = LinearGradient(
        colors: [
            Color(hex: "1A1D24"),
            Color(hex: "1E2128")
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - Spacing Scale

/// Consistent spacing based on 4px unit
enum Spacing {
    /// 4pt - Tight grouping between related elements
    static let xs: CGFloat = 4

    /// 8pt - Related items, inline spacing
    static let sm: CGFloat = 8

    /// 12pt - Compact component padding
    static let smd: CGFloat = 12

    /// 16pt - Standard padding, between components
    static let md: CGFloat = 16

    /// 24pt - Between sections
    static let lg: CGFloat = 24

    /// 32pt - Major section separators
    static let xl: CGFloat = 32

    /// 48pt - Screen margins, large separations
    static let xxl: CGFloat = 48
}

// MARK: - Radius Scale

/// Corner radius tokens
enum Radius {
    /// 8pt - Small elements: badges, tags
    static let sm: CGFloat = 8

    /// 12pt - Medium elements: buttons, inputs
    static let md: CGFloat = 12

    /// 16pt - Cards, tiles
    static let lg: CGFloat = 16

    /// 20pt - Large cards
    static let xlg: CGFloat = 20

    /// 24pt - Modals, sheets
    static let xl: CGFloat = 24

    /// 999pt - Pills, avatars (fully rounded)
    static let full: CGFloat = 999
}

// MARK: - Motion System

/// Animation curves and durations
enum Motion {
    /// 0.15s - Micro-interactions (button press, toggle)
    static let quick: Double = 0.15

    /// 0.25s - Standard transitions
    static let normal: Double = 0.25

    /// 0.4s - Page transitions, modals
    static let smooth: Double = 0.4

    /// 0.6s - Celebration animations
    static let slow: Double = 0.6

    /// Standard spring animation
    static let spring = Animation.spring(response: 0.35, dampingFraction: 0.7)

    /// Bouncy spring for celebrations
    static let bounce = Animation.spring(response: 0.4, dampingFraction: 0.6)

    /// Snappy spring for quick interactions
    static let snappy = Animation.spring(response: 0.25, dampingFraction: 0.8)

    /// Smooth ease for fades
    static func ease(_ duration: Double = normal) -> Animation {
        .easeInOut(duration: duration)
    }
}

// MARK: - Shadow Tokens

/// Shadow definitions for elevation
enum Shadow {
    /// Subtle shadow for cards
    static let sm = (color: Color.black.opacity(0.15), radius: 4.0, x: 0.0, y: 2.0)

    /// Medium shadow for elevated cards
    static let md = (color: Color.black.opacity(0.2), radius: 8.0, x: 0.0, y: 4.0)

    /// Large shadow for modals
    static let lg = (color: Color.black.opacity(0.25), radius: 16.0, x: 0.0, y: 8.0)

    /// Glow effect for accents
    static func glow(_ color: Color, radius: CGFloat = 12) -> (color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) {
        (color: color.opacity(0.4), radius: radius, x: 0, y: 0)
    }
}

// MARK: - Color Extension

extension Color {
    /// Initialize Color from hex string
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - View Extensions

extension View {
    /// Apply standard surface shadow
    func surfaceShadow() -> some View {
        self.shadow(
            color: Shadow.md.color,
            radius: Shadow.md.radius,
            x: Shadow.md.x,
            y: Shadow.md.y
        )
    }

    /// Apply glow effect
    func glowEffect(_ color: Color, radius: CGFloat = 12) -> some View {
        let glow = Shadow.glow(color, radius: radius)
        return self.shadow(
            color: glow.color,
            radius: glow.radius,
            x: glow.x,
            y: glow.y
        )
    }
}

// MARK: - Preview

#Preview("Theme Colors") {
    ScrollView {
        VStack(spacing: Spacing.lg) {
            // Backgrounds
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text("Backgrounds")
                    .font(.headline)
                    .foregroundColor(Theme.textPrimary)

                HStack(spacing: Spacing.sm) {
                    colorSwatch("background", Theme.background)
                    colorSwatch("surface", Theme.surface)
                    colorSwatch("elevated", Theme.surfaceElevated)
                }
            }

            // Text
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text("Text Colors")
                    .font(.headline)
                    .foregroundColor(Theme.textPrimary)

                HStack(spacing: Spacing.sm) {
                    colorSwatch("primary", Theme.textPrimary)
                    colorSwatch("secondary", Theme.textSecondary)
                    colorSwatch("tertiary", Theme.textTertiary)
                }
            }

            // Semantic
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text("Semantic Colors")
                    .font(.headline)
                    .foregroundColor(Theme.textPrimary)

                HStack(spacing: Spacing.sm) {
                    colorSwatch("accent", Theme.accent)
                    colorSwatch("success", Theme.success)
                    colorSwatch("error", Theme.error)
                }
            }

            // Gamification
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text("Gamification")
                    .font(.headline)
                    .foregroundColor(Theme.textPrimary)

                HStack(spacing: Spacing.sm) {
                    colorSwatch("streak", Theme.streak)
                    colorSwatch("xp", Theme.xp)
                    colorSwatch("level", Theme.level)
                }
            }
        }
        .padding(Spacing.lg)
    }
    .background(Theme.background)
}

@ViewBuilder
private func colorSwatch(_ name: String, _ color: Color) -> some View {
    VStack(spacing: Spacing.xs) {
        RoundedRectangle(cornerRadius: Radius.sm)
            .fill(color)
            .frame(width: 60, height: 60)
            .overlay(
                RoundedRectangle(cornerRadius: Radius.sm)
                    .stroke(Theme.surfaceBorder, lineWidth: 1)
            )

        Text(name)
            .font(.caption2)
            .foregroundColor(Theme.textSecondary)
    }
}
