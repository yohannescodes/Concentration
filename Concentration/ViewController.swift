//
//  ViewController.swift
//  Concentration
//
//  Created by Yohannes Haile on 8/9/22.
//

import UIKit

final class ViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet private var buttons: [UIButton]!
    @IBOutlet private var resetHighScoreBtn: UIButton!
    @IBOutlet private var highScoreLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var restartBtn: UIButton!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var rankLabel: UILabel!
    @IBOutlet private weak var levelSwitch: UISwitch!

    // MARK: - Properties

    private let phrases = [
        "Impressive 🙃",
        "Did you get it?",
        "Keep on!",
        "Promising",
        "Don't disappint the nation!",
        "Loving it 🔥"
    ]

    private var game = GameSession()
    private var highScore = 0
    private var isBoardLocked = false

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureStatusLabel()
        startGame()
    }

    // MARK: - Actions

    @IBAction private func button1Flipped() {
        handleFlip(at: 0)
    }

    @IBAction private func button2Flipped() {
        handleFlip(at: 1)
    }

    @IBAction private func button3Flipped() {
        handleFlip(at: 2)
    }

    @IBAction private func button4Flipped() {
        handleFlip(at: 3)
    }

    @IBAction private func button5Flipped() {
        handleFlip(at: 4)
    }

    @IBAction private func button6Flipped() {
        handleFlip(at: 5)
    }

    @IBAction private func button7Flipped() {
        handleFlip(at: 6)
    }

    @IBAction private func button8Flipped() {
        handleFlip(at: 7)
    }

    @IBAction private func button9Flipped() {
        handleFlip(at: 8)
    }

    @IBAction private func button10Flipped() {
        handleFlip(at: 9)
    }

    @IBAction private func button11Flipped() {
        handleFlip(at: 10)
    }

    @IBAction private func button12Flipped() {
        handleFlip(at: 11)
    }

    @IBAction private func didTapRestart() {
        restartGame()
    }

    @IBAction private func didTapResetHighScore() {
        resetHighScore()
    }

    @IBAction private func didSwitchLevel() {
        confirmRestart()
        statusLabel.text = levelSwitch.isOn ? "Try me!" : "Come on, coward!"
    }

    // MARK: - Setup

    private func configureStatusLabel() {
        statusLabel.font = .systemFont(ofSize: 17, weight: .thin)
        statusLabel.numberOfLines = 0
        statusLabel.textAlignment = .left
    }

    private func startGame() {
        isBoardLocked = false
        highScore = retrieveHighScore()
        highScoreLabel.text = "\(highScore)"

        game.startNewGame(level: currentLevel())
        let initialRank: Rank = highScore > 0 ? .kid : .noob
        game.setInitialRank(initialRank)

        rankLabel.text = initialRank.rawValue
        rankLabel.textColor = .label
        restartBtn.tintColor = .black

        updateScoreLabel(with: 0)
        updateStatus()
        configureBoard()
    }

    private func configureBoard() {
        statusLabel.text = "By the King's decree, let the trial of skill commence!"
        for (index, button) in buttons.enumerated() {
            button.tag = index
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.borderWidth = 0.6
            button.backgroundColor = .white
            button.isEnabled = true
        }
    }

    private func currentLevel() -> Level {
        levelSwitch.isOn ? .hard : .easy
    }

    // MARK: - Game Flow

    private func handleFlip(at index: Int) {
        guard !isBoardLocked, let color = game.tileColor(at: index), buttons.indices.contains(index) else {
            return
        }

        buttons[index].backgroundColor = color
        buttons[index].isEnabled = false
        if let phrase = phrases.randomElement() {
            rankLabel.text = phrase
        }

        let result = game.flipTile(at: index)
        updateScoreLabel(with: result.score)
        updateStatus()

        if result.rankDidChange {
            announceRankChange(with: result.matchedColor)
        }

        switch result.state {
        case .awaitingSecondFlip:
            break
        case let .match(indices, didWin):
            applyMatch(for: indices, color: result.matchedColor)
            if didWin {
                entertainWinner()
            }
        case let .mismatch(indices):
            handleMismatch(for: indices)
        case .ignored:
            buttons[index].isEnabled = true
        }
    }

    private func applyMatch(for indices: [Int], color: UIColor?) {
        for index in indices where buttons.indices.contains(index) {
            if let color {
                buttons[index].backgroundColor = color
            }
            buttons[index].isEnabled = false
        }

        if let color {
            rankLabel.textColor = color
        }
    }

    private func handleMismatch(for indices: [Int]) {
        isBoardLocked = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak self] in
            guard let self else { return }
            for index in indices where self.buttons.indices.contains(index) {
                self.buttons[index].backgroundColor = .white
                self.buttons[index].isEnabled = true
            }
            self.isBoardLocked = false
        }
    }

    private func announceRankChange(with color: UIColor?) {
        rankLabel.text = "Just became \(game.rank.rawValue) 🎖️"
        if let color {
            rankLabel.textColor = color
        }
    }

    private func updateScoreLabel(with score: Int) {
        scoreLabel.text = "\(score)"
    }

    private func updateStatus() {
        statusLabel.text = "Chop Chop, \(game.rank.rawValue)! You tried \(game.trials) times."
    }

    // MARK: - Alerts & Persistence

    private func entertainWinner() {
        setHighScore(trials: game.trials)

        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Woooo 🏆",
                message: "Congratulations, \(self.game.rank.rawValue) you scored 60/60.",
                preferredStyle: .alert
            )

            let alertAction = UIAlertAction(title: "New Game", style: .default) { _ in
                let newerHighScore = self.retrieveHighScore()
                self.highScore = newerHighScore
                self.highScoreLabel.text = "\(newerHighScore)"
                self.confirmRestart()
            }

            alert.addAction(alertAction)
            self.present(alert, animated: true)
        }
    }

    private func restartGame() {
        DispatchQueue.main.async {
            let restartAlert = UIAlertController(
                title: "Are you sure?",
                message: "Tap Yes if you want restart the game.",
                preferredStyle: .alert
            )

            let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
                self.confirmRestart()
            }

            let noAction = UIAlertAction(title: "No", style: .cancel)

            restartAlert.addAction(yesAction)
            restartAlert.addAction(noAction)

            self.present(restartAlert, animated: true)
        }
    }

    private func setHighScore(trials: Int) {
        let previousHighScore = UserDefaults.standard.integer(forKey: "highScore")
        let newHighScore: Int
        if previousHighScore == 0 {
            newHighScore = trials
        } else {
            newHighScore = min(previousHighScore, trials)
        }
        UserDefaults.standard.set(newHighScore, forKey: "highScore")
    }

    private func retrieveHighScore() -> Int {
        UserDefaults.standard.integer(forKey: "highScore")
    }

    // MARK: - Game Controls

    private func confirmRestart() {
        startGame()
    }

    private func resetHighScore() {
        DispatchQueue.main.async {
            let restartAlert = UIAlertController(
                title: "Are you sure?",
                message: "Tap Yes if you want reset your High Score.",
                preferredStyle: .alert
            )

            let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
                UserDefaults.standard.set(0, forKey: "highScore")
                UserDefaults.standard.set(Rank.noob.rawValue, forKey: "playerRank")
                self.highScore = 0
                self.highScoreLabel.text = "0"
                self.game.setInitialRank(.noob)
                self.rankLabel.text = Rank.noob.rawValue
                self.rankLabel.textColor = .label
                self.updateStatus()
            }

            let noAction = UIAlertAction(title: "No", style: .cancel)

            restartAlert.addAction(yesAction)
            restartAlert.addAction(noAction)

            self.present(restartAlert, animated: true)
        }
    }
}
