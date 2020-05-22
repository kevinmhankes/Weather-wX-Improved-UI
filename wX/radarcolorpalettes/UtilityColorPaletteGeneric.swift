/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityColorPaletteGeneric {
    
    static func generate(_ productCode: Int, _ code: String) {
        let scale: Int
        let lowerEnd: Int
        var prodOffset = 0.0
        var prodScale = 1.0
        let colorMapR = MyApplication.colorMap[productCode]!.redValues
        let colorMapG = MyApplication.colorMap[productCode]!.greenValues
        let colorMapB = MyApplication.colorMap[productCode]!.blueValues
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
        colorMapR.position = 0
        colorMapG.position = 0
        colorMapB.position = 0
        var dbzAl = [Int]()
        var rAl = [UInt8]()
        var gAl = [UInt8]()
        var bAl = [UInt8]()
        let text = UtilityColorPalette.getColorMapStringFromDisk(productCode, code)
        // TODO why are these used
        var red = "0"
        var green = "0"
        var blue = "0"
        var priorLineHas6 = false
        text.split("\n").forEach { line in
            if line.contains("olor") && !line.contains("#") {
                let items = line.contains(",") ? line.split(",") : line.split(" ")
                if items.count > 4 {
                    if priorLineHas6 {
                        dbzAl.append(Int(Double(items[1])! * prodScale + prodOffset - 1))
                        rAl.append(UInt8(Int(red)!))
                        gAl.append(UInt8(Int(green)!))
                        bAl.append(UInt8(Int(blue)!))
                        dbzAl.append(Int(Double(items[1])! * prodScale + prodOffset))
                        rAl.append(UInt8(items[2])!)
                        gAl.append(UInt8(items[3])!)
                        bAl.append(UInt8(items[4])!)
                        priorLineHas6 = false
                    } else {
                        dbzAl.append(Int(Double(items[1])! * prodScale + prodOffset))
                        rAl.append(UInt8(items[2])!)
                        gAl.append(UInt8(items[3])!)
                        bAl.append(UInt8(items[4])!)
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
            (0..<10).forEach { _ in
                colorMapR.put(rAl[0])
                colorMapG.put(gAl[0])
                colorMapB.put(bAl[0])
            }
        }
        if productCode == 99 || productCode == 135 {
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
                let low = dbzAl[index]
                let lowColor = Color.rgb(rAl[index], gAl[index], bAl[index])
                let high = dbzAl[index + 1]
                let highColor = Color.rgb(rAl[index + 1], gAl[index + 1], bAl[index + 1])
                var diff = high - low
                colorMapR.put(rAl[index])
                colorMapG.put(gAl[index])
                colorMapB.put(bAl[index])
                if scale == 2 {
                    colorMapR.put(rAl[index])
                    colorMapG.put(gAl[index])
                    colorMapB.put(bAl[index])
                }
                if diff == 0 { diff = 1 } // TODO why is this needed?
                (1..<diff).forEach { j in
                    if scale == 1 {
                        let colorInt = UtilityNexradColors.interpolateColor(Int(lowColor), Int(highColor), Double(j) / Double(diff * scale))
                        colorMapR.put(Color.red(colorInt))
                        colorMapG.put(Color.green(colorInt))
                        colorMapB.put(Color.blue(colorInt))
                    } else if scale == 2 {
                        let colorInt = UtilityNexradColors.interpolateColor(Int(lowColor), Int(highColor), Double(((j * 2)-1)) / Double((diff * 2)))
                        let colorInt2 = UtilityNexradColors.interpolateColor(Int(lowColor), Int(highColor), Double((j * 2)) / Double((diff * 2)))
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
    
    static func loadColorMap(_ product: Int) {
        let map = MyApplication.radarColorPalette[product]!
        switch product {
        case 94:
            switch map {
            case "DKenh":
                generate(product, "DKenh")
            case "COD":
                generate(product, "CODENH")
            case "CODENH":
                generate(product, "CODENH")
            case "MENH":
                generate(product, "MENH")
            case "GREEN":
                generate(product, "GREEN")
            case "AF":
                generate(product, "AF")
            case "EAK":
                generate(product, "EAK")
            case "NWS":
                generate(product, "NWS")
            default:
                generate(product, map)
            }
        case 99:
            switch map {
            case "COD":
                generate(product, "CODENH")
            case "CODENH":
                generate(product, "CODENH")
            case "AF":
                generate(product, "AF")
            case "EAK":
                generate(product, "EAK")
            default:
                generate(product, map)
            }
        case 134:
            switch map {
            case "CODENH":
                generate(product, "CODENH")
            default:
                generate(product, map)
            }
        case 135:
            switch map {
            case "CODENH":
                generate(product, "CODENH")
            default:
                generate(product, map)
            }
        case 159:
            switch map {
            case "CODENH":
                generate(product, "CODENH")
            default:
                generate(product, map)
            }
        case 161:
            switch map {
            case "CODENH":
                generate(product, "CODENH")
            default:
                generate(product, map)
            }
        case 163:
            switch map {
            case "CODENH":
                generate(product, "CODENH")
            default:
                generate(product, map)
            }
        case 172:
            switch map {
            case "CODENH":
                generate(product, "CODENH")
            default:
                generate(product, map)
            }
        default:
            break
        }
    }
}
