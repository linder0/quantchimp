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
        case .tournament, .challenge:
            break // Disabled modes
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
