//
//  SprintResultView.swift
//  quantchimp
//
//  Sprint result view - Full screen immersive modal
//

import SwiftUI

struct SprintResultView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var statsManager: StatsManager

    let correctCount: Int
    let totalAttempts: Int
    let difficulty: Difficulty
    let duration: Duration
    let onDismiss: () -> Void
    let onPlayAgain: () -> Void

    @State private var hasUpdatedXP = false
    @State private var showXPAnimation = false
    @State private var showContent = false

    private var accuracy: Double {
        guard totalAttempts > 0 else { return 0 }
        return Double(correctCount) / Double(totalAttempts) * 100
    }

    private var xpEarned: Int {
        min(correctCount * 10, 200)
    }

    private var performanceMessage: String {
        if correctCount >= 20 {
            return "Outstanding!"
        } else if correctCount >= 15 {
            return "Excellent!"
        } else if correctCount >= 10 {
            return "Great job!"
        } else if correctCount >= 5 {
            return "Good effort!"
        } else {
            return "Keep practicing!"
        }
    }

    private var performanceImage: String {
        if correctCount >= 20 { return "monkey_outstanding" }
        else if correctCount >= 15 { return "monkey_excellent" }
        else if correctCount >= 10 { return "monkey_great" }
        else if correctCount >= 5 { return "monkey_good" }
        else { return "monkey_practice" }
    }

    var body: some View {
        ZStack {
            Theme.background
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: Spacing.lg) {
                    // Close button
                    HStack {
                        Spacer()
                        Button {
                            onDismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Theme.textSecondary)
                                .frame(width: 40, height: 40)
                                .background(Theme.surfaceElevated)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.top, Spacing.lg)

                    // Result header
                    resultHeader

                    // Stats grid
                    statsGrid

                    // XP earned
                    xpCard

                    Spacer(minLength: 40)

                    // Action buttons
                    actionButtons
                }
                .padding(.horizontal, Spacing.md)
                .padding(.bottom, Spacing.xl)
            }
            .scrollIndicators(.hidden)
            .opacity(showContent ? 1 : 0)
            .scaleEffect(showContent ? 1 : 0.9)
        }
        .onAppear {
            updateXPIfNeeded()
            withAnimation(Motion.spring.delay(0.1)) {
                showContent = true
            }
        }
    }

    private var resultHeader: some View {
        VStack(spacing: Spacing.md) {
            Image(performanceImage)
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)

            Text("Sprint Complete!")
                .font(Typography.displaySmall)
                .foregroundColor(Theme.textPrimary)

            Text(performanceMessage)
                .font(Typography.heading3)
                .foregroundColor(Theme.textSecondary)

            // Duration info
            Text("\(duration.displayTime) • \(difficulty.rawValue)")
                .font(Typography.caption)
                .foregroundColor(Theme.textTertiary)
        }
        .padding(.top, Spacing.md)
    }

    private var statsGrid: some View {
        HStack(spacing: Spacing.smd) {
            StatCardLarge(
                icon: "checkmark.circle.fill",
                value: "\(correctCount)",
                label: "Correct",
                color: Theme.success
            )

            StatCardLarge(
                icon: "percent",
                value: String(format: "%.0f%%", accuracy),
                label: "Accuracy",
                color: Theme.sprint
            )

            StatCardLarge(
                icon: "number",
                value: "\(totalAttempts)",
                label: "Attempts",
                color: Theme.accent
            )
        }
    }

    private var xpCard: some View {
        VStack(spacing: Spacing.smd) {
            HStack(spacing: Spacing.sm) {
                Image(systemName: "star.fill")
                    .font(.title)
                    .foregroundColor(Theme.xp)

                Text("+\(xpEarned) XP")
                    .font(Typography.heading2)
                    .foregroundColor(Theme.textPrimary)
            }
            .scaleEffect(showXPAnimation ? 1.1 : 1.0)
            .animation(Motion.bounce, value: showXPAnimation)
        }
        .frame(maxWidth: .infinity)
        .padding(Spacing.lg)
        .background(
            LinearGradient(
                colors: [Theme.xp.opacity(0.2), Theme.accent.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(Radius.lg)
        .overlay(
            RoundedRectangle(cornerRadius: Radius.lg)
                .stroke(Theme.xp.opacity(0.3), lineWidth: 1)
        )
        .onAppear {
            withAnimation(Motion.ease(Motion.normal).delay(0.5)) {
                showXPAnimation = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation {
                    showXPAnimation = false
                }
            }
        }
    }

    private var actionButtons: some View {
        VStack(spacing: Spacing.smd) {
            PrimaryButton(title: "Play Again", color: Theme.sprint) {
                onPlayAgain()
            }

            SecondaryButton(title: "Back Home") {
                onDismiss()
            }
        }
    }

    private func updateXPIfNeeded() {
        guard !hasUpdatedXP else { return }
        hasUpdatedXP = true
        appState.addArithmeticXP(correctCount: correctCount)

        // Play celebration sound for good performance
        if correctCount >= 5 {
            Sound.celebration()
        }

        // Record session to stats
        let session = SessionRecord(
            mode: .sprint,
            questionsAnswered: totalAttempts,
            correctCount: correctCount,
            xpEarned: xpEarned
        )
        statsManager.recordSession(session)
    }
}

#Preview {
    SprintResultView(
        correctCount: 12,
        totalAttempts: 15,
        difficulty: .medium,
        duration: .blitz,
        onDismiss: {},
        onPlayAgain: {}
    )
    .environmentObject(AppState())
    .environmentObject(StatsManager())
}
