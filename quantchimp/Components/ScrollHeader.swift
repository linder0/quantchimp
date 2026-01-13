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

// MARK: - Stylized Scroll Header View (Duolingo-inspired)

struct StylizedScrollHeader: View {
    let title: String
    let subtitle: String?
    let mascotImage: String?
    let color: Color
    let isScrolled: Bool

    // Computed gradient from the base color
    private var headerGradient: LinearGradient {
        LinearGradient(
            colors: [
                color,
                color.opacity(0.85)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: Spacing.md) {
            // Text content
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(Typography.heading2)
                    .foregroundColor(.white)

                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(Typography.caption)
                        .foregroundColor(.white.opacity(0.85))
                }
            }
            .padding(.bottom, Spacing.md)

            Spacer()

            // Mascot image - larger, shifted down to be partially cut off
            if let mascotImage = mascotImage {
                Image(mascotImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 110, height: 110)
                    .offset(y: 24) // Push down so bottom is clipped
            }
        }
        .padding(.horizontal, Spacing.md)
        .padding(.top, 56)
        .frame(maxWidth: .infinity)
        .frame(height: 140)
        .background(headerGradient.ignoresSafeArea(edges: .top))
        .clipped() // Clip the overflowing mascot
        .shadow(
            color: isScrolled ? Shadow.md.color : .clear,
            radius: isScrolled ? Shadow.md.radius : 0,
            x: 0,
            y: isScrolled ? Shadow.md.y : 0
        )
        .animation(Motion.ease(Motion.quick), value: isScrolled)
    }
}

// MARK: - Legacy Scroll Header View (kept for backwards compatibility)

struct ScrollHeader: View {
    let title: String
    let color: Color
    let isScrolled: Bool

    var body: some View {
        VStack(spacing: 0) {
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

            // Bottom border
            Rectangle()
                .fill(Theme.surfaceBorder)
                .frame(height: 1)
                .padding(.horizontal, Spacing.md)
        }
        .background(Theme.background)
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

// MARK: - Scrollable View with Stylized Header

struct ScrollableViewWithHeader<Content: View>: View {
    let title: String
    let subtitle: String?
    let mascotImage: String?
    let headerColor: Color
    let content: Content

    @State private var scrollOffset: CGFloat = 0

    init(
        title: String,
        subtitle: String? = nil,
        mascotImage: String? = nil,
        headerColor: Color,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.mascotImage = mascotImage
        self.headerColor = headerColor
        self.content = content()
    }

    // Use stylized header if subtitle or mascot is provided
    private var useStylizedHeader: Bool {
        subtitle != nil || mascotImage != nil
    }

    var body: some View {
        VStack(spacing: 0) {
            // Choose header style based on parameters
            if useStylizedHeader {
                StylizedScrollHeader(
                    title: title,
                    subtitle: subtitle,
                    mascotImage: mascotImage,
                    color: headerColor,
                    isScrolled: scrollOffset < -5
                )
            } else {
                ScrollHeader(
                    title: title,
                    color: headerColor,
                    isScrolled: scrollOffset < -5
                )
            }

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

#Preview("Stylized Header") {
    NavigationStack {
        ScrollableViewWithHeader(
            title: "Stats",
            subtitle: "Track your progress",
            mascotImage: "monkey_great",
            headerColor: Theme.level
        ) {
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

#Preview("Simple Header") {
    NavigationStack {
        ScrollableViewWithHeader(
            title: "Friends",
            headerColor: Theme.background
        ) {
            VStack(spacing: Spacing.lg) {
                ForEach(0..<10) { i in
                    Text("Friend \(i)")
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
