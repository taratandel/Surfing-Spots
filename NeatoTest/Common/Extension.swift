//
//  Extension.swift
//  NeatoTest
//
//  Created by Tara Tandel on 20/08/2020.
//  Copyright © 2020 Tara Tandel. All rights reserved.
//

import Foundation
/// if have 10 numbers, but you only want to select from 9 numbers (0 through 9, but excluding the previous number). If you reduce your range by 1, you can select from 9 random numbers and then just replace a repeated number with the previous top number of the range. In this way, you only have to generate a single random number each time and you get uniformity.

extension Int {
    /**
     This function will generated a random number in a range excluding a specific number
     - Parameters:
        - in range: the range of number that the random number is choosen in
        - excluding x: the specific number to exclude
     - Returns:
     a uniformly selected random number
     */
    static func random(in range: ClosedRange<Int>, excluding x: Int) -> Int {
        if range.contains(x) {
            let r = Int.random(in: Range(uncheckedBounds: (range.lowerBound, range.upperBound)))
            return r == x ? range.upperBound : r
        } else {
            return Int.random(in: range)
        }
    }
}
