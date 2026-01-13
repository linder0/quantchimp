//
//  StatCard.swift
//  quantchimp
//
//  Stat display cards using Theme tokens
//

import SwiftUI

// MARK: - Circular Progress Ring

/// Animated circular progress indicator with glow effect
struct CircularProgress: View {
    let progress: Double
    let color: Color
    var lineWidth: CGFloat = 8
    var size: CGFloat = 60
    var showBackground: Bool = true

    @State private var animatedProgress: Double = 0

    var body: some View {
        ZStack {
            // Background ring
            if showBackground {
                Circle()
                    .stroke(
                        color.opacity(0.15),
                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                    )
            }

            // Progress ring
            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(
                    AngularGradient(
                        colors: [color, color.opacity(0.7), color],
                        center: .center,
                        startAngle: .degrees(0),
                        endAngle: .degrees(360)
                    ),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .shadow(color: color.opacity(0.5), radius: lineWidth / 2, x: 0, y: 0)
        }
        .frame(width: size, height: size)
        .onAppear {
            withAnimation(.easeOut(duration: Motion.slow)) {
                animatedProgress = min(1.0, max(0, progress))
            }
        }
        .onChange(of: progress) { _, newValue in
            withAnimation(.easeOut(duration: Motion.normal)) {
                animatedProgress = min(1.0, max(0, newValue))
            }
        }
    }
}

/// Large circular progress for hero sections (level ring)
struct LevelRing: View {
    let level: Int
    let progress: Double
    let color: Color
    var size: CGFloat = 160

    @State private var animatedProgress: Double = 0
    @State private var showLevel = false

    private var ringSize: CGFloat { size * 0.875 }
    private var lineWidth: CGFloat { size * 0.075 }
    private var glowWidth: CGFloat { size * 0.125 }
    private var levelFontSize: CGFloat { size * 0.25 }
    private var labelFontSize: CGFloat { size * 0.07 }

    var body: some View {
        ZStack {
            // Outer glow ring
            Circle()
                .stroke(color.opacity(0.1), lineWidth: glowWidth)

            // Background track
            Circle()
                .stroke(
                    color.opacity(0.25),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .frame(width: ringSize, height: ringSize)

            // Progress ring
            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(
                    color,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .frame(width: ringSize, height: ringSize)
                .rotationEffect(.degrees(-90))
                .shadow(color: color.opacity(0.5), radius: 4)

            // Level text
            VStack(spacing: 2) {
                Text("LEVEL")
                    .font(.system(size: labelFontSize, weight: .semibold))
                    .foregroundColor(color.opacity(0.9))
                    .opacity(showLevel ? 1 : 0)

                Text("\(level)")
                    .font(.system(size: levelFontSize, weight: .bold))
                    .foregroundColor(color)
                    .scaleEffect(showLevel ? 1 : 0.5)
                    .opacity(showLevel ? 1 : 0)
            }
        }
        .frame(width: size, height: size)
        .onAppear {
            withAnimation(.easeOut(duration: Motion.slow)) {
                animatedProgress = min(1.0, max(0, progress))
            }
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.2)) {
                showLevel = true
            }
        }
    }
}

// MARK: - Section Header

/// Reusable section header with uppercase styling (muted like Duolingo)
struct SectionHeader: View {
    let title: String

    var body: some View {
        Text(title.uppercased())
            .font(Typography.headline as Font)
            .foregroundColor(Theme.textSecondary)
    }
}

// MARK: - Section Divider

/// Horizontal divider between sections
struct SectionDivider: View {
    var body: some View {
        Rectangle()
            .fill(Theme.textSecondary.opacity(0.3))
            .frame(height: 1)
            .padding(.vertical, Spacing.sm)
    }
}

/// Unified stat card component used across HomeView, StatsView, and ResultViews
struct StatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: Spacing.sm) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)

            Text(value)
                .font(Typography.heading3 as Font)
                .foregroundColor(Theme.textPrimary)

            Text(label)
                .font(Typography.caption as Font)
                .foregroundColor(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.smd)
        .cardStyle()
    }
}

/// Larger stat card variant for result screens
struct StatCardLarge: View {
    let icon: String
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: Spacing.sm) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)

            Text(value)
                .font(Typography.heading2 as Font)
                .foregroundColor(Theme.textPrimary)

            Text(label)
                .font(Typography.caption as Font)
                .foregroundColor(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.md)
        .cardStyle()
    }
}

/// Animated stat card that counts up
struct AnimatedStatCard: View {
    let icon: String
    let targetValue: Int
    let label: String
    let color: Color
    var suffix: String = ""

    @State private var displayValue: Int = 0

    var body: some View {
        VStack(spacing: Spacing.sm) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)

            Text("\(displayValue)\(suffix)")
                .font(Typography.heading2 as Font)
                .foregroundColor(Theme.textPrimary)
                .contentTransition(.numericText())

            Text(label)
                .font(Typography.caption as Font)
                .foregroundColor(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.md)
        .cardStyle()
        .onAppear {
            withAnimation(.easeOut(duration: Motion.slow)) {
                displayValue = targetValue
            }
        }
    }
}

/// Stat card with circular progress ring
struct RingStatCard: View {
    let value: String
    let label: String
    let progress: Double
    let color: Color
    var icon: String? = nil

    var body: some View {
        VStack(spacing: Spacing.smd) {
            ZStack {
                CircularProgress(
                    progress: progress,
                    color: color,
                    lineWidth: 6,
                    size: 56
                )

                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(color)
                } else {
                    Text(value)
                        .font(Typography.label as Font)
                        .foregroundColor(color)
                }
            }

            Text(value)
                .font(Typography.heading3 as Font)
                .foregroundColor(Theme.textPrimary)
                .opacity(icon != nil ? 1 : 0)

            Text(label)
                .font(Typography.caption as Font)
                .foregroundColor(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity, minHeight: 130)
        .padding(.vertical, Spacing.md)
        .padding(.horizontal, Spacing.sm)
        .background(Theme.surfaceElevated)
        .cardStyle()
    }
}

/// Compact ring stat for inline displays
struct CompactRingStat: View {
    let value: String
    let label: String
    let progress: Double
    let color: Color

    var body: some View {
        HStack(spacing: Spacing.smd) {
            ZStack {
                CircularProgress(
                    progress: progress,
                    color: color,
                    lineWidth: 4,
                    size: 40
                )

                Text(value)
                    .font(Typography.captionSmall as Font)
                    .foregroundColor(color)
            }

            Text(label)
                .font(Typography.caption as Font)
                .foregroundColor(Theme.textSecondary)
        }
    }
}

#Preview("Stat Cards") {
    ScrollView {
        VStack(spacing: Spacing.lg) {
            // Original stat cards
            HStack(spacing: Spacing.smd) {
                StatCard(
                    icon: "flame.fill",
                    value: "7",
                    label: "Streak",
                    color: Theme.streak
                )

                StatCard(
                    icon: "trophy.fill",
                    value: "12",
                    label: "Best",
                    color: Theme.level
                )
            }

            // Ring stat cards
            HStack(spacing: Spacing.smd) {
                RingStatCard(
                    value: "156",
                    label: "Questions",
                    progress: 0.78,
                    color: Theme.sprint,
                    icon: "questionmark"
                )

                RingStatCard(
                    value: "142",
                    label: "Correct",
                    progress: 0.91,
                    color: Theme.success,
                    icon: "checkmark"
                )

                RingStatCard(
                    value: "91%",
                    label: "Accuracy",
                    progress: 0.91,
                    color: Theme.level
                )
            }

            // Level ring
            LevelRing(
                level: 7,
                progress: 0.65,
                color: Theme.level
            )
            .padding(.vertical, Spacing.lg)

            // Compact ring stats
            HStack(spacing: Spacing.lg) {
                CompactRingStat(
                    value: "85%",
                    label: "Daily",
                    progress: 0.85,
                    color: Theme.daily
                )

                CompactRingStat(
                    value: "72%",
                    label: "Sprint",
                    progress: 0.72,
                    color: Theme.sprint
                )
            }
            .padding(Spacing.md)
            .cardStyle()
        }
        .padding(Spacing.lg)
    }
    .background(Theme.background)
}
