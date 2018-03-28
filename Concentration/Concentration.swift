//
//  Concentration.swift
//  Concentration
//
//  Created by Abhishesh Pradhan on 18/3/18.
//  Copyright © 2018 Abhishesh Pradhan. All rights reserved.
//

import Foundation

struct Concentration{    //API for the Concentration App. All the methods here are used by the controller

    private(set) var cards =  [Card]()
    private(set) var matches = 0
    
    private var indexOfOneAndOnlyFaceUpCard: Int?{
        get{
            return cards.indices.filter{cards[$0].isFaceUp}.oneAndOnly //closures used
        }
        set{
            for index in cards.indices{
                cards[index].isFaceUp = (index == newValue )
            }
        }
    }
    
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
            }
            else{
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int){
        assert(numberOfPairsOfCards>0, "Concentration.init(\(numberOfPairsOfCards):must have atleast one pair of card")
        for _ in 1...numberOfPairsOfCards{
            let card = Card()
            cards += [card, card]
        }
        cards.shuffle()
    }
}

//MARK: COLLECTION EXTENSION
extension Collection{
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
