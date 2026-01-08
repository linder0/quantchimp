//
//  Typography.swift
//  quantchimp
//
//  Typography system with custom fonts and text styles
//

import SwiftUI

// MARK: - Font Names

/// Font family names for Plus Jakarta Sans
/// Download from: https://fonts.google.com/specimen/Plus+Jakarta+Sans
///
/// To add fonts to your project:
/// 1. Download Plus Jakarta Sans from Google Fonts
/// 2. Add .ttf files to quantchimp/Resources/Fonts/
/// 3. Add files to Info.plist under "Fonts provided by application"
/// 4. Add files to Xcode project (Copy items if needed, Add to target: quantchimp)
enum FontFamily {
    static let regular = "PlusJakartaSans-Regular"
    static let medium = "PlusJakartaSans-Medium"
    static let semiBold = "PlusJakartaSans-SemiBold"
    static let bold = "PlusJakartaSans-Bold"
    static let extraBold = "PlusJakartaSans-ExtraBold"

    /// Check if custom fonts are available
    static var isAvailable: Bool {
        UIFont(name: regular, size: 12) != nil
    }
}

// MARK: - Typography Styles

/// Text style definitions
enum Typography {

    // MARK: - Display Styles (Large numbers, celebrations)

    /// 56pt ExtraBold - Result numbers, celebrations
    static let displayLarge: Font = customFont(.extraBold, size: 56, fallback: .system(size: 56, weight: .heavy, design: .rounded))

    /// 40pt Bold - Math questions
    static let displayMedium: Font = customFont(.bold, size: 40, fallback: .system(size: 40, weight: .bold, design: .rounded))

    /// 32pt Bold - Large headings
    static let displaySmall: Font = customFont(.bold, size: 32, fallback: .system(size: 32, weight: .bold, design: .rounded))

    // MARK: - Heading Styles

    /// 28pt Bold - Screen titles
    static let heading1: Font = customFont(.bold, size: 28, fallback: .system(size: 28, weight: .bold))

    /// 22pt SemiBold - Section headers
    static let heading2: Font = customFont(.semiBold, size: 22, fallback: .system(size: 22, weight: .semibold))

    /// 18pt SemiBold - Subsection headers
    static let heading3: Font = customFont(.semiBold, size: 18, fallback: .system(size: 18, weight: .semibold))

    // MARK: - Body Styles

    /// 17pt SemiBold - Card titles, emphasized text
    static let headline: Font = customFont(.semiBold, size: 17, fallback: .system(size: 17, weight: .semibold))

    /// 16pt Medium - Emphasized body text
    static let bodyBold: Font = customFont(.medium, size: 16, fallback: .system(size: 16, weight: .medium))

    /// 16pt Regular - General text
    static let body: Font = customFont(.regular, size: 16, fallback: .system(size: 16, weight: .regular))

    /// 15pt Regular - Secondary body text
    static let bodySmall: Font = customFont(.regular, size: 15, fallback: .system(size: 15, weight: .regular))

    // MARK: - Caption Styles

    /// 14pt Medium - Labels, tags
    static let label: Font = customFont(.medium, size: 14, fallback: .system(size: 14, weight: .medium))

    /// 13pt Regular - Secondary info
    static let caption: Font = customFont(.regular, size: 13, fallback: .system(size: 13, weight: .regular))

    /// 11pt Regular - Fine print
    static let captionSmall: Font = customFont(.regular, size: 11, fallback: .system(size: 11, weight: .regular))

    // MARK: - Special Styles

    /// Monospace for timers, scores, numbers that need alignment
    static let mono: Font = .system(size: 17, weight: .semibold, design: .monospaced)

    /// Large monospace for countdown timers
    static let monoLarge: Font = .system(size: 32, weight: .bold, design: .monospaced)

    /// Extra large monospace for game results
    static let monoDisplay: Font = .system(size: 48, weight: .bold, design: .monospaced)

    // MARK: - Helper

    private enum Weight {
        case regular, medium, semiBold, bold, extraBold

        var fontName: String {
            switch self {
            case .regular: return FontFamily.regular
            case .medium: return FontFamily.medium
            case .semiBold: return FontFamily.semiBold
            case .bold: return FontFamily.bold
            case .extraBold: return FontFamily.extraBold
            }
        }
    }

    private static func customFont(_ weight: Weight, size: CGFloat, fallback: Font) -> Font {
        if let uiFont = UIFont(name: weight.fontName, size: size) {
            return Font(uiFont)
        }
        return fallback
    }
}

// MARK: - Text Style Modifier

/// Convenience modifier for applying typography with theme colors
struct ThemedText: ViewModifier {
    let font: Font
    let color: Color

    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundColor(color)
    }
}

extension View {
    /// Apply themed typography style
    func textStyle(_ font: Font, color: Color = Theme.textPrimary) -> some View {
        modifier(ThemedText(font: font, color: color))
    }
}

// MARK: - Preview

#Preview("Typography Styles") {
    ScrollView {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Group {
                Text("Display Large")
                    .font(Typography.displayLarge)

                Text("Display Medium")
                    .font(Typography.displayMedium)

                Text("Display Small")
                    .font(Typography.displaySmall)
            }

            Divider().background(Theme.surfaceBorder)

            Group {
                Text("Heading 1")
                    .font(Typography.heading1)

                Text("Heading 2")
                    .font(Typography.heading2)

                Text("Heading 3")
                    .font(Typography.heading3)
            }

            Divider().background(Theme.surfaceBorder)

            Group {
                Text("Headline")
                    .font(Typography.headline)

                Text("Body Bold")
                    .font(Typography.bodyBold)

                Text("Body Regular")
                    .font(Typography.body)

                Text("Body Small")
                    .font(Typography.bodySmall)
            }

            Divider().background(Theme.surfaceBorder)

            Group {
                Text("Label")
                    .font(Typography.label)

                Text("Caption")
                    .font(Typography.caption)

                Text("Caption Small")
                    .font(Typography.captionSmall)
            }

            Divider().background(Theme.surfaceBorder)

            Group {
                Text("12:34")
                    .font(Typography.mono)

                Text("59")
                    .font(Typography.monoLarge)

                Text("100")
                    .font(Typography.monoDisplay)
            }
        }
        .foregroundColor(Theme.textPrimary)
        .padding(Spacing.lg)
    }
    .background(Theme.background)
}
