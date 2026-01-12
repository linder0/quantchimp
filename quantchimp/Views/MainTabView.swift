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
        case .home: return "tab_home"
        case .stats: return "tab_stats"
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
        .padding(.top, Spacing.smd)
        .padding(.bottom, Spacing.sm)
        .frame(maxWidth: .infinity)
        .background(Theme.surface.ignoresSafeArea(edges: .bottom))
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
                            .overlay(
                                RoundedRectangle(cornerRadius: Radius.md)
                                    .stroke(Theme.xp.opacity(0.6), lineWidth: 1.5)
                            )
                            .frame(width: 52, height: 38)
                    }

                    Image(tab.icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .opacity(isSelected ? 1.0 : 0.5)
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
