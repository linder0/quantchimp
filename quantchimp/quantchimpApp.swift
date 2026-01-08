//
//  quantchimpApp.swift
//  quantchimp
//
//  Created by Linda Xue on 1/8/26.
//

import SwiftUI

@main
struct quantchimpApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var statsManager = StatsManager()
    @State private var isLoading = true

    init() {
        // Force traditional tab bar appearance
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = .systemBackground
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                // Main content - show onboarding or main app based on state
                Group {
                    if appState.hasCompletedOnboarding {
                        MainTabView()
                            .environmentObject(appState)
                            .environmentObject(statsManager)
                    } else {
                        OnboardingContainerView()
                            .environmentObject(appState)
                    }
                }
                .opacity(isLoading ? 0 : 1)

                if isLoading {
                    SplashView()
                        .transition(.opacity.combined(with: .scale(scale: 1.1)))
                }
            }
            .onAppear {
                // Give the app time to fully mount
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        isLoading = false
                    }
                }
            }
        }
    }
}
