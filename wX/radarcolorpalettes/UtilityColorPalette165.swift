/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityColorPalette165 {
    
    static let radarColorPaletteCode = 165
    
    static func generate(_ code: String) {
        let objectColorPalette = MyApplication.colorMap[radarColorPaletteCode]!
        objectColorPalette.position(0)
        //var dbzList = [Int]()
        //var redList = [UInt8]()
        //var greenList = [UInt8]()
        //var blueList = [UInt8]()
        var objectColorPaletteLines = [ObjectColorPaletteLine]()
        UtilityColorPalette.getColorMapStringFromDisk(radarColorPaletteCode, code).split("\n").forEach { line in
            if line.contains("olor") && !line.contains("#") {
                let items = line.contains(",") ? line.split(",") : line.split(" ")
                if items.count > 4 {
                    objectColorPaletteLines.append(ObjectColorPaletteLine(items))
                    //dbzList.append(Int(items[1])!)
                    //redList.append(UInt8(items[2])!)
                    //greenList.append(UInt8(items[3])!)
                    //blueList.append(UInt8(items[4])!)
                }
            }
        }
        let diff = 10
        objectColorPaletteLines.forEach {
            let lowColor = $0.asInt
            //objectColorPalette.putBytes($0)
            (0..<diff).forEach { _ in objectColorPalette.putInt(lowColor) }
        }
    }
    
    static func loadColorMap() {
        generate(MyApplication.radarColorPalette[radarColorPaletteCode]!)
    }
}
