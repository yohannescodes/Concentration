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
    var flippedButtons = 0
    var flippedButtonsIndex: [Int] = []
    var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setUpButtons()
        setupButtons()
    }
    
    func setupButtons(){
        for button in buttons{
            button.layer.borderWidth = 1
            button.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        }
    }

    func resetButtons(){
        for button in buttons{
            button.layer.backgroundColor =  CGColor(red: 250, green: 250, blue: 250, alpha: 1)
        }
        flippedButtons = 0
        flippedButtonsIndex = []
    }
    
    func checkIfMatched(){
        
        if(((flippedButtonsIndex[0] == 1) && (flippedButtonsIndex[1] == 6)) || ((flippedButtonsIndex[0] == 6) && (flippedButtonsIndex[1] == 1))){
            score += 10
            scoreLabel.text = "\(score)"
        }
        else if(((flippedButtonsIndex[0] == 2) && (flippedButtonsIndex[1] == 7)) || ((flippedButtonsIndex[0] == 7) && (flippedButtonsIndex[1] == 2))){
            score += 10
            scoreLabel.text = "\(score)"
        }
        else if(((flippedButtonsIndex[0] == 3) && (flippedButtonsIndex[1] == 4)) || ((flippedButtonsIndex[0] == 4) && (flippedButtonsIndex[1] == 3))){
            score += 10
            scoreLabel.text = "\(score)"
        }
        else if(((flippedButtonsIndex[0] == 5) && (flippedButtonsIndex[1] == 8)) || ((flippedButtonsIndex[0] == 8) && (flippedButtonsIndex[1] == 5))){
            score += 10
            scoreLabel.text = "\(score)"
        }
        if(score == 40){
            let alert = UIAlertController(title: "Congrats", message: "You got every match.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { okAction in
                alert.resignFirstResponder()
            }
            alert.addAction(okAction)
            present(alert, animated: true)
        }
    }
    
    @IBAction func button1Flipped(){
        
        if flippedButtons < 2{
            buttons[0].layer.backgroundColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
            flippedButtonsIndex.append(1)
            flippedButtons += 1
            if(flippedButtonsIndex.count == 2){
                checkIfMatched()
            }
        }
        else{
            resetButtons()
            buttons[0].layer.backgroundColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
            flippedButtonsIndex.append(1)
            flippedButtons += 1
            if(flippedButtonsIndex.count == 2){
                checkIfMatched()
            }
        }
    }
    @IBAction func button2Flipped(){
        if flippedButtons < 2 {
            buttons[1].layer.backgroundColor = CGColor(red: 250, green: 0, blue: 0, alpha: 1)
            flippedButtonsIndex.append(2)
            flippedButtons += 1
            if(flippedButtonsIndex.count == 2){
                checkIfMatched()
            }
        }
        else{
            resetButtons()
            buttons[1].layer.backgroundColor = CGColor(red: 250, green: 0, blue: 0, alpha: 1)
            flippedButtonsIndex.append(2)
            flippedButtons += 1
            if(flippedButtonsIndex.count == 2){
                checkIfMatched()
            }
        }
    }
    @IBAction func button3Flipped(){

        if flippedButtons < 2{
            buttons[2].layer.backgroundColor = CGColor(red: 0, green: 250, blue: 0, alpha: 1)
            flippedButtonsIndex.append(3)
            flippedButtons += 1
            if(flippedButtonsIndex.count == 2){
                checkIfMatched()
            }
        }
        else{
            resetButtons()
            buttons[2].layer.backgroundColor = CGColor(red: 0, green: 250, blue: 0, alpha: 1)
            flippedButtonsIndex.append(3)
            flippedButtons += 1
            if(flippedButtonsIndex.count == 2){
                checkIfMatched()
            }
            
        }
    }
    @IBAction func button4Flipped(){

        if flippedButtons < 2{
            buttons[3].layer.backgroundColor = CGColor(red: 0, green: 250, blue: 0, alpha: 1)
            flippedButtonsIndex.append(4)
            flippedButtons += 1
            if(flippedButtonsIndex.count == 2){
                checkIfMatched()
            }
        }
        else{
            resetButtons()
            buttons[3].layer.backgroundColor = CGColor(red: 0, green: 250, blue: 0, alpha: 1)
            flippedButtonsIndex.append(4)
            flippedButtons += 1
            if(flippedButtonsIndex.count == 2){
                checkIfMatched()
            }
        }
    }
    @IBAction func button5Flipped(){

        if flippedButtons < 2{
            buttons[4].layer.backgroundColor = CGColor(red: 0, green: 0, blue: 250, alpha: 1)
            flippedButtonsIndex.append(5)
            flippedButtons += 1
            if(flippedButtonsIndex.count == 2){
                checkIfMatched()
            }
        }
        else{
            resetButtons()
            buttons[4].layer.backgroundColor = CGColor(red: 0, green: 0, blue: 250, alpha: 1)
            flippedButtonsIndex.append(5)
            flippedButtons += 1
            if(flippedButtonsIndex.count == 2){
                checkIfMatched()
            }
        }
    }
    @IBAction func button6Flipped(){
        
        if flippedButtons < 2 {
            
            buttons[5].layer.backgroundColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
            flippedButtonsIndex.append(6)
            flippedButtons += 1
            if(flippedButtonsIndex.count == 2){
                checkIfMatched()
            }
        }
        else{
            resetButtons()
            buttons[5].layer.backgroundColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
            flippedButtonsIndex.append(6)
            flippedButtons += 1
            if(flippedButtonsIndex.count == 2){
                checkIfMatched()
            }
        }
    }
    @IBAction func button7Flipped(){
        if flippedButtons < 2{
            buttons[6].layer.backgroundColor = CGColor(red: 250, green: 0, blue: 0, alpha: 1)
            flippedButtonsIndex.append(7)
            flippedButtons += 1
            if(flippedButtonsIndex.count == 2){
                checkIfMatched()
            }
        }
        else{
            resetButtons()
            buttons[6].layer.backgroundColor = CGColor(red: 250, green: 0, blue: 0, alpha: 1)
            flippedButtonsIndex.append(7)
            flippedButtons += 1
            if(flippedButtonsIndex.count == 2){
                checkIfMatched()
            }
        }
    }
    
    @IBAction func button8Flipped(){
        if flippedButtons < 2 {
            buttons[7].layer.backgroundColor = CGColor(red: 0, green: 0, blue: 250, alpha: 1)
            flippedButtonsIndex.append(8)
            flippedButtons += 1
            if(flippedButtonsIndex.count == 2){
                checkIfMatched()
            }
        }
        else{
            resetButtons()
            buttons[7].layer.backgroundColor = CGColor(red: 0, green: 0, blue: 250, alpha: 1)
            flippedButtonsIndex.append(8)
            flippedButtons += 1
            if(flippedButtonsIndex.count == 2){
                checkIfMatched()
            }
        }
    }
}
