//
//  quantchimpApp.swift
//  quantchimp
//
//  App entry point with Theme configuration
//

import SwiftUI

@main
struct quantchimpApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var statsManager = StatsManager()
    @State private var isLoading = true

    init() {
        // Configure appearance for dark theme
        configureAppearance()
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
                            .environmentObject(ThemeManager.shared)
                    } else {
                        OnboardingContainerView()
                            .environmentObject(appState)
                            .environmentObject(ThemeManager.shared)
                    }
                }
                .opacity(isLoading ? 0 : 1)

                if isLoading {
                    SplashView()
                        .transition(.opacity.animation(.easeOut(duration: 0.6)))
                }
            }
            .preferredColorScheme(.dark) // Force dark mode for premium feel
            .onAppear {
                // Give the app time to fully mount
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                    withAnimation(.easeOut(duration: 0.8)) {
                        isLoading = false
                    }
                }
            }
        }
    }

    private func configureAppearance() {
        // Tab bar appearance
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(Theme.surface)
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance

        // Navigation bar appearance
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor(Theme.surface)
        navBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor(Theme.textPrimary)
        ]
        navBarAppearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor(Theme.textPrimary)
        ]
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance

        // Segmented control tint
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Theme.accent)
        UISegmentedControl.appearance().setTitleTextAttributes([
            .foregroundColor: UIColor(Theme.background)
        ], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([
            .foregroundColor: UIColor(Theme.textPrimary)
        ], for: .normal)
    }
}
