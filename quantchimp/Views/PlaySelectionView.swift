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
                ScrollView(showsIndicators: false) {
                    VStack(spacing: Spacing.lg) {
                        // CLASSIC Section
                        VStack(spacing: Spacing.smd) {
                            SectionCard(
                                icon: "brain.head.profile",
                                title: "CLASSIC",
                                description: "Practice your mental math skills"
                            )

                            // Classic game modes - side by side cards
                            HStack(spacing: Spacing.smd) {
                                ForEach(GameMode.activeModesForCards) { mode in
                                    PlayOptionCard(
                                        imageName: mode.imageName,
                                        title: mode.rawValue,
                                        subtitle: mode.subtitle(for: appState),
                                        isCompleted: mode.isCompleted(for: appState),
                                        imageOffset: mode.imageOffset,
                                        imageSize: mode.imageSize
                                    ) {
                                        dismiss()
                                        handleGameModeSelection(mode)
                                    }
                                }
                            }
                        }

                        // POKER Section
                        VStack(spacing: Spacing.smd) {
                            SectionCard(
                                icon: "suit.spade.fill",
                                title: "POKER",
                                description: "Combine math with poker hands"
                            )

                            // Poker game mode
                            PlayOptionCard(
                                imageName: GameMode.poker.imageName,
                                title: GameMode.poker.rawValue,
                                subtitle: GameMode.poker.subtitle(for: appState),
                                isCompleted: false,
                                imageOffset: GameMode.poker.imageOffset,
                                imageSize: GameMode.poker.imageSize
                            ) {
                                dismiss()
                                handleGameModeSelection(.poker)
                            }
                        }

                        // Future modes (disabled)
                        ForEach(GameMode.disabledModesForTiles) { mode in
                            PlayOptionTile(
                                imageName: mode.imageName,
                                title: mode.rawValue,
                                subtitle: mode.subtitle(for: appState),
                                isDisabled: true
                            ) {}
                        }
                    }
                    .padding(.horizontal, Spacing.lg)
                    .padding(.top, Spacing.lg)
                    .padding(.bottom, Spacing.xl)
                }

                Spacer()
            }
        }
    }

    private func handleGameModeSelection(_ mode: GameMode) {
        switch mode {
        case .daily:
            onSelectDaily()
        case .sprint:
            onSelectSprint()
        case .poker:
            break // Handled directly in HomeView
        case .tournament, .challenge:
            break // Disabled modes
        }
    }
}

// MARK: - Section Card Component
struct SectionCard: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: Spacing.md) {
            // Icon
            Image(systemName: icon)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(Theme.accent)
                .frame(width: 44, height: 44)
                .background(Theme.accent.opacity(0.15))
                .clipShape(Circle())

            // Text content
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(title)
                    .font(Typography.bodyBold)
                    .foregroundColor(Theme.textPrimary)

                Text(description)
                    .font(Typography.caption)
                    .foregroundColor(Theme.textSecondary)
            }

            Spacer()
        }
        .padding(Spacing.md)
        .background(Theme.surfaceElevated)
        .cornerRadius(Radius.md)
    }
}

#Preview {
    PlaySelectionView(
        onSelectDaily: {},
        onSelectSprint: {}
    )
    .environmentObject(AppState())
}
