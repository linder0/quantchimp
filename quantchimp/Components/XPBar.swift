//
//  XPBar.swift
//  quantchimp
//
//  Created by Linda Xue on 1/8/26.
//

import SwiftUI

struct XPBar: View {
    let progress: Double
    let level: Int
    let xpToNext: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Level \(level)")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.orange)

                Spacer()

                Text("\(xpToNext) XP to next level")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemGray5))
                        .frame(height: 12)

                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                colors: [.orange, .yellow],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: max(0, geometry.size.width * progress), height: 12)
                        .animation(.spring(response: 0.5), value: progress)
                }
            }
            .frame(height: 12)
        }
        .padding()
        .cardStyle()
    }
}

#Preview {
    VStack(spacing: 20) {
        XPBar(progress: 0.3, level: 2, xpToNext: 140)
        XPBar(progress: 0.75, level: 5, xpToNext: 50)
    }
    .padding()
    .background(Color(.systemGray6))
}
