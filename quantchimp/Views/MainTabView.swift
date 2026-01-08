//
//  MainTabView.swift
//  quantchimp
//
//  Main tab navigation using Theme tokens
//

import SwiftUI

enum Tab: String, CaseIterable {
    case home = "Home"
    case stats = "Stats"
    case friends = "Friends"
    case profile = "Profile"

    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .stats: return "chart.bar.fill"
        case .friends: return "person.2.fill"
        case .profile: return "person.fill"
        }
    }
}

struct MainTabView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var statsManager: StatsManager

    @State private var selectedTab: Tab = .home
    @State private var homeNavigationPath = NavigationPath()

    var body: some View {
        VStack(spacing: 0) {
            // Content area
            ZStack {
                switch selectedTab {
                case .home:
                    NavigationStack(path: $homeNavigationPath) {
                        HomeView(navigationPath: $homeNavigationPath)
                    }
                case .stats:
                    StatsView()
                case .friends:
                    FriendsView()
                case .profile:
                    ProfileView()
                }
            }
            .ignoresSafeArea(edges: .top)

            // Custom tab bar
            CustomTabBar(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(.keyboard)
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Tab

    var body: some View {
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
        .padding(.top, Spacing.sm)
        .padding(.bottom, Spacing.sm)
        .frame(maxWidth: .infinity)
        .background(
            Theme.surface
                .overlay(
                    Rectangle()
                        .fill(Theme.surfaceBorder)
                        .frame(height: 1),
                    alignment: .top
                )
        )
        .background(
            Theme.surface
                .ignoresSafeArea(edges: .bottom)
        )
    }
}

struct TabBarButton: View {
    let tab: Tab
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: Spacing.xs) {
                Image(systemName: tab.icon)
                    .font(.system(size: 22))
                    .foregroundColor(isSelected ? Theme.accent : Theme.textTertiary)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    MainTabView()
        .environmentObject(AppState())
        .environmentObject(StatsManager())
}
