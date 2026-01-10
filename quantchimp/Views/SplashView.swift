//
//  SplashView.swift
//  quantchimp
//
//  Splash screen using Theme tokens
//

import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false
    @State private var showSubtitle = false
    @State private var bananaRotation: Double = 0
    @State private var pulseScale: CGFloat = 1.0

    var body: some View {
        ZStack {
            // Background gradient
            Theme.backgroundGradient
                .ignoresSafeArea()

            // Floating math symbols background
            GeometryReader { geo in
                ForEach(0..<12, id: \.self) { i in
                    Text(["π", "∑", "∫", "√", "∞", "÷", "×", "+", "−", "=", "%", "Δ"][i])
                        .font(.system(size: CGFloat.random(in: 20...40)))
                        .foregroundColor(Theme.accent.opacity(0.15))
                        .position(
                            x: CGFloat.random(in: 0...geo.size.width),
                            y: CGFloat.random(in: 0...geo.size.height)
                        )
                        .offset(y: isAnimating ? -20 : 20)
                        .animation(
                            .easeInOut(duration: Double.random(in: 2...4))
                            .repeatForever(autoreverses: true)
                            .delay(Double(i) * 0.1),
                            value: isAnimating
                        )
                }
            }

            VStack(spacing: Spacing.lg) {
                // Chimp with banana orbit
                ZStack {
                    // Pulsing ring
                    Circle()
                        .stroke(Theme.accentGradient, lineWidth: 3)
                        .frame(width: 160, height: 160)
                        .scaleEffect(pulseScale)
                        .opacity(2 - pulseScale)

                    // Main chimp
                    Image("monkey_splash")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140, height: 140)
                        .scaleEffect(isAnimating ? 1.05 : 0.95)
                        .animation(
                            .easeInOut(duration: 1.2).repeatForever(autoreverses: true),
                            value: isAnimating
                        )

                    // Orbiting banana
                    Text("🍌")
                        .font(.system(size: 32))
                        .offset(x: 85)
                        .rotationEffect(.degrees(bananaRotation))
                }
                .frame(width: 180, height: 180)

                VStack(spacing: Spacing.sm) {
                    // App name
                    Text("quantchimp")
                        .font(Typography.displaySmall)
                        .foregroundStyle(Theme.accentGradient)
                        .opacity(isAnimating ? 1 : 0)
                        .offset(y: isAnimating ? 0 : 10)

                    // Tagline
                    Text("Math skills, leveled up")
                        .font(Typography.body)
                        .foregroundColor(Theme.textSecondary)
                        .opacity(showSubtitle ? 1 : 0)
                        .offset(y: showSubtitle ? 0 : 5)
                }

                // Loading dots
                HStack(spacing: Spacing.sm) {
                    ForEach(0..<3, id: \.self) { i in
                        Circle()
                            .fill(Theme.accent)
                            .frame(width: 8, height: 8)
                            .scaleEffect(isAnimating ? 1 : 0.5)
                            .animation(
                                .easeInOut(duration: 0.6)
                                .repeatForever(autoreverses: true)
                                .delay(Double(i) * 0.2),
                                value: isAnimating
                            )
                    }
                }
                .padding(.top, Spacing.xl)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                isAnimating = true
            }

            withAnimation(.easeOut(duration: 0.5).delay(0.3)) {
                showSubtitle = true
            }

            // Banana orbit animation
            withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                bananaRotation = 360
            }

            // Pulse ring animation
            withAnimation(.easeOut(duration: 1.5).repeatForever(autoreverses: false)) {
                pulseScale = 1.5
            }
        }
    }
}

#Preview {
    SplashView()
}
