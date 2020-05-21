/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityColorPalette4bitGeneric {

    static func generate(_ productCode: Int) {
        MyApplication.colorMap[productCode]!.redValues.position = 0
        MyApplication.colorMap[productCode]!.greenValues.position = 0
        MyApplication.colorMap[productCode]!.blueValues.position = 0
        UtilityIO.readTextFile("colormap" + String(productCode) + ".txt").split("\n").forEach { line in
            if line.contains(",") {
                let colors = line.split(",")
                let red = UInt8(colors[0])!
                let green = UInt8(colors[1])!
                let blue = UInt8(colors[2])!
                MyApplication.colorMap[productCode]!.redValues.put(red)
                MyApplication.colorMap[productCode]!.greenValues.put(green)
                MyApplication.colorMap[productCode]!.blueValues.put(blue)
            }
        }
    }
}
