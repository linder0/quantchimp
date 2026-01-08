//
//  ArithmeticSetupView.swift
//  quantchimp
//
//  Arithmetic sprint setup using Theme tokens
//

import SwiftUI

struct ArithmeticSetupView: View {
    @EnvironmentObject var appState: AppState
    @Binding var navigationPath: NavigationPath

    @State private var selectedDifficulty: Difficulty = .easy
    @State private var showSprint = false

    var body: some View {
        VStack(spacing: Spacing.xl) {
            Spacer()

            // Header
            VStack(spacing: Spacing.smd) {
                ZStack {
                    Circle()
                        .fill(Theme.sprint.opacity(0.15))
                        .frame(width: 100, height: 100)

                    Image(systemName: "timer")
                        .font(.system(size: 44))
                        .foregroundColor(Theme.sprint)
                }

                Text("Arithmetic Sprint")
                    .font(Typography.heading1)
                    .foregroundColor(Theme.textPrimary)

                Text("Solve as many problems as you can in 60 seconds!")
                    .font(Typography.body)
                    .foregroundColor(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.md)
            }

            // Difficulty picker
            VStack(spacing: Spacing.md) {
                Text("Select Difficulty")
                    .font(Typography.headline)
                    .foregroundColor(Theme.textPrimary)

                Picker("Difficulty", selection: $selectedDifficulty) {
                    ForEach(Difficulty.allCases, id: \.self) { difficulty in
                        Text(difficulty.rawValue).tag(difficulty)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, Spacing.md)

                Text(selectedDifficulty.description)
                    .font(Typography.bodyBold)
                    .foregroundColor(difficultyColor)
            }
            .padding(Spacing.lg)
            .cardStyle(cornerRadius: Radius.xlg)

            Spacer()

            // Start button
            PrimaryButton(title: "Start Sprint", color: Theme.sprint) {
                showSprint = true
            }
            .padding(.horizontal, Spacing.md)
            .padding(.bottom, Spacing.xl)
        }
        .padding(Spacing.md)
        .background(Theme.background)
        .navigationTitle("Setup")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showSprint) {
            SprintPlayView(difficulty: selectedDifficulty, navigationPath: $navigationPath)
        }
    }

    private var difficultyColor: Color {
        switch selectedDifficulty {
        case .easy:
            return Theme.success
        case .medium:
            return Theme.warning
        case .hard:
            return Theme.error
        }
    }
}

#Preview {
    NavigationStack {
        ArithmeticSetupView(navigationPath: .constant(NavigationPath()))
            .environmentObject(AppState())
    }
}
