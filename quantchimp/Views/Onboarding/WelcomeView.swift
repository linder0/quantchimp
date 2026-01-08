//
//  WelcomeView.swift
//  quantchimp
//
//  Created by Linda Xue on 1/8/26.
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
                                Color.orange.opacity(0.3),
                                Color.orange.opacity(0.1),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 40,
                            endRadius: 120
                        )
                    )
                    .frame(width: 240, height: 240)

                // Mascot circle
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.orange.opacity(0.2), .yellow.opacity(0.15)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 160, height: 160)
                    .overlay(
                        Circle()
                            .stroke(Color.orange.opacity(0.3), lineWidth: 3)
                    )

                Text("🐵")
                    .font(.system(size: 80))
                    .offset(y: mascotBounce)
            }
            .scaleEffect(mascotScale)
            .opacity(mascotOpacity)

            Spacer()
                .frame(height: 40)

            // Title
            VStack(spacing: 16) {
                Text("Welcome to")
                    .font(.title2)
                    .foregroundColor(.secondary)

                Text("QuantChimp")
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.orange, .orange.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            }
            .opacity(titleOpacity)

            Spacer()
                .frame(height: 24)

            // Subtitle
            VStack(spacing: 12) {
                Text("Train your brain like a quant")
                    .font(.title3)
                    .fontWeight(.medium)

                Text("Master mental math, sharpen your mind,\nand track your progress every day.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .opacity(subtitleOpacity)
            .padding(.horizontal, 32)

            Spacer()

            // Continue button
            PrimaryButton(title: "Let's Go!") {
                onContinue()
            }
            .opacity(buttonOpacity)
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
        }
        .onAppear {
            startAnimations()
        }
    }

    private func startAnimations() {
        // Mascot entrance
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2)) {
            mascotScale = 1.0
            mascotOpacity = 1.0
        }

        // Title fade in
        withAnimation(.easeOut(duration: 0.5).delay(0.5)) {
            titleOpacity = 1.0
        }

        // Subtitle fade in
        withAnimation(.easeOut(duration: 0.5).delay(0.7)) {
            subtitleOpacity = 1.0
        }

        // Button fade in
        withAnimation(.easeOut(duration: 0.5).delay(0.9)) {
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
