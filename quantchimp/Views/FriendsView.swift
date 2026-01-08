//
//  FriendsView.swift
//  quantchimp
//
//  Created by Linda Xue on 1/8/26.
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
        ScrollView {
            VStack(spacing: 32) {
                // Empty state illustration
                emptyStateView

                // Invite button
                inviteButton

                // Coming soon section
                comingSoonSection

                Spacer(minLength: 40)
            }
            .padding()
        }
        .background(Color(.systemGray6).ignoresSafeArea())
        .navigationBarHidden(true)
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(activityItems: [inviteMessage])
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.orange.opacity(0.25), .yellow.opacity(0.15)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 140, height: 140)

                Image(systemName: "person.2.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.orange)
            }

            Text("No friends yet")
                .font(.title2)
                .fontWeight(.bold)

            Text("Invite your friends to compete and compare stats!")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .padding(.top, 40)
    }

    private var inviteButton: some View {
        Button {
            showShareSheet = true
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "square.and.arrow.up")
                    .font(.headline)

                Text("Invite Friends")
                    .font(.headline)
                    .fontWeight(.bold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: [.orange, .yellow],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16)
            .shadow(color: .orange.opacity(0.3), radius: 8, x: 0, y: 4)
        }
    }

    private var comingSoonSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Coming Soon")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 12) {
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
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.15))
                    .frame(width: 44, height: 44)

                Image(systemName: icon)
                    .font(.headline)
                    .foregroundColor(.gray)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)

                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Text("Soon")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color(.systemGray5))
                .cornerRadius(6)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
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
