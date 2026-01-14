//
//  PokerGameView.swift
//  quantchimp
//
//  Poker game view with swipe gesture to choose winning hand
//

import SwiftUI

struct PokerGameView: View {
    @EnvironmentObject var appState: AppState

    let difficulty: Difficulty
    let duration: Duration
    let showHandNames: Bool
    let onComplete: (Int, Int) -> Void
    let onExit: () -> Void

    @State private var timeRemaining: Int
    @State private var leftHand: PokerHand
    @State private var rightHand: PokerHand
    @State private var correctCount = 0
    @State private var totalAttempts = 0
    @State private var swipeOffset: CGFloat = 0
    @State private var showFeedback: FeedbackType? = nil
    @State private var selectedSide: SwipeSide? = nil
    @State private var showExitConfirmation = false
    @State private var timerTask: Task<Void, Never>?
    @State private var isFirstDeal = true

    enum FeedbackType {
        case correct, incorrect
    }

    enum SwipeSide {
        case left, right
    }

    init(
        difficulty: Difficulty,
        duration: Duration,
        showHandNames: Bool,
        onComplete: @escaping (Int, Int) -> Void,
        onExit: @escaping () -> Void
    ) {
        self.difficulty = difficulty
        self.duration = duration
        self.showHandNames = showHandNames
        self.onComplete = onComplete
        self.onExit = onExit
        self._timeRemaining = State(initialValue: duration.seconds)

        let (hand1, hand2) = PokerHand.generatePair(difficulty: difficulty)
        self._leftHand = State(initialValue: hand1)
        self._rightHand = State(initialValue: hand2)
    }

    var body: some View {
        VStack(spacing: 0) {
            // Top bar
            HStack {
                IconButton(icon: "xmark", backgroundColor: Theme.surfaceElevated, size: 40) {
                    showExitConfirmation = true
                }

                Spacer()

                timerView

                Spacer()

                scoreView
            }
            .padding(.horizontal, Spacing.md)
            .padding(.top, Spacing.lg)

            Spacer()

            // Card display with swipe gesture
            cardDisplay

            Spacer()

            // Instruction text
            instructionText
                .padding(.bottom, Spacing.xl)
        }
        .alert("Exit Poker Sprint?", isPresented: $showExitConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Exit", role: .destructive) {
                timerTask?.cancel()
                onExit()
            }
        } message: {
            Text("Your progress will be lost.")
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            timerTask?.cancel()
        }
    }

    private var timerView: some View {
        HStack(spacing: Spacing.xs) {
            Image(systemName: "timer")
                .font(.system(size: 20))
                .foregroundColor(timeRemaining <= 10 ? Theme.error : Theme.accent)

            Text("\(timeRemaining)s")
                .font(Typography.heading3)
                .foregroundColor(timeRemaining <= 10 ? Theme.error : Theme.textPrimary)
                .monospacedDigit()
        }
    }

    private var scoreView: some View {
        HStack(spacing: Spacing.xs) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 20))
                .foregroundColor(Theme.success)

            Text("\(correctCount)")
                .font(Typography.heading3)
                .foregroundColor(Theme.textPrimary)
                .monospacedDigit()
        }
    }

    private var cardDisplay: some View {
        HStack(spacing: Spacing.xl) {
            // Left hand
            PokerHandCard(hand: leftHand, showName: showHandNames, isFirstDeal: isFirstDeal, isLeft: true)
                .scaleEffect(selectedSide == .left ? 1.05 : (selectedSide == .right ? 0.95 : 1.0))
                .opacity(selectedSide == .right ? 0.5 : 1.0)
                .rotationEffect(.degrees(selectedSide == .left ? -5 : 0))

            // Right hand
            PokerHandCard(hand: rightHand, showName: showHandNames, isFirstDeal: isFirstDeal, isLeft: false)
                .scaleEffect(selectedSide == .right ? 1.05 : (selectedSide == .left ? 0.95 : 1.0))
                .opacity(selectedSide == .left ? 0.5 : 1.0)
                .rotationEffect(.degrees(selectedSide == .right ? 5 : 0))
        }
        .padding(.horizontal, Spacing.md)
        .offset(x: swipeOffset * 0.3)
        .gesture(
            DragGesture()
                .onChanged { value in
                    swipeOffset = value.translation.width

                    // Visual feedback during drag
                    if abs(swipeOffset) > 50 {
                        if swipeOffset < 0 {
                            selectedSide = .left
                        } else {
                            selectedSide = .right
                        }
                    } else {
                        selectedSide = nil
                    }
                }
                .onEnded { value in
                    let velocity = value.predictedEndLocation.x - value.location.x

                    if abs(value.translation.width) > 80 || abs(velocity) > 500 {
                        // Determine swipe direction
                        let swipedLeft = value.translation.width < 0
                        handleSwipe(swipedLeft ? .left : .right)
                    } else {
                        // Snap back
                        withAnimation(Motion.spring) {
                            swipeOffset = 0
                            selectedSide = nil
                        }
                    }
                }
        )
        .overlay {
            // Feedback overlay
            if let feedback = showFeedback {
                feedbackOverlay(feedback)
            }
        }
    }

    private func feedbackOverlay(_ feedback: FeedbackType) -> some View {
        VStack(spacing: Spacing.md) {
            Image(feedback == .correct ? "monkey_excellent" : "monkey_practice")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)

            Text(feedback == .correct ? "Correct!" : "Wrong!")
                .font(Typography.heading1)
                .foregroundColor(.white)
        }
        .padding(Spacing.xl)
        .background(
            RoundedRectangle(cornerRadius: Radius.xlg)
                .fill(feedback == .correct ? Theme.success : Theme.error)
                .shadow(color: .black.opacity(0.5), radius: 20, x: 0, y: 10)
        )
        .transition(.scale.combined(with: .opacity))
    }

    private var instructionText: some View {
        Text("← Swipe to choose winner →")
            .font(Typography.body)
            .foregroundColor(Theme.textSecondary)
    }

    private func startTimer() {
        Sound.start()

        timerTask = Task {
            while !Task.isCancelled && timeRemaining > 0 {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                if !Task.isCancelled {
                    await MainActor.run {
                        timeRemaining -= 1

                        if timeRemaining <= 10 && timeRemaining > 0 {
                            Sound.tick()
                            if timeRemaining == 10 {
                                Haptic.warning()
                            }
                        }

                        if timeRemaining == 0 {
                            Haptic.success()
                            Sound.gameOver()
                            onComplete(correctCount, totalAttempts)
                        }
                    }
                }
            }
        }
    }

    private func handleSwipe(_ side: SwipeSide) {
        totalAttempts += 1

        // Determine if the selected hand wins
        let selectedHandWins = (side == .left && leftHand.beats(rightHand)) ||
                               (side == .right && rightHand.beats(leftHand))

        withAnimation(Motion.spring) {
            showFeedback = selectedHandWins ? .correct : .incorrect
            selectedSide = side
        }

        if selectedHandWins {
            correctCount += 1
            Haptic.success()
            Sound.success()
        } else {
            Haptic.warning()
            Sound.error()
        }

        // Generate new hands after feedback
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let (hand1, hand2) = PokerHand.generatePair(difficulty: difficulty)

            withAnimation(Motion.spring) {
                leftHand = hand1
                rightHand = hand2
                showFeedback = nil
                selectedSide = nil
                swipeOffset = 0
                isFirstDeal = false
            }
        }
    }
}

// MARK: - Poker Hand Card

struct PokerHandCard: View {
    let hand: PokerHand
    let showName: Bool
    let isFirstDeal: Bool
    let isLeft: Bool

    var body: some View {
        VStack(spacing: Spacing.smd) {
            // Cards display - vertical column layout
            VStack(spacing: Spacing.sm) {
                ForEach(Array(hand.cards.enumerated()), id: \.element.id) { index, card in
                    IndividualCard(
                        card: card,
                        cardIndex: index,
                        isFirstDeal: isFirstDeal,
                        isLeft: isLeft
                    )
                    .id(card.id)
                }
            }
            .padding(Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: Radius.lg)
                    .fill(Theme.surface)
            )

            // Hand name (if enabled)
            if showName {
                Text(hand.displayName)
                    .font(Typography.caption)
                    .foregroundColor(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .transition(.opacity)
            }
        }
        .id(hand.id)
    }
}

// MARK: - Individual Playing Card

struct IndividualCard: View {
    let card: PokerCard
    let cardIndex: Int
    let isFirstDeal: Bool
    let isLeft: Bool

    @State private var isDealt = false
    @State private var isFlipped = false

    var body: some View {
        ZStack {
            // Back of card
            RoundedRectangle(cornerRadius: Radius.md)
                .fill(
                    LinearGradient(
                        colors: [Color(red: 0.2, green: 0.3, blue: 0.5), Color(red: 0.15, green: 0.25, blue: 0.45)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 75, height: 100)
                .overlay(
                    RoundedRectangle(cornerRadius: Radius.md)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
                .opacity(isFlipped ? 0 : 1)

            // Front of card
            VStack(spacing: 6) {
                // Rank
                Text(card.rank.displayString)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(card.suit.isRed ? Theme.error : .black)

                // Suit
                Text(card.suit.rawValue)
                    .font(.system(size: 24))
                    .foregroundColor(card.suit.isRed ? Theme.error : .black)
            }
            .frame(width: 75, height: 100)
            .background(
                RoundedRectangle(cornerRadius: Radius.md)
                    .fill(.white)
                    .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: Radius.md)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
            .opacity(isFlipped ? 1 : 0)
        }
        .rotation3DEffect(
            .degrees(isFlipped ? 0 : 180),
            axis: (x: 0, y: 1, z: 0)
        )
        .offset(y: isDealt ? 0 : -300)
        .offset(x: isDealt ? 0 : (isLeft ? -50 : 50))
        .rotationEffect(.degrees(isDealt ? 0 : -15))
        .scaleEffect(isDealt ? 1 : 0.8)
        .opacity(isDealt ? 1 : 0)
        .onAppear {
            if isFirstDeal {
                // Dealing animation
                let dealDelay = Double(cardIndex) * 0.1
                withAnimation(Motion.spring.delay(dealDelay)) {
                    isDealt = true
                }
                // Flip animation after dealing
                withAnimation(Motion.spring.delay(dealDelay + 0.3)) {
                    isFlipped = true
                }
            } else {
                // Instant appearance for subsequent hands
                isDealt = true
                isFlipped = false
                // Quick flip animation
                withAnimation(Motion.spring.delay(Double(cardIndex) * 0.08)) {
                    isFlipped = true
                }
            }
        }
        .onChange(of: card.id) { _, _ in
            // Flip out old card
            withAnimation(Motion.spring) {
                isFlipped = false
            }
            // Flip in new card
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(Motion.spring.delay(Double(cardIndex) * 0.08)) {
                    isFlipped = true
                }
            }
        }
    }
}

#Preview {
    PokerGameView(
        difficulty: .easy,
        duration: .bullet,
        showHandNames: true,
        onComplete: { _, _ in },
        onExit: {}
    )
    .environmentObject(AppState())
}
