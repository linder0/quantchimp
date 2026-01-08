//
//  StatCard.swift
//  quantchimp
//
//  Stat display cards using Theme tokens
//

import SwiftUI

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
                .font(Typography.heading3)
                .foregroundColor(Theme.textPrimary)

            Text(label)
                .font(Typography.caption)
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
                .font(Typography.heading2)
                .foregroundColor(Theme.textPrimary)

            Text(label)
                .font(Typography.caption)
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
                .font(Typography.heading2)
                .foregroundColor(Theme.textPrimary)
                .contentTransition(.numericText())

            Text(label)
                .font(Typography.caption)
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

#Preview("Stat Cards") {
    VStack(spacing: Spacing.lg) {
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

        HStack(spacing: Spacing.smd) {
            StatCardLarge(
                icon: "checkmark.circle.fill",
                value: "15",
                label: "Correct",
                color: Theme.success
            )

            StatCardLarge(
                icon: "percent",
                value: "85%",
                label: "Accuracy",
                color: Theme.sprint
            )
        }

        HStack(spacing: Spacing.smd) {
            AnimatedStatCard(
                icon: "star.fill",
                targetValue: 150,
                label: "XP Earned",
                color: Theme.xp
            )

            AnimatedStatCard(
                icon: "percent",
                targetValue: 92,
                label: "Accuracy",
                color: Theme.success,
                suffix: "%"
            )
        }
    }
    .padding(Spacing.lg)
    .background(Theme.background)
}
