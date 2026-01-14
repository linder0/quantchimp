//
//  PokerHand.swift
//  quantchimp
//
//  Poker hand evaluation and comparison logic for Poker Sprint mode
//

import Foundation

// MARK: - Poker Card

struct PokerCard: Identifiable, Equatable {
    let id = UUID()
    let rank: Rank
    let suit: Suit

    enum Rank: Int, CaseIterable, Comparable {
        case two = 2, three, four, five, six, seven, eight, nine, ten
        case jack = 11, queen, king, ace

        var displayString: String {
            switch self {
            case .two: return "2"
            case .three: return "3"
            case .four: return "4"
            case .five: return "5"
            case .six: return "6"
            case .seven: return "7"
            case .eight: return "8"
            case .nine: return "9"
            case .ten: return "10"
            case .jack: return "J"
            case .queen: return "Q"
            case .king: return "K"
            case .ace: return "A"
            }
        }

        static func < (lhs: Rank, rhs: Rank) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
    }

    enum Suit: String, CaseIterable {
        case spades = "♠"
        case hearts = "♥"
        case diamonds = "♦"
        case clubs = "♣"

        var isRed: Bool {
            self == .hearts || self == .diamonds
        }
    }
}

// MARK: - Poker Hand

struct PokerHand: Identifiable {
    let id = UUID()
    let cards: [PokerCard]

    init(cards: [PokerCard]) {
        assert(cards.count == 5, "Poker hand must have exactly 5 cards")
        self.cards = cards
    }

    // MARK: - Hand Evaluation

    var evaluation: HandEvaluation {
        let sortedCards = cards.sorted { $0.rank > $1.rank }
        let ranks = sortedCards.map { $0.rank }
        let suits = sortedCards.map { $0.suit }

        // Count occurrences of each rank
        var rankCounts: [PokerCard.Rank: Int] = [:]
        for rank in ranks {
            rankCounts[rank, default: 0] += 1
        }

        let counts = rankCounts.values.sorted(by: >)

        // Check for flush
        let isFlush = Set(suits).count == 1

        // Check for straight
        let isStraight = checkStraight(ranks: ranks)

        // Evaluate hand rank
        if isStraight && isFlush {
            if ranks.contains(.ace) && ranks.contains(.king) {
                return HandEvaluation(rank: .royalFlush, primaryRank: .ace, kickers: [])
            }
            return HandEvaluation(rank: .straightFlush, primaryRank: ranks.max()!, kickers: [])
        }

        if counts == [4, 1] {
            let quadRank = rankCounts.first { $0.value == 4 }!.key
            let kicker = rankCounts.first { $0.value == 1 }!.key
            return HandEvaluation(rank: .fourOfAKind, primaryRank: quadRank, kickers: [kicker])
        }

        if counts == [3, 2] {
            let tripleRank = rankCounts.first { $0.value == 3 }!.key
            let pairRank = rankCounts.first { $0.value == 2 }!.key
            return HandEvaluation(rank: .fullHouse, primaryRank: tripleRank, secondaryRank: pairRank, kickers: [])
        }

        if isFlush {
            let sortedRanks = ranks.sorted(by: >)
            return HandEvaluation(rank: .flush, primaryRank: sortedRanks[0], kickers: Array(sortedRanks[1...]))
        }

        if isStraight {
            return HandEvaluation(rank: .straight, primaryRank: ranks.max()!, kickers: [])
        }

        if counts == [3, 1, 1] {
            let tripleRank = rankCounts.first { $0.value == 3 }!.key
            let kickers = rankCounts.filter { $0.value == 1 }.map { $0.key }.sorted(by: >)
            return HandEvaluation(rank: .threeOfAKind, primaryRank: tripleRank, kickers: kickers)
        }

        if counts == [2, 2, 1] {
            let pairs = rankCounts.filter { $0.value == 2 }.map { $0.key }.sorted(by: >)
            let kicker = rankCounts.first { $0.value == 1 }!.key
            return HandEvaluation(rank: .twoPair, primaryRank: pairs[0], secondaryRank: pairs[1], kickers: [kicker])
        }

        if counts == [2, 1, 1, 1] {
            let pairRank = rankCounts.first { $0.value == 2 }!.key
            let kickers = rankCounts.filter { $0.value == 1 }.map { $0.key }.sorted(by: >)
            return HandEvaluation(rank: .pair, primaryRank: pairRank, kickers: kickers)
        }

        let sortedRanks = ranks.sorted(by: >)
        return HandEvaluation(rank: .highCard, primaryRank: sortedRanks[0], kickers: Array(sortedRanks[1...]))
    }

    private func checkStraight(ranks: [PokerCard.Rank]) -> Bool {
        let sortedRanks = ranks.sorted()

        // Check for regular straight
        let isConsecutive = (0..<4).allSatisfy { i in
            sortedRanks[i+1].rawValue == sortedRanks[i].rawValue + 1
        }

        if isConsecutive {
            return true
        }

        // Check for A-2-3-4-5 (wheel)
        let rankValues = Set(ranks.map { $0.rawValue })
        if rankValues == [14, 2, 3, 4, 5] {
            return true
        }

        return false
    }

    // MARK: - Display Name

    var displayName: String {
        let eval = evaluation
        switch eval.rank {
        case .royalFlush:
            return "Royal Flush"
        case .straightFlush:
            return "Straight Flush"
        case .fourOfAKind:
            return "Four \(eval.primaryRank.displayString)s"
        case .fullHouse:
            return "Full House"
        case .flush:
            return "\(eval.primaryRank.displayString) High Flush"
        case .straight:
            return "\(eval.primaryRank.displayString) High Straight"
        case .threeOfAKind:
            return "Three \(eval.primaryRank.displayString)s"
        case .twoPair:
            return "Two Pair"
        case .pair:
            return "Pair of \(eval.primaryRank.displayString)s"
        case .highCard:
            return "\(eval.primaryRank.displayString) High"
        }
    }

    // MARK: - Comparison

    /// Compare this hand to another and return true if this hand wins
    func beats(_ other: PokerHand) -> Bool {
        let eval1 = self.evaluation
        let eval2 = other.evaluation

        // Compare hand ranks first
        if eval1.rank != eval2.rank {
            return eval1.rank > eval2.rank
        }

        // Same hand rank, compare primary rank
        if eval1.primaryRank != eval2.primaryRank {
            return eval1.primaryRank > eval2.primaryRank
        }

        // Compare secondary rank if applicable
        if let sec1 = eval1.secondaryRank, let sec2 = eval2.secondaryRank {
            if sec1 != sec2 {
                return sec1 > sec2
            }
        }

        // Compare kickers
        for i in 0..<min(eval1.kickers.count, eval2.kickers.count) {
            if eval1.kickers[i] != eval2.kickers[i] {
                return eval1.kickers[i] > eval2.kickers[i]
            }
        }

        // Hands are equal (tie)
        return false
    }

    // MARK: - Hand Generation

    /// Generate a random pair of hands based on difficulty
    static func generatePair(difficulty: Difficulty) -> (PokerHand, PokerHand) {
        var attempts = 0
        let maxAttempts = 100

        while attempts < maxAttempts {
            let (hand1, hand2) = generateTwoRandomHands()
            let eval1 = hand1.evaluation
            let eval2 = hand2.evaluation

            // Ensure hands are not tied
            if hand1.beats(hand2) || hand2.beats(hand1) {
                let rankDiff = abs(eval1.rank.rawValue - eval2.rank.rawValue)

                switch difficulty {
                case .easy:
                    // Easy: 3+ rank difference (e.g., Flush vs Two Pair)
                    if rankDiff >= 3 {
                        return (hand1, hand2)
                    }

                case .medium:
                    // Medium: 1-2 rank difference
                    if rankDiff >= 1 && rankDiff <= 2 {
                        return (hand1, hand2)
                    }

                case .hard:
                    // Hard: Same hand rank (kicker battles)
                    if rankDiff == 0 {
                        return (hand1, hand2)
                    }
                }
            }

            attempts += 1
        }

        // Fallback: generate appropriate hands for the difficulty
        return generateFallbackPair(difficulty: difficulty)
    }

    private static func generateTwoRandomHands() -> (PokerHand, PokerHand) {
        var deck = createDeck()
        deck.shuffle()

        let hand1Cards = Array(deck[0..<5])
        let hand2Cards = Array(deck[5..<10])

        return (PokerHand(cards: hand1Cards), PokerHand(cards: hand2Cards))
    }

    private static func createDeck() -> [PokerCard] {
        var deck: [PokerCard] = []
        for suit in PokerCard.Suit.allCases {
            for rank in PokerCard.Rank.allCases {
                deck.append(PokerCard(rank: rank, suit: suit))
            }
        }
        return deck
    }

    private static func generateFallbackPair(difficulty: Difficulty) -> (PokerHand, PokerHand) {
        // Generate specific hands for each difficulty as fallback
        switch difficulty {
        case .easy:
            // Generate a flush vs a pair
            return (generateFlush(), generatePair())
        case .medium:
            // Generate a straight vs three of a kind
            return (generateStraight(), generateThreeOfAKind())
        case .hard:
            // Generate two high cards with close kickers
            return generateHighCardPair()
        }
    }

    private static func generateFlush() -> PokerHand {
        let suit = PokerCard.Suit.allCases.randomElement()!
        let ranks = PokerCard.Rank.allCases.shuffled().prefix(5)
        let cards = ranks.map { PokerCard(rank: $0, suit: suit) }
        return PokerHand(cards: Array(cards))
    }

    private static func generatePair() -> PokerHand {
        let pairRank = PokerCard.Rank.allCases.randomElement()!
        let otherRanks = PokerCard.Rank.allCases.filter { $0 != pairRank }.shuffled().prefix(3)
        let suits = PokerCard.Suit.allCases.shuffled()

        var cards: [PokerCard] = []
        cards.append(PokerCard(rank: pairRank, suit: suits[0]))
        cards.append(PokerCard(rank: pairRank, suit: suits[1]))

        for (i, rank) in otherRanks.enumerated() {
            cards.append(PokerCard(rank: rank, suit: suits[i + 2]))
        }

        return PokerHand(cards: cards.shuffled())
    }

    private static func generateStraight() -> PokerHand {
        let startRank = Int.random(in: 2...10)
        let ranks = (startRank..<startRank+5).map { PokerCard.Rank(rawValue: $0)! }
        let suits = (0..<5).map { _ in PokerCard.Suit.allCases.randomElement()! }

        // Ensure not all same suit (would be straight flush)
        var finalSuits = suits
        if Set(suits).count == 1 {
            finalSuits[0] = PokerCard.Suit.allCases.filter { $0 != suits[0] }.randomElement()!
        }

        let cards = zip(ranks, finalSuits).map { PokerCard(rank: $0.0, suit: $0.1) }
        return PokerHand(cards: Array(cards))
    }

    private static func generateThreeOfAKind() -> PokerHand {
        let tripleRank = PokerCard.Rank.allCases.randomElement()!
        let otherRanks = PokerCard.Rank.allCases.filter { $0 != tripleRank }.shuffled().prefix(2)
        let suits = PokerCard.Suit.allCases.shuffled()

        var cards: [PokerCard] = []
        cards.append(PokerCard(rank: tripleRank, suit: suits[0]))
        cards.append(PokerCard(rank: tripleRank, suit: suits[1]))
        cards.append(PokerCard(rank: tripleRank, suit: suits[2]))

        for (i, rank) in otherRanks.enumerated() {
            cards.append(PokerCard(rank: rank, suit: suits[i + 3]))
        }

        return PokerHand(cards: cards.shuffled())
    }

    private static func generateHighCardPair() -> (PokerHand, PokerHand) {
        // Generate two high card hands with similar high cards but different kickers
        let highCard = PokerCard.Rank.allCases.randomElement()!
        let secondCard = PokerCard.Rank.allCases.filter { $0 != highCard }.randomElement()!

        // Hand 1: high card, second card, and 3 random kickers
        let kickers1 = PokerCard.Rank.allCases.filter { $0 != highCard && $0 != secondCard }.shuffled().prefix(3)
        var cards1: [PokerCard] = [
            PokerCard(rank: highCard, suit: .spades),
            PokerCard(rank: secondCard, suit: .hearts)
        ]
        for (i, rank) in kickers1.enumerated() {
            cards1.append(PokerCard(rank: rank, suit: PokerCard.Suit.allCases[i]))
        }

        // Hand 2: same high card, different second card
        let secondCard2 = PokerCard.Rank.allCases.filter {
            $0 != highCard && $0 != secondCard
        }.randomElement()!
        let kickers2 = PokerCard.Rank.allCases.filter {
            $0 != highCard && $0 != secondCard2
        }.shuffled().prefix(3)
        var cards2: [PokerCard] = [
            PokerCard(rank: highCard, suit: .diamonds),
            PokerCard(rank: secondCard2, suit: .clubs)
        ]
        for (i, rank) in kickers2.enumerated() {
            cards2.append(PokerCard(rank: rank, suit: PokerCard.Suit.allCases[i]))
        }

        return (PokerHand(cards: cards1), PokerHand(cards: cards2))
    }
}

// MARK: - Hand Evaluation

struct HandEvaluation {
    let rank: HandRank
    let primaryRank: PokerCard.Rank
    var secondaryRank: PokerCard.Rank? = nil
    let kickers: [PokerCard.Rank]
}

enum HandRank: Int, Comparable {
    case highCard = 1
    case pair = 2
    case twoPair = 3
    case threeOfAKind = 4
    case straight = 5
    case flush = 6
    case fullHouse = 7
    case fourOfAKind = 8
    case straightFlush = 9
    case royalFlush = 10

    static func < (lhs: HandRank, rhs: HandRank) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
