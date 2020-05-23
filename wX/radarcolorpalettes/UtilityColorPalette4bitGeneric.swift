/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityColorPalette4bitGeneric {

    static func generate(_ product: Int) {
        MyApplication.colorMap[product]!.position(0)
        UtilityIO.readTextFile("colormap" + String(product) + ".txt").split("\n").forEach { line in
            if line.contains(",") { MyApplication.colorMap[product]!.putLine(line) }
        }
    }
}
