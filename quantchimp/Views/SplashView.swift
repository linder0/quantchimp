//
//  SplashView.swift
//  quantchimp
//
//  Created by Linda Xue on 1/8/26.
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
            LinearGradient(
                colors: [
                    Color(red: 0.12, green: 0.10, blue: 0.18),
                    Color(red: 0.08, green: 0.06, blue: 0.12)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Floating math symbols background
            GeometryReader { geo in
                ForEach(0..<12, id: \.self) { i in
                    Text(["π", "∑", "∫", "√", "∞", "÷", "×", "+", "−", "=", "%", "Δ"][i])
                        .font(.system(size: CGFloat.random(in: 20...40)))
                        .foregroundColor(.orange.opacity(0.15))
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

            VStack(spacing: 24) {
                // Chimp emoji with banana orbit
                ZStack {
                    // Pulsing ring
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [.orange, .yellow],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 3
                        )
                        .frame(width: 140, height: 140)
                        .scaleEffect(pulseScale)
                        .opacity(2 - pulseScale)

                    // Main chimp
                    Text("🐵")
                        .font(.system(size: 80))
                        .scaleEffect(isAnimating ? 1.05 : 0.95)
                        .animation(
                            .easeInOut(duration: 1.2).repeatForever(autoreverses: true),
                            value: isAnimating
                        )

                    // Orbiting banana
                    Text("🍌")
                        .font(.system(size: 32))
                        .offset(x: 70)
                        .rotationEffect(.degrees(bananaRotation))
                }
                .frame(width: 160, height: 160)

                VStack(spacing: 8) {
                    // App name
                    Text("quantchimp")
                        .font(.system(size: 38, weight: .black, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.orange, .yellow],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .opacity(isAnimating ? 1 : 0)
                        .offset(y: isAnimating ? 0 : 10)

                    // Tagline
                    Text("Math skills, leveled up")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.6))
                        .opacity(showSubtitle ? 1 : 0)
                        .offset(y: showSubtitle ? 0 : 5)
                }

                // Loading dots
                HStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { i in
                        Circle()
                            .fill(Color.orange)
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
                .padding(.top, 32)
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
