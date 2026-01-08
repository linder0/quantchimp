//
//  ArithmeticSetupView.swift
//  quantchimp
//
//  Created by Linda Xue on 1/8/26.
//

import SwiftUI

struct ArithmeticSetupView: View {
    @EnvironmentObject var appState: AppState
    @Binding var navigationPath: NavigationPath

    @State private var selectedDifficulty: Difficulty = .easy
    @State private var showSprint = false

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            // Header
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.15))
                        .frame(width: 100, height: 100)

                    Image(systemName: "timer")
                        .font(.system(size: 44))
                        .foregroundColor(.blue)
                }

                Text("Arithmetic Sprint")
                    .font(.title)
                    .fontWeight(.bold)

                Text("Solve as many problems as you can in 60 seconds!")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            // Difficulty picker
            VStack(spacing: 16) {
                Text("Select Difficulty")
                    .font(.headline)

                Picker("Difficulty", selection: $selectedDifficulty) {
                    ForEach(Difficulty.allCases, id: \.self) { difficulty in
                        Text(difficulty.rawValue).tag(difficulty)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                Text(selectedDifficulty.description)
                    .font(.subheadline)
                    .foregroundColor(selectedDifficulty.color)
                    .fontWeight(.medium)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(20)

            Spacer()

            // Start button
            PrimaryButton(title: "Start Sprint", color: .blue) {
                showSprint = true
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
        .padding()
        .background(Color(.systemGray6))
        .navigationTitle("Setup")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showSprint) {
            SprintPlayView(difficulty: selectedDifficulty, navigationPath: $navigationPath)
        }
    }
}

#Preview {
    NavigationStack {
        ArithmeticSetupView(navigationPath: .constant(NavigationPath()))
            .environmentObject(AppState())
    }
}
