/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

// FIXME cleanup comments
// FIXME decide if continue with X Y R G B (5 floats) or go to X Y rgba (3 floats)

import Foundation

class UtilityWXMetalPerf {

    static let k180DivPi = 180.0 / Double.pi
    static let piDiv4 = Double.pi / 4.0
    static let piDiv360 = Double.pi / 360.0
    static let twicePi = 2.0 * Double.pi

    static func decode8BitAndGenRadials(_ radarBuffers: ObjectMetalRadarBuffers) -> Int {
        var totalBins = 0
        let disFirst = UtilityIO.readFiletoByteByffer(radarBuffers.fileName)
        if disFirst.capacity == 0 {return 0}
        while disFirst.getShort() != -1 {}
        disFirst.skipBytes(100)
        var retSize: UInt32 = 1000000
        let oBuff = [UInt8](repeating: 1, count: Int(retSize))
        let compressedFileSize: CLong = disFirst.capacity - disFirst.position
        BZ2_bzBuffToBuffDecompress(MemoryBuffer.getPointer(oBuff), &retSize,
                                   MemoryBuffer.getPointerAndAdvance(disFirst.array, by: disFirst.position),
                                   UInt32(compressedFileSize), 1, 0)
        let dis2 = MemoryBuffer(oBuff)
        dis2.skipBytes(30)
        var numberOfRleHalfwords: UInt16 = 0
        radarBuffers.colormap.redValues.put(0, Color.red(radarBuffers.bgColor))
        radarBuffers.colormap.greenValues.put(0, Color.green(radarBuffers.bgColor))
        radarBuffers.colormap.blueValues.put(0, Color.blue(radarBuffers.bgColor))
        radarBuffers.setToPositionZero()
        var angle = 0.0
        var angleV = 0.0
        var level: UInt8 = 0
        var levelCount: Int = 0
        var binStart = 0.0
        var curLevel: UInt8 = 0
        var angleSin = 0.0
        var angleCos = 0.0
        var angleVSin = 0.0
        var angleVCos = 0.0
        var angleNext = 0.0
        var angle0 = 0.0
        (0..<360).forEach { radial in
            numberOfRleHalfwords = dis2.getUnsignedShort()
            angle = (450.0 - (Double(Int(dis2.getUnsignedShort())) / 10.0))
            dis2.skipBytes(2)
            if radial < 359 {
                dis2.mark(dis2.position)
                dis2.skipBytes(Int(numberOfRleHalfwords) + 2)
                angleNext = (450.0 - (Double(Int(dis2.getUnsignedShort())) / 10.0))
                dis2.reset()
            }
            level = 0
            levelCount = 0
            binStart = radarBuffers.rd.binSize
            if radial == 0 {angle0 = angle}
            if radial < 359 {
                angleV = angleNext
            } else {
                angleV = angle0
            }
            (0..<numberOfRleHalfwords).forEach { bin in
                curLevel = dis2.get()
                if bin==0 {level = curLevel}
                if curLevel == level {
                    levelCount += 1
                } else {
                    angleVCos = cos((angleV)/k180DivPi)
                    angleVSin = sin((angleV)/k180DivPi)

                    // 1
                    radarBuffers.putFloat((binStart * angleVCos))
                    radarBuffers.putFloat((binStart * angleVSin))
                    //radarBuffers.putFloat(0.0)
                    //(0...3).forEach { _ in
                        radarBuffers.putColor(radarBuffers.colormap.redValues.get(Int(level)))
                        radarBuffers.putColor(radarBuffers.colormap.greenValues.get(Int(level)))
                        radarBuffers.putColor(radarBuffers.colormap.blueValues.get(Int(level)))
                        //radarBuffers.putColorFloat(1.0)
                    //}

                    // 2
                    radarBuffers.putFloat(((binStart + (radarBuffers.rd.binSize * Double(levelCount))) * angleVCos))
                    radarBuffers.putFloat(((binStart + (radarBuffers.rd.binSize * Double(levelCount))) * angleVSin))
                    //radarBuffers.putFloat(0.0)
                    //(0...3).forEach { _ in
                        radarBuffers.putColor(radarBuffers.colormap.redValues.get(Int(level)))
                        radarBuffers.putColor(radarBuffers.colormap.greenValues.get(Int(level)))
                        radarBuffers.putColor(radarBuffers.colormap.blueValues.get(Int(level)))
                        //radarBuffers.putColorFloat(1.0)
                    //}

                    angleCos = cos(angle/k180DivPi)
                    angleSin = sin(angle/k180DivPi)

                    // 3
                    radarBuffers.putFloat(((binStart + (radarBuffers.rd.binSize * Double(levelCount))) * angleCos))
                    radarBuffers.putFloat(((binStart + (radarBuffers.rd.binSize * Double(levelCount))) * angleSin))
                    //radarBuffers.putFloat(0.0)
                    //(0...3).forEach { _ in
                        radarBuffers.putColor(radarBuffers.colormap.redValues.get(Int(level)))
                        radarBuffers.putColor(radarBuffers.colormap.greenValues.get(Int(level)))
                        radarBuffers.putColor(radarBuffers.colormap.blueValues.get(Int(level)))
                        //radarBuffers.putColorFloat(1.0)
                    //}

                    // 1
                    radarBuffers.putFloat((binStart * angleVCos))
                    radarBuffers.putFloat((binStart * angleVSin))
                    //radarBuffers.putFloat(0.0)
                    //(0...3).forEach { _ in
                        radarBuffers.putColor(radarBuffers.colormap.redValues.get(Int(level)))
                        radarBuffers.putColor(radarBuffers.colormap.greenValues.get(Int(level)))
                        radarBuffers.putColor(radarBuffers.colormap.blueValues.get(Int(level)))
                        //radarBuffers.putColorFloat(1.0)
                    //}

                    // 3
                    radarBuffers.putFloat(((binStart + (radarBuffers.rd.binSize * Double(levelCount))) * angleCos))
                    radarBuffers.putFloat(((binStart + (radarBuffers.rd.binSize * Double(levelCount))) * angleSin))
                    //radarBuffers.putFloat(0.0)
                    //(0...3).forEach { _ in
                        radarBuffers.putColor(radarBuffers.colormap.redValues.get(Int(level)))
                        radarBuffers.putColor(radarBuffers.colormap.greenValues.get(Int(level)))
                        radarBuffers.putColor(radarBuffers.colormap.blueValues.get(Int(level)))
                        //radarBuffers.putColorFloat(1.0)
                    //}
                    // 4
                    radarBuffers.putFloat((binStart * angleCos))
                    radarBuffers.putFloat((binStart * angleSin))
                    //radarBuffers.putFloat(0.0)
                    //(0...3).forEach { _ in
                        radarBuffers.putColor(radarBuffers.colormap.redValues.get(Int(level)))
                        radarBuffers.putColor(radarBuffers.colormap.greenValues.get(Int(level)))
                        radarBuffers.putColor(radarBuffers.colormap.blueValues.get(Int(level)))
                        //radarBuffers.putColorFloat(1.0)
                    //}

                    totalBins += 1
                    level = curLevel
                    binStart = Double(bin) * radarBuffers.rd.binSize
                    levelCount = 1
                }
            }
        }
        return totalBins
    }

    static func genRadials(_ radarBuffers: ObjectMetalRadarBuffers) -> Int {
        radarBuffers.colormap.redValues.put(0, Color.red(radarBuffers.bgColor))
        radarBuffers.colormap.greenValues.put(0, Color.green(radarBuffers.bgColor))
        radarBuffers.colormap.blueValues.put(0, Color.blue(radarBuffers.bgColor))
        var totalBins = 0
        var angle = 0.0
        var angleV = 0.0
        var level: UInt8 = 0
        var levelCount = 0
        var binStart = 0.0
        var bI = 0
        var curLevel: UInt8 = 0
        var angleSin = 0.0
        var angleCos = 0.0
        var angleVSin = 0.0
        var angleVCos = 0.0
        var radarBlackHole = 0.0
        var radarBlackHoleAdd = 0.0
        if radarBuffers.rd.productCode==56 || radarBuffers.rd.productCode==19 {
            radarBlackHole = 1.0
            radarBlackHoleAdd = 0.0
        } else {
            radarBlackHole = 4.0
            radarBlackHoleAdd = 4.0
        }
        (0..<radarBuffers.rd.numberOfRadials).forEach { g in
            // since radial_start is constructed natively as opposed to read in
            // from bigendian file we have to use getFloatNatve
            angle = radarBuffers.rd.radialStartAngle.getFloatNative(g * 4)
            level = radarBuffers.rd.binWord.get(bI)
            levelCount = 0
            binStart = radarBlackHole
            if g < (radarBuffers.rd.numberOfRadials - 1) {
                angleV = radarBuffers.rd.radialStartAngle.getFloatNative(g * 4 + 4)
            } else {
                angleV = radarBuffers.rd.radialStartAngle.getFloatNative(0)
            }
            (0..<radarBuffers.rd.numberOfRangeBins).forEach { bin in
                curLevel = radarBuffers.rd.binWord.get(bI)
                bI += 1
                if curLevel == level {
                    levelCount += 1
                } else {
                    angleVCos = cos((angleV) / k180DivPi)
                    angleVSin = sin((angleV) / k180DivPi)

                    // 1
                    radarBuffers.putFloat(binStart * angleVCos)
                    radarBuffers.putFloat(binStart * angleVSin)
                    radarBuffers.putColor(radarBuffers.colormap.redValues.get(Int(level)))
                    radarBuffers.putColor(radarBuffers.colormap.greenValues.get(Int(level)))
                    radarBuffers.putColor(radarBuffers.colormap.blueValues.get(Int(level)))

                    // 2
                    radarBuffers.putFloat((binStart + radarBuffers.rd.binSize * Double(levelCount)) * angleVCos)
                    radarBuffers.putFloat((binStart + radarBuffers.rd.binSize * Double(levelCount)) * angleVSin)
                    radarBuffers.putColor(radarBuffers.colormap.redValues.get(Int(level)))
                    radarBuffers.putColor(radarBuffers.colormap.greenValues.get(Int(level)))
                    radarBuffers.putColor(radarBuffers.colormap.blueValues.get(Int(level)))

                    angleCos = cos(angle / k180DivPi)
                    angleSin = sin(angle / k180DivPi)

                    // 3
                    radarBuffers.putFloat((binStart + radarBuffers.rd.binSize * Double(levelCount)) * angleCos)
                    radarBuffers.putFloat((binStart + radarBuffers.rd.binSize * Double(levelCount)) * angleSin)
                    radarBuffers.putColor(radarBuffers.colormap.redValues.get(Int(level)))
                    radarBuffers.putColor(radarBuffers.colormap.greenValues.get(Int(level)))
                    radarBuffers.putColor(radarBuffers.colormap.blueValues.get(Int(level)))

                    // 1
                    radarBuffers.putFloat((binStart * angleVCos))
                    radarBuffers.putFloat((binStart * angleVSin))
                    radarBuffers.putColor(radarBuffers.colormap.redValues.get(Int(level)))
                    radarBuffers.putColor(radarBuffers.colormap.greenValues.get(Int(level)))
                    radarBuffers.putColor(radarBuffers.colormap.blueValues.get(Int(level)))

                    // 3
                    radarBuffers.putFloat(((binStart + (radarBuffers.rd.binSize * Double(levelCount))) * angleCos))
                    radarBuffers.putFloat(((binStart + (radarBuffers.rd.binSize * Double(levelCount))) * angleSin))
                    radarBuffers.putColor(radarBuffers.colormap.redValues.get(Int(level)))
                    radarBuffers.putColor(radarBuffers.colormap.greenValues.get(Int(level)))
                    radarBuffers.putColor(radarBuffers.colormap.blueValues.get(Int(level)))

                    // 4
                    radarBuffers.putFloat(binStart * angleCos)
                    radarBuffers.putFloat(binStart * angleSin)
                    radarBuffers.putColor(radarBuffers.colormap.redValues.get(Int(level)))
                    radarBuffers.putColor(radarBuffers.colormap.greenValues.get(Int(level)))
                    radarBuffers.putColor(radarBuffers.colormap.blueValues.get(Int(level)))

                    totalBins += 1
                    level = curLevel
                    binStart = Double(bin) * radarBuffers.rd.binSize + radarBlackHoleAdd
                    levelCount = 1
                }
            }
        }
        return totalBins
    }

    static func genTriangle(_ buffers: ObjectMetalBuffers, _ pn: ProjectionNumbers) {
        var pointX = 0.0
        var pointY = 0.0
        var pixYD = 0.0
        var pixXD = 0.0
        var test1 = 0.0
        var test2 = 0.0
        let len = Double(buffers.lenInit)
        buffers.setToPositionZero()
        buffers.metalBuffer = []
        (0..<buffers.count).forEach {
            pointX = buffers.latList[$0]
            pointY = buffers.lonList[$0]
            test1 = k180DivPi * log(tan(piDiv4 + pointX * piDiv360))
            test2 = k180DivPi * log(tan(piDiv4 + pn.xDbl * piDiv360))
            pixYD = -((test1 - test2) *  pn.oneDegreeScaleFactor) + pn.yCenterDouble
            pixXD = ( -((pointY - pn.yDbl) * pn.oneDegreeScaleFactor) + pn.xCenterDouble)

            buffers.putFloat(pixXD)
            buffers.putFloat( -pixYD)
            buffers.putColor(buffers.red)
            buffers.putColor(buffers.green)
            buffers.putColor(buffers.blue)

            buffers.putFloat(pixXD - len)
            buffers.putFloat(-pixYD + len)
            buffers.putColor(buffers.red)
            buffers.putColor(buffers.green)
            buffers.putColor(buffers.blue)

            buffers.putFloat(pixXD + len)
            buffers.putFloat( -pixYD + len)
            buffers.putColor(buffers.red)
            buffers.putColor(buffers.green)
            buffers.putColor(buffers.blue)
        }
    }

    static func genTriangleUp(_ buffers: ObjectMetalBuffers, _ pn: ProjectionNumbers) {
        var pointX = 0.0
        var pointY = 0.0
        var pixYD = 0.0
        var pixXD = 0.0
        var test1 = 0.0
        var test2 = 0.0
        buffers.setToPositionZero()
        buffers.metalBuffer = []
        let len = buffers.lenInit
        (0..<buffers.count).forEach {
            pointX = buffers.latList[$0]
            pointY = buffers.lonList[$0]
            test1 = k180DivPi * log(tan(piDiv4 + pointX * piDiv360))
            test2 = k180DivPi * log(tan(piDiv4 + pn.xDbl * piDiv360))
            pixYD = -((test1 - test2) *  pn.oneDegreeScaleFactor) + pn.yCenterDouble
            pixXD = ( -((pointY - pn.yDbl) * pn.oneDegreeScaleFactor) + pn.xCenterDouble)

            buffers.putFloat(pixXD)
            buffers.putFloat( -pixYD)
            buffers.putColor(buffers.red)
            buffers.putColor(buffers.green)
            buffers.putColor(buffers.blue)

            buffers.putFloat(pixXD - len)
            buffers.putFloat(-pixYD - len)
            buffers.putColor(buffers.red)
            buffers.putColor(buffers.green)
            buffers.putColor(buffers.blue)

            buffers.putFloat(pixXD + len)
            buffers.putFloat( -pixYD - len)
            buffers.putColor(buffers.red)
            buffers.putColor(buffers.green)
            buffers.putColor(buffers.blue)
        }
    }

    static func genCircle(_ buffers: ObjectMetalBuffers, _ pn: ProjectionNumbers) {
        var pointX = 0.0
        var pointY = 0.0
        var pixYD = 0.0
        var pixXD = 0.0
        var test1 = 0.0
        var test2 = 0.0
        let lenLocal = buffers.lenInit * 0.50
        let triangleAmountF = Double(buffers.triangleCount)
        buffers.setToPositionZero()
        buffers.metalBuffer = []
        (0..<buffers.count).forEach {
            pointX = buffers.latList[$0]
            pointY = buffers.lonList[$0]
            test1 = k180DivPi * log(tan(piDiv4 + pointX * piDiv360))
            test2 = k180DivPi * log(tan(piDiv4 + pn.xDbl * piDiv360))
            pixYD = -((test1 - test2) *  pn.oneDegreeScaleFactor) + pn.yCenterDouble
            pixXD = (-((pointY - pn.yDbl) * pn.oneDegreeScaleFactor) + pn.xCenterDouble)
            (0..<buffers.triangleCount).forEach {
                buffers.putFloat(pixXD)
                buffers.putFloat(-pixYD)
                buffers.putColor(buffers.red)
                buffers.putColor(buffers.green)
                buffers.putColor(buffers.blue)
                buffers.putFloat(pixXD + (lenLocal * cos(Double($0) *  twicePi / triangleAmountF)))
                buffers.putFloat(-pixYD + (lenLocal * sin(Double($0) * twicePi / triangleAmountF)))
                buffers.putColor(buffers.red)
                buffers.putColor(buffers.green)
                buffers.putColor(buffers.blue)
                buffers.putFloat(pixXD + (lenLocal * cos((Double($0)+1) *  twicePi / triangleAmountF)))
                buffers.putFloat(-pixYD + (lenLocal * sin((Double($0)+1) * twicePi / triangleAmountF)))
                buffers.putColor(buffers.red)
                buffers.putColor(buffers.green)
                buffers.putColor(buffers.blue)
            }
        }
    }

    static func genCircleWithColor(_ buffers: ObjectMetalBuffers, _ pn: ProjectionNumbers) {
        var pointX = 0.0
        var pointY = 0.0
        var pixYD = 0.0
        var pixXD = 0.0
        //var ixCount: UInt16 = 0
        var test1 = 0.0
        var test2 = 0.0
        let lenLocal = buffers.lenInit * 0.50
        let triangleAmountF = Double(buffers.triangleCount)
        //var col = [UInt8]()
        buffers.setToPositionZero()
        buffers.metalBuffer = []
        var red: UInt8 = 0
        var blue: UInt8 = 0
        var green: UInt8 = 0
        (0..<buffers.count).forEach {
            switch buffers.type.string {
            case "WIND_BARB_CIRCLE":
                red = Color.red(Int(buffers.colorIntArray[$0]))
                green = Color.green(Int(buffers.colorIntArray[$0]))
                blue = Color.blue(Int(buffers.colorIntArray[$0]))
            default:
                red = buffers.red
                green = buffers.green
                blue = buffers.blue
            }
            pointX = buffers.latList[$0]
            pointY = buffers.lonList[$0]
            test1 = k180DivPi * log(tan(piDiv4 + pointX * piDiv360))
            test2 = k180DivPi * log(tan(piDiv4 + pn.xDbl * piDiv360))
            pixYD = -((test1 - test2) *  pn.oneDegreeScaleFactor) + pn.yCenterDouble
            pixXD = (-((pointY - pn.yDbl) * pn.oneDegreeScaleFactor) + pn.xCenterDouble)
            (0..<buffers.triangleCount).forEach {
                buffers.putFloat(pixXD)
                buffers.putFloat(-pixYD)
                buffers.putColor(red)
                buffers.putColor(green)
                buffers.putColor(blue)

                buffers.putFloat(pixXD + (lenLocal * cos(Double($0) *  twicePi / triangleAmountF)))
                buffers.putFloat(-pixYD + (lenLocal * sin(Double($0) * twicePi / triangleAmountF)))
                buffers.putColor(red)
                buffers.putColor(green)
                buffers.putColor(blue)

                buffers.putFloat(pixXD + (lenLocal * cos((Double($0)+1) *  twicePi / triangleAmountF)))
                buffers.putFloat(-pixYD + (lenLocal * sin((Double($0)+1) * twicePi / triangleAmountF)))
                buffers.putColor(red)
                buffers.putColor(green)
                buffers.putColor(blue)
            }
        }
    }

    static func genCircleLocdot(_ buffers: ObjectMetalBuffers, _ pn: ProjectionNumbers, _ location: LatLon) {
        buffers.setToPositionZero()
        var pixYD = 0.0
        var pixXD = 0.0
        var test1 = 0.0
        var test2 = 0.0
        buffers.count = buffers.triangleCount * 4
        let lenLocal = buffers.lenInit * 2.0
        let triangleAmountF = Double(buffers.triangleCount)
        buffers.metalBuffer = []
        test1 = k180DivPi * log(tan(piDiv4 + location.lat * piDiv360))
        test2 = k180DivPi * log(tan(piDiv4 + pn.xDbl * piDiv360))
        pixYD = -((test1 - test2) *  pn.oneDegreeScaleFactor) + pn.yCenterDouble
        pixXD = (-((location.lon - pn.yDbl) * pn.oneDegreeScaleFactor) + pn.xCenterDouble)
        (0..<buffers.triangleCount).forEach {
            buffers.putFloat(pixXD + (lenLocal*cos(Double($0) * twicePi / triangleAmountF)))
            buffers.putFloat(-pixYD + (lenLocal*sin(Double($0) * twicePi / triangleAmountF)))
            buffers.putColor(buffers.red)
            buffers.putColor(buffers.green)
            buffers.putColor(buffers.blue)
            buffers.putFloat(pixXD + (lenLocal*cos((Double($0) + 1) * twicePi / triangleAmountF)))
            buffers.putFloat(-pixYD + (lenLocal*sin((Double($0) + 1) * twicePi / triangleAmountF)))
            buffers.putColor(buffers.red)
            buffers.putColor(buffers.green)
            buffers.putColor(buffers.blue)
        }
    }

    static func colorGen (_ colorBuff: MemoryBuffer, _ len: Int, _ colArr: [UInt8]) {
        (0..<len).forEach { _ in
            colorBuff.put(colArr[0])
            colorBuff.put(colArr[1])
            colorBuff.put(colArr[2])
        }
    }

    static func colorGen (_ buffers: ObjectOglBuffers, _ len: Int) {
        (0..<len).forEach { _ in
            buffers.putColor(buffers.red)
            buffers.putColor(buffers.green)
            buffers.putColor(buffers.blue)
        }
    }
}
