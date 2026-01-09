//
//  OnboardingContainerView.swift
//  quantchimp
//
//  Onboarding container using Theme tokens
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
            // Background
            Theme.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Progress dots
                progressDots
                    .padding(.top, Spacing.lg)

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
                .animation(Motion.spring, value: currentStep)
            }
        }
    }

    private var progressDots: some View {
        HStack(spacing: Spacing.sm) {
            ForEach(OnboardingStep.allCases, id: \.rawValue) { step in
                Circle()
                    .fill(step == currentStep ? Theme.accent : Theme.textTertiary)
                    .frame(width: step == currentStep ? 10 : 8, height: step == currentStep ? 10 : 8)
                    .animation(Motion.spring, value: currentStep)
            }
        }
        .padding(.vertical, Spacing.md)
    }

    private func goToNextStep() {
        let nextIndex = currentStep.rawValue + 1
        if let next = OnboardingStep(rawValue: nextIndex) {
            withAnimation(Motion.spring) {
                currentStep = next
            }
        }
    }

    private func goToPreviousStep() {
        let prevIndex = currentStep.rawValue - 1
        if let prev = OnboardingStep(rawValue: prevIndex) {
            withAnimation(Motion.spring) {
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
