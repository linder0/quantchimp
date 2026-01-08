//
//  ModeStatCard.swift
//  quantchimp
//
//  Created by Linda Xue on 1/8/26.
//

import SwiftUI

struct ModeStatCard: View {
    let mode: GameMode
    let completed: Int
    let accuracy: Double

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(mode.color.opacity(0.15))
                    .frame(width: 48, height: 48)

                Image(systemName: mode.icon)
                    .font(.title3)
                    .foregroundColor(mode.color)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(mode.rawValue)
                    .font(.headline)

                Text("\(completed) completed")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text(String(format: "%.0f%%", accuracy))
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(mode.color)

                Text("accuracy")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .cardStyle()
    }
}

#Preview {
    VStack(spacing: 12) {
        ModeStatCard(mode: .daily, completed: 15, accuracy: 85)
        ModeStatCard(mode: .sprint, completed: 23, accuracy: 72)
    }
    .padding()
    .background(Color(.systemGray6))
}
