//
//  StatsView.swift
//  quantchimp
//
//  Statistics view using Theme tokens
//

import SwiftUI

struct StatsView: View {
    @EnvironmentObject var statsManager: StatsManager
    @EnvironmentObject var appState: AppState

    // MARK: - Constants
    private enum Layout {
        static let scrollThreshold: CGFloat = 100
        static let headerTopPadding: CGFloat = 50
        static let headerMinBottomPadding: CGFloat = 8
        static let headerMaxBottomPadding: CGFloat = 12
        static let elementSize: CGFloat = 80
        static let safeAreaOffset: CGFloat = 100
    }

    // MARK: - State
    @State private var scrollPosition: CGFloat = 0
    @State private var initialOffset: CGFloat? = nil
    @State private var selectedMode: GameMode = .daily

    // MARK: - Computed Properties
    private var headerColor: Color {
        Color(hex: appState.userProfile.profileColor.hex)
    }

    private var collapseProgress: CGFloat {
        min(1, max(0, scrollPosition / Layout.scrollThreshold))
    }

    private var elementOpacity: Double {
        max(0, 1 - (collapseProgress * 1.2))
    }

    private var elementScale: CGFloat {
        max(0.01, 1 - (collapseProgress * 0.8))
    }

    private var elementHeight: CGFloat {
        Layout.elementSize * (1 - collapseProgress)
    }

    private var bottomPadding: CGFloat {
        max(Layout.headerMinBottomPadding,
            Layout.headerMaxBottomPadding - (8 * collapseProgress))
    }

    private var filteredSessions: [SessionRecord] {
        statsManager.recentSessions.filter { $0.mode == selectedMode }
    }

    private var modeCompleted: Int {
        selectedMode == .daily ? statsManager.dailyCompleted : statsManager.sprintCompleted
    }

    private var modeAccuracy: Double {
        selectedMode == .daily ? statsManager.dailyAccuracy : statsManager.sprintAccuracy
    }

    private var modeQuestions: Int {
        statsManager.sessionHistory
            .filter { $0.mode == selectedMode }
            .reduce(0) { $0 + $1.questionsAnswered }
    }

    private var modeCorrect: Int {
        statsManager.sessionHistory
            .filter { $0.mode == selectedMode }
            .reduce(0) { $0 + $1.correctCount }
    }

    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.lg) {
                scrollTracker
                modePickerSection
                modeStatsSection
                Spacer(minLength: 40)
            }
            .padding(.horizontal, Spacing.md)
            .padding(.top, Spacing.md)
        }
        .scrollIndicators(.hidden)
        .background(Theme.background)
        .safeAreaInset(edge: .top, spacing: 0) {
            statsHeader
        }
        .navigationBarHidden(true)
    }

    // MARK: - Scroll Tracker
    private var scrollTracker: some View {
        GeometryReader { geo in
            Color.clear
                .task(id: geo.frame(in: .global).minY) {
                    let offset = geo.frame(in: .global).minY
                    if initialOffset == nil {
                        initialOffset = offset
                    }
                    if let initial = initialOffset {
                        scrollPosition = max(0, initial - offset)
                    }
                }
        }
        .frame(height: 0)
    }

    // MARK: - Header
    private var statsHeader: some View {
        VStack(spacing: 0) {
            HStack(alignment: .bottom, spacing: Spacing.md) {
                headerLeftContent
                Spacer()
            }
            .padding(.top, Layout.headerTopPadding)
            .padding(.bottom, bottomPadding)
        }
        .frame(maxWidth: .infinity)
        .background(
            headerColor
                .ignoresSafeArea(edges: .top)
        )
    }

    private var headerLeftContent: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text("Stats")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
        }
        .padding(.leading, Spacing.md)
    }


    // MARK: - Sections
    private var modePickerSection: some View {
        HStack(spacing: 0) {
            ForEach(GameMode.allCases, id: \.self) { mode in
                modePickerButton(for: mode)
            }
        }
        .padding(4)
        .background(Theme.surfaceElevated)
        .cornerRadius(Radius.lg)
    }

    @ViewBuilder
    private func modePickerButton(for mode: GameMode) -> some View {
        let isSelected = selectedMode == mode

        Button {
            withAnimation(.easeInOut(duration: Motion.quick)) {
                selectedMode = mode
            }
        } label: {
            HStack(spacing: Spacing.xs) {
                Image(mode.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)

                Text(mode.rawValue)
                    .font(Typography.label as Font)
            }
            .foregroundColor(isSelected ? .white : Theme.textSecondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.smd)
            .background(
                RoundedRectangle(cornerRadius: Radius.md)
                    .fill(isSelected ? mode.color : Color.clear)
            )
        }
        .buttonStyle(.plain)
    }

    private var modeStatsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            VStack(spacing: Spacing.smd) {
                RingStatCard(
                    value: "\(modeQuestions)",
                    label: "Questions",
                    progress: min(1.0, Double(modeQuestions) / 100.0),
                    color: selectedMode.color,
                    icon: "questionmark"
                )

                RingStatCard(
                    value: "\(modeCorrect)",
                    label: "Correct",
                    progress: modeQuestions > 0
                        ? Double(modeCorrect) / Double(modeQuestions)
                        : 0,
                    color: Theme.success,
                    icon: "checkmark"
                )

                RingStatCard(
                    value: formatAccuracy(modeAccuracy),
                    label: "Accuracy",
                    progress: modeAccuracy / 100.0,
                    color: Theme.level
                )
            }

            // Completed count
            HStack(spacing: Spacing.xs) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(selectedMode.color)
                Text("\(modeCompleted) sessions completed")
                    .font(Typography.caption as Font)
                    .foregroundColor(Theme.textSecondary)
            }
            .padding(.horizontal, Spacing.sm)
        }
    }

}

#Preview {
    NavigationStack {
        StatsView()
            .environmentObject(StatsManager())
            .environmentObject(AppState())
    }
}
