//
//  SimplePageHeader.swift
//  quantchimp
//
//  Simple page header with title and optional subtitle
//

import SwiftUI

/// Simple page header with consistent styling and bottom border
struct SimplePageHeader: View {
    let title: String
    let subtitle: String?
    var backgroundColor: Color = Theme.background
    var topPadding: CGFloat = 80
    var bottomPadding: CGFloat = 12

    init(
        title: String,
        subtitle: String? = nil,
        backgroundColor: Color = Theme.background,
        topPadding: CGFloat = 80,
        bottomPadding: CGFloat = 12
    ) {
        self.title = title
        self.subtitle = subtitle
        self.backgroundColor = backgroundColor
        self.topPadding = topPadding
        self.bottomPadding = bottomPadding
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .bottom, spacing: Spacing.md) {
                headerContent
                Spacer()
            }
            .padding(.top, topPadding)
            .padding(.bottom, bottomPadding)

            // Bottom border
            Rectangle()
                .fill(Theme.surfaceBorder)
                .frame(height: 1)
                .padding(.horizontal, Spacing.md)
        }
        .frame(maxWidth: .infinity)
        .background(
            backgroundColor
                .ignoresSafeArea(edges: .top)
        )
    }

    private var headerContent: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(title)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Theme.textPrimary)

            if let subtitle = subtitle {
                Text(subtitle)
                    .font(Typography.caption)
                    .foregroundColor(Theme.textSecondary)
            }
        }
        .padding(.leading, Spacing.md)
    }
}

#Preview("Simple Headers") {
    VStack(spacing: 0) {
        SimplePageHeader(title: "Match History")

        Spacer()
            .frame(height: 40)

        SimplePageHeader(
            title: "Quests",
            subtitle: "5 achievements unlocked"
        )

        Spacer()
    }
    .background(Theme.background)
}
