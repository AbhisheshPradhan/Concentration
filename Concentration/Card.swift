//
//  Card.swift
//  Concentration
//
//  Created by Abhishesh Pradhan on 18/3/18.
//  Copyright © 2018 Abhishesh Pradhan. All rights reserved.
//

import Foundation

struct Card{
    
    var isFaceUp = false
    var isMatched = false
    var identifier: Int // something to identify the card.
    //doesn't require var for emoji as it is model and is UI independent.
    //private because they are internal implementation only
    
   private static var identifierFactory = 0
    
    //puts unique int value to identifier for each "emoji" card
    //card doesn't understand this method but Card type does. TIED TO THE TYPE
    //so ask Card for this not card.
    
   private static func getUniqueIdentifier() -> Int{
        //Card.identifierFactory is not required as it is a static method of its own type
        identifierFactory += 1
        return identifierFactory
    }
    
    //isFaceUp & isMatched is already initialized. so identifier needs an init
    init(){
        //self = this cards identifier
        //rhs identifier is the passed identifier in the parameter
        self.identifier = Card.getUniqueIdentifier()
    }
}
