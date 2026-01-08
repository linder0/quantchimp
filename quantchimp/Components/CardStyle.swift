//
//  CardStyle.swift
//  quantchimp
//
//  Created by Linda Xue on 1/8/26.
//

import SwiftUI

// MARK: - Card Style Modifier

struct CardStyle: ViewModifier {
    var cornerRadius: CGFloat = 16
    var shadowRadius: CGFloat = 8
    var shadowOpacity: Double = 0.05

    func body(content: Content) -> some View {
        content
            .background(Color(.systemBackground))
            .cornerRadius(cornerRadius)
            .shadow(color: .black.opacity(shadowOpacity), radius: shadowRadius, x: 0, y: 2)
    }
}

extension View {
    func cardStyle(
        cornerRadius: CGFloat = 16,
        shadowRadius: CGFloat = 8,
        shadowOpacity: Double = 0.05
    ) -> some View {
        modifier(CardStyle(
            cornerRadius: cornerRadius,
            shadowRadius: shadowRadius,
            shadowOpacity: shadowOpacity
        ))
    }
}

#Preview {
    VStack(spacing: 20) {
        Text("Default Card")
            .padding()
            .frame(maxWidth: .infinity)
            .cardStyle()

        Text("Custom Card")
            .padding()
            .frame(maxWidth: .infinity)
            .cardStyle(cornerRadius: 24, shadowRadius: 12)
    }
    .padding()
    .background(Color(.systemGray6))
}
