/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityColorPalette4bitGeneric {

    static func generate(_ radarColorPaletteCode: Int) {
        //let radarColorPaletteCode = Int(product)!
        MyApplication.colorMap[radarColorPaletteCode]!.redValues.position = 0
        MyApplication.colorMap[radarColorPaletteCode]!.greenValues.position = 0
        MyApplication.colorMap[radarColorPaletteCode]!.blueValues.position = 0
        UtilityIO.readTextFile("colormap" + String(radarColorPaletteCode) + ".txt").split("\n").forEach { line in
            if line.contains(",") {
                let colors = line.split(",")
                let red = UInt8(colors[0])!
                let green = UInt8(colors[1])!
                let blue = UInt8(colors[2])!
                MyApplication.colorMap[radarColorPaletteCode]!.redValues.put(red)
                MyApplication.colorMap[radarColorPaletteCode]!.greenValues.put(green)
                MyApplication.colorMap[radarColorPaletteCode]!.blueValues.put(blue)
            }
        }
    }
}
