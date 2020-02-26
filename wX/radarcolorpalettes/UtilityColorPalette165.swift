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
        let text = UtilityColorPalette.getColorMapStringFromDisk("165", code)
        let lines = text.split("\n")
        var tmpArr = [String]()
        lines.forEach {
            if $0.contains("olor") && !$0.contains("#") {
                if $0.contains(",") {
                    tmpArr = $0.split(",")
                } else {
                    tmpArr = $0.split(" ")
                }
                if tmpArr.count > 4 {
                    dbzAl.append(Int(tmpArr[1])!)
                    rAl.append(UInt8(tmpArr[2])!)
                    gAl.append(UInt8(tmpArr[3])!)
                    bAl.append(UInt8(tmpArr[4])!)
                }
            }
        }
        var lowColor = 0
        var diff = 0
        dbzAl.indices.forEach { i in
            lowColor = Color.rgb(rAl[i], gAl[i], bAl[i])
            diff = 10
            MyApplication.colorMap[radarColorPaletteCode]!.redValues.put(rAl[i])
            MyApplication.colorMap[radarColorPaletteCode]!.greenValues.put(gAl[i])
            MyApplication.colorMap[radarColorPaletteCode]!.blueValues.put(bAl[i])
            (1..<diff).forEach { _ in
                MyApplication.colorMap[radarColorPaletteCode]!.redValues.put(Color.red(lowColor))
                MyApplication.colorMap[radarColorPaletteCode]!.greenValues.put(Color.green(lowColor))
                MyApplication.colorMap[radarColorPaletteCode]!.blueValues.put(Color.blue(lowColor))
            }
        }
    }
    
    static func loadColorMap() {
        switch MyApplication.radarColorPalette["165"]! {
        case "CODENH": UtilityColorPalette165.generate("CODENH")
        default:       UtilityColorPalette165.generate(MyApplication.radarColorPalette["165"]!)
        }
    }
}
