//
//  DailyProblem.swift
//  quantchimp
//
//  Created by Linda Xue on 1/8/26.
//

import Foundation

struct DailyProblem: Identifiable {
    let id: Int
    let prompt: String
    let choices: [String]
    let correctIndex: Int
    let explanation: String
}
