//
//  ViewController.swift
//  Concentration
//
//  Created by Abhishesh Pradhan on 18/3/18.
//  Copyright © 2018 Abhishesh Pradhan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK: GAME CREATION
    // game creates Controller -> model link
    private lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1 ) / 2 )
    
    private(set) var flipCount = 0{
        didSet{
            updateFlipCountLabel()
        }
    }
    
    private func updateFlipCountLabel(){
        let attributes: [NSAttributedStringKey:Any] = [
            .strokeWidth : 5.0,
            .strokeColor : #colorLiteral(red: 1, green: 0.6098514711, blue: 0, alpha: 1)
        ]
        
        let attributedString = NSAttributedString(string: "Flips: \(flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
    
    
    //MARK: INSTANCE VARIABLES
    //   private var emojiChoices = ["🍆", "😀","🍏","🍎","🥥","🍠"]
    private var emojiChoices = "🍆😀🍏🍎🥥🍠"
    private var emoji =  [Card:String]()
    private var start: Date?
    private var elapsedTime: TimeInterval?
    
    private var numberOfPairsOfCards: Int{
        return cardButtons.count / 2
    }
    
    //MARK: OUTLETS
    @IBOutlet private var cardButtons: [UIButton]!
    @IBOutlet private weak var flipCountLabel: UILabel!{
        didSet{
            updateFlipCountLabel()
        }
    }
    @IBOutlet weak var endGameLabel: UILabel!
    @IBOutlet weak var resetGameText: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    //MARK: ACTIONS
    @IBAction private func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.index(of: sender){
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
        else{
            print("chosen card was not in cardButtons")
        }
        if game.matches == numberOfPairsOfCards{
            endGameLabel.isHidden = false
        }
    }
    
    @IBAction private func newGameButton(_ sender: UIButton) {
        
        resetGame()
    }
    
    //MARK: METHODS
    private func  updateViewFromModel(){
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp{
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                startTimer()
            }
            else{
                //if cards gets matched, do this
                button.setTitle("", for: UIControlState.normal)
                //make it clear if set or orange if not set
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.6098514711, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
                if game.matches == numberOfPairsOfCards{
                    turnFaceDown()
                    resetGameText.setTitle("New Game", for: .normal)
                    stopTimer()
                }
            }
        }
    }
    
    private func turnFaceDown(){
        for index in cardButtons.indices {
            let button = cardButtons[index]
            button.backgroundColor = #colorLiteral(red: 1, green: 0.6098514711, blue: 0, alpha: 0)
            button.setTitle("", for: UIControlState.normal)
        }
    }
    
    private  func resetGame(){
        self.flipCount = 0
        emoji.removeAll()
        //    emojiChoices = ["🍆", "😀","🍏","🍎","🥥","🍠"]
        emojiChoices = "🍆😀🍏🍎🥥🍠"
        startNewGame()
        updateViewFromModel()
    }
    
    //initialize the game
    private func startNewGame() {
        endGameLabel.isHidden = true
        timeLabel.isHidden = true
        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
        emoji.removeAll()
        resetGameText.setTitle("Restart", for: .normal)
    }
    
    private func emoji(for card: Card) -> String{
        if emoji[card] == nil, emojiChoices.count > 0{
            let randomIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomIndex))
        }
        return emoji[card] ?? "?"
    }
    
    private func startTimer(){
        if start == nil{
            start = Date()
        }
    }
    private func stopTimer(){
        if start != nil{
            elapsedTime = Date().timeIntervalSince(start!)
        }
        timeLabel.isHidden = false
        timeLabel.text = "Time: \(Int(elapsedTime!))s"
    }
}

//MARK: INT EXTENSION
extension Int{
    var arc4random: Int{
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        }
        else if self < 0{
            return -Int(arc4random_uniform(UInt32(abs(self))))
        }
        else{
            return 0
        }
    }
}

