//
//  ScrollHeader.swift
//  quantchimp
//
//  Scroll header components using Theme tokens
//

import SwiftUI

// MARK: - Scroll Offset Preference Key

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - Scroll Header View

struct ScrollHeader: View {
    let title: String
    let color: Color
    let isScrolled: Bool

    var body: some View {
        HStack {
            Text(title)
                .font(Typography.heading2)
                .foregroundColor(Theme.textPrimary)

            Spacer()
        }
        .padding(.horizontal, Spacing.md)
        .padding(.top, 60)
        .padding(.bottom, Spacing.smd)
        .frame(maxWidth: .infinity)
        .background(color)
        .ignoresSafeArea(edges: .top)
        .shadow(
            color: isScrolled ? Shadow.md.color : .clear,
            radius: isScrolled ? Shadow.md.radius : 0,
            x: 0,
            y: isScrolled ? Shadow.md.y : 0
        )
        .animation(Motion.ease(Motion.quick), value: isScrolled)
    }
}

// MARK: - Scrollable View with Header

struct ScrollableViewWithHeader<Content: View>: View {
    let title: String
    let headerColor: Color
    let content: Content

    @State private var scrollOffset: CGFloat = 0

    init(title: String, headerColor: Color, @ViewBuilder content: () -> Content) {
        self.title = title
        self.headerColor = headerColor
        self.content = content()
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header with safe area extension
            ScrollHeader(title: title, color: headerColor, isScrolled: scrollOffset < -5)

            // Scrollable content
            ScrollView {
                VStack(spacing: 0) {
                    // Invisible tracker at the top
                    GeometryReader { geometry in
                        Color.clear
                            .preference(
                                key: ScrollOffsetPreferenceKey.self,
                                value: geometry.frame(in: .named("scroll")).minY
                            )
                    }
                    .frame(height: 0)

                    // Actual content
                    content
                }
            }
            .scrollIndicators(.hidden)
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                scrollOffset = value
            }
            .background(Theme.background)
        }
        .background(Theme.background.ignoresSafeArea())
    }
}

#Preview {
    NavigationStack {
        ScrollableViewWithHeader(title: "Friends", headerColor: Theme.surfaceElevated) {
            VStack(spacing: Spacing.lg) {
                ForEach(0..<20) { i in
                    Text("Item \(i)")
                        .font(Typography.body)
                        .foregroundColor(Theme.textPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(Spacing.md)
                        .cardStyle()
                }
            }
            .padding(Spacing.md)
        }
    }
}
