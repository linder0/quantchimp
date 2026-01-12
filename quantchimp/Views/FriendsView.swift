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

    private let inviteMessage = """
    Hey! I've been training my brain with QuantChimp 🐵

    It's a fun app with daily puzzles and arithmetic challenges. Join me and let's see who can get the highest streak!

    Download it here: [App Store Link]
    """

    var body: some View {
        VStack(spacing: 0) {
            // Colored header with monkey, text, and invite button
            friendsHeader

            // Content area
            ScrollView {
                VStack(spacing: Spacing.lg) {
                    if appState.hasFriends {
                        friendsList
                    } else {
                        emptyStateHint
                    }

                    Spacer(minLength: 40)
                }
                .padding(Spacing.md)
            }
            .scrollIndicators(.hidden)
            .background(Theme.background)
        }
        .background(Theme.background.ignoresSafeArea())
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(activityItems: [inviteMessage])
        }
    }

    // MARK: - Colored Header
    private var friendsHeader: some View {
        HStack(alignment: .bottom, spacing: 0) {
            // Monkey on left - bigger to fill space
            Image("monkey_no_friends")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .offset(x: -Spacing.sm, y: -Spacing.sm)

            // Text and button on right
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text(appState.hasFriends ? "Friends" : "No friends yet")
                    .font(Typography.heading1)
                    .foregroundColor(.white)

                if !appState.hasFriends {
                    Text("Invite friends to compete!")
                        .font(Typography.caption)
                        .foregroundColor(.white.opacity(0.8))
                } else {
                    Text("\(appState.friends.count) friend\(appState.friends.count == 1 ? "" : "s")")
                        .font(Typography.caption)
                        .foregroundColor(.white.opacity(0.8))
                }

                // Invite button under text
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
            Text("LEADERBOARD")
                .font(Typography.headline)
                .foregroundColor(Theme.textPrimary)

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
