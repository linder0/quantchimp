//
//  MainTabView.swift
//  quantchimp
//
//  Main tab navigation using Theme tokens
//

import SwiftUI

enum Tab: String, CaseIterable {
    case home = "Home"
    case matchHistory = "History"
    case quests = "Quests"
    case friends = "Friends"
    case profile = "Profile"

    var icon: String {
        switch self {
        case .home: return "tab_home"
        case .matchHistory: return "clock"
        case .quests: return "trophy"
        case .friends: return "tab_friends"
        case .profile: return "tab_profile"
        }
    }
}

struct MainTabView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var statsManager: StatsManager

    @State private var selectedTab: Tab = .home
    @State private var homeNavigationPath = NavigationPath()

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Content area
                ZStack {
                    switch selectedTab {
                    case .home:
                        NavigationStack(path: $homeNavigationPath) {
                            HomeView(navigationPath: $homeNavigationPath)
                        }
                    case .matchHistory:
                        MatchHistoryView()
                    case .quests:
                        QuestsView()
                    case .friends:
                        FriendsView()
                    case .profile:
                        ProfileView()
                    }
                }
                .frame(maxHeight: .infinity)

                // Custom tab bar with fixed bottom safe area
                CustomTabBar(selectedTab: $selectedTab, bottomSafeArea: geometry.safeAreaInsets.bottom)
            }
        }
        .ignoresSafeArea()
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    let bottomSafeArea: CGFloat

    var body: some View {
        VStack(spacing: 0) {
            // Top border for separation from content
            Rectangle()
                .fill(Theme.surfaceBorder)
                .frame(height: 1)

            HStack(spacing: 0) {
                ForEach(Tab.allCases, id: \.self) { tab in
                    TabBarButton(
                        tab: tab,
                        isSelected: selectedTab == tab
                    ) {
                        withAnimation(Motion.ease(Motion.quick)) {
                            selectedTab = tab
                        }
                    }
                }
            }
            .padding(.top, Spacing.md)
            .padding(.bottom, Spacing.xxl)

            // Fixed space for bottom safe area (home indicator)
            Color.clear
                .frame(height: bottomSafeArea)
        }
        .frame(maxWidth: .infinity)
        .background(Theme.surface)
    }
}

struct TabBarButton: View {
    let tab: Tab
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: {
            Haptic.light()
            action()
        }) {
            VStack(spacing: Spacing.xs) {
                ZStack {
                    // Highlight background for selected tab
                    if isSelected {
                        RoundedRectangle(cornerRadius: Radius.md)
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 52, height: 38)
                    }

                    // Use custom asset
                    Image(tab.icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: isSelected ? 38 : 32, height: isSelected ? 38 : 32)
                        .animation(Motion.ease(Motion.quick), value: isSelected)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(TabIconButtonStyle())
    }
}

/// Button style that shrinks on press and bounces back on release
struct TabIconButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.8 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: configuration.isPressed)
    }
}

#Preview {
    MainTabView()
        .environmentObject(AppState())
        .environmentObject(StatsManager())
}
