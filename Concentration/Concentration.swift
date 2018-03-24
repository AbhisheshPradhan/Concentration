//
//  Concentration.swift
//  Concentration
//
//  Created by Abhishesh Pradhan on 18/3/18.
//  Copyright © 2018 Abhishesh Pradhan. All rights reserved.
//

import Foundation

struct Concentration{    //API for the Concentration App. All the methods here are used by the controller
    
    
    //array of cards of type Card(struct)
    //arrays are value types so we can create array of type struct as structs are also value types.
    
    //uses UI for value of cards but setting is done by the class so private(set)
    private(set) var cards =  [Card]()
    private(set) var matches = 0
    
    //it is optional value, as if there are two or 0 faceup cards, its value is not set
    private var indexOfOneAndOnlyFaceUpCard: Int?
    
    mutating func chooseCard(at index: Int){
        //assertion for crash test
        assert(cards.indices.contains(index),"Concentration.chooseCard(at: \(index)):chosen index is not in card")
        if !cards[index].isMatched{
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index{
                
                //check if cards match
                if cards[matchIndex] == cards[index]{
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    matches += 1
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = nil
            }
            else{
                // either no cards or 2 cards are face up
                for flipDownIndex in cards.indices{
                    cards[flipDownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int){
        assert(numberOfPairsOfCards>0, "Concentration.init(\(numberOfPairsOfCards):must have atleast one pair of card")
        //  _ = idc
        for _ in 1...numberOfPairsOfCards{      // iterate from 1 to num of pairs //Sequence = Countable Range
            // 1...numberOfPairsOfCards = 1 to numberOfPairsOfCards(inclusive)
            //other example 0..<numberOfPairsOfCards
            
            let card = Card()
            cards += [card, card]           // put 2(1 pair) copies of cards into the cards array
            //card = instances of struct..cards makes 2 copies of Card and puts it into the array
            //so card = 2 same cards but 2 different instances
        }
        cards.shuffle()
    }
}
