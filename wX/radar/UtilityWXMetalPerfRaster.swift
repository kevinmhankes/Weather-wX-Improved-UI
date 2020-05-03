/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

class UtilityWXMetalPerfRaster {

    static func generate(_ radarBuffers: ObjectMetalRadarBuffers) -> Int {
        radarBuffers.colorMap.redValues.put(0, Color.red(radarBuffers.bgColor))
        radarBuffers.colorMap.greenValues.put(0, Color.green(radarBuffers.bgColor))
        radarBuffers.colorMap.blueValues.put(0, Color.blue(radarBuffers.bgColor))
        var totalBins = 0
        var curLevel: UInt8 = 0
        var numberOfRows = 464
        var binsPerRow = 464
        var scaleFactor: Float = 2.0
        if radarBuffers.rd.productCode == 38 {
            numberOfRows = 232
            binsPerRow = 232
            scaleFactor = 8.0 // was 8
        }
        if radarBuffers.rd.productCode == 41 || radarBuffers.rd.productCode == 57 {
            numberOfRows = 116
            binsPerRow = 116
            scaleFactor = 8.0 // was 8
        }
        let halfPoint = numberOfRows / 2
        (0..<numberOfRows).forEach { g in
            (0..<binsPerRow).forEach { bin in
                curLevel = radarBuffers.rd.binWord.get(g * binsPerRow + bin)
                // 1
                radarBuffers.putFloat(Float(bin - halfPoint) * scaleFactor)
                radarBuffers.putFloat(Float(g - halfPoint) * scaleFactor * -1.0)
                radarBuffers.putColorsByIndex(curLevel)
                // 2
                radarBuffers.putFloat(Float(bin - halfPoint) * scaleFactor)
                radarBuffers.putFloat(Float(g + 1 - halfPoint) * scaleFactor * -1.0)
                radarBuffers.putColorsByIndex(curLevel)
                // 3
                radarBuffers.putFloat(Float(bin + 1 - halfPoint) * scaleFactor)
                radarBuffers.putFloat(Float(g + 1 - halfPoint) * scaleFactor * -1.0)
                radarBuffers.putColorsByIndex(curLevel)
                // 1
                radarBuffers.putFloat(Float(bin - halfPoint) * scaleFactor)
                radarBuffers.putFloat(Float(g - halfPoint) * scaleFactor * -1.0)
                radarBuffers.putColorsByIndex(curLevel)
                // 3
                radarBuffers.putFloat(Float(bin + 1 - halfPoint) * scaleFactor)
                radarBuffers.putFloat(Float(g + 1 - halfPoint) * scaleFactor * -1.0)
                radarBuffers.putColorsByIndex(curLevel)
                // 4
                radarBuffers.putFloat(Float(bin + 1 - halfPoint) * scaleFactor)
                radarBuffers.putFloat(Float(g  - halfPoint) * scaleFactor * -1.0) //
                radarBuffers.putColorsByIndex(curLevel)
                totalBins += 1
            }
        }
        return totalBins
    }
}
