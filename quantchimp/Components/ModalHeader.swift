//
//  ModalHeader.swift
//  quantchimp
//
//  Reusable modal header with close button and title
//

import SwiftUI

struct ModalHeader: View {
    let title: String
    let onDismiss: () -> Void
    var trailingContent: (() -> AnyView)? = nil

    var body: some View {
        HStack {
            IconButton(icon: "xmark", backgroundColor: Theme.surfaceElevated, size: 36) {
                onDismiss()
            }

            Spacer()

            Text(title)
                .font(Typography.headline)
                .foregroundColor(Theme.textPrimary)

            Spacer()

            if let trailing = trailingContent {
                trailing()
            } else {
                Color.clear.frame(width: 36, height: 36)
            }
        }
        .padding(.horizontal, Spacing.md)
        .padding(.top, Spacing.md)
        .padding(.bottom, Spacing.sm)
    }
}

// Convenience initializer for optional trailing content
extension ModalHeader {
    init(title: String, onDismiss: @escaping () -> Void) {
        self.title = title
        self.onDismiss = onDismiss
        self.trailingContent = nil
    }

    init<Content: View>(title: String, onDismiss: @escaping () -> Void, @ViewBuilder trailing: @escaping () -> Content) {
        self.title = title
        self.onDismiss = onDismiss
        self.trailingContent = { AnyView(trailing()) }
    }
}

#Preview {
    VStack {
        ModalHeader(title: "Test Modal") {}

        ModalHeader(title: "With Trailing") {
            // Dismiss action
        } trailing: {
            Image(systemName: "gear")
                .foregroundColor(Theme.textPrimary)
        }
    }
    .background(Theme.background)
}
