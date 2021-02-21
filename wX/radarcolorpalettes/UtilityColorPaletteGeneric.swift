/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityColorPaletteGeneric {
    
    static func generate(_ productCode: Int, _ code: String) {
        let scale: Int
        let lowerEnd: Int
        var prodOffset = 0.0
        var prodScale = 1.0
        let objectColorPalette = ObjectColorPalette.colorMap[productCode]!
        objectColorPalette.position(0)
        switch productCode {
        case 94:
            scale = 2
            lowerEnd = -32
        case 99:
            scale = 1
            lowerEnd = -127
        case 134:
            scale = 1
            lowerEnd = 0
            prodOffset = 0.0
            prodScale = 3.64
        case 135:
            scale = 1
            lowerEnd = 0
        case 159:
            scale = 1
            lowerEnd = 0
            prodOffset = 128.0
            prodScale = 16.0
        case 161:
            scale = 1
            lowerEnd = 0
            prodOffset = -60.5
            prodScale = 300.0
        case 163:
            scale = 1
            lowerEnd = 0
            prodOffset = 43.0
            prodScale = 20.0
        case 172:
            scale = 1
            lowerEnd = 0
        default:
            scale = 2
            lowerEnd = -32
        }
        var objectColorPaletteLines = [ObjectColorPaletteLine]()
        var red = "0"
        var green = "0"
        var blue = "0"
        var priorLineHas6 = false
        UtilityColorPalette.getColorMapStringFromDisk(productCode, code).split("\n").forEach { line in
            if line.contains("olor") && !line.contains("#") {
                let items = line.contains(",") ? line.split(",") : line.split(" ")
                if items.count > 4 {
                    if priorLineHas6 {
                        objectColorPaletteLines.append(ObjectColorPaletteLine(Int((Double(items[1]) ?? 0.0) * prodScale + prodOffset - 1  ), red, green, blue))
                        objectColorPaletteLines.append(ObjectColorPaletteLine(items) {
                                                   Int(((Double($0[1]) ?? 0.0) * prodScale + prodOffset))
                                               })
                        
                        priorLineHas6 = false
                    } else {
                        objectColorPaletteLines.append(ObjectColorPaletteLine(items) {
                            Int(((Double($0[1]) ?? 0.0) * prodScale + prodOffset))
                        })
                        
                    }
                    if items.count > 7 {
                        priorLineHas6 = true
                        red = items[5]
                        green = items[6]
                        blue = items[7]
                    }
                }
            }
        }
        if productCode == 161 {
            (0..<10).forEach { _ in objectColorPalette.putBytes(objectColorPaletteLines[0]) }
        }
        if productCode == 99 || productCode == 135 {
            objectColorPalette.putBytes(objectColorPaletteLines[0])
            objectColorPalette.putBytes(objectColorPaletteLines[0])
        }
        (lowerEnd..<objectColorPaletteLines[0].dbz).forEach { _ in
            objectColorPalette.putBytes(objectColorPaletteLines[0])
            if scale == 2 {
                objectColorPalette.putBytes(objectColorPaletteLines[0])
            }
        }
        objectColorPaletteLines.indices.forEach { index in
            if index < (objectColorPaletteLines.count - 1) {
                let low = objectColorPaletteLines[index].dbz
                let lowColor = objectColorPaletteLines[index].asInt
                let high = objectColorPaletteLines[index + 1].dbz
                let highColor = objectColorPaletteLines[index + 1].asInt
                var diff = high - low
                objectColorPalette.putBytes(objectColorPaletteLines[index])
                if scale == 2 { objectColorPalette.putBytes(objectColorPaletteLines[index]) }
                if diff == 0 { diff = 1 }
                (1..<diff).forEach { j in
                    if scale == 1 {
                        let colorInt = UtilityNexradColors.interpolateColor(Int(lowColor), Int(highColor), Double(j) / Double(diff * scale))
                        objectColorPalette.putInt(colorInt)
                    } else if scale == 2 {
                        let colorInt = UtilityNexradColors.interpolateColor(Int(lowColor), Int(highColor), Double(((j * 2) - 1)) / Double((diff * 2)))
                        let colorInt2 = UtilityNexradColors.interpolateColor(Int(lowColor), Int(highColor), Double((j * 2)) / Double((diff * 2)))
                        objectColorPalette.putInt(colorInt)
                        objectColorPalette.putInt(colorInt2)
                    }
                }
            } else {
                objectColorPalette.putBytes(objectColorPaletteLines[index])
                if scale == 2 {
                    objectColorPalette.putBytes(objectColorPaletteLines[index])
                }
            }
        }
    }
    
    static func loadColorMap(_ product: Int) {
        generate(product, ObjectColorPalette.radarColorPalette[product]!)
    }
}
