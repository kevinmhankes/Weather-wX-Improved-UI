/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

// represents the items in a single line of a colorpal file
// dbz r g b
final class ObjectColorPaletteLine {
    
    let dbz: Int
    let red: UInt8
    let green: UInt8
    let blue: UInt8
    
    init(_ items: [String]) {
        dbz = Int(items[1]) ?? 0
        red = UInt8(items[2]) ?? 0
        green = UInt8(items[3]) ?? 0
        blue = UInt8(items[4]) ?? 0
    }
    
    init (_ items: [String], _ fn: ([String]) -> Int) {
        dbz = fn(items)
        red = UInt8(items[2]) ?? 0
        green = UInt8(items[3]) ?? 0
        blue = UInt8(items[4]) ?? 0
    }
    
    init(_ dbz: Int, _ red: String, _ green: String, _ blue: String) {
        self.dbz = dbz
        self.red = UInt8(red) ?? 0
        self.green = UInt8(green) ?? 0
        self.blue = UInt8(blue) ?? 0
    }
    
    var asInt: Int { Color.rgb(red, green, blue) }
}
