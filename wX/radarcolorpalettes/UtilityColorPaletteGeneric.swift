/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityColorPaletteGeneric {
    
    static func generate(_ prod: String, _ code: String) {
        let colorMapR: MemoryBuffer
        let colorMapG: MemoryBuffer
        let colorMapB: MemoryBuffer
        var scale = 2
        var lowerEnd = -32
        var prodOffset = 0.0
        var prodScale = 1.0
        let productCode = Int(prod) ?? 94
        switch prod {
        case "94":
            colorMapR = MyApplication.colorMap[Int(productCode)]!.redValues
            colorMapG = MyApplication.colorMap[Int(productCode)]!.greenValues
            colorMapB = MyApplication.colorMap[Int(productCode)]!.blueValues
            scale = 2
            lowerEnd = -32
        case "99":
            colorMapR = MyApplication.colorMap[Int(productCode)]!.redValues
            colorMapG = MyApplication.colorMap[Int(productCode)]!.greenValues
            colorMapB = MyApplication.colorMap[Int(productCode)]!.blueValues
            scale = 1
            lowerEnd = -127
        case "134":
            colorMapR = MyApplication.colorMap[Int(productCode)]!.redValues
            colorMapG = MyApplication.colorMap[Int(productCode)]!.greenValues
            colorMapB = MyApplication.colorMap[Int(productCode)]!.blueValues
            scale = 1
            lowerEnd = 0
            prodOffset = 0.0
            prodScale = 3.64
        case "135":
            colorMapR = MyApplication.colorMap[Int(productCode)]!.redValues
            colorMapG = MyApplication.colorMap[Int(productCode)]!.greenValues
            colorMapB = MyApplication.colorMap[Int(productCode)]!.blueValues
            scale = 1
            lowerEnd = 0
        case "159":
            colorMapR = MyApplication.colorMap[Int(productCode)]!.redValues
            colorMapG = MyApplication.colorMap[Int(productCode)]!.greenValues
            colorMapB = MyApplication.colorMap[Int(productCode)]!.blueValues
            scale = 1
            lowerEnd = 0
            prodOffset = 128.0
            prodScale = 16.0
        case "161":
            colorMapR = MyApplication.colorMap[Int(productCode)]!.redValues
            colorMapG = MyApplication.colorMap[Int(productCode)]!.greenValues
            colorMapB = MyApplication.colorMap[Int(productCode)]!.blueValues
            scale = 1
            lowerEnd = 0
            prodOffset = -60.5
            prodScale = 300.0
        case "163":
            colorMapR = MyApplication.colorMap[Int(productCode)]!.redValues
            colorMapG = MyApplication.colorMap[Int(productCode)]!.greenValues
            colorMapB = MyApplication.colorMap[Int(productCode)]!.blueValues
            scale = 1
            lowerEnd = 0
            prodOffset = 43.0
            prodScale = 20.0
        case "172":
            colorMapR = MyApplication.colorMap[Int(productCode)]!.redValues
            colorMapG = MyApplication.colorMap[Int(productCode)]!.greenValues
            colorMapB = MyApplication.colorMap[Int(productCode)]!.blueValues
            scale = 1
            lowerEnd = 0
        default:
            colorMapR = MemoryBuffer()
            colorMapG = MemoryBuffer()
            colorMapB = MemoryBuffer()
        }
        colorMapR.position = 0
        colorMapG.position = 0
        colorMapB.position = 0
        var dbzAl = [Int]()
        var rAl = [UInt8]()
        var gAl = [UInt8]()
        var bAl = [UInt8]()
        let text = UtilityColorPalette.getColorMapStringFromDisk(prod, code)
        let lines = text.split("\n")
        var red = "0"
        var green = "0"
        var blue = "0"
        var priorLineHas6 = false
        lines.forEach { line in
            var tmpArr = [String]()
            if line.contains("olor") && !line.contains("#") {
                if line.contains(",") {
                    tmpArr = line.split(",")
                } else {
                    tmpArr = line.split(" ")
                }
                if tmpArr.count > 4 {
                    if priorLineHas6 {
                        dbzAl.append(Int(Double(tmpArr[1])! * prodScale + prodOffset - 1))
                        rAl.append(UInt8(Int(red)!))
                        gAl.append(UInt8(Int(green)!))
                        bAl.append(UInt8(Int(blue)!))
                        dbzAl.append(Int(Double(tmpArr[1])! * prodScale + prodOffset))
                        rAl.append(UInt8(tmpArr[2])!)
                        gAl.append(UInt8(tmpArr[3])!)
                        bAl.append(UInt8(tmpArr[4])!)
                        priorLineHas6 = false
                    } else {
                        dbzAl.append(Int(Double(tmpArr[1])! * prodScale + prodOffset))
                        rAl.append(UInt8(tmpArr[2])!)
                        gAl.append(UInt8(tmpArr[3])!)
                        bAl.append(UInt8(tmpArr[4])!)
                    }
                    if tmpArr.count > 7 {
                        priorLineHas6 = true
                        red = tmpArr[5]
                        green = tmpArr[6]
                        blue = tmpArr[7]
                    }
                }
            }
        }
        var low = 0
        var high = 0
        var lowColor = 0
        var highColor = 0
        var diff = 0
        var colorInt = 0
        var colorInt2 = 0
        if prod == "161" {
            (0..<10).forEach { _ in
                colorMapR.put(rAl[0])
                colorMapG.put(gAl[0])
                colorMapB.put(bAl[0])
            }
        }
        if prod == "99" || prod == "135" {
            colorMapR.put(rAl[0])
            colorMapG.put(gAl[0])
            colorMapB.put(bAl[0])
            colorMapR.put(rAl[0])
            colorMapG.put(gAl[0])
            colorMapB.put(bAl[0])
        }
        (lowerEnd..<dbzAl[0]).forEach { _ in
            colorMapR.put(rAl[0])
            colorMapG.put(gAl[0])
            colorMapB.put(bAl[0])
            if scale == 2 {
                colorMapR.put(rAl[0])
                colorMapG.put(gAl[0])
                colorMapB.put(bAl[0])
            }
        }
        dbzAl.indices.forEach { index in
            if index < (dbzAl.count - 1) {
                low = dbzAl[index]
                lowColor = Color.rgb(rAl[index], gAl[index], bAl[index])
                high = dbzAl[index + 1]
                highColor = Color.rgb(rAl[index + 1], gAl[index + 1], bAl[index + 1])
                diff = high - low
                colorMapR.put(rAl[index])
                colorMapG.put(gAl[index])
                colorMapB.put(bAl[index])
                if scale == 2 {
                    colorMapR.put(rAl[index])
                    colorMapG.put(gAl[index])
                    colorMapB.put(bAl[index])
                }
                if diff == 0 { diff = 1 }
                (1..<diff).forEach { j in
                    if scale == 1 {
                        colorInt = UtilityNexradColors.interpolateColor(Int(lowColor), Int(highColor), Double(j) / Double(diff * scale))
                        colorMapR.put(Color.red(colorInt))
                        colorMapG.put(Color.green(colorInt))
                        colorMapB.put(Color.blue(colorInt))
                    } else if scale == 2 {
                        colorInt = UtilityNexradColors.interpolateColor(Int(lowColor), Int(highColor), Double(((j * 2)-1)) / Double((diff * 2)))
                        colorInt2 = UtilityNexradColors.interpolateColor(Int(lowColor), Int(highColor), Double((j * 2)) / Double((diff * 2)))
                        colorMapR.put(Color.red(colorInt))
                        colorMapG.put(Color.green(colorInt))
                        colorMapB.put(Color.blue(colorInt))
                        colorMapR.put(Color.red(colorInt2))
                        colorMapG.put(Color.green(colorInt2))
                        colorMapB.put(Color.blue(colorInt2))
                    }
                }
            } else {
                colorMapR.put(rAl[index])
                colorMapG.put(gAl[index])
                colorMapB.put(bAl[index])
                if scale == 2 {
                    colorMapR.put(rAl[index])
                    colorMapG.put(gAl[index])
                    colorMapB.put(bAl[index])
                }
            }
        }
    }
    
    static func loadColorMap(_ product: String) {
        let map = MyApplication.radarColorPalette[product]!
        switch product {
        case "94":
            switch map {
            case "DKenh":
                UtilityColorPaletteGeneric.generate(product, "DKenh")
            case "COD":
                UtilityColorPaletteGeneric.generate(product, "CODENH")
            case "CODENH":
                UtilityColorPaletteGeneric.generate(product, "CODENH")
            case "MENH":
                UtilityColorPaletteGeneric.generate(product, "MENH")
            case "GREEN":
                UtilityColorPaletteGeneric.generate(product, "GREEN")
            case "AF":
                UtilityColorPaletteGeneric.generate(product, "AF")
            case "EAK":
                UtilityColorPaletteGeneric.generate(product, "EAK")
            case "NWS":
                UtilityColorPaletteGeneric.generate(product, "NWS")
            default:
                UtilityColorPaletteGeneric.generate(product, map)
            }
        case "99":
            switch map {
            case "COD":
                UtilityColorPaletteGeneric.generate(product, "CODENH")
            case "CODENH":
                UtilityColorPaletteGeneric.generate(product, "CODENH")
            case "AF":
                UtilityColorPaletteGeneric.generate(product, "AF")
            case "EAK":
                UtilityColorPaletteGeneric.generate(product, "EAK")
            default:
                UtilityColorPaletteGeneric.generate(product, map)
            }
        case "134":
            switch map {
            case "CODENH":
                UtilityColorPaletteGeneric.generate(product, "CODENH")
            default:
                UtilityColorPaletteGeneric.generate(product, map)
            }
        case "135":
            switch map {
            case "CODENH":
                UtilityColorPaletteGeneric.generate(product, "CODENH")
            default:
                UtilityColorPaletteGeneric.generate(product, map)
            }
        case "159":
            switch map {
            case "CODENH":
                UtilityColorPaletteGeneric.generate(product, "CODENH")
            default:
                UtilityColorPaletteGeneric.generate(product, map)
            }
        case "161":
            switch map {
            case "CODENH":
                UtilityColorPaletteGeneric.generate(product, "CODENH")
            default:
                UtilityColorPaletteGeneric.generate(product, map)
            }
        case "163":
            switch map {
            case "CODENH":
                UtilityColorPaletteGeneric.generate(product, "CODENH")
            default:
                UtilityColorPaletteGeneric.generate(product, map)
            }
        case "172":
            switch map {
            case "CODENH":
                UtilityColorPaletteGeneric.generate(product, "CODENH")
            default:
                UtilityColorPaletteGeneric.generate(product, map)
            }
        default:
            break
        }
    }
}
