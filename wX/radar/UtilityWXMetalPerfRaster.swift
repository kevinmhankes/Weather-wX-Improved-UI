/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

class UtilityWXMetalPerfRaster {

    static func genRaster(_ radarBuffers: ObjectMetalRadarBuffers) -> Int {
        radarBuffers.colormap.redValues.put(0, Color.red(radarBuffers.bgColor))
        radarBuffers.colormap.greenValues.put(0, Color.green(radarBuffers.bgColor))
        radarBuffers.colormap.blueValues.put(0, Color.blue(radarBuffers.bgColor))
        var totalBins = 0
        //var level: UInt8 = 0
        //var levelCount = 0
        //ar binStart = 0.0
        //var bI = 0
        var curLevel: UInt8 = 0
        //print(radarBuffers.rd.numberOfRadials)
        //print(radarBuffers.rd.numberOfRangeBins)
        //print(radarBuffers.rd.binWord.length)
        // 464 is bins per row for NCR (37)
        // 232 for long range NCZ (38)
        var numberOfRows = 464
        var binsPerRow = 464
        var scaleFactor = 2.0
        if radarBuffers.rd.productCode == 38 {
            numberOfRows = 232
            binsPerRow = 232
            scaleFactor = 8.0
        }
        if radarBuffers.rd.productCode == 41 || radarBuffers.rd.productCode == 57 {
            numberOfRows = 116
            binsPerRow = 116
            scaleFactor = 8.0
        }
        let halfPoint = numberOfRows / 2
        (0..<numberOfRows).forEach { g in
            // since radial_start is constructed natively as opposed to read in
            // from bigendian file we have to use getFloatNatve
            //angle = radarBuffers.rd.radialStartAngle.getFloatNative(g * 4)
            //level = radarBuffers.rd.binWord.get(bI)
            //levelCount = 0
            //binStart = radarBlackHole
            //if g < radarBuffers.rd.numberOfRadials - 1 {
            //    angleV = radarBuffers.rd.radialStartAngle.getFloatNative(g * 4 + 4)
            //} else {
            //    angleV = radarBuffers.rd.radialStartAngle.getFloatNative(0)
            //}
            (0..<binsPerRow).forEach { bin in
                //curLevel = radarBuffers.rd.binWord.get(bI)
                curLevel = radarBuffers.rd.binWord.get(g * numberOfRows + bin)
                //bI += 1
                //if curLevel == level {
                //    levelCount += 1
                //} else {
                    /*angleVCos = cos((angleV) / k180DivPi)
                    angleVSin = sin((angleV) / k180DivPi)
                    // 1
                    radarBuffers.putFloat(binStart * angleVCos)
                    radarBuffers.putFloat(binStart * angleVSin)
                    radarBuffers.putColorsByIndex(level)
                    // 2
                    radarBuffers.putFloat((binStart + radarBuffers.rd.binSize * Double(levelCount)) * angleVCos)
                    radarBuffers.putFloat((binStart + radarBuffers.rd.binSize * Double(levelCount)) * angleVSin)
                    radarBuffers.putColorsByIndex(level)
                    
                    angleCos = cos(angle / k180DivPi)
                    angleSin = sin(angle / k180DivPi)
                    // 3
                    radarBuffers.putFloat((binStart + radarBuffers.rd.binSize * Double(levelCount)) * angleCos)
                    radarBuffers.putFloat((binStart + radarBuffers.rd.binSize * Double(levelCount)) * angleSin)
                    radarBuffers.putColorsByIndex(level)
                    // 1
                    radarBuffers.putFloat((binStart * angleVCos))
                    radarBuffers.putFloat((binStart * angleVSin))
                    radarBuffers.putColorsByIndex(level)
                    // 3
                    radarBuffers.putFloat(((binStart + (radarBuffers.rd.binSize * Double(levelCount))) * angleCos))
                    radarBuffers.putFloat(((binStart + (radarBuffers.rd.binSize * Double(levelCount))) * angleSin))
                    radarBuffers.putColorsByIndex(level)
                    // 4
                    radarBuffers.putFloat(binStart * angleCos)
                    radarBuffers.putFloat(binStart * angleSin)
                    radarBuffers.putColorsByIndex(level)*/

                    radarBuffers.floatBuffer.putFloat(Double(bin - halfPoint) * scaleFactor)
                    //rI += 4
                    radarBuffers.floatBuffer.putFloat(Double(g - halfPoint) * scaleFactor * -1.0)
                    //rI += 4
                radarBuffers.putColorsByIndex(curLevel)

                    radarBuffers.floatBuffer.putFloat(Double(bin - halfPoint) * scaleFactor)
                    //rI += 4
                    radarBuffers.floatBuffer.putFloat(Double(g + 1 - halfPoint) * scaleFactor * -1.0)
                    //rI += 4
                radarBuffers.putColorsByIndex(curLevel)

                    radarBuffers.floatBuffer.putFloat(Double(bin + 1 - halfPoint) * scaleFactor)
                    //rI += 4
                    radarBuffers.floatBuffer.putFloat(Double(g + 1 - halfPoint) * scaleFactor * -1.0)
                    //rI += 4
                radarBuffers.putColorsByIndex(curLevel)

                    radarBuffers.floatBuffer.putFloat(Double(bin + 1 - halfPoint) * scaleFactor)
                    //rI += 4
                    radarBuffers.floatBuffer.putFloat(Double(g  - halfPoint) * scaleFactor * -1.0)
                    //rI += 4
                radarBuffers.putColorsByIndex(curLevel)

                    /*[0...3].forEach { _ in
                        //radarBuffers.colorBuffer.put(cI++, radarBuffers.colormap.redValues.get(curLevel and 0xFF))
                        //radarBuffers.colorBuffer.put(cI++, radarBuffers.colormap.greenValues.get(curLevel and 0xFF))
                        //radarBuffers.colorBuffer.put(cI++, radarBuffers.colormap.blueValues.get(curLevel and 0xFF))
                        radarBuffers.putColorsByIndex(curLevel)
                    }*/

                    totalBins += 1
                    //level = curLevel
                    //binStart = Double(bin) * radarBuffers.rd.binSize + radarBlackHoleAdd
                    //levelCount = 1
                }
            //}
        }
        return totalBins
    }
}
