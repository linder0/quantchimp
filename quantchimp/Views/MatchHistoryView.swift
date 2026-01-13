//
//  MatchHistoryView.swift
//  quantchimp
//
//  Match history and statistics by game mode
//

import SwiftUI

struct MatchHistoryView: View {
    @EnvironmentObject var statsManager: StatsManager
    @EnvironmentObject var appState: AppState

    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            SimplePageHeader(title: "Match History")

            if statsManager.recentSessions.isEmpty {
                emptySessionsView
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Theme.background)
            } else {
                ScrollView {
                    VStack(spacing: Spacing.sm) {
                        ForEach(statsManager.recentSessions) { session in
                            SessionRow(session: session)
                        }
                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, Spacing.md)
                    .padding(.top, Spacing.md)
                }
                .scrollIndicators(.hidden)
                .background(Theme.background)
            }
        }
        .background(Theme.background.ignoresSafeArea(edges: .top))
        .navigationBarHidden(true)
    }

    private var emptySessionsView: some View {
        VStack(spacing: Spacing.md) {
            Image("monkey_no_sessions")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .opacity(0.6)

            Text("No matches yet")
                .font(Typography.bodyBold as Font)
                .foregroundColor(Theme.textSecondary)

            Text("Complete a puzzle or sprint to see your history here.")
                .font(Typography.caption as Font)
                .foregroundColor(Theme.textTertiary)
                .multilineTextAlignment(.center)
        }
        .padding(Spacing.xl)
    }
}

#Preview {
    NavigationStack {
        MatchHistoryView()
            .environmentObject(StatsManager())
            .environmentObject(AppState())
    }
}
