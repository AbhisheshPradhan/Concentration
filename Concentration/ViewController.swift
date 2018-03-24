//
//  ViewController.swift
//  Concentration
//
//  Created by Abhishesh Pradhan on 18/3/18.
//  Copyright © 2018 Abhishesh Pradhan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // need to know how many cards there is so use numberOfPairsOfCards which is an init
    //swift requires everything to be initialized before it is used.
    //Here, we get an error as var game tries to initialize itself but cardButtons hasn't been initialized yet.
    //game var depends on cardButtons being initialized first so we make game a lazy var which only gets initialized when it is called/or used
    //lazy counts as this var is initilized.
    //can't add didSet/property observers to lazy var
    
    
    //MARK: GAME CREATION
    // game creates Controller -> model link
    private lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1 ) / 2 )
    
    private(set) var flipCount = 0{
        didSet{
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    
    
    //MARK: INSTANCE VARIABLES
    private var emojiChoices = ["🍆", "😀","🍏","🍎","🥥","🍠"]
    //use card identifier(int) to put the corresponding emoji(string) into the cards array
    private var emoji =  [Card:String]()
    private var start: Date?
    private var elapsedTime: TimeInterval?
    
    private var numberOfPairsOfCards: Int{
        return cardButtons.count / 2
    }

    //MARK: OUTLETS
    @IBOutlet private var cardButtons: [UIButton]!
    @IBOutlet private weak var flipCountLabel: UILabel!
    @IBOutlet weak var endGameLabel: UILabel!
    @IBOutlet weak var resetGameText: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    //MARK: ACTIONS
    @IBAction private func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.index(of: sender){
            
            //Controller -> Model link
            game.chooseCard(at: cardNumber)
            
            //update the view since the user just touched(chose) a card so we need to update the view
            //we get the info for the new view from the model
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
    //update the view when there are any changes in the value of cards
    // indirect link of Model -> View and done by controller
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
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.6098514711, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.6098514711, blue: 0, alpha: 1)
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
        //reset flip count, clear the emoji dictionary, start new game and update the view
        self.flipCount = 0
        emoji.removeAll()
        emojiChoices = ["🍆", "😀","🍏","🍎","🥥","🍠"]
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
            
            //arc4random = get random value from 0 to upper bound
            //let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
            
            emoji[card] = emojiChoices.remove(at: emojiChoices.count.arc4random)
            
            //this code is kinda messy so we can extend int and get a random integer. this process is related to int only and not concentration class which is OKAY.
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

