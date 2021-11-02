// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import Foundation

final class to {

    static func String(_ i: Int) -> String {
        Swift.String(i)
    }
    
    static func Int(_ s: String) -> Int {
        Swift.Int(s) ?? 0
    }
    
    static func Double(_ s: String) -> Double {
        Swift.Double(s) ?? 0.0
    }
    
    static func Float(_ s: String) -> Float {
        Swift.Float(s) ?? 0.0
    }
    
//    fun stringPadLeft(s: String, padAmount: Int): String {
//        return String.format("%-" + padAmount.toString() + "s", s)
//    }

    static func stringPadLeftZeros(_ s: Int, _ padAmount: Int) -> String {
        return Swift.String(format: "%0" + String(padAmount) + "d", s)
        // return String.format("%0" + padAmount.toString() + "d", s)
    }

//    fun stringFromFloatFixed(d: Double, precision: Int): String {
//        return String.format(  "%." + precision.toString() + "f", d)
//    }
}
