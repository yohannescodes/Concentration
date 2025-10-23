import UIKit

// MARK: - Game Session

struct GameSession {

    struct FlipResult {
        enum State {
            case awaitingSecondFlip
            case match(indices: [Int], didWin: Bool)
            case mismatch(indices: [Int])
            case ignored
        }

        let state: State
        let score: Int
        let trials: Int
        let rank: Rank
        let matchedColor: UIColor?
        let rankDidChange: Bool
    }

    private(set) var level: Level = .easy
    private(set) var score: Int = 0
    private(set) var trials: Int = 0
    private(set) var rank: Rank = .noob
    private(set) var tiles: [UIColor] = []

    private var openedIndices: [Int] = []
    private var matchedIndices = Set<Int>()
    private var matchedColors = Set<UIColor>()
    private let thresholds = RankThresholds()

    mutating func startNewGame(level: Level) {
        self.level = level
        score = 0
        trials = 0
        rank = .noob
        openedIndices.removeAll()
        matchedIndices.removeAll()
        matchedColors.removeAll()
        tiles = ColorDeck.generateShuffledPairs()
    }

    mutating func setInitialRank(_ rank: Rank) {
        self.rank = rank
    }

    func tileColor(at index: Int) -> UIColor? {
        guard tiles.indices.contains(index) else { return nil }
        return tiles[index]
    }

    mutating func flipTile(at index: Int) -> FlipResult {
        guard tiles.indices.contains(index),
              !matchedIndices.contains(index),
              !openedIndices.contains(index) else {
            return FlipResult(state: .ignored, score: score, trials: trials, rank: rank, matchedColor: nil, rankDidChange: false)
        }

        trials += 1
        openedIndices.append(index)

        if openedIndices.count < 2 {
            return FlipResult(state: .awaitingSecondFlip, score: score, trials: trials, rank: rank, matchedColor: nil, rankDidChange: false)
        }

        let first = openedIndices[0]
        let second = openedIndices[1]
        openedIndices.removeAll()

        let firstColor = tiles[first]
        let secondColor = tiles[second]

        if firstColor == secondColor {
            matchedIndices.insert(first)
            matchedIndices.insert(second)
            matchedColors.insert(firstColor)
            score += 10

            let previousRank = rank
            if let newRank = thresholds.rank(for: level, score: score, trials: trials) {
                rank = newRank
            }

            let didWin = matchedColors.count == tiles.count / 2
            return FlipResult(
                state: .match(indices: [first, second], didWin: didWin),
                score: score,
                trials: trials,
                rank: rank,
                matchedColor: firstColor,
                rankDidChange: previousRank != rank
            )
        }

        return FlipResult(
            state: .mismatch(indices: [first, second]),
            score: score,
            trials: trials,
            rank: rank,
            matchedColor: nil,
            rankDidChange: false
        )
    }
}

// MARK: - Rank Thresholds

private struct RankThresholds {

    private struct Threshold {
        let score: Int
        let limit: Int
        let rank: Rank
    }

    private let easyThresholds: [Threshold]
    private let hardThresholds: [Threshold]

    init() {
        let hardMode = [3, 5, 11, 15, 17, 13, 16, 20, 27]
        let easyMode = [6, 12, 26, 36, 42, 36, 44, 54, 70]

        easyThresholds = [
            Threshold(score: 10, limit: easyMode[0], rank: .subltnt),
            Threshold(score: 20, limit: easyMode[1], rank: .ltnt),
            Threshold(score: 30, limit: easyMode[2], rank: .ltntcmd),
            Threshold(score: 40, limit: easyMode[3], rank: .cmd),
            Threshold(score: 50, limit: easyMode[4], rank: .capt),
            Threshold(score: 60, limit: easyMode[5], rank: .admrl),
            Threshold(score: 60, limit: easyMode[6], rank: .vcadmrl),
            Threshold(score: 60, limit: easyMode[7], rank: .rradmrl),
            Threshold(score: 60, limit: easyMode[8], rank: .cmmdr)
        ]

        hardThresholds = [
            Threshold(score: 10, limit: hardMode[0], rank: .subltnt),
            Threshold(score: 20, limit: hardMode[1], rank: .ltnt),
            Threshold(score: 30, limit: hardMode[2], rank: .ltntcmd),
            Threshold(score: 40, limit: hardMode[3], rank: .cmd),
            Threshold(score: 50, limit: hardMode[4], rank: .capt),
            Threshold(score: 60, limit: hardMode[5], rank: .admrl),
            Threshold(score: 60, limit: hardMode[6], rank: .vcadmrl),
            Threshold(score: 60, limit: hardMode[7], rank: .rradmrl),
            Threshold(score: 60, limit: hardMode[8], rank: .cmmdr)
        ]
    }

    func rank(for level: Level, score: Int, trials: Int) -> Rank? {
        let thresholds = level == .hard ? hardThresholds : easyThresholds
        guard score > 0 else { return nil }

        for threshold in thresholds where threshold.score == score {
            if trials < threshold.limit {
                return threshold.rank
            }
        }

        return nil
    }
}

// MARK: - Color Deck

private enum ColorDeck {
    static func generateShuffledPairs() -> [UIColor] {
        let colors: [UIColor] = [
            .black,
            .gray,
            .green,
            .yellow,
            .red,
            .red,
            .blue,
            .blue,
            .yellow,
            .black,
            .green,
            .gray
        ]

        return colors.shuffled()
    }
}

// MARK: - Supporting Types

enum Rank: String {
    case subltnt = " Sub-lieutenant"
    case ltnt = " Lieutenant"
    case ltntcmd = " Lieutenant commander"
    case cmd = " Commander"
    case capt = " Captain"
    case admrl = " Admiral"
    case vcadmrl = " Vice admiral"
    case rradmrl = " Rear admiral"
    case cmmdr = " Commodore"
    case noob = " NOOB"
    case kid = " Kid"
}

enum Level {
    case easy
    case hard
}
