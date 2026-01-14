//
//  GenericDifficultyCarousel.swift
//  quantchimp
//
//  Generic reusable difficulty carousel component
//

import SwiftUI

struct GenericDifficultyCarousel<CardContent: View>: View {
    @Binding var selectedDifficulty: Difficulty
    let cardContent: (Difficulty) -> CardContent

    private var currentIndex: Int {
        Difficulty.allCases.firstIndex(of: selectedDifficulty) ?? 1
    }

    private var canGoBack: Bool {
        currentIndex > 0
    }

    private var canGoForward: Bool {
        currentIndex < Difficulty.allCases.count - 1
    }

    var body: some View {
        VStack(spacing: Spacing.smd) {
            // Swipeable card carousel
            TabView(selection: $selectedDifficulty) {
                ForEach(Difficulty.allCases, id: \.self) { difficulty in
                    cardContent(difficulty)
                        .tag(difficulty)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .onChange(of: selectedDifficulty) { _, _ in
                Haptic.selection()
                Sound.select()
            }

            // Navigation row with arrows and dots
            navigationControls
        }
    }

    private var navigationControls: some View {
        HStack(spacing: Spacing.lg) {
            // Left arrow
            carouselButton(
                icon: "chevron.left",
                isEnabled: canGoBack
            ) {
                if canGoBack {
                    withAnimation(Motion.snappy) {
                        selectedDifficulty = Difficulty.allCases[currentIndex - 1]
                    }
                }
            }

            // Page dots
            HStack(spacing: Spacing.sm) {
                ForEach(Difficulty.allCases, id: \.self) { difficulty in
                    Circle()
                        .fill(selectedDifficulty == difficulty ? difficulty.color : Theme.textTertiary.opacity(0.4))
                        .frame(
                            width: selectedDifficulty == difficulty ? 10 : 8,
                            height: selectedDifficulty == difficulty ? 10 : 8
                        )
                        .animation(Motion.snappy, value: selectedDifficulty)
                        .onTapGesture {
                            Haptic.selection()
                            Sound.select()
                            withAnimation(Motion.snappy) {
                                selectedDifficulty = difficulty
                            }
                        }
                }
            }

            // Right arrow
            carouselButton(
                icon: "chevron.right",
                isEnabled: canGoForward
            ) {
                if canGoForward {
                    withAnimation(Motion.snappy) {
                        selectedDifficulty = Difficulty.allCases[currentIndex + 1]
                    }
                }
            }
        }
    }

    private func carouselButton(icon: String, isEnabled: Bool, action: @escaping () -> Void) -> some View {
        Button {
            Haptic.selection()
            Sound.select()
            action()
        } label: {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(isEnabled ? Theme.textPrimary : Theme.textTertiary.opacity(0.3))
                .frame(width: 36, height: 36)
                .background(Theme.surfaceElevated)
                .clipShape(Circle())
        }
        .disabled(!isEnabled)
    }
}

#Preview {
    GenericDifficultyCarousel(
        selectedDifficulty: .constant(.medium)
    ) { difficulty in
        VStack {
            Text(difficulty.rawValue)
                .font(Typography.displaySmall)
                .foregroundColor(difficulty.color)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.surface)
        .cornerRadius(Radius.xlg)
        .padding(.horizontal, Spacing.md)
    }
    .background(Theme.background)
}
