//
//  GetStartedView.swift
//  quantchimp
//
//  Created by Linda Xue on 1/8/26.
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

    var body: some View {
        ZStack {
            // Confetti layer
            ForEach(confettiPieces) { piece in
                ConfettiView(piece: piece)
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
                                    Color.orange.opacity(0.4),
                                    Color.orange.opacity(0.1),
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
                                colors: [.orange.opacity(0.25), .yellow.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 160, height: 160)
                        .overlay(
                            Circle()
                                .stroke(Color.orange.opacity(0.4), lineWidth: 4)
                        )

                    Text("🎉")
                        .font(.system(size: 80))
                }
                .scaleEffect(mascotScale)

                Spacer()
                    .frame(height: 40)

                // Title
                VStack(spacing: 16) {
                    Text("You're All Set!")
                        .font(.system(size: 32, weight: .bold, design: .rounded))

                    Text("Your training journey begins now")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }

                Spacer()
                    .frame(height: 32)

                // Summary card
                summaryCard
                    .padding(.horizontal, 24)

                Spacer()

                // Navigation buttons
                VStack(spacing: 12) {
                    PrimaryButton(title: "Start Training") {
                        onComplete()
                    }

                    Button {
                        onBack()
                    } label: {
                        Text("Back")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 20)
            }
            .opacity(contentOpacity)
        }
        .onAppear {
            startAnimations()
        }
    }

    private var summaryCard: some View {
        VStack(spacing: 16) {
            // Goal
            if let goal = selectedGoal {
                SummaryRow(
                    icon: goal.icon,
                    iconColor: goalColor(for: goal),
                    label: "Goal",
                    value: goal.rawValue
                )

                Divider()
            }

            // Daily goal
            SummaryRow(
                icon: "clock.fill",
                iconColor: .orange,
                label: "Daily Goal",
                value: "\(appState.userProfile.dailyGoalMinutes) minutes"
            )

            // Reminder
            if let preset = appState.userProfile.reminderPreset, preset != .none {
                Divider()

                SummaryRow(
                    icon: "bell.fill",
                    iconColor: .purple,
                    label: "Reminder",
                    value: reminderDescription
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
        )
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
        case "purple": return .purple
        case "blue": return .blue
        case "orange": return .orange
        case "green": return .green
        default: return .orange
        }
    }

    private func startAnimations() {
        // Content fade in
        withAnimation(.easeOut(duration: 0.5)) {
            contentOpacity = 1.0
        }

        // Mascot entrance
        withAnimation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.2)) {
            mascotScale = 1.0
        }

        // Trigger confetti
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            triggerConfetti()
        }
    }

    private func triggerConfetti() {
        showConfetti = true

        // Create confetti pieces
        for i in 0..<50 {
            let piece = ConfettiPiece(
                id: i,
                x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                color: [Color.orange, .yellow, .purple, .blue, .green, .pink].randomElement() ?? .orange
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
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(iconColor)
                .frame(width: 28)

            Text(label)
                .font(.body)
                .foregroundColor(.secondary)

            Spacer()

            Text(value)
                .font(.body)
                .fontWeight(.medium)
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

    @State private var yOffset: CGFloat = -50
    @State private var rotation: Double = 0
    @State private var opacity: Double = 1

    var body: some View {
        Rectangle()
            .fill(piece.color)
            .frame(width: CGFloat.random(in: 6...10), height: CGFloat.random(in: 10...16))
            .cornerRadius(2)
            .rotationEffect(.degrees(rotation))
            .offset(x: piece.x - UIScreen.main.bounds.width / 2, y: yOffset)
            .opacity(opacity)
            .onAppear {
                withAnimation(
                    .easeOut(duration: Double.random(in: 2.0...3.5))
                ) {
                    yOffset = UIScreen.main.bounds.height + 100
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
