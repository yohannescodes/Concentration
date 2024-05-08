//
//  ViewController.swift
//  Concentration
//
//  Created by Yohannes Haile on 8/9/22.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet var buttons: [UIButton]!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var restartBtn: UIButton!
    
    var score = 0
    var levelCombo = [UIColor]()
    var squares = [Square]()
    var openedSquares = [Square]()
    var scoredColors = [UIColor]()
    var matchedSquaresID = [(Int, Int)]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        levelCombo = self.randomizeColors()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setUpButtons()
        setSquares()
    }
    
    
    func setSquares(){
        restartBtn.tintColor = .black
        levelCombo = randomizeColors()
        for i in 0...11{
            let square = Square(id: i, color: levelCombo[i], button: buttons[i])
            square.button.layer.borderColor = UIColor.black.cgColor
            square.button.layer.borderWidth = 0.6
            squares.append(square)
        }
    }
    
    
    func checkIfMatched(){
        print("Opened: \(openedSquares.count)")
        print("Matched: \(matchedSquaresID.count)")
        
        if matchedSquaresID.count == 6{
            DispatchQueue.main.async{
                let alert = UIAlertController(title: "Woooo 🏆", message: "You scored 60/60.", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "New Game", style: .default) { _ in
                    self.confirmRestart()
                }
                
                alert.addAction(alertAction)
                self.present(alert, animated: true)
            }
        }else {
            
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
                                print("Opened: \(openedSquares.count)")
                                print("Matched: \(matchedSquaresID.count)")
                            }
                        }
                    }
                    
                }
                removeFirstOpenedSquare()
                print("Opened: \(openedSquares.count)")
            }
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
    
    
    
    func randomizeColors() -> [UIColor] {
        let colors = [UIColor.black, UIColor.gray, UIColor.green, UIColor.yellow, UIColor.red, UIColor.red, UIColor.blue, UIColor.blue, UIColor.yellow, UIColor.black, UIColor.green, UIColor.gray]
        
        let shuffledColors = colors.shuffled()
        return shuffledColors
    }
    
    func flipColor(square: Square){
        square.button.backgroundColor = square.color
        openedSquares.append(square)
        resetSquares(squares: squares)
    }
    
    func resetSquares(squares: [Square]){
        self.checkIfMatched()
    }
    
    func confirmRestart() {
        self.score = 0
        self.scoreLabel.text = "\(self.score)"
        self.openedSquares.removeAll()
        self.scoredColors.removeAll()
        self.matchedSquaresID.removeAll()
        self.levelCombo.removeAll()
        for square in self.squares {
            square.button.backgroundColor = UIColor.white
        }
        self.setSquares()
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
