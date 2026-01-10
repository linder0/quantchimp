//
//  WelcomeView.swift
//  quantchimp
//
//  Welcome onboarding view using Theme tokens
//

import SwiftUI

struct WelcomeView: View {
    let onContinue: () -> Void

    @State private var mascotScale: CGFloat = 0.5
    @State private var mascotOpacity: Double = 0
    @State private var titleOpacity: Double = 0
    @State private var subtitleOpacity: Double = 0
    @State private var buttonOpacity: Double = 0
    @State private var mascotBounce: CGFloat = 0

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // Mascot with animation
            ZStack {
                // Glow effect
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Theme.accent.opacity(0.3),
                                Theme.accent.opacity(0.1),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 60,
                            endRadius: 140
                        )
                    )
                    .frame(width: 280, height: 280)

                Image("monkey_welcome")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 180)
                    .offset(y: mascotBounce)
            }
            .scaleEffect(mascotScale)
            .opacity(mascotOpacity)

            Spacer()
                .frame(height: 40)

            // Title
            VStack(spacing: Spacing.md) {
                Text("Welcome to")
                    .font(Typography.heading2)
                    .foregroundColor(Theme.textSecondary)

                Text("QuantChimp")
                    .font(Typography.displayMedium)
                    .foregroundStyle(Theme.accentGradient)
            }
            .opacity(titleOpacity)

            Spacer()
                .frame(height: Spacing.lg)

            // Subtitle
            VStack(spacing: Spacing.smd) {
                Text("Train your brain like a quant")
                    .font(Typography.heading3)
                    .foregroundColor(Theme.textPrimary)

                Text("Master mental math, sharpen your mind,\nand track your progress every day.")
                    .font(Typography.body)
                    .foregroundColor(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .opacity(subtitleOpacity)
            .padding(.horizontal, Spacing.xl)

            Spacer()

            // Continue button
            PrimaryButton(title: "Let's Go!") {
                onContinue()
            }
            .opacity(buttonOpacity)
            .padding(.horizontal, Spacing.lg)
            .padding(.bottom, Spacing.lg)
        }
        .background(Theme.background)
        .onAppear {
            startAnimations()
        }
    }

    private func startAnimations() {
        // Mascot entrance
        withAnimation(Motion.bounce.delay(0.2)) {
            mascotScale = 1.0
            mascotOpacity = 1.0
        }

        // Title fade in
        withAnimation(Motion.ease(Motion.smooth).delay(0.5)) {
            titleOpacity = 1.0
        }

        // Subtitle fade in
        withAnimation(Motion.ease(Motion.smooth).delay(0.7)) {
            subtitleOpacity = 1.0
        }

        // Button fade in
        withAnimation(Motion.ease(Motion.smooth).delay(0.9)) {
            buttonOpacity = 1.0
        }

        // Start continuous bounce animation
        startBounceAnimation()
    }

    private func startBounceAnimation() {
        withAnimation(
            .easeInOut(duration: 1.5)
            .repeatForever(autoreverses: true)
            .delay(1.0)
        ) {
            mascotBounce = -8
        }
    }
}

#Preview {
    WelcomeView(onContinue: {})
}
