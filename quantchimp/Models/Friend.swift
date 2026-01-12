//
//  Friend.swift
//  quantchimp
//
//  Friend data model
//

import Foundation

struct Friend: Codable, Identifiable, Equatable {
    let id: UUID
    var displayName: String
    var avatarImage: String
    var streak: Int
    var xp: Int
    var addedDate: Date

    init(
        id: UUID = UUID(),
        displayName: String,
        avatarImage: String = "avatar_default",
        streak: Int = 0,
        xp: Int = 0,
        addedDate: Date = Date()
    ) {
        self.id = id
        self.displayName = displayName
        self.avatarImage = avatarImage
        self.streak = streak
        self.xp = xp
        self.addedDate = addedDate
    }

    var level: Int {
        xp / 200 + 1
    }
}
