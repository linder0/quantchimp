//
//  SprintResultView.swift
//  quantchimp
//
//  Created by Linda Xue on 1/8/26.
//

import SwiftUI

struct SprintResultView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var statsManager: StatsManager
    let correctCount: Int
    let totalAttempts: Int
    let difficulty: Difficulty
    @Binding var navigationPath: NavigationPath

    @State private var hasUpdatedXP = false
    @State private var showXPAnimation = false

    private var accuracy: Double {
        guard totalAttempts > 0 else { return 0 }
        return Double(correctCount) / Double(totalAttempts) * 100
    }

    private var xpEarned: Int {
        min(correctCount * 10, 200)
    }

    private var performanceMessage: String {
        if correctCount >= 15 {
            return "Outstanding! 🏆"
        } else if correctCount >= 10 {
            return "Great job! 🌟"
        } else if correctCount >= 5 {
            return "Good effort! 💪"
        } else {
            return "Keep practicing! 📚"
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
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
            .padding()
        }
        .background(Color(.systemGray6))
        .navigationTitle("Results")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            updateXPIfNeeded()
        }
    }

    private var resultHeader: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.blue.opacity(0.3), .purple.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)

                Image(systemName: "flag.checkered")
                    .font(.system(size: 44))
                    .foregroundColor(.blue)
            }

            Text("Sprint Complete!")
                .font(.title)
                .fontWeight(.bold)

            Text(performanceMessage)
                .font(.title3)
                .foregroundColor(.secondary)
        }
        .padding(.top, 20)
    }

    private var statsGrid: some View {
        HStack(spacing: 16) {
            StatCardLarge(
                icon: "checkmark.circle.fill",
                value: "\(correctCount)",
                label: "Correct",
                color: .green
            )

            StatCardLarge(
                icon: "percent",
                value: String(format: "%.0f%%", accuracy),
                label: "Accuracy",
                color: .blue
            )

            StatCardLarge(
                icon: "number",
                value: "\(totalAttempts)",
                label: "Attempts",
                color: .orange
            )
        }
    }

    private var xpCard: some View {
        VStack(spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "star.fill")
                    .font(.title)
                    .foregroundColor(.yellow)

                Text("+\(xpEarned) XP")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .scaleEffect(showXPAnimation ? 1.1 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: showXPAnimation)

            Text("Difficulty: \(difficulty.rawValue)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(
            LinearGradient(
                colors: [.yellow.opacity(0.2), .orange.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.3).delay(0.3)) {
                showXPAnimation = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                withAnimation {
                    showXPAnimation = false
                }
            }
        }
    }

    private var actionButtons: some View {
        VStack(spacing: 12) {
            PrimaryButton(title: "Try Again", color: .blue) {
                // Go back to setup (remove last 2 items from path: SprintPlay and SprintResult)
                if navigationPath.count >= 2 {
                    navigationPath.removeLast(2)
                    // Re-add arithmetic setup
                    navigationPath.append(NavigationDestination.arithmeticSetup)
                }
            }

            SecondaryButton(title: "Back Home") {
                navigationPath = NavigationPath()
            }
        }
        .padding(.bottom, 20)
    }

    private func updateXPIfNeeded() {
        guard !hasUpdatedXP else { return }
        hasUpdatedXP = true
        appState.addArithmeticXP(correctCount: correctCount)

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
    NavigationStack {
        SprintResultView(
            correctCount: 12,
            totalAttempts: 15,
            difficulty: .medium,
            navigationPath: .constant(NavigationPath())
        )
        .environmentObject(AppState())
        .environmentObject(StatsManager())
    }
}
