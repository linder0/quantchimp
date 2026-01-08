//
//  DailyPuzzleBank.swift
//  quantchimp
//
//  Created by Linda Xue on 1/8/26.
//

import Foundation

struct DailyPuzzleBank {
    static let puzzles: [DailyProblem] = [
        DailyProblem(
            id: 1,
            prompt: "What is the probability of rolling a 6 on a fair six-sided die?",
            choices: ["1/3", "1/6", "1/2", "1/12"],
            correctIndex: 1,
            explanation: "A fair six-sided die has 6 equally likely outcomes. Only one of these outcomes is a 6. Therefore, the probability is 1/6 ≈ 0.167 or about 16.7%."
        ),
        DailyProblem(
            id: 2,
            prompt: "If you flip a fair coin 3 times, what is the probability of getting exactly 2 heads?",
            choices: ["1/4", "3/8", "1/2", "1/8"],
            correctIndex: 1,
            explanation: "There are 2³ = 8 possible outcomes when flipping 3 coins. The favorable outcomes for exactly 2 heads are: HHT, HTH, THH. That's 3 outcomes out of 8, so the probability is 3/8."
        ),
        DailyProblem(
            id: 3,
            prompt: "A bag contains 4 red balls and 6 blue balls. What is the probability of drawing a red ball?",
            choices: ["2/5", "3/5", "1/2", "4/5"],
            correctIndex: 0,
            explanation: "There are 4 + 6 = 10 balls total. The probability of drawing a red ball is 4/10 = 2/5 = 0.4 or 40%."
        ),
        DailyProblem(
            id: 4,
            prompt: "What is 15% of 80?",
            choices: ["10", "12", "15", "8"],
            correctIndex: 1,
            explanation: "To find 15% of 80, calculate: 0.15 × 80 = 12. Alternatively, 10% of 80 is 8, and 5% is 4, so 15% is 8 + 4 = 12."
        ),
        DailyProblem(
            id: 5,
            prompt: "If the mean of 5, 10, 15, 20, and x is 12, what is x?",
            choices: ["8", "10", "12", "15"],
            correctIndex: 1,
            explanation: "The mean is the sum divided by count. So (5 + 10 + 15 + 20 + x) / 5 = 12. This means 50 + x = 60, so x = 10."
        ),
        DailyProblem(
            id: 6,
            prompt: "Two dice are rolled. What is the probability that the sum is 7?",
            choices: ["1/6", "1/12", "5/36", "7/36"],
            correctIndex: 0,
            explanation: "There are 36 possible outcomes. The pairs that sum to 7 are: (1,6), (2,5), (3,4), (4,3), (5,2), (6,1). That's 6 outcomes, so the probability is 6/36 = 1/6."
        ),
        DailyProblem(
            id: 7,
            prompt: "What is the median of: 3, 7, 2, 9, 5?",
            choices: ["3", "5", "7", "5.2"],
            correctIndex: 1,
            explanation: "First, sort the numbers: 2, 3, 5, 7, 9. The median is the middle value. With 5 numbers, the middle (3rd) value is 5."
        ),
        DailyProblem(
            id: 8,
            prompt: "A store offers 20% off, then an additional 10% off the sale price. What is the total discount?",
            choices: ["30%", "28%", "25%", "32%"],
            correctIndex: 1,
            explanation: "If original price is $100: After 20% off = $80. After 10% off of $80 = $72. Total discount = $28, which is 28% of original."
        ),
        DailyProblem(
            id: 9,
            prompt: "What is the probability of drawing a face card (J, Q, K) from a standard 52-card deck?",
            choices: ["1/4", "3/13", "1/13", "12/52"],
            correctIndex: 1,
            explanation: "There are 12 face cards (3 per suit × 4 suits). Probability = 12/52 = 3/13 ≈ 0.231 or about 23.1%."
        ),
        DailyProblem(
            id: 10,
            prompt: "If you invest $1000 at 5% annual interest compounded yearly, how much do you have after 1 year?",
            choices: ["$1005", "$1050", "$1500", "$1100"],
            correctIndex: 1,
            explanation: "After 1 year: $1000 × (1 + 0.05) = $1000 × 1.05 = $1050."
        ),
        DailyProblem(
            id: 11,
            prompt: "What is the expected value when rolling a fair six-sided die?",
            choices: ["3", "3.5", "4", "3.25"],
            correctIndex: 1,
            explanation: "Expected value = (1 + 2 + 3 + 4 + 5 + 6) / 6 = 21/6 = 3.5. This is the average outcome over many rolls."
        ),
        DailyProblem(
            id: 12,
            prompt: "A test has 10 true/false questions. How many ways can you answer all questions?",
            choices: ["20", "100", "512", "1024"],
            correctIndex: 3,
            explanation: "Each question has 2 choices. For 10 questions, that's 2¹⁰ = 1024 possible ways to answer the test."
        )
    ]

    /// Returns today's puzzle based on day of year
    static func getTodaysPuzzle() -> DailyProblem {
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let index = (dayOfYear - 1) % puzzles.count
        return puzzles[index]
    }
}
