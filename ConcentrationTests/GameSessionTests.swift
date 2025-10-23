import XCTest
import UIKit
@testable import Concentration

final class GameSessionTests: XCTestCase {

    private var session: GameSession!

    override func setUpWithError() throws {
        try super.setUpWithError()
        session = GameSession()
        session.startNewGame(level: .easy)
        session.setInitialRank(.noob)
    }

    override func tearDownWithError() throws {
        session = nil
        try super.tearDownWithError()
    }

    func testStartNewGameInitializesBoard() throws {
        XCTAssertEqual(session.level, .easy)
        XCTAssertEqual(session.score, 0)
        XCTAssertEqual(session.trials, 0)
        XCTAssertEqual(session.rank, .noob)
        XCTAssertEqual(session.tiles.count, 12)

        for index in 0..<session.tiles.count {
            XCTAssertNotNil(session.tileColor(at: index))
        }
    }

    func testFlipMatchingTilesUpdatesScoreAndRank() throws {
        let pair = try XCTUnwrap(firstMatchingPair())

        let firstFlip = session.flipTile(at: pair.first)
        if case .awaitingSecondFlip = firstFlip.state {
            // expected state
        } else {
            XCTFail("Expected awaiting second flip state but received \(firstFlip.state)")
        }

        let secondFlip = session.flipTile(at: pair.second)
        guard case let .match(indices, didWin) = secondFlip.state else {
            XCTFail("Expected match state but received \(secondFlip.state)")
            return
        }

        XCTAssertTrue(indices.contains(pair.first))
        XCTAssertTrue(indices.contains(pair.second))
        XCTAssertFalse(didWin)
        XCTAssertEqual(secondFlip.score, 10)
        XCTAssertEqual(secondFlip.trials, 2)
        XCTAssertEqual(session.score, 10)
        XCTAssertEqual(session.rank, .subltnt)
        XCTAssertTrue(secondFlip.rankDidChange)
    }

    func testFlipMismatchReturnsMismatchState() throws {
        let mismatch = try XCTUnwrap(firstMismatchingPair())

        _ = session.flipTile(at: mismatch.first)
        let result = session.flipTile(at: mismatch.second)

        guard case let .mismatch(indices) = result.state else {
            XCTFail("Expected mismatch state but received \(result.state)")
            return
        }

        XCTAssertTrue(indices.contains(mismatch.first))
        XCTAssertTrue(indices.contains(mismatch.second))
        XCTAssertEqual(result.score, 0)
        XCTAssertEqual(result.trials, 2)
        XCTAssertEqual(session.score, 0)

        let retry = session.flipTile(at: mismatch.first)
        if case .awaitingSecondFlip = retry.state {
            // still playable after mismatch
        } else {
            XCTFail("Expected awaiting second flip after mismatch but received \(retry.state)")
        }
    }

    func testFlippingMatchedTileIsIgnored() throws {
        let pair = try XCTUnwrap(firstMatchingPair())
        _ = session.flipTile(at: pair.first)
        _ = session.flipTile(at: pair.second)

        let ignored = session.flipTile(at: pair.first)
        if case .ignored = ignored.state {
            XCTAssertEqual(ignored.score, session.score)
        } else {
            XCTFail("Expected ignored state but received \(ignored.state)")
        }
    }

    func testCompletingAllPairsWinsGame() throws {
        let pairs = allMatchingPairs()
        var lastResult: GameSession.FlipResult?

        for pair in pairs {
            _ = session.flipTile(at: pair.first)
            lastResult = session.flipTile(at: pair.second)
        }

        let result = try XCTUnwrap(lastResult)
        guard case let .match(indices, didWin) = result.state else {
            XCTFail("Expected match state on final flip but received \(result.state)")
            return
        }

        XCTAssertEqual(indices.count, 2)
        XCTAssertTrue(didWin)
        XCTAssertEqual(result.score, 60)
        XCTAssertEqual(session.score, 60)
    }

    // MARK: - Helpers

    private func firstMatchingPair() -> (first: Int, second: Int)? {
        let tiles = session.tiles
        for firstIndex in 0..<tiles.count {
            for secondIndex in (firstIndex + 1)..<tiles.count {
                if tiles[firstIndex].isEqual(tiles[secondIndex]) {
                    return (firstIndex, secondIndex)
                }
            }
        }
        return nil
    }

    private func firstMismatchingPair() -> (first: Int, second: Int)? {
        let tiles = session.tiles
        for firstIndex in 0..<tiles.count {
            for secondIndex in (firstIndex + 1)..<tiles.count {
                if !tiles[firstIndex].isEqual(tiles[secondIndex]) {
                    return (firstIndex, secondIndex)
                }
            }
        }
        return nil
    }

    private func allMatchingPairs() -> [(first: Int, second: Int)] {
        let tiles = session.tiles
        var buckets: [String: [Int]] = [:]

        for (index, color) in tiles.enumerated() {
            let key = colorKey(for: color)
            buckets[key, default: []].append(index)
        }

        return buckets.values.compactMap { indices in
            guard indices.count == 2 else { return nil }
            return (indices[0], indices[1])
        }
    }

    private func colorKey(for color: UIColor) -> String {
        if let components = color.cgColor.components {
            return components.map { String(format: "%.3f", $0) }.joined(separator: "-")
        }
        return color.description
    }
}
