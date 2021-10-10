// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import Foundation

final class UtilityWXMetalPerf {
    
    private static let k180DivPi = 180.0 / Double.pi
    private static let piDiv4 = Double.pi / 4.0
    private static let piDiv360 = Double.pi / 360.0
    private static let twicePi = 2.0 * Double.pi
    
    static func decode8BitAndGenRadials(_ radarBuffers: ObjectMetalRadarBuffers, _ fileStorage: FileStorage) -> Int {
        var totalBins = 0
        let disFirst = fileStorage.memoryBuffer
        disFirst.position = 0
        if disFirst.capacity == 0 {
            return 0
        }
        while disFirst.getShort() != -1 {}
        disFirst.skipBytes(100)
        let dis2 = UtilityIO.uncompress(disFirst)
        dis2.skipBytes(30)
        var numberOfRleHalfWords: UInt16 = 0
        radarBuffers.colorMap.redValues.put(0, Color.red(radarBuffers.bgColor))
        radarBuffers.colorMap.greenValues.put(0, Color.green(radarBuffers.bgColor))
        radarBuffers.colorMap.blueValues.put(0, Color.blue(radarBuffers.bgColor))
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
        let numberOfRadials = 360
        (0..<numberOfRadials).forEach { radial in
            numberOfRleHalfWords = dis2.getUnsignedShort()
            angle = (450.0 - (Double(Int(dis2.getUnsignedShort())) / 10.0))
            // print(angle)
            dis2.skipBytes(2)
            if radial < numberOfRadials - 1 {
                dis2.mark(dis2.position)
                dis2.skipBytes(Int(numberOfRleHalfWords) + 2)
                angleNext = (450.0 - (Double(Int(dis2.getUnsignedShort())) / 10.0))
                dis2.reset()
            }
            level = 0
            levelCount = 0
            binStart = radarBuffers.rd.binSize
            if radial == 0 {
                angle0 = angle
            }
            if radial < numberOfRadials - 1 {
                angleV = angleNext
            } else {
                angleV = angle0
            }
            (0..<numberOfRleHalfWords).forEach { bin in
                curLevel = dis2.get()
                if bin == 0 {
                    level = curLevel
                }
                if curLevel == level {
                    levelCount += 1
                } else {
                    angleVCos = cos((angleV)/k180DivPi)
                    angleVSin = sin((angleV)/k180DivPi)
                    // 1
                    radarBuffers.putFloat((binStart * angleVCos))
                    radarBuffers.putFloat((binStart * angleVSin))
                    radarBuffers.putColorsByIndex(level)
                    // 2
                    radarBuffers.putFloat(((binStart + (radarBuffers.rd.binSize * Double(levelCount))) * angleVCos))
                    radarBuffers.putFloat(((binStart + (radarBuffers.rd.binSize * Double(levelCount))) * angleVSin))
                    radarBuffers.putColorsByIndex(level)
                    
                    angleCos = cos(angle/k180DivPi)
                    angleSin = sin(angle/k180DivPi)
                    // 3
                    radarBuffers.putFloat(((binStart + (radarBuffers.rd.binSize * Double(levelCount))) * angleCos))
                    radarBuffers.putFloat(((binStart + (radarBuffers.rd.binSize * Double(levelCount))) * angleSin))
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
                    radarBuffers.putFloat((binStart * angleCos))
                    radarBuffers.putFloat((binStart * angleSin))
                    radarBuffers.putColorsByIndex(level)
                    
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
        radarBuffers.colorMap.redValues.put(0, Color.red(radarBuffers.bgColor))
        radarBuffers.colorMap.greenValues.put(0, Color.green(radarBuffers.bgColor))
        radarBuffers.colorMap.blueValues.put(0, Color.blue(radarBuffers.bgColor))
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
        let radarBlackHole: Double
        let radarBlackHoleAdd: Double
        switch radarBuffers.rd.productCode {
        case 56, 19, 181, 78, 80:
            radarBlackHole = 1.0
            radarBlackHoleAdd = 0.0
        default:
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
            if g < radarBuffers.rd.numberOfRadials - 1 {
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
                    radarBuffers.putColorsByIndex(level)
                    
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
            pixYD = -((test1 - test2) * pn.oneDegreeScaleFactor) + pn.yCenterDouble
            pixXD = -((pointY - pn.yDbl) * pn.oneDegreeScaleFactor) + pn.xCenterDouble
            buffers.putFloat(pixXD)
            buffers.putFloat(-pixYD)
            buffers.putColors()
            buffers.putFloat(pixXD - len)
            buffers.putFloat(-pixYD + len)
            buffers.putColors()
            buffers.putFloat(pixXD + len)
            buffers.putFloat(-pixYD + len)
            buffers.putColors()
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
            pixYD = -((test1 - test2) * pn.oneDegreeScaleFactor) + pn.yCenterDouble
            pixXD = -((pointY - pn.yDbl) * pn.oneDegreeScaleFactor) + pn.xCenterDouble
            buffers.putFloat(pixXD)
            buffers.putFloat(-pixYD)
            buffers.putColors()
            buffers.putFloat(pixXD - len)
            buffers.putFloat(-pixYD - len)
            buffers.putColors()
            buffers.putFloat(pixXD + len)
            buffers.putFloat(-pixYD - len)
            buffers.putColors()
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
        let triangleAmount = Double(buffers.triangleCount)
        buffers.setToPositionZero()
        buffers.metalBuffer = []
        (0..<buffers.count).forEach {
            pointX = buffers.latList[$0]
            pointY = buffers.lonList[$0]
            test1 = k180DivPi * log(tan(piDiv4 + pointX * piDiv360))
            test2 = k180DivPi * log(tan(piDiv4 + pn.xDbl * piDiv360))
            pixYD = -((test1 - test2) * pn.oneDegreeScaleFactor) + pn.yCenterDouble
            pixXD = -((pointY - pn.yDbl) * pn.oneDegreeScaleFactor) + pn.xCenterDouble
            (0..<buffers.triangleCount).forEach {
                buffers.putFloat(pixXD)
                buffers.putFloat(-pixYD)
                buffers.putColors()
                buffers.putFloat(pixXD + (lenLocal * cos(Double($0) * twicePi / triangleAmount)))
                buffers.putFloat(-pixYD + (lenLocal * sin(Double($0) * twicePi / triangleAmount)))
                buffers.putColors()
                buffers.putFloat(pixXD + (lenLocal * cos((Double($0) + 1) * twicePi / triangleAmount)))
                buffers.putFloat(-pixYD + (lenLocal * sin((Double($0) + 1) * twicePi / triangleAmount)))
                buffers.putColors()
            }
        }
    }
    
    static func genCircleWithColor(_ buffers: ObjectMetalBuffers, _ pn: ProjectionNumbers) {
        var pointX = 0.0
        var pointY = 0.0
        var pixYD = 0.0
        var pixXD = 0.0
        var test1 = 0.0
        var test2 = 0.0
        let lenLocal = buffers.lenInit * 0.50
        let triangleAmount = Double(buffers.triangleCount)
        buffers.setToPositionZero()
        buffers.metalBuffer = []
        (0..<buffers.count).forEach {
            if buffers.typeEnum == .WIND_BARB_CIRCLE {
                buffers.red = Color.red(Int(buffers.colorIntArray[$0]))
                buffers.green = Color.green(Int(buffers.colorIntArray[$0]))
                buffers.blue = Color.blue(Int(buffers.colorIntArray[$0]))
            }
            pointX = buffers.latList[$0]
            pointY = buffers.lonList[$0]
            test1 = k180DivPi * log(tan(piDiv4 + pointX * piDiv360))
            test2 = k180DivPi * log(tan(piDiv4 + pn.xDbl * piDiv360))
            pixYD = -((test1 - test2) * pn.oneDegreeScaleFactor) + pn.yCenterDouble
            pixXD = -((pointY - pn.yDbl) * pn.oneDegreeScaleFactor) + pn.xCenterDouble
            (0..<buffers.triangleCount).forEach {
                buffers.putFloat(pixXD)
                buffers.putFloat(-pixYD)
                buffers.putColors()
                buffers.putFloat(pixXD + (lenLocal * cos(Double($0) * twicePi / triangleAmount)))
                buffers.putFloat(-pixYD + (lenLocal * sin(Double($0) * twicePi / triangleAmount)))
                buffers.putColors()
                buffers.putFloat(pixXD + (lenLocal * cos((Double($0) + 1) * twicePi / triangleAmount)))
                buffers.putFloat(-pixYD + (lenLocal * sin((Double($0) + 1) * twicePi / triangleAmount)))
                buffers.putColors()
            }
        }
    }
    
    static func genCircleLocationDot(_ buffers: ObjectMetalBuffers, _ pn: ProjectionNumbers, _ location: LatLon) {
        buffers.setToPositionZero()
        buffers.count = buffers.triangleCount * 4
        let lenLocal = buffers.lenInit * 2.0
        let triangleAmount = Double(buffers.triangleCount)
        buffers.metalBuffer = []
        let test1 = k180DivPi * log(tan(piDiv4 + location.lat * piDiv360))
        let test2 = k180DivPi * log(tan(piDiv4 + pn.xDbl * piDiv360))
        let pixYD = -((test1 - test2) * pn.oneDegreeScaleFactor) + pn.yCenterDouble
        let pixXD = -((location.lon - pn.yDbl) * pn.oneDegreeScaleFactor) + pn.xCenterDouble
        (0..<buffers.triangleCount).forEach {
            buffers.putFloat(pixXD + (lenLocal * cos(Double($0) * twicePi / triangleAmount)))
            buffers.putFloat(-pixYD + (lenLocal * sin(Double($0) * twicePi / triangleAmount)))
            buffers.putColors()
            buffers.putFloat(pixXD + (lenLocal * cos((Double($0) + 1) * twicePi / triangleAmount)))
            buffers.putFloat(-pixYD + (lenLocal * sin((Double($0) + 1) * twicePi / triangleAmount)))
            buffers.putColors()
        }
    }
}
