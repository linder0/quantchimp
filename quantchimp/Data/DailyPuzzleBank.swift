//
//  DailyPuzzleBank.swift
//  quantchimp
//
//  Created by Linda Xue on 1/8/26.
//

import Foundation

struct DailyPuzzleBank {
    static let puzzles: [DailyProblem] = [
        // MARK: - Easy (Difficulty 1-2)

        DailyProblem(
            id: 1,
            prompt: "You place 3 dots along the edges of an octagon at random. What is the probability that all three dots lie on distinct edges of the octagon?",
            answer: "21/32",
            explanation: "The first dot will be placed on a distinct edge by default. For the second dot to be on a distinct edge, it must avoid the first edge (7/8 probability). The third dot must avoid both previous edges (6/8 probability). Total probability: 1 × (7/8) × (6/8) = 21/32.",
            difficulty: 1
        ),
        DailyProblem(
            id: 2,
            prompt: "At an ice cream shop you can choose from 10 toppings and must choose at least one. How many different topping combinations are possible?",
            answer: "1023",
            explanation: "Each topping can be either included or excluded, giving 2^10 total combinations. Excluding the case where no toppings are chosen leaves 2^10 - 1 = 1023.",
            difficulty: 1
        ),
        DailyProblem(
            id: 3,
            prompt: "Dan has two glasses. The first is full and the second is empty. He pours all the water from the first into the second and the second becomes 3/4 full. What is the ratio of the volume of the first glass to the second?",
            answer: "3/4",
            explanation: "Let the volumes be x and y. Pouring the full first glass into the second fills it 3/4, giving x = (3/4)y. The ratio x/y = 3/4.",
            difficulty: 1
        ),
        DailyProblem(
            id: 4,
            prompt: "Integers a and b are chosen uniformly from −10 to 10. What is the probability max(0, a) = min(0, b)?",
            answer: "121/441",
            explanation: "The condition holds exactly when a ≤ 0 and b ≥ 0. There are 11 choices for each (including 0) out of 21 total possibilities each, giving probability (11/21) × (11/21) = 121/441.",
            difficulty: 1
        ),

        // MARK: - Easy-Medium (Difficulty 2)

        DailyProblem(
            id: 5,
            prompt: "A point is chosen uniformly at random on the unit sphere. What is the variance of the z coordinate?",
            answer: "1/3",
            explanation: "By symmetry the expected value of z is zero. The distribution of z is uniform between -1 and 1, giving E[z²] = 1/3. Since Var(z) = E[z²] - E[z]², the variance is 1/3.",
            difficulty: 2
        ),
        DailyProblem(
            id: 6,
            prompt: "You have a 10 by 10 by 10 cube made of unit cubes. After dipping the entire cube in paint, how many unit cubes have no paint on them?",
            answer: "512",
            explanation: "Removing the painted outer layer leaves an 8 × 8 × 8 cube of unpainted cubes. 8³ = 512.",
            difficulty: 2
        ),
        DailyProblem(
            id: 7,
            prompt: "What is the probability of drawing a four of a kind in a standard five card poker hand?",
            answer: "624/2598960",
            explanation: "Choose the rank for the four of a kind in 13 ways and the remaining card in 48 ways. Total four of a kind hands = 13 × 48 = 624. Divide by C(52,5) = 2,598,960.",
            difficulty: 2
        ),
        DailyProblem(
            id: 8,
            prompt: "You roll two fair dice and select the higher value. What is the expected value of the selected die?",
            answer: "161/36",
            explanation: "Compute the probability distribution of the maximum of two dice. Multiply each possible maximum (1-6) by its probability and sum to obtain the expectation ≈ 4.47.",
            difficulty: 2
        ),
        DailyProblem(
            id: 9,
            prompt: "Samuel flips a fair coin until he first lands tails. He receives min(64, 2^n) dollars where n is the number of flips. What is his expected payoff?",
            answer: "7",
            explanation: "Split into cases: flips 1-6 pay 2^n with probability (1/2)^n, and flip 7+ pays 64. Sum: Σ(n=1 to 6) 2^n × (1/2)^n + 64 × (1/2)^6 = 6 + 1 = 7.",
            difficulty: 2
        ),
        DailyProblem(
            id: 10,
            prompt: "You are given a 3 by 3 grid and the numbers 1 through 9. Each number is used once. How many ways can you fill the grid so every row and column sums to an even number?",
            answer: "0",
            explanation: "There are five odd numbers and four even numbers. Any row/column summing to even must contain 0 or 2 odd numbers. With 5 odds in 9 cells, at least one row or column must have exactly 1 odd, making an even sum impossible.",
            difficulty: 2
        ),
        DailyProblem(
            id: 11,
            prompt: "Each of 25 independent bakers has a standard deviation of 10 donuts in output. What is the standard deviation of the average number of donuts baked?",
            answer: "2",
            explanation: "Variance adds for independent variables. Var(total) = 25 × 100 = 2500. For the average, Var(avg) = 2500/25² = 4. Standard deviation = √4 = 2.",
            difficulty: 2
        ),
        DailyProblem(
            id: 12,
            prompt: "Five pirates must divide 100 gold coins using majority vote with executions. How many coins does the oldest pirate receive?",
            answer: "98",
            explanation: "Work backward from smaller groups. The oldest bribes just enough pirates who would otherwise receive zero. With five pirates, the oldest keeps 98 coins (giving 1 coin each to pirates 3 and 5).",
            difficulty: 2
        ),
        DailyProblem(
            id: 13,
            prompt: "Positive integers A, B, C, and D satisfy AB = 16, BC = 14, and CD = 63. What is A + B + C + D?",
            answer: "26",
            explanation: "From AB = 16 and BC = 14, B must divide both. B = 2 gives A = 8, C = 7. Then CD = 63 gives D = 9. Sum: 8 + 2 + 7 + 9 = 26.",
            difficulty: 2
        ),

        // MARK: - Medium (Difficulty 3)

        DailyProblem(
            id: 14,
            prompt: "A fair coin is flipped n times. What is the expected length of the longest run of heads?",
            answer: "≈ log₂(n)",
            explanation: "For large n, the expected longest run is approximately log₂(n). This follows from the probability that a run of length k exists, which decays exponentially with k.",
            difficulty: 3
        ),
        DailyProblem(
            id: 15,
            prompt: "What is the sum of all positive divisors of 360?",
            answer: "1170",
            explanation: "360 = 2³ × 3² × 5. Sum of divisors = (1+2+4+8)(1+3+9)(1+5) = 15 × 13 × 6 = 1170.",
            difficulty: 3
        ),
        DailyProblem(
            id: 16,
            prompt: "You draw cards from a shuffled deck until you get an ace. What is the expected number of cards drawn?",
            answer: "53/5",
            explanation: "By symmetry, the 4 aces divide the deck into 5 segments. On average, each segment has 48/5 non-aces. Expected draws = 1 + 48/5 = 53/5 ≈ 10.6.",
            difficulty: 3
        ),
        DailyProblem(
            id: 17,
            prompt: "A stick is broken at two random points. What is the probability the three pieces can form a triangle?",
            answer: "1/4",
            explanation: "For a triangle, no piece can be ≥ 1/2 the total length. The valid region forms 1/4 of the sample space (the center of a triangular diagram).",
            difficulty: 3
        ),
        DailyProblem(
            id: 18,
            prompt: "What is the probability that two randomly chosen integers are coprime?",
            answer: "6/π²",
            explanation: "The probability that two random integers share no common prime factor p is 1 - 1/p². Product over all primes: ∏(1 - 1/p²) = 1/ζ(2) = 6/π² ≈ 0.608.",
            difficulty: 3
        ),
        DailyProblem(
            id: 19,
            prompt: "You have 12 balls, one weighs differently. Using a balance scale, what is the minimum number of weighings to find the odd ball?",
            answer: "3",
            explanation: "Each weighing has 3 outcomes (left heavy, balanced, right heavy). 3 weighings give 3³ = 27 outcomes, enough to identify 1 of 24 possibilities (12 balls × 2 directions).",
            difficulty: 3
        ),
        DailyProblem(
            id: 20,
            prompt: "In how many ways can you place 8 non-attacking rooks on a chessboard?",
            answer: "40320",
            explanation: "Each rook must be in a different row and column. Place the first rook in any of 8 columns, second in 7 remaining, etc. Total = 8! = 40,320.",
            difficulty: 3
        ),
        DailyProblem(
            id: 21,
            prompt: "What is the expected number of coin flips to get two consecutive heads?",
            answer: "6",
            explanation: "Let E be expected flips to HH. After H (expected 2 flips), we either get H (done) or T (restart). E = 2 + (1/2)(0) + (1/2)(E) → E = 6.",
            difficulty: 3
        ),
        DailyProblem(
            id: 22,
            prompt: "A random permutation of 1 to n is chosen. What is the expected number of fixed points?",
            answer: "1",
            explanation: "By linearity of expectation, E[fixed points] = Σ P(position i is fixed) = n × (1/n) = 1. This holds for any n.",
            difficulty: 3
        ),

        // MARK: - Medium (Difficulty 4)

        DailyProblem(
            id: 23,
            prompt: "You shuffle a deck and deal 5 cards. What is the probability of getting exactly one pair?",
            answer: "1098240/2598960",
            explanation: "Choose pair rank (13), pair suits C(4,2), 3 other ranks C(12,3), and their suits (4³). Total = 13 × 6 × 220 × 64 = 1,098,240. Divide by C(52,5).",
            difficulty: 4
        ),
        DailyProblem(
            id: 24,
            prompt: "Two points are chosen uniformly on [0,1]. What is the expected distance between them?",
            answer: "1/3",
            explanation: "E[|X-Y|] = ∫∫|x-y|dxdy = 2∫∫(x-y)dxdy for x>y = 1/3.",
            difficulty: 4
        ),
        DailyProblem(
            id: 25,
            prompt: "What is the probability that a random 3×3 binary matrix has full rank over F₂?",
            answer: "168/512",
            explanation: "First row: any nonzero (7 options). Second row: not in span of first (6 options). Third row: not in span of first two (4 options). Probability = (7×6×4)/512 = 168/512.",
            difficulty: 4
        ),
        DailyProblem(
            id: 26,
            prompt: "A drunkard starts at 0 and takes steps +1 or -1 with equal probability. What is the expected number of steps to reach +1 or -1?",
            answer: "1",
            explanation: "The drunkard reaches +1 or -1 on the very first step with probability 1. Expected steps = 1.",
            difficulty: 4
        ),
        DailyProblem(
            id: 27,
            prompt: "How many trailing zeros does 100! have?",
            answer: "24",
            explanation: "Count factors of 5 in 100!: ⌊100/5⌋ + ⌊100/25⌋ + ⌊100/125⌋ = 20 + 4 + 0 = 24. Each pairs with a factor of 2 to make 10.",
            difficulty: 4
        ),
        DailyProblem(
            id: 28,
            prompt: "What is the sum 1/1! + 1/2! + 1/3! + ... + 1/n! as n→∞?",
            answer: "e - 1",
            explanation: "e = Σ(1/k!) from k=0 to ∞. Subtracting the k=0 term (which is 1), we get e - 1 ≈ 1.718.",
            difficulty: 4
        ),
        DailyProblem(
            id: 29,
            prompt: "You roll a die repeatedly until you get a 6. What is the expected number of rolls?",
            answer: "6",
            explanation: "This is a geometric distribution with p = 1/6. Expected value = 1/p = 6.",
            difficulty: 4
        ),
        DailyProblem(
            id: 30,
            prompt: "What is the probability that a random chord of a circle is longer than the side of an inscribed equilateral triangle?",
            answer: "1/3",
            explanation: "Using the midpoint method: a chord is longer than the triangle side iff its midpoint lies within a concentric circle of radius 1/2. Area ratio = 1/4... Actually 1/3 by random endpoint method.",
            difficulty: 4
        ),

        // MARK: - Medium-Hard (Difficulty 5)

        DailyProblem(
            id: 31,
            prompt: "What is the expected number of distinct values when rolling n fair dice?",
            answer: "6(1 - (5/6)^n)",
            explanation: "By linearity, E[distinct] = Σ P(face i appears at least once) = 6 × (1 - (5/6)^n).",
            difficulty: 5
        ),
        DailyProblem(
            id: 32,
            prompt: "In a room of n people, what is the expected number of birthday collisions (pairs sharing a birthday)?",
            answer: "n(n-1)/(2×365)",
            explanation: "There are C(n,2) pairs. Each pair shares a birthday with probability 1/365. Expected collisions = n(n-1)/730.",
            difficulty: 5
        ),
        DailyProblem(
            id: 33,
            prompt: "A monkey types randomly on a 26-letter keyboard. What is the expected number of keystrokes to type 'AB'?",
            answer: "702",
            explanation: "Expected time to hit A is 26. From A, expected time to AB is 26 (if B) or 26 + E (if A, restart) or 26 + E (if other). Solving: E = 26 + 26×26 = 702.",
            difficulty: 5
        ),
        DailyProblem(
            id: 34,
            prompt: "What is the probability that a random permutation of n elements has no fixed points (derangement)?",
            answer: "≈ 1/e",
            explanation: "D(n)/n! ≈ 1/e as n→∞. More precisely, D(n) = n! × Σ((-1)^k/k!) from k=0 to n.",
            difficulty: 5
        ),
        DailyProblem(
            id: 35,
            prompt: "You have n identical balls and k distinct boxes. How many ways can you distribute the balls?",
            answer: "C(n+k-1, k-1)",
            explanation: "Stars and bars: arrange n stars (balls) and k-1 bars (dividers). Choose positions for bars: C(n+k-1, k-1).",
            difficulty: 5
        ),
        DailyProblem(
            id: 36,
            prompt: "What is E[X²] if X is uniformly distributed on [0, 1]?",
            answer: "1/3",
            explanation: "E[X²] = ∫₀¹ x² dx = [x³/3]₀¹ = 1/3.",
            difficulty: 5
        ),
        DailyProblem(
            id: 37,
            prompt: "A fair coin is flipped until both heads and tails have appeared. What is the expected number of flips?",
            answer: "3",
            explanation: "First flip is always new. Expected flips for second outcome = 2 (geometric with p=1/2). Total = 1 + 2 = 3.",
            difficulty: 5
        ),
        DailyProblem(
            id: 38,
            prompt: "What is the expected number of shuffles (riffle) to randomize a deck of 52 cards?",
            answer: "≈ 7",
            explanation: "By the Gilbert-Shannon-Reeds model, about 3/2 log₂(52) ≈ 7 shuffles are needed for a deck to be nearly random.",
            difficulty: 5
        ),

        // MARK: - Medium-Hard (Difficulty 6)

        DailyProblem(
            id: 39,
            prompt: "What is the probability that a random graph on n vertices (each edge independently with p=1/2) is connected?",
            answer: "≈ 1 for large n",
            explanation: "For p = 1/2, the graph is almost surely connected for large n. The threshold for connectivity is p ≈ ln(n)/n.",
            difficulty: 6
        ),
        DailyProblem(
            id: 40,
            prompt: "You draw cards without replacement until you get a spade. What is the expected number of cards drawn?",
            answer: "53/14",
            explanation: "The 13 spades divide the deck into 14 gaps. Each gap has expected length 39/14 non-spades. Expected draws = 1 + 39/14 = 53/14 ≈ 3.79.",
            difficulty: 6
        ),
        DailyProblem(
            id: 41,
            prompt: "In a game, you flip a coin. If heads, you win $1. If tails, you lose all. You can quit anytime. What's the optimal strategy if you start with $1?",
            answer: "Quit immediately",
            explanation: "If you flip, expected value is 0.5×$2 + 0.5×$0 = $1. Same as quitting. But any further flip risks losing everything for no expected gain.",
            difficulty: 6
        ),
        DailyProblem(
            id: 42,
            prompt: "What is the probability that a random 5-card poker hand contains at least one ace?",
            answer: "1 - C(48,5)/C(52,5)",
            explanation: "P(no aces) = C(48,5)/C(52,5). P(at least one ace) = 1 - C(48,5)/C(52,5) ≈ 0.341.",
            difficulty: 6
        ),
        DailyProblem(
            id: 43,
            prompt: "A biased coin has P(H) = p. What value of p maximizes the entropy of a single flip?",
            answer: "1/2",
            explanation: "Entropy H = -p log p - (1-p) log(1-p) is maximized when p = 1/2, giving H = 1 bit.",
            difficulty: 6
        ),
        DailyProblem(
            id: 44,
            prompt: "What is the expected number of inversions in a random permutation of n elements?",
            answer: "n(n-1)/4",
            explanation: "There are C(n,2) pairs. Each pair is inverted with probability 1/2. Expected inversions = n(n-1)/4.",
            difficulty: 6
        ),
        DailyProblem(
            id: 45,
            prompt: "You observe X ~ Poisson(λ). What is the MLE for λ given X = 5?",
            answer: "5",
            explanation: "For Poisson, the MLE of λ is the sample mean. With one observation X = 5, the MLE is λ̂ = 5.",
            difficulty: 6
        ),
        DailyProblem(
            id: 46,
            prompt: "What is E[min(X,Y)] where X,Y are iid Exp(λ)?",
            answer: "1/(2λ)",
            explanation: "min(X,Y) ~ Exp(2λ) since the minimum of iid exponentials has rate = sum of rates. E[min] = 1/(2λ).",
            difficulty: 6
        ),

        // MARK: - Hard (Difficulty 7)

        DailyProblem(
            id: 47,
            prompt: "A random walk starts at 0 and goes to +1 or -1 with equal probability. What is the probability it ever returns to 0?",
            answer: "1",
            explanation: "In 1D simple random walk, the probability of eventual return to origin is 1 (recurrence). This follows from the fact that Σ P(S₂ₙ=0) diverges.",
            difficulty: 7
        ),
        DailyProblem(
            id: 48,
            prompt: "What is the expected number of rolls of a fair die to see all six faces?",
            answer: "14.7",
            explanation: "Coupon collector problem: E = 6(1/1 + 1/2 + 1/3 + 1/4 + 1/5 + 1/6) = 6 × H₆ ≈ 14.7.",
            difficulty: 7
        ),
        DailyProblem(
            id: 49,
            prompt: "What is the probability that a random binary string of length n has no two consecutive 1s?",
            answer: "F(n+2)/2^n",
            explanation: "The count of valid strings follows Fibonacci: a(n) = a(n-1) + a(n-2). With a(1)=2, a(2)=3, we get a(n) = F(n+2). Probability = F(n+2)/2^n.",
            difficulty: 7
        ),
        DailyProblem(
            id: 50,
            prompt: "What is E[X] where X = max of n iid Uniform[0,1] random variables?",
            answer: "n/(n+1)",
            explanation: "CDF of max is F(x) = x^n. PDF is f(x) = nx^(n-1). E[max] = ∫₀¹ x × nx^(n-1) dx = n/(n+1).",
            difficulty: 7
        ),
        DailyProblem(
            id: 51,
            prompt: "In the Monty Hall problem, what is the probability of winning by switching?",
            answer: "2/3",
            explanation: "Initially, P(car behind chosen door) = 1/3. After Monty reveals a goat, switching wins if original choice was wrong (probability 2/3).",
            difficulty: 7
        ),
        DailyProblem(
            id: 52,
            prompt: "What is the variance of a Poisson(λ) random variable?",
            answer: "λ",
            explanation: "For Poisson distribution, both mean and variance equal λ. This is a defining property: Var(X) = E[X] = λ.",
            difficulty: 7
        ),
        DailyProblem(
            id: 53,
            prompt: "What is P(X > Y) where X ~ Exp(1) and Y ~ Exp(2) are independent?",
            answer: "1/3",
            explanation: "P(X > Y) = ∫∫_{x>y} e^(-x) × 2e^(-2y) dydx = ∫₀^∞ e^(-x) (1-e^(-2x)) dx = 1 - 2/3 = 1/3.",
            difficulty: 7
        ),
        DailyProblem(
            id: 54,
            prompt: "How many ways can you tile a 2×n board with 1×2 dominoes?",
            answer: "F(n+1)",
            explanation: "Let T(n) be the count. T(n) = T(n-1) + T(n-2) with T(1)=1, T(2)=2. This is the Fibonacci sequence: T(n) = F(n+1).",
            difficulty: 7
        ),
        DailyProblem(
            id: 55,
            prompt: "What is the expected payoff in the St. Petersburg paradox (you win 2^n if the first head appears on flip n)?",
            answer: "Infinite",
            explanation: "E = Σ (1/2)^n × 2^n = Σ 1 = ∞. Each flip contributes expected value 1, and there are infinitely many possible flips.",
            difficulty: 7
        ),
        DailyProblem(
            id: 56,
            prompt: "A and B take turns flipping a fair coin (A first). First to flip heads wins. What is P(A wins)?",
            answer: "2/3",
            explanation: "P(A) = 1/2 + (1/2)(1/2)P(A). Solving: P(A) = 1/2 + P(A)/4 → 3P(A)/4 = 1/2 → P(A) = 2/3.",
            difficulty: 7
        ),

        // MARK: - Hard (Difficulty 8)

        DailyProblem(
            id: 57,
            prompt: "What is the MGF of a standard normal random variable evaluated at t?",
            answer: "e^(t²/2)",
            explanation: "For Z ~ N(0,1), M(t) = E[e^(tZ)] = e^(t²/2). This follows from completing the square in the integral.",
            difficulty: 8
        ),
        DailyProblem(
            id: 58,
            prompt: "What is E[N] where N is the first time a simple random walk reaches level k starting from 0?",
            answer: "Infinite for k ≠ 0",
            explanation: "While P(reach k) = 1, the expected hitting time is infinite. E[T_k] = ∞ because the walk can wander arbitrarily far before reaching k.",
            difficulty: 8
        ),
        DailyProblem(
            id: 59,
            prompt: "What is the characteristic function of a Poisson(λ) random variable?",
            answer: "exp(λ(e^(it) - 1))",
            explanation: "φ(t) = E[e^(itX)] = Σ e^(itk) × e^(-λ)λ^k/k! = e^(-λ) × e^(λe^(it)) = exp(λ(e^(it) - 1)).",
            difficulty: 8
        ),
        DailyProblem(
            id: 60,
            prompt: "In Bayesian inference, if prior is Beta(α,β) and we observe k successes in n trials, what is the posterior?",
            answer: "Beta(α+k, β+n-k)",
            explanation: "Beta is conjugate to Binomial. The posterior parameters update: α → α+k (add successes), β → β+(n-k) (add failures).",
            difficulty: 8
        ),
        DailyProblem(
            id: 61,
            prompt: "What is the probability that two random permutations of n elements commute?",
            answer: "≈ e^(-1) for large n",
            explanation: "Two permutations commute iff each is constant on the cycle structure of the other. For random permutations, this probability approaches 1/e.",
            difficulty: 8
        ),
        DailyProblem(
            id: 62,
            prompt: "What is the expected length of the longest increasing subsequence in a random permutation of n elements?",
            answer: "≈ 2√n",
            explanation: "By the Baik-Deift-Johansson theorem, E[LIS] ~ 2√n as n→∞. The distribution approaches Tracy-Widom.",
            difficulty: 8
        ),
        DailyProblem(
            id: 63,
            prompt: "What is P(X > 2σ) for X ~ N(μ, σ²)?",
            answer: "≈ 0.0228",
            explanation: "P(X > μ+2σ) = P(Z > 2) ≈ 0.0228 by the standard normal table. About 2.28% of probability mass is above 2 standard deviations.",
            difficulty: 8
        ),
        DailyProblem(
            id: 64,
            prompt: "In the secretary problem with n candidates, what is the optimal strategy's probability of selecting the best?",
            answer: "≈ 1/e ≈ 0.368",
            explanation: "Observe first n/e candidates, then select the next one better than all observed. As n→∞, success probability → 1/e ≈ 0.368.",
            difficulty: 8
        ),
        DailyProblem(
            id: 65,
            prompt: "What is E[X²] for X ~ Geometric(p)?",
            answer: "(2-p)/p²",
            explanation: "E[X] = 1/p, Var(X) = (1-p)/p². Since E[X²] = Var(X) + E[X]², we get E[X²] = (1-p)/p² + 1/p² = (2-p)/p².",
            difficulty: 8
        ),
        DailyProblem(
            id: 66,
            prompt: "A random walk on Z² starts at origin. What is the probability of eventual return?",
            answer: "1",
            explanation: "2D random walk is recurrent. P(return) = 1, but E[return time] = ∞. This contrasts with 3D where P(return) < 1.",
            difficulty: 8
        ),

        // MARK: - Very Hard (Difficulty 9-10)

        DailyProblem(
            id: 67,
            prompt: "What is the sum Σ(k=1 to ∞) k × x^k for |x| < 1?",
            answer: "x/(1-x)²",
            explanation: "Start with Σx^k = 1/(1-x). Differentiate both sides: Σ k×x^(k-1) = 1/(1-x)². Multiply by x: Σ k×x^k = x/(1-x)².",
            difficulty: 9
        ),
        DailyProblem(
            id: 68,
            prompt: "What is the probability that a random nxn matrix over a finite field F_q is invertible?",
            answer: "∏(k=0 to n-1)(1-1/q^(n-k))",
            explanation: "Row 1: any nonzero (q^n-1 choices). Row 2: not in span of row 1 (q^n-q choices). Probability = ∏(1-1/q^k) for k=1 to n.",
            difficulty: 9
        ),
        DailyProblem(
            id: 69,
            prompt: "What is E[e^X] for X ~ N(0,1)?",
            answer: "e^(1/2)",
            explanation: "E[e^X] = MGF of N(0,1) at t=1 = e^(1²/2) = e^(1/2) ≈ 1.649.",
            difficulty: 9
        ),
        DailyProblem(
            id: 70,
            prompt: "In optimal stopping, you see n random numbers. What's the threshold to maximize expected payoff?",
            answer: "Accept if x > median of remaining",
            explanation: "The optimal threshold varies with position. Early on, be selective; near the end, be lenient. The exact solution involves backward induction.",
            difficulty: 9
        ),
        DailyProblem(
            id: 71,
            prompt: "What is the entropy of a fair n-sided die?",
            answer: "log₂(n) bits",
            explanation: "H = -Σ(1/n)log₂(1/n) = log₂(n). A fair 6-sided die has entropy log₂(6) ≈ 2.58 bits.",
            difficulty: 9
        ),
        DailyProblem(
            id: 72,
            prompt: "Two players repeatedly play matching pennies. If player A has edge ε, what is their expected win rate?",
            answer: "(1+ε)/2",
            explanation: "With edge ε, player A wins with probability (1+ε)/2 each round. Over many rounds, win rate converges to this value.",
            difficulty: 9
        ),
        DailyProblem(
            id: 73,
            prompt: "What is the probability generating function of a Poisson(λ) random variable?",
            answer: "e^(λ(s-1))",
            explanation: "G(s) = E[s^X] = Σ s^k × e^(-λ)λ^k/k! = e^(-λ) × Σ(λs)^k/k! = e^(-λ) × e^(λs) = e^(λ(s-1)).",
            difficulty: 9
        ),
        DailyProblem(
            id: 74,
            prompt: "In a branching process with offspring distribution Poisson(1), what is the probability of extinction?",
            answer: "1",
            explanation: "Extinction probability q satisfies q = G(q) where G is the PGF. For Poisson(1), the unique solution in [0,1] is q = 1.",
            difficulty: 9
        ),
        DailyProblem(
            id: 75,
            prompt: "What is the probability that a random polynomial of degree n over F_2 is irreducible?",
            answer: "≈ 1/n",
            explanation: "By Gauss's formula, the number of irreducible polynomials of degree n is approximately 2^n/n. Probability ≈ (2^n/n)/2^n = 1/n.",
            difficulty: 9
        ),
        DailyProblem(
            id: 76,
            prompt: "In the gambler's ruin problem, starting with $k and target $n, what is P(ruin) with fair bets?",
            answer: "1 - k/n",
            explanation: "For a fair game, P(ruin) = 1 - k/n. Starting with $3 targeting $10, P(ruin) = 7/10 = 0.7.",
            difficulty: 9
        ),
        DailyProblem(
            id: 77,
            prompt: "What is the Fisher information for parameter θ in N(θ, 1)?",
            answer: "1",
            explanation: "I(θ) = E[(∂/∂θ log f)²] = E[(X-θ)²] = 1 for N(θ,1). Fisher information measures the amount of information about θ.",
            difficulty: 9
        ),
        DailyProblem(
            id: 78,
            prompt: "What is the limiting distribution of (X₁+...+Xₙ - n)/√n for Xi iid Bernoulli(1/2)?",
            answer: "N(0, 1/4)",
            explanation: "By CLT, the sum converges to normal. Var(Xi) = 1/4, so the limit is N(0, Var) = N(0, 1/4) after proper scaling.",
            difficulty: 9
        ),
        DailyProblem(
            id: 79,
            prompt: "What is E[XY] where X, Y are iid standard normal?",
            answer: "0",
            explanation: "E[XY] = E[X]E[Y] = 0 × 0 = 0 since X and Y are independent and E[X] = E[Y] = 0.",
            difficulty: 10
        ),
        DailyProblem(
            id: 80,
            prompt: "What is the Jacobian of the transformation from (X,Y) to (R,Θ) where X = R cos Θ, Y = R sin Θ?",
            answer: "R",
            explanation: "J = |∂(x,y)/∂(r,θ)| = |cos θ × r cos θ - (-r sin θ)(sin θ)| = r(cos²θ + sin²θ) = r.",
            difficulty: 10
        ),
        DailyProblem(
            id: 81,
            prompt: "What is the expected number of local maxima in a random permutation of n elements?",
            answer: "(n+1)/3",
            explanation: "A position i is a local max if a[i-1] < a[i] > a[i+1]. For internal positions, P(local max) = 1/3. Expected count ≈ (n+1)/3.",
            difficulty: 10
        ),
        DailyProblem(
            id: 82,
            prompt: "In the ballot problem, if A gets a votes and B gets b < a votes, what is P(A leads throughout)?",
            answer: "(a-b)/(a+b)",
            explanation: "By the reflection principle, P(A always ahead) = (a-b)/(a+b). This is a classic result in combinatorics.",
            difficulty: 10
        ),
        DailyProblem(
            id: 83,
            prompt: "What is the probability that two random points in a unit square are within distance r of each other?",
            answer: "πr² - 8r³/3 + r⁴/2 for r ≤ 1",
            explanation: "Integrate the probability density over all point pairs, accounting for boundary effects. The formula involves geometric probability calculations.",
            difficulty: 10
        ),
        DailyProblem(
            id: 84,
            prompt: "What is the value of Σ(n=1 to ∞) 1/n²?",
            answer: "π²/6",
            explanation: "This is Euler's Basel problem. ζ(2) = π²/6 ≈ 1.6449. Euler proved this in 1734 using Fourier series.",
            difficulty: 10
        ),
        DailyProblem(
            id: 85,
            prompt: "In a martingale betting system (double after loss), what is the expected profit if you start with infinite capital?",
            answer: "1 unit per sequence",
            explanation: "With infinite capital, you always eventually win, netting 1 unit. But expected profit equals expected loss in a fair game over infinite time.",
            difficulty: 10
        ),
        DailyProblem(
            id: 86,
            prompt: "Two players start with 12 tokens each. A biased process (p=0.6) transfers tokens. What is P(player A wins all 24)?",
            answer: "≈ 0.9991",
            explanation: "Using gambler's ruin with p=0.6, P(A wins) = (1-(q/p)^12)/(1-(q/p)^24) where q=0.4. This gives ≈ 0.9991.",
            difficulty: 10
        ),
        DailyProblem(
            id: 87,
            prompt: "A baby walks with P(forward)=0.2, P(stay)=0.5, P(back)=0.3, can't go behind couch. What fraction of time at couch?",
            answer: "1/3",
            explanation: "In steady state, flow balance: rate leaving couch (0.2π₀) = rate entering (0.3π₁). With detailed balance, π₀ = 1/3.",
            difficulty: 10
        ),
        DailyProblem(
            id: 88,
            prompt: "Given Bob flipped more times than Alice (both flip until heads), what is E[Alice's flips]?",
            answer: "4/3",
            explanation: "Condition on Alice finishing before Bob. By symmetry and conditional expectation calculations, E[Alice|Alice<Bob] = 4/3.",
            difficulty: 10
        )
    ]

    /// Returns today's puzzle based on day of year
    static func getTodaysPuzzle() -> DailyProblem {
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let index = (dayOfYear - 1) % puzzles.count
        return puzzles[index]
    }

    /// Returns a puzzle by ID
    static func getPuzzle(id: Int) -> DailyProblem? {
        puzzles.first { $0.id == id }
    }

    /// Returns puzzles filtered by difficulty range
    static func getPuzzles(minDifficulty: Int, maxDifficulty: Int) -> [DailyProblem] {
        puzzles.filter { $0.difficulty >= minDifficulty && $0.difficulty <= maxDifficulty }
    }
}
