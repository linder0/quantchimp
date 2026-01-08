//
//  HomeView.swift
//  quantchimp
//
//  Created by Linda Xue on 1/8/26.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var statsManager: StatsManager
    @State private var navigationPath = NavigationPath()
    @State private var showPlaySelection = false

    private let welcomeMessages = [
        "Welcome back, %@!",
        "Ready to train, %@?",
        "Let's crush it, %@!",
        "The chimp awaits, %@!",
        "Time for gains, %@!",
        "Hey %@, let's go!"
    ]

    private var welcomeMessage: String {
        let template = welcomeMessages.randomElement() ?? "Welcome back, %@!"
        return String(format: template, appState.userProfile.displayName)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            // Main scrollable content
            ScrollView {
                VStack(spacing: 24) {
                    // Welcome header with mascot
                    welcomeHeader

                    // Stats section
                    statsSection

                    // Game history section
                    gameHistorySection

                    // Bottom padding for the sticky button
                    Spacer(minLength: 80)
                }
                .padding()
            }
.background(Color(.systemGray6).ignoresSafeArea())

            // Sticky Play button - blends with tab bar
            VStack(spacing: 0) {
                // Gradient fade from content to button area
                LinearGradient(
                    colors: [
                        Color(.systemGray6).opacity(0),
                        Color(.systemBackground)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 24)

                // Button container matches tab bar background
                VStack {
                    PrimaryButton(title: "Play") {
                        showPlaySelection = true
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 12)
                .background(Color(.systemBackground))
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showPlaySelection) {
            PlaySelectionView(
                onSelectDaily: {
                    navigationPath.append(NavigationDestination.dailyPuzzle)
                },
                onSelectSprint: {
                    navigationPath.append(NavigationDestination.arithmeticSetup)
                }
            )
            .environmentObject(appState)
        }
        .navigationDestination(for: NavigationDestination.self) { destination in
            switch destination {
            case .dailyPuzzle:
                DailyPuzzleView(navigationPath: $navigationPath)
            case .arithmeticSetup:
                ArithmeticSetupView(navigationPath: $navigationPath)
            }
        }
    }

    private var welcomeHeader: some View {
        VStack(spacing: 16) {
            // Mascot with user avatar
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.orange.opacity(0.3), .yellow.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 80, height: 80)

                    Text("🐵")
                        .font(.system(size: 40))
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(welcomeMessage)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)

                    Text("Ready to train your brain?")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()
            }
        }
        .padding(.top, 8)
    }

    private var statsSection: some View {
        HStack(spacing: 16) {
            StatCard(
                icon: "flame.fill",
                value: "\(appState.streak)",
                label: "Streak",
                color: .orange
            )

            StatCard(
                icon: "trophy.fill",
                value: "\(appState.bestStreak)",
                label: "Best",
                color: .purple
            )
        }
    }

    private var gameHistorySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Games")
                .font(.headline)
                .foregroundColor(.primary)

            if statsManager.sessionHistory.isEmpty {
                // Empty state
                VStack(spacing: 16) {
                    Text("🎮")
                        .font(.system(size: 48))

                    Text("No games yet")
                        .font(.headline)
                        .foregroundColor(.primary)

                    Text("Tap Play to start your first game!")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
                .cardStyle()
            } else {
                // Game history cards
                LazyVStack(spacing: 12) {
                    ForEach(statsManager.recentSessions) { session in
                        GameHistoryCard(session: session)
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
            .environmentObject(AppState())
            .environmentObject(StatsManager())
    }
}
