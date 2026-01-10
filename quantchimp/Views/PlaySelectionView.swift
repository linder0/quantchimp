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
                    Text("PLAY")
                        .font(Typography.displaySmall)
                        .foregroundColor(Theme.textPrimary)

                    // Mascot
                    Image("avatar_default")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                }
                .padding(.top, Spacing.lg)
                .padding(.bottom, Spacing.xl)
                .frame(maxWidth: .infinity)
                .background(Theme.surfaceGradient)

                // Game mode options
                VStack(spacing: Spacing.smd) {
                    // Active game modes - side by side cards
                    HStack(spacing: Spacing.smd) {
                        PlayOptionCard(
                            imageName: "monkey_daily_puzzle",
                            title: "Daily Puzzle",
                            subtitle: appState.completedDailyToday ? "Completed" : "Ready to play",
                            isCompleted: appState.completedDailyToday,
                            imageOffset: 10
                        ) {
                            dismiss()
                            onSelectDaily()
                        }

                        PlayOptionCard(
                            imageName: "monkey_sprint",
                            title: "Sprint",
                            subtitle: "60 second challenge",
                            imageOffset: 20,
                            imageSize: 160
                        ) {
                            dismiss()
                            onSelectSprint()
                        }
                    }

                    // Future modes (disabled)
                    PlayOptionTile(
                        imageName: "monkey_tournament",
                        title: "Tournaments",
                        subtitle: "Coming soon",
                        isDisabled: true
                    ) {}

                    PlayOptionTile(
                        imageName: "monkey_challenge",
                        title: "Challenge a Friend",
                        subtitle: "Coming soon",
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
