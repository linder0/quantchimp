//
//  GoalSelectionView.swift
//  quantchimp
//
//  Goal selection onboarding using Theme tokens
//

import SwiftUI

struct GoalSelectionView: View {
    @Binding var selectedGoal: UserGoal?
    let onContinue: () -> Void
    let onBack: () -> Void

    @State private var contentOpacity: Double = 0

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: Spacing.lg) {
                // Header
                VStack(spacing: Spacing.smd) {
                    Text("What's your goal?")
                        .font(Typography.heading1)
                        .foregroundColor(Theme.textPrimary)

                    Text("We'll personalize your experience based on what you want to achieve.")
                        .font(Typography.body)
                        .foregroundColor(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Spacing.md)
                }
                .padding(.top, Spacing.xl)

                // Goal tiles
                VStack(spacing: Spacing.smd) {
                    ForEach(UserGoal.allCases) { goal in
                        GoalTile(
                            goal: goal,
                            isSelected: selectedGoal == goal,
                            onTap: {
                                Haptic.selection()
                                Sound.select()
                                withAnimation(Motion.spring) {
                                    selectedGoal = goal
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, Spacing.lg)

                Spacer()
            }

            // Navigation buttons
            VStack(spacing: Spacing.smd) {
                PrimaryButton(title: selectedGoal != nil ? "Continue" : "Select a Goal", isEnabled: selectedGoal != nil) {
                    if selectedGoal != nil {
                        onContinue()
                    }
                }

                TertiaryButton(title: "Back") {
                    onBack()
                }
            }
            .padding(.horizontal, Spacing.lg)
            .padding(.bottom, Spacing.md)
        }
        .background(Theme.background)
        .opacity(contentOpacity)
        .onAppear {
            withAnimation(Motion.ease(Motion.smooth)) {
                contentOpacity = 1.0
            }
        }
    }
}

#Preview {
    GoalSelectionView(
        selectedGoal: .constant(.quantCareer),
        onContinue: {},
        onBack: {}
    )
}
