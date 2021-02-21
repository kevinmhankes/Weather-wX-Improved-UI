/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityColorPalette165 {
    
    static let radarColorPaletteCode = 165
    
    static func generate(_ code: String) {
        let objectColorPalette = ObjectColorPalette.colorMap[radarColorPaletteCode]!
        objectColorPalette.position(0)
        var objectColorPaletteLines = [ObjectColorPaletteLine]()
        UtilityColorPalette.getColorMapStringFromDisk(radarColorPaletteCode, code).split("\n").forEach { line in
            if line.contains("olor") && !line.contains("#") {
                let items = line.contains(",") ? line.split(",") : line.split(" ")
                if items.count > 4 { objectColorPaletteLines.append(ObjectColorPaletteLine(items)) }
            }
        }
        let diff = 10
        objectColorPaletteLines.forEach { line in
            (0..<diff).forEach { _ in objectColorPalette.putInt(line.asInt) }
        }
    }
    
    static func loadColorMap() {
        generate(ObjectColorPalette.radarColorPalette[radarColorPaletteCode]!)
    }
}
