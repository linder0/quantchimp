//
//  MainTabView.swift
//  quantchimp
//
//  Created by Linda Xue on 1/8/26.
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

    var body: some View {
        VStack(spacing: 0) {
            // Content area
            ZStack {
                Color(.systemGray6)
                    .ignoresSafeArea()

                TabView(selection: $selectedTab) {
                    NavigationStack {
                        HomeView()
                    }
                    .tag(Tab.home)

                    StatsView()
                        .tag(Tab.stats)

                    FriendsView()
                        .tag(Tab.friends)

                    ProfileView()
                        .tag(Tab.profile)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }

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
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = tab
                    }
                }
            }
        }
        .padding(.top, 10)
        .padding(.bottom, 8)
        .background(Color(.systemBackground))
        .background(
            Color(.systemBackground)
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
            VStack(spacing: 4) {
                Image(systemName: tab.icon)
                    .font(.system(size: 22))

                Text(tab.rawValue)
                    .font(.caption2)
            }
            .foregroundColor(isSelected ? .orange : .gray)
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
