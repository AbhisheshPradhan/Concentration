//
//  ArrayExtension.swift
//  Concentration
//
//  Created by Abhishesh Pradhan on 19/3/18.
//  Copyright © 2018 Abhishesh Pradhan. All rights reserved.
//

import Foundation

extension Array {
    public mutating func shuffle() {
        var temp = [Element]()
        while !isEmpty {
            let i = Int(arc4random_uniform(UInt32(count)))
            let obj = remove(at: i)
            temp.append(obj)
        }
        self = temp
    }
}
