/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class ColorPalettes {
    
    static func initialize() {
        [94, 99, 134, 135, 159, 161, 163, 165, 172].forEach { product in
            ObjectColorPalette.radarColorPalette[product] = Utility.readPref("RADAR_COLOR_PALETTE_" + String(product), "CODENH")
        }
        let colorMapNumbers = [19, 30, 41, 56, 134, 135, 159, 161, 163, 165]
        let cm94 = ObjectColorPalette(94)
        ObjectColorPalette.colorMap[94] = cm94
        ObjectColorPalette.colorMap[94]!.initialize()
        ObjectColorPalette.colorMap[153] = cm94
        ObjectColorPalette.colorMap[180] = cm94
        ObjectColorPalette.colorMap[186] = cm94
        let cm99 = ObjectColorPalette(99)
        ObjectColorPalette.colorMap[99] = cm99
        ObjectColorPalette.colorMap[99]!.initialize()
        ObjectColorPalette.colorMap[154] = cm99
        ObjectColorPalette.colorMap[182] = cm99
        let cm172 = ObjectColorPalette(172)
        ObjectColorPalette.colorMap[172] = cm172
        ObjectColorPalette.colorMap[172]!.initialize()
        ObjectColorPalette.colorMap[170] = cm172
        colorMapNumbers.forEach { productNumber in
            ObjectColorPalette.colorMap[productNumber] = ObjectColorPalette(productNumber)
            ObjectColorPalette.colorMap[productNumber]!.initialize()
        }
        ObjectColorPalette.colorMap[37] = ObjectColorPalette.colorMap[19]
        ObjectColorPalette.colorMap[38] = ObjectColorPalette.colorMap[19]
    }
}
