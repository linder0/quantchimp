//
//  FriendsView.swift
//  quantchimp
//
//  Friends view using Theme tokens
//

import SwiftUI

struct FriendsView: View {
    @State private var showShareSheet = false

    private let inviteMessage = """
    Hey! I've been training my brain with QuantChimp 🐵

    It's a fun app with daily puzzles and arithmetic challenges. Join me and let's see who can get the highest streak!

    Download it here: [App Store Link]
    """

    var body: some View {
        ScrollableViewWithHeader(title: "Friends", headerColor: Theme.surfaceElevated) {
            VStack(spacing: Spacing.xl) {
                // Empty state illustration
                emptyStateView

                // Invite button
                inviteButton

                // Coming soon section
                comingSoonSection

                Spacer(minLength: 40)
            }
            .padding(Spacing.md)
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(activityItems: [inviteMessage])
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: Spacing.lg) {
            Image("monkey_no_friends")
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 140)

            Text("No friends yet")
                .font(Typography.heading2)
                .foregroundColor(Theme.textPrimary)

            Text("Invite your friends to compete and compare stats!")
                .font(Typography.body)
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.xl)
        }
        .padding(.top, Spacing.xl)
    }

    private var inviteButton: some View {
        Button {
            showShareSheet = true
        } label: {
            HStack(spacing: Spacing.smd) {
                Image(systemName: "square.and.arrow.up")
                    .font(Typography.headline)

                Text("Invite Friends")
                    .font(Typography.headline)
            }
            .foregroundColor(Theme.background)
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.md)
            .background(Theme.accentGradient)
            .cornerRadius(Radius.md)
            .shadow(color: Theme.accent.opacity(0.3), radius: 10, x: 0, y: 4)
        }
    }

    private var comingSoonSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("COMING SOON")
                .font(Typography.headline)
                .foregroundColor(Theme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: Spacing.smd) {
                ComingSoonRow(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Leaderboards",
                    description: "Compete with friends for the top spot"
                )

                ComingSoonRow(
                    icon: "bolt.fill",
                    title: "Challenges",
                    description: "Send daily challenges to friends"
                )

                ComingSoonRow(
                    icon: "trophy.fill",
                    title: "Achievements",
                    description: "Unlock and share achievements"
                )
            }
        }
    }
}

struct ComingSoonRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: Spacing.md) {
            ZStack {
                Circle()
                    .fill(Theme.textTertiary.opacity(0.15))
                    .frame(width: 44, height: 44)

                Image(systemName: icon)
                    .font(Typography.headline)
                    .foregroundColor(Theme.textTertiary)
            }

            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(title)
                    .font(Typography.bodyBold)
                    .foregroundColor(Theme.textPrimary)

                Text(description)
                    .font(Typography.caption)
                    .foregroundColor(Theme.textSecondary)
            }

            Spacer()

            Text("Soon")
                .font(Typography.caption)
                .foregroundColor(Theme.textTertiary)
                .padding(.horizontal, Spacing.sm)
                .padding(.vertical, Spacing.xs)
                .background(Theme.surfaceElevated)
                .cornerRadius(Radius.sm)
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

#Preview {
    NavigationStack {
        FriendsView()
    }
}
