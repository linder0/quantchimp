//
//  OnboardingContainerView.swift
//  quantchimp
//
//  Created by Linda Xue on 1/8/26.
//

import SwiftUI

enum OnboardingStep: Int, CaseIterable {
    case welcome = 0
    case goal = 1
    case dailyGoal = 2
    case getStarted = 3

    var title: String {
        switch self {
        case .welcome: return "Welcome"
        case .goal: return "Your Goal"
        case .dailyGoal: return "Daily Goal"
        case .getStarted: return "Get Started"
        }
    }
}

struct OnboardingContainerView: View {
    @EnvironmentObject var appState: AppState
    @State private var currentStep: OnboardingStep = .welcome
    @State private var selectedGoal: UserGoal?

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color.orange.opacity(0.1),
                    Color.yellow.opacity(0.05),
                    Color(.systemBackground)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Content area
                TabView(selection: $currentStep) {
                    WelcomeView(onContinue: { goToNextStep() })
                        .tag(OnboardingStep.welcome)

                    GoalSelectionView(
                        selectedGoal: $selectedGoal,
                        onContinue: { goToNextStep() },
                        onBack: { goToPreviousStep() }
                    )
                    .tag(OnboardingStep.goal)

                    DailyGoalView(
                        onContinue: { goToNextStep() },
                        onBack: { goToPreviousStep() }
                    )
                    .tag(OnboardingStep.dailyGoal)

                    GetStartedView(
                        selectedGoal: selectedGoal,
                        onComplete: { completeOnboarding() },
                        onBack: { goToPreviousStep() }
                    )
                    .tag(OnboardingStep.getStarted)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: currentStep)

                // Progress dots
                progressDots
                    .padding(.bottom, 20)
            }
        }
    }

    private var progressDots: some View {
        HStack(spacing: 8) {
            ForEach(OnboardingStep.allCases, id: \.rawValue) { step in
                Circle()
                    .fill(step == currentStep ? Color.orange : Color.gray.opacity(0.3))
                    .frame(width: step == currentStep ? 10 : 8, height: step == currentStep ? 10 : 8)
                    .animation(.spring(response: 0.3), value: currentStep)
            }
        }
        .padding(.vertical, 16)
    }

    private func goToNextStep() {
        let nextIndex = currentStep.rawValue + 1
        if let next = OnboardingStep(rawValue: nextIndex) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                currentStep = next
            }
        }
    }

    private func goToPreviousStep() {
        let prevIndex = currentStep.rawValue - 1
        if let prev = OnboardingStep(rawValue: prevIndex) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                currentStep = prev
            }
        }
    }

    private func completeOnboarding() {
        // Save selected goal to profile
        if let goal = selectedGoal {
            appState.userProfile.goal = goal
        }
        appState.completeOnboarding()
    }
}

#Preview {
    OnboardingContainerView()
        .environmentObject(AppState())
}
