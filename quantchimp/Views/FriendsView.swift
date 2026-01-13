//
//  FriendsView.swift
//  quantchimp
//
//  Friends view using Theme tokens
//

import SwiftUI

struct FriendsView: View {
    @EnvironmentObject var appState: AppState
    @State private var showShareSheet = false
    @State private var scrollOffset: CGFloat = 0
    @State private var initialScrollOffset: CGFloat = 0

    private let inviteMessage = """
    Hey! I've been training my brain with QuantChimp 🐵

    It's a fun app with daily puzzles and arithmetic challenges. Join me and let's see who can get the highest streak!

    Download it here: [App Store Link]
    """

    // Header transition thresholds
    private let collapseThreshold: CGFloat = 60

    private var collapseProgress: CGFloat {
        guard scrollOffset < 0 else { return 0 }
        return min(1, abs(scrollOffset) / collapseThreshold)
    }

    private func lerp(_ a: CGFloat, _ b: CGFloat, _ t: CGFloat) -> CGFloat {
        a + (b - a) * t
    }

    var body: some View {
        Group {
            if appState.hasFriends {
                // Transforming header when friends exist
                ZStack(alignment: .top) {
                    // Main scrollable content
                    ScrollView {
                        VStack(spacing: 0) {
                            // Spacer for header with scroll tracking
                            Color.clear
                                .frame(height: 180)
                                .overlay(
                                    GeometryReader { geometry in
                                        Color.clear
                                            .onAppear {
                                                initialScrollOffset = geometry.frame(in: .global).minY
                                            }
                                            .onChange(of: geometry.frame(in: .global).minY) { _, newValue in
                                                scrollOffset = newValue - initialScrollOffset
                                            }
                                    }
                                )

                            VStack(spacing: Spacing.lg) {
                                friendsList
                                Spacer(minLength: 40)
                            }
                            .padding(Spacing.md)
                        }
                    }
                    .scrollIndicators(.hidden)
                    .background(Theme.background.ignoresSafeArea(edges: .top))

                    // Transforming header
                    friendsHeader
                }
                .navigationBarHidden(true)
                .ignoresSafeArea(edges: .top)
            } else {
                // Static header when no friends
                VStack(spacing: 0) {
                    staticFriendsHeader

                    // Empty state centered in remaining space
                    emptyStateHint
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Theme.background)
                }
                .background(Theme.background.ignoresSafeArea(edges: .top))
            }
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(activityItems: [inviteMessage])
        }
    }

    // MARK: - Static Header (no friends)
    private var staticFriendsHeader: some View {
        HStack(alignment: .bottom, spacing: 0) {
            // Monkey on left
            Image("monkey_no_friends")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .offset(x: -Spacing.sm, y: -Spacing.sm)

            // Text and button on right
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text("No friends yet")
                    .font(Typography.heading1)
                    .foregroundColor(.white)

                Text("Invite friends to compete!")
                    .font(Typography.caption)
                    .foregroundColor(.white.opacity(0.8))

                inviteButton
            }
            .padding(.bottom, Spacing.lg)

            Spacer()
        }
        .padding(.top, 56)
        .padding(.trailing, Spacing.md)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [Theme.accentSecondary, Theme.accentSecondary.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea(edges: .top)
        )
        .clipped()
    }

    // MARK: - Transforming Header (has friends)
    private var friendsHeader: some View {
        VStack(spacing: 0) {
            // Main header row
            HStack(alignment: .bottom, spacing: 0) {
                // Monkey on left - scales down smoothly
                Image("monkey_no_friends")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .scaleEffect(lerp(1.0, 0, collapseProgress), anchor: .bottomLeading)
                    .frame(
                        width: lerp(200, 0, collapseProgress),
                        height: lerp(200, 0, collapseProgress)
                    )
                    .opacity(1 - collapseProgress)
                    .offset(x: -Spacing.sm, y: -Spacing.sm)

                // Text and button
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text("Friends")
                        .font(Typography.heading1)
                        .scaleEffect(lerp(1.0, 0.8, collapseProgress), anchor: .leading)
                        .foregroundColor(.white)

                    Text("\(appState.friends.count) friend\(appState.friends.count == 1 ? "" : "s")")
                        .font(Typography.caption)
                        .foregroundColor(.white.opacity(0.8))
                        .opacity(1 - collapseProgress)
                        .frame(height: lerp(18, 0, collapseProgress), alignment: .top)
                        .clipped()

                    inviteButton
                        .scaleEffect(lerp(1.0, 0.9, collapseProgress), anchor: .leading)
                }

                Spacer()
            }
            .padding(.horizontal, Spacing.md)
            .padding(.top, 60)
            .padding(.bottom, lerp(Spacing.md, 10, collapseProgress))
            .frame(maxWidth: .infinity)
        }
        .background(Theme.accentSecondary.ignoresSafeArea(edges: .top))
        .shadow(
            color: Shadow.md.color.opacity(Double(collapseProgress)),
            radius: lerp(0, Shadow.md.radius, collapseProgress),
            x: 0,
            y: lerp(0, Shadow.md.y, collapseProgress)
        )
    }

    // MARK: - Empty State Hint
    private var emptyStateHint: some View {
        VStack(spacing: Spacing.md) {
            Image("tab_friends")
                .resizable()
                .scaledToFit()
                .frame(width: 48, height: 48)
                .opacity(0.4)

            Text("Your friends will appear here")
                .font(Typography.bodyBold)
                .foregroundColor(Theme.textSecondary)

            Text("Once friends join via your invite link, you'll be able to see their stats and compete on leaderboards.")
                .font(Typography.caption)
                .foregroundColor(Theme.textTertiary)
                .multilineTextAlignment(.center)
        }
        .padding(Spacing.xl)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Friends List
    private var friendsList: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            SectionHeader(title: "Leaderboard")

            VStack(spacing: Spacing.sm) {
                ForEach(appState.friends.sorted { $0.xp > $1.xp }) { friend in
                    FriendRow(friend: friend)
                }
            }
        }
    }

    // MARK: - Invite Button
    private var inviteButton: some View {
        Button {
            showShareSheet = true
        } label: {
            HStack(spacing: Spacing.sm) {
                Image(systemName: "square.and.arrow.up")
                    .font(Typography.label)

                Text("Invite Friends")
                    .font(Typography.label)
            }
            .foregroundColor(Theme.accentSecondary)
            .padding(.horizontal, Spacing.md)
            .padding(.vertical, Spacing.sm)
            .background(.white)
            .cornerRadius(Radius.md)
        }
    }
}

// MARK: - Friend Row
struct FriendRow: View {
    let friend: Friend

    var body: some View {
        HStack(spacing: Spacing.md) {
            // Avatar
            Image(friend.avatarImage)
                .resizable()
                .scaledToFit()
                .frame(width: 44, height: 44)
                .clipShape(Circle())

            // Name and level
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(friend.displayName)
                    .font(Typography.bodyBold)
                    .foregroundColor(Theme.textPrimary)

                Text("Level \(friend.level)")
                    .font(Typography.caption)
                    .foregroundColor(Theme.textSecondary)
            }

            Spacer()

            // XP and streak
            VStack(alignment: .trailing, spacing: Spacing.xs) {
                HStack(spacing: Spacing.xs) {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundColor(Theme.xp)
                    Text("\(friend.xp)")
                        .font(Typography.label)
                        .foregroundColor(Theme.textPrimary)
                }

                if friend.streak > 0 {
                    HStack(spacing: Spacing.xs) {
                        Image(systemName: "flame.fill")
                            .font(.caption)
                            .foregroundColor(Theme.streak)
                        Text("\(friend.streak)")
                            .font(Typography.caption)
                            .foregroundColor(Theme.textSecondary)
                    }
                }
            }
        }
        .padding(Spacing.md)
        .cardStyle()
    }
}

// UIKit wrapper for share sheet
struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview("Empty State") {
    FriendsView()
        .environmentObject(AppState())
}

#Preview("With Friends") {
    let appState = AppState()
    appState.friends = [
        Friend(displayName: "Alice", avatarImage: "avatar_cool", streak: 5, xp: 450),
        Friend(displayName: "Bob", avatarImage: "avatar_ninja", streak: 12, xp: 890),
        Friend(displayName: "Charlie", avatarImage: "avatar_wizard", streak: 0, xp: 120)
    ]
    return FriendsView()
        .environmentObject(appState)
}
