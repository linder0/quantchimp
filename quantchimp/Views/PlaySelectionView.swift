//
//  PlaySelectionView.swift
//  quantchimp
//
//  Play mode selection using Theme tokens
//

import SwiftUI

struct PlaySelectionView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss

    let onSelectDaily: () -> Void
    let onSelectSprint: () -> Void

    var body: some View {
        ZStack {
            // Dark background
            Theme.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                VStack(spacing: Spacing.md) {
                    // Close button
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.title3.weight(.semibold))
                                .foregroundColor(Theme.textSecondary)
                                .frame(width: 40, height: 40)
                                .background(Theme.surfaceElevated)
                                .clipShape(Circle())
                        }

                        Spacer()
                    }
                    .padding(.horizontal, Spacing.md)

                    // Title
                    Text("Play")
                        .font(Typography.displaySmall)
                        .foregroundColor(Theme.textPrimary)

                    // Mascot
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Theme.accent.opacity(0.3), Theme.xp.opacity(0.2)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 100, height: 100)

                        Text("🐵")
                            .font(.system(size: 50))
                    }
                }
                .padding(.top, Spacing.lg)
                .padding(.bottom, Spacing.xl)
                .frame(maxWidth: .infinity)
                .background(Theme.surfaceGradient)

                // Game mode options
                VStack(spacing: Spacing.smd) {
                    // Daily Puzzle
                    PlayOptionTile(
                        icon: "brain.head.profile",
                        emoji: "🧠",
                        title: "Daily Puzzle",
                        subtitle: appState.completedDailyToday ? "Completed today" : "Ready to play",
                        isCompleted: appState.completedDailyToday,
                        color: Theme.daily
                    ) {
                        dismiss()
                        onSelectDaily()
                    }

                    // Arithmetic Sprint
                    PlayOptionTile(
                        icon: "timer",
                        emoji: "⚡",
                        title: "Arithmetic Sprint",
                        subtitle: "60 second challenge",
                        isCompleted: false,
                        color: Theme.sprint
                    ) {
                        dismiss()
                        onSelectSprint()
                    }

                    // Future modes (disabled)
                    PlayOptionTile(
                        icon: "trophy.fill",
                        emoji: "🏆",
                        title: "Tournaments",
                        subtitle: "Coming soon",
                        isCompleted: false,
                        color: Theme.xp,
                        isDisabled: true
                    ) {}

                    PlayOptionTile(
                        icon: "person.2.fill",
                        emoji: "🤝",
                        title: "Challenge a Friend",
                        subtitle: "Coming soon",
                        isCompleted: false,
                        color: Theme.success,
                        isDisabled: true
                    ) {}
                }
                .padding(.horizontal, Spacing.lg)
                .padding(.top, Spacing.lg)

                Spacer()
            }
        }
    }
}

#Preview {
    PlaySelectionView(
        onSelectDaily: {},
        onSelectSprint: {}
    )
    .environmentObject(AppState())
}
