//
//  XPBar.swift
//  quantchimp
//
//  XP progress bar using Theme tokens
//

import SwiftUI

struct XPBar: View {
    let progress: Double
    let level: Int
    let xpToNext: Int
    var showLabels: Bool = true

    @State private var animatedProgress: Double = 0

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            if showLabels {
                HStack {
                    Text("Level \(level)")
                        .font(Typography.label)
                        .foregroundColor(Theme.accent)
                        .fixedSize()

                    Spacer()

                    Text("\(xpToNext) XP to next level")
                        .font(Typography.caption)
                        .foregroundColor(Theme.textSecondary)
                        .fixedSize()
                }
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background track
                    RoundedRectangle(cornerRadius: Radius.full)
                        .fill(Theme.surfaceElevated)
                        .frame(height: 10)

                    // Progress fill with gradient
                    RoundedRectangle(cornerRadius: Radius.full)
                        .fill(Theme.accentGradient)
                        .frame(width: max(0, geometry.size.width * animatedProgress), height: 10)
                        .shadow(color: Theme.accent.opacity(0.4), radius: 4, x: 0, y: 0)
                }
            }
            .frame(height: 10)
        }
        .padding(Spacing.md)
        .cardStyle()
        .onAppear {
            withAnimation(.easeOut(duration: Motion.smooth)) {
                animatedProgress = progress
            }
        }
        .onChange(of: progress) { _, newValue in
            withAnimation(.easeOut(duration: Motion.normal)) {
                animatedProgress = newValue
            }
        }
    }
}

/// Compact inline XP bar for headers
struct XPBarCompact: View {
    let progress: Double

    @State private var animatedProgress: Double = 0

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Theme.surfaceElevated)
                    .frame(height: 6)

                Capsule()
                    .fill(Theme.accentGradient)
                    .frame(width: max(0, geometry.size.width * animatedProgress), height: 6)
            }
        }
        .frame(height: 6)
        .onAppear {
            withAnimation(.easeOut(duration: Motion.smooth)) {
                animatedProgress = progress
            }
        }
        .onChange(of: progress) { _, newValue in
            withAnimation(.easeOut(duration: Motion.normal)) {
                animatedProgress = newValue
            }
        }
    }
}

#Preview("XP Bars") {
    VStack(spacing: Spacing.lg) {
        XPBar(progress: 0.3, level: 2, xpToNext: 140)
        XPBar(progress: 0.75, level: 5, xpToNext: 50)

        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Compact variant")
                .font(Typography.caption)
                .foregroundColor(Theme.textSecondary)

            XPBarCompact(progress: 0.6)
        }
        .padding(Spacing.md)
        .cardStyle()
    }
    .padding(Spacing.lg)
    .background(Theme.background)
}
