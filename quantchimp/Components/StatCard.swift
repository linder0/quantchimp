//
//  StatCard.swift
//  quantchimp
//
//  Created by Linda Xue on 1/8/26.
//

import SwiftUI

/// Unified stat card component used across HomeView, StatsView, and ResultViews
struct StatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)

            Text(value)
                .font(.title3)
                .fontWeight(.bold)

            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .cardStyle()
    }
}

/// Larger stat card variant for result screens
struct StatCardLarge: View {
    let icon: String
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)

            Text(value)
                .font(.title2)
                .fontWeight(.bold)

            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .cardStyle()
    }
}

#Preview {
    VStack(spacing: 20) {
        HStack(spacing: 16) {
            StatCard(
                icon: "flame.fill",
                value: "7",
                label: "Streak",
                color: .orange
            )

            StatCard(
                icon: "trophy.fill",
                value: "12",
                label: "Best",
                color: .purple
            )
        }

        HStack(spacing: 16) {
            StatCardLarge(
                icon: "checkmark.circle.fill",
                value: "15",
                label: "Correct",
                color: .green
            )

            StatCardLarge(
                icon: "percent",
                value: "85%",
                label: "Accuracy",
                color: .blue
            )
        }
    }
    .padding()
    .background(Color(.systemGray6))
}
