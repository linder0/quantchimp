//
//  PlaySelectionView.swift
//  quantchimp
//
//  Created by Linda Xue on 1/8/26.
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
            Color(red: 0.12, green: 0.12, blue: 0.14)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    // Close button
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.title3.weight(.semibold))
                                .foregroundColor(.white.opacity(0.7))
                                .frame(width: 40, height: 40)
                                .background(Color.white.opacity(0.1))
                                .clipShape(Circle())
                        }

                        Spacer()
                    }
                    .padding(.horizontal)

                    // Title
                    Text("Play")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)

                    // Mascot
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.orange.opacity(0.3), .yellow.opacity(0.2)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 100, height: 100)

                        Text("🐵")
                            .font(.system(size: 50))
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 32)
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(
                        colors: [
                            Color(red: 0.18, green: 0.18, blue: 0.22),
                            Color(red: 0.12, green: 0.12, blue: 0.14)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

                // Game mode options
                VStack(spacing: 12) {
                    // Daily Puzzle
                    PlayOptionTile(
                        icon: "brain.head.profile",
                        emoji: "🧠",
                        title: "Daily Puzzle",
                        subtitle: appState.completedDailyToday ? "Completed today" : "Ready to play",
                        isCompleted: appState.completedDailyToday,
                        color: .purple
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
                        color: .blue
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
                        color: .yellow,
                        isDisabled: true
                    ) {}

                    PlayOptionTile(
                        icon: "person.2.fill",
                        emoji: "🤝",
                        title: "Challenge a Friend",
                        subtitle: "Coming soon",
                        isCompleted: false,
                        color: .green,
                        isDisabled: true
                    ) {}
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)

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
