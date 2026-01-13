//
//  SplashView.swift
//  quantchimp
//
//  Minimal splash screen inspired by Duolingo
//

import SwiftUI

struct SplashView: View {
    @State private var showContent = false

    // Muted warm gold for splash background
    private let splashBackground = Color(hex: "E09F1F")

    var body: some View {
        ZStack {
            // Solid brand color background
            splashBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Centered chimp mascot
                Image("monkey_splash")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 180)
                    .opacity(showContent ? 1 : 0)
                    .scaleEffect(showContent ? 1 : 0.8)

                Spacer()

                // App name at bottom
                Text("quantchimp")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .opacity(showContent ? 1 : 0)
                    .padding(.bottom, 80)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.4)) {
                showContent = true
            }
        }
    }
}

#Preview {
    SplashView()
}
