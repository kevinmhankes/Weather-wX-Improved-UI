/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityColorPalette165 {
    
    static func generate(_ code: String) {
        let radarColorPaletteCode = 165
        MyApplication.colorMap[radarColorPaletteCode]!.redValues.position = 0
        MyApplication.colorMap[radarColorPaletteCode]!.greenValues.position = 0
        MyApplication.colorMap[radarColorPaletteCode]!.blueValues.position = 0
        var dbzAl = [Int]()
        var rAl = [UInt8]()
        var gAl = [UInt8]()
        var bAl = [UInt8]()
        UtilityColorPalette.getColorMapStringFromDisk(radarColorPaletteCode, code).split("\n").forEach { line in
            if line.contains("olor") && !line.contains("#") {
                let items = line.contains(",") ? line.split(",") : line.split(" ")
                if items.count > 4 {
                    dbzAl.append(Int(items[1])!)
                    rAl.append(UInt8(items[2])!)
                    gAl.append(UInt8(items[3])!)
                    bAl.append(UInt8(items[4])!)
                }
            }
        }
        let diff = 10
        dbzAl.indices.forEach { index in
            let lowColor = Color.rgb(rAl[index], gAl[index], bAl[index])
            MyApplication.colorMap[radarColorPaletteCode]!.redValues.put(rAl[index])
            MyApplication.colorMap[radarColorPaletteCode]!.greenValues.put(gAl[index])
            MyApplication.colorMap[radarColorPaletteCode]!.blueValues.put(bAl[index])
            (1..<diff).forEach { _ in
                MyApplication.colorMap[radarColorPaletteCode]!.putInt(lowColor)
                //MyApplication.colorMap[radarColorPaletteCode]!.redValues.put(Color.red(lowColor))
                //MyApplication.colorMap[radarColorPaletteCode]!.greenValues.put(Color.green(lowColor))
                //MyApplication.colorMap[radarColorPaletteCode]!.blueValues.put(Color.blue(lowColor))
            }
        }
    }
    
    static func loadColorMap() {
        generate(MyApplication.radarColorPalette[165]!)
        // TODO replace with one line
        //switch MyApplication.radarColorPalette[165]! {
        //case "CODENH":
        //    generate("CODENH")
        //default:
        //    generate(MyApplication.radarColorPalette[165]!)
        //}
    }
}
