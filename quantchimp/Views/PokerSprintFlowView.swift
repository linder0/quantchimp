//
//  PokerSprintFlowView.swift
//  quantchimp
//
//  Full-screen modal flow for Poker Sprint (Setup -> Play -> Results)
//

import SwiftUI

struct PokerSprintFlowView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var statsManager: StatsManager

    @State private var phase: SprintPhase = .setup
    @State private var selectedDifficulty: Difficulty = .medium
    @State private var showHandNames: Bool = true

    // Fixed duration: all poker sprints are 60 seconds
    private let sprintDuration: Duration = .bullet

    // Results data
    @State private var correctCount = 0
    @State private var totalAttempts = 0

    enum SprintPhase {
        case setup
        case playing
        case results
    }

    var body: some View {
        ZStack {
            Theme.background
                .ignoresSafeArea()

            switch phase {
            case .setup:
                setupPhase
                    .transition(.opacity)

            case .playing:
                PokerGameView(
                    difficulty: selectedDifficulty,
                    duration: sprintDuration,
                    showHandNames: showHandNames,
                    onComplete: { correct, total in
                        correctCount = correct
                        totalAttempts = total
                        withAnimation(Motion.spring) {
                            phase = .results
                        }
                    },
                    onExit: {
                        dismiss()
                    }
                )
                .transition(.opacity)

            case .results:
                PokerResultView(
                    correctCount: correctCount,
                    totalAttempts: totalAttempts,
                    difficulty: selectedDifficulty,
                    duration: sprintDuration,
                    onDismiss: {
                        dismiss()
                    },
                    onPlayAgain: {
                        // Reset and go back to setup
                        correctCount = 0
                        totalAttempts = 0
                        withAnimation(Motion.spring) {
                            phase = .setup
                        }
                    }
                )
                .transition(.opacity)
            }
        }
    }

    // MARK: - Setup Phase

    private var setupPhase: some View {
        VStack(spacing: 0) {
            // Header with close button
            ModalHeader(title: "Poker Sprint") {
                dismiss()
            }

            // Difficulty carousel - takes flexible space
            GenericDifficultyCarousel(selectedDifficulty: $selectedDifficulty) { difficulty in
                PokerDifficultyCard(difficulty: difficulty)
            }
            .onChange(of: selectedDifficulty) { _, newValue in
                // Auto-enable hand names for Easy difficulty
                if newValue == .easy {
                    showHandNames = true
                }
            }

            // Bottom controls - fixed height section
            VStack(spacing: Spacing.smd) {
                // Show hand names toggle
                handNamesToggle

                // Start button - stylized
                startSprintButton
            }
            .padding(.horizontal, Spacing.md)
            .padding(.top, Spacing.smd)
            .padding(.bottom, Spacing.lg)
        }
    }

    // MARK: - Hand Names Toggle

    private var handNamesToggle: some View {
        Toggle(isOn: $showHandNames) {
            HStack(spacing: Spacing.sm) {
                Image(systemName: showHandNames ? "eye.fill" : "eye.slash.fill")
                    .font(.system(size: 16))
                    .foregroundColor(showHandNames ? Theme.accent : Theme.textTertiary)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Show Hand Names")
                        .font(Typography.bodyBold)
                        .foregroundColor(Theme.textPrimary)

                    Text(showHandNames ? "Hand names visible" : "Test your knowledge")
                        .font(Typography.caption)
                        .foregroundColor(Theme.textSecondary)
                }
            }
        }
        .toggleStyle(SwitchToggleStyle(tint: Theme.accent))
        .padding(Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Radius.md)
                .fill(Theme.surface)
        )
        .onChange(of: showHandNames) { _, _ in
            Haptic.selection()
            Sound.select()
        }
    }

    // MARK: - Start Sprint Button

    private var startSprintButton: some View {
        PrimaryButton(title: "Start Poker Sprint", color: Theme.accent) {
            withAnimation(Motion.spring) {
                phase = .playing
            }
        }
    }
}

// MARK: - Poker Difficulty Card

struct PokerDifficultyCard: View {
    let difficulty: Difficulty

    var body: some View {
        ZStack(alignment: .bottom) {
            // Monkey mascot image - always anchored at bottom, fixed position
            Image(difficulty.imageName)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .padding(.horizontal, Spacing.lg)
                .padding(.bottom, Spacing.md)

            // Content overlay
            VStack(spacing: 0) {
                // Title with difficulty color - ON TOP
                Text(difficulty.rawValue.uppercased())
                    .font(Typography.displaySmall)
                    .foregroundColor(difficulty.color)
                    .padding(.top, Spacing.lg)

                // Poker-specific descriptions
                VStack(spacing: Spacing.xs) {
                    difficultyInfoRow(
                        label: "Hand Comparison",
                        value: difficulty.pokerDescription
                    )
                }
                .padding(.horizontal, Spacing.lg)
                .padding(.top, Spacing.md)

                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: Radius.xlg)
                .fill(Theme.surface)
        )
        .padding(.horizontal, Spacing.md)
    }

    private func difficultyInfoRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(Typography.caption)
                .foregroundColor(Theme.textSecondary)

            Spacer()

            Text(value)
                .font(Typography.label)
                .foregroundColor(Theme.textPrimary)
        }
    }
}

#Preview {
    PokerSprintFlowView()
        .environmentObject(AppState())
        .environmentObject(StatsManager())
}
