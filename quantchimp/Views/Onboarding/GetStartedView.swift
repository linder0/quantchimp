//
//  GetStartedView.swift
//  quantchimp
//
//  Get started onboarding using Theme tokens
//

import SwiftUI

struct GetStartedView: View {
    @EnvironmentObject var appState: AppState
    let selectedGoal: UserGoal?
    let onComplete: () -> Void
    let onBack: () -> Void

    @State private var contentOpacity: Double = 0
    @State private var mascotScale: CGFloat = 0.5
    @State private var showConfetti: Bool = false
    @State private var confettiPieces: [ConfettiPiece] = []
    @State private var viewSize: CGSize = .zero

    var body: some View {
        ZStack {
            // Capture view size
            GeometryReader { geometry in
                Color.clear
                    .onAppear {
                        viewSize = geometry.size
                    }
                    .onChange(of: geometry.size) { _, newSize in
                        viewSize = newSize
                    }
            }

            // Confetti layer
            ForEach(confettiPieces) { piece in
                ConfettiView(piece: piece, viewSize: viewSize)
            }

            VStack(spacing: 0) {
                Spacer()

                // Celebration mascot
                ZStack {
                    // Glow
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Theme.accent.opacity(0.4),
                                    Theme.accent.opacity(0.1),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 40,
                                endRadius: 140
                            )
                        )
                        .frame(width: 280, height: 280)

                    // Circle
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Theme.accent.opacity(0.25), Theme.xp.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 160, height: 160)
                        .overlay(
                            Circle()
                                .stroke(Theme.accent.opacity(0.4), lineWidth: 4)
                        )

                    Text("🎉")
                        .font(.system(size: 80))
                }
                .scaleEffect(mascotScale)

                Spacer()
                    .frame(height: 40)

                // Title
                VStack(spacing: Spacing.md) {
                    Text("You're All Set!")
                        .font(Typography.displaySmall)
                        .foregroundColor(Theme.textPrimary)

                    Text("Your training journey begins now")
                        .font(Typography.heading3)
                        .foregroundColor(Theme.textSecondary)
                }

                Spacer()

                // Navigation buttons
                VStack(spacing: Spacing.smd) {
                    PrimaryButton(title: "Start Training") {
                        onComplete()
                    }

                    TertiaryButton(title: "Back") {
                        onBack()
                    }
                }
                .padding(.horizontal, Spacing.lg)
                .padding(.bottom, Spacing.lg)
            }
            .opacity(contentOpacity)
        }
        .background(Theme.background)
        .onAppear {
            startAnimations()
        }
    }

    private var summaryCard: some View {
        VStack(spacing: Spacing.md) {
            // Goal
            if let goal = selectedGoal {
                SummaryRow(
                    icon: goal.icon,
                    iconColor: goalColor(for: goal),
                    label: "Goal",
                    value: goal.rawValue
                )

                Divider()
                    .background(Theme.surfaceBorder)
            }

            // Daily goal
            SummaryRow(
                icon: "clock.fill",
                iconColor: Theme.accent,
                label: "Daily Goal",
                value: "\(appState.userProfile.dailyGoalMinutes) minutes"
            )

            // Reminder
            if let preset = appState.userProfile.reminderPreset, preset != .none {
                Divider()
                    .background(Theme.surfaceBorder)

                SummaryRow(
                    icon: "bell.fill",
                    iconColor: Theme.level,
                    label: "Reminder",
                    value: reminderDescription
                )
            }
        }
        .padding(Spacing.lg)
        .cardStyle()
    }

    private var reminderDescription: String {
        guard let preset = appState.userProfile.reminderPreset else { return "None" }

        if preset == .custom, let time = appState.userProfile.reminderTime {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter.string(from: time)
        }

        return preset.timeDescription
    }

    private func goalColor(for goal: UserGoal) -> Color {
        switch goal.color {
        case "purple": return Theme.level
        case "blue": return Theme.sprint
        case "orange": return Theme.accent
        case "green": return Theme.success
        default: return Theme.accent
        }
    }

    private func startAnimations() {
        // Content fade in
        withAnimation(Motion.ease(Motion.smooth)) {
            contentOpacity = 1.0
        }

        // Mascot entrance
        withAnimation(Motion.bounce.delay(0.2)) {
            mascotScale = 1.0
        }

        // Trigger confetti
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            triggerConfetti()
        }
    }

    private func triggerConfetti() {
        showConfetti = true

        // Play celebration sound
        Sound.celebration()
        Haptic.success()

        // Create confetti pieces
        let width = viewSize.width > 0 ? viewSize.width : 400
        for i in 0..<50 {
            let piece = ConfettiPiece(
                id: i,
                x: CGFloat.random(in: 0...width),
                color: [Theme.accent, Theme.xp, Theme.level, Theme.sprint, Theme.success, Theme.streak].randomElement() ?? Theme.accent
            )
            confettiPieces.append(piece)
        }
    }
}

// MARK: - Summary Row

struct SummaryRow: View {
    let icon: String
    let iconColor: Color
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: Spacing.md) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(iconColor)
                .frame(width: 28)

            Text(label)
                .font(Typography.body)
                .foregroundColor(Theme.textSecondary)

            Spacer()

            Text(value)
                .font(Typography.bodyBold)
                .foregroundColor(Theme.textPrimary)
        }
    }
}

// MARK: - Confetti

struct ConfettiPiece: Identifiable {
    let id: Int
    let x: CGFloat
    let color: Color
}

struct ConfettiView: View {
    let piece: ConfettiPiece
    let viewSize: CGSize

    @State private var yOffset: CGFloat = -50
    @State private var rotation: Double = 0
    @State private var opacity: Double = 1

    private var viewWidth: CGFloat {
        viewSize.width > 0 ? viewSize.width : 400
    }

    private var viewHeight: CGFloat {
        viewSize.height > 0 ? viewSize.height : 800
    }

    var body: some View {
        Rectangle()
            .fill(piece.color)
            .frame(width: CGFloat.random(in: 6...10), height: CGFloat.random(in: 10...16))
            .cornerRadius(2)
            .rotationEffect(.degrees(rotation))
            .offset(x: piece.x - viewWidth / 2, y: yOffset)
            .opacity(opacity)
            .onAppear {
                withAnimation(
                    .easeOut(duration: Double.random(in: 2.0...3.5))
                ) {
                    yOffset = viewHeight + 100
                    rotation = Double.random(in: 360...720)
                }

                withAnimation(
                    .easeOut(duration: 2.0).delay(1.5)
                ) {
                    opacity = 0
                }
            }
    }
}

#Preview {
    GetStartedView(
        selectedGoal: .quantCareer,
        onComplete: {},
        onBack: {}
    )
    .environmentObject(AppState())
}
