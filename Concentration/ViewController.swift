//
//  ViewController.swift
//  Concentration
//
//  Created by Yohannes Haile on 8/9/22.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet var buttons: [UIButton]!

    @IBOutlet var resetHighScoreBtn: UIButton!
    @IBOutlet var highScoreLabel: UILabel!

    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var restartBtn: UIButton!
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    
    @IBOutlet weak var levelSwitch: UISwitch!
    
    var score = 0
    var levelCombo = [UIColor]()
    var squares = [Square]()
    var openedSquares = [Square]()
    var scoredColors = [UIColor]()
    var matchedSquaresID = [(Int, Int)]()
    var trials = 0
    var highScore = 0
    var rank = ""
    var level =  Level.easy
    
    let hardMode = [3, 5, 11, 15, 17, 13, 16, 20, 27]
    let easyMode = [6, 12, 26, 36, 42, 36, 44, 54, 70]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        levelCombo = self.randomizeColors()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustLevel()
    }
    
    
    func setSquares(){
        statusLabel.font = .systemFont(ofSize: 12, weight: .medium)
        statusLabel.numberOfLines = 0
        statusLabel.textAlignment = .left
        statusLabel.text = "By the King's decree, let the trial of skill commence!"
        rank = highScore > 0 ? Rank.kid.rawValue : Rank.noob.rawValue
        restartBtn.tintColor = .black
        levelCombo = randomizeColors()
        highScore = UserDefaults.standard.integer(forKey: "highScore")
        highScoreLabel.text = "\(highScore)"
        for i in 0...11{
            let square = Square(id: i, color: levelCombo[i], button: buttons[i])
            square.button.layer.borderColor = UIColor.black.cgColor
            square.button.layer.borderWidth = 0.6
            squares.append(square)
        }
    }
    
    
    func entertainWinner() {
        self.setHighScore(trials: trials, rank: rank)
        DispatchQueue.main.async{
            let alert = UIAlertController(title: "Woooo 🏆", message: "Congratulations, \(self.rank) you scored 60/60.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "New Game", style: .default) { _ in
                
                self.confirmRestart()
            }
            
            alert.addAction(alertAction)
            self.present(alert, animated: true)
        }
    }
    
    func checkIfMatched(){
        
            if openedSquares.count > 2{
                removeFirstOpenedSquare()
            }else if openedSquares.count == 2{
                if openedSquares.first?.color == openedSquares.last?.color{
                    if let color = openedSquares.first?.color{
                        if !scoredColors.contains(color){
                            if let id1 = openedSquares.first?.id, let id2 = openedSquares.last?.id {
                                scoredColors.append(color)
                                matchedSquaresID.append((id1, id2))
                                score += 10
                                scoreLabel.text = "\(score)"
                                rankLabel.textColor = color
                                self.honor()
                                if matchedSquaresID.count == 6{
                                    entertainWinner()
                                }
                            }
                        }
                    }
                    
                }
                removeFirstOpenedSquare()
            }
        }

    
    func removeFirstOpenedSquare(){
        openedSquares.first?.button.backgroundColor = UIColor.white
        openedSquares.removeFirst()
    }
    
    @IBAction func button1Flipped(){
        flipColor(square: squares[0])
    }
    @IBAction func button2Flipped(){
        flipColor(square: squares[1])
    }
    @IBAction func button3Flipped(){
        flipColor(square: squares[2])
    }
    @IBAction func button4Flipped(){
        flipColor(square: squares[3])
        
    }
    @IBAction func button5Flipped(){
        flipColor(square: squares[4])
        
    }
    @IBAction func button6Flipped(){
        flipColor(square: squares[5])
        
    }
    @IBAction func button7Flipped(){
        flipColor(square: squares[6])
    }
    
    @IBAction func button8Flipped(){
        flipColor(square: squares[7])
    }
    
    @IBAction func button9Flipped(){
        flipColor(square: squares[8])
    }
    
    @IBAction func button10Flipped(){
        flipColor(square: squares[9])
    }
    
    @IBAction func button11Flipped(){
        flipColor(square: squares[10])
    }
    
    @IBAction func button12Flipped(){
        flipColor(square: squares[11])
    }
    
    @IBAction func didTapRestart(){
        restartGame()
    }
    
    @IBAction func didTapResetHighScore(){
        resetHighScore()
    }
    
    @IBAction func didSwitchLevel(){
        confirmRestart()
        statusLabel.text = level == .hard ? "Try me!" : "Come on, coward!"
    }
    
    
    func adjustLevel(){
        level = levelSwitch.isOn ? .hard : .easy
       
        setSquares()
    }
    func randomizeColors() -> [UIColor] {
        let colors = [UIColor.black, UIColor.gray, UIColor.green, UIColor.yellow, UIColor.red, UIColor.red, UIColor.blue, UIColor.blue, UIColor.yellow, UIColor.black, UIColor.green, UIColor.gray]
        
        let shuffledColors = colors.shuffled()
        return shuffledColors
    }
    
    func flipColor(square: Square){
        square.button.backgroundColor = square.color
        openedSquares.append(square)
        trials += 1
        resetSquares(squares: squares)
    }
    
    func resetSquares(squares: [Square]){
        self.checkIfMatched()
    }
    
    func confirmRestart() {
        self.score = 0
        self.scoreLabel.text = "\(self.score)"
        self.rankLabel.textColor = .label
        self.openedSquares.removeAll()
        self.scoredColors.removeAll()
        self.matchedSquaresID.removeAll()
        self.levelCombo.removeAll()
        self.adjustLevel()
        for square in self.squares {
            square.button.backgroundColor = UIColor.white
        }
        trials = 0
    }
    
    func restartGame(){
        
        DispatchQueue.main.async{
            let restartAlert = UIAlertController(title: "Are you sure?", message: "Tap Yes if you want restart the game.", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
                self.confirmRestart()
            }
            
            let noAction = UIAlertAction(title: "No", style: .cancel)
            
            restartAlert.addAction(yesAction)
            restartAlert.addAction(noAction)
            
            self.present(restartAlert, animated: true)
        }
    }
    
    func setHighScore(trials: Int, rank: String){
        let previousHighScore = UserDefaults.standard.integer(forKey: "highScore")
        let newHighScore = previousHighScore >= trials ? previousHighScore : trials
        UserDefaults.standard.set(newHighScore, forKey: "highScore")
        UserDefaults.standard.set(rank, forKey: "playerRank")
    }
    
    func retrieveHighScore() -> (Int, String){
        let previousHighScore = UserDefaults.standard.integer(forKey: "highScore")
        let previousRank = UserDefaults.standard.string(forKey: "playerRank") ?? Rank.noob.rawValue
        return (previousHighScore, previousRank)
        
    }
    
    func honor(){
        print("Level = \(level == .hard ? "Hard" : "Easy")")
        if score == 10 && trials < (level == .hard ? hardMode[0] : easyMode[0]){
            rank = Rank.subltnt.rawValue
            rankLabel.text = "Just became \(rank) 🎖️"
        }else if score == 20 && trials < (level == .hard ? hardMode[1] : easyMode[1]){
            rank = Rank.ltnt.rawValue
            rankLabel.text = "Just became \(rank) 🎖️"
        }else if score == 30 && trials < (level == .hard ? hardMode[2] : easyMode[2]){
            rank = Rank.ltntcmd.rawValue
            rankLabel.text = "Just became \(rank) 🎖️"
        }else if score == 40 && trials < (level == .hard ? hardMode[3] : easyMode[3]){
            rank = Rank.cmd.rawValue
            rankLabel.text = "Just became \(rank) 🎖️"
        }else if score == 50 && trials < (level == .hard ? hardMode[4] : easyMode[4]){
            rank =  Rank.capt.rawValue
            rankLabel.text = "Just became \(rank) 🎖️"
        }else if score == 60 && trials < (level == .hard ? hardMode[5] : easyMode[5]){
            rank = Rank.admrl.rawValue
            rankLabel.text = "Just became \(rank) 🎖️"
        }
        else if score == 60 && trials < (level == .hard ? hardMode[6] : easyMode[6]){
            rank = Rank.vcadmrl.rawValue
            rankLabel.text = "Just became \(rank) 🎖️"
        }else if score == 60 && trials < (level == .hard ? hardMode[7] : easyMode[7]){
            rank = Rank.rradmrl.rawValue
            rankLabel.text = "Just became \(rank) 🎖️"
        }
        else if score == 60 && trials < (level == .hard ? hardMode[8] : easyMode[8]){
            rank = Rank.cmmdr.rawValue
            rankLabel.text = "Just became \(rank) 🎖️"
        }
        
        statusLabel.text = "Chop Chop, \(rank)! You tried \(trials) times."
       
    }
    
    func resetHighScore(){
        DispatchQueue.main.async{
            
            let restartAlert = UIAlertController(title: "Are you sure?", message: "Tap Yes if you want reset your High Score.", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
                UserDefaults.standard.set(0, forKey: "highScore")
                UserDefaults.standard.set(Rank.kid.rawValue, forKey: "playerRank")
                self.highScoreLabel.text = "\(UserDefaults.standard.integer(forKey: "highSchool"))"
                self.rank = UserDefaults.standard.string(forKey: "playerRank") ?? Rank.noob.rawValue
            }
            
            let noAction = UIAlertAction(title: "No", style: .cancel)
            
            restartAlert.addAction(yesAction)
            restartAlert.addAction(noAction)
            
            self.present(restartAlert, animated: true)
        }
    }
    
}


struct Square{
    var id: Int
    var color: UIColor
    var button: UIButton
    
    init(id: Int, color: UIColor, button: UIButton) {
        self.id = id
        self.color = color
        self.button = button
    }
}

enum Rank: String{
    
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

enum Level{
    case easy
    case hard
}
