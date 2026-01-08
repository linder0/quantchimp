//
//  GoalSelectionView.swift
//  quantchimp
//
//  Created by Linda Xue on 1/8/26.
//

import SwiftUI

struct GoalSelectionView: View {
    @Binding var selectedGoal: UserGoal?
    let onContinue: () -> Void
    let onBack: () -> Void

    @State private var contentOpacity: Double = 0

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 12) {
                    Text("What's your goal?")
                        .font(.system(size: 28, weight: .bold, design: .rounded))

                    Text("We'll personalize your experience based on what you want to achieve.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                }
                .padding(.top, 40)

                // Goal tiles
                VStack(spacing: 12) {
                    ForEach(UserGoal.allCases) { goal in
                        GoalTile(
                            goal: goal,
                            isSelected: selectedGoal == goal,
                            onTap: {
                                withAnimation(.spring(response: 0.3)) {
                                    selectedGoal = goal
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, 24)

                Spacer(minLength: 120)
            }
        }
        .safeAreaInset(edge: .bottom) {
            // Navigation buttons
            VStack(spacing: 12) {
                PrimaryButton(title: selectedGoal != nil ? "Continue" : "Select a Goal") {
                    if selectedGoal != nil {
                        onContinue()
                    }
                }
                .disabled(selectedGoal == nil)
                .opacity(selectedGoal == nil ? 0.6 : 1.0)

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
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: [Color(.systemBackground).opacity(0), Color(.systemBackground)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
        .opacity(contentOpacity)
        .onAppear {
            withAnimation(.easeOut(duration: 0.4)) {
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
