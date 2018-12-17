/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

class UtilityWXOGLPerf {

    static let k180DivPi = 180.0 / Double.pi
    static let piDiv4 = Double.pi / 4.0
    static let piDiv360 = Double.pi / 360.0
    static let twicePi = 2.0 * Double.pi

    static func decode8BitAndGenRadials(_ radarBuffers: ObjectOglRadarBuffers) -> Int {
        var totalBins = 0
        let disFirst = UtilityIO.readFiletoByteByffer(radarBuffers.fileName)
        if disFirst.capacity == 0 {
            return 0
        }
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
        let numRadials = 360
        (0..<numRadials).forEach { radial in
            numberOfRleHalfwords = dis2.getUnsignedShort()
            angle = (450.0 - (Double(Int(dis2.getUnsignedShort())) / 10.0))
            dis2.skipBytes(2)
            if radial < numRadials - 1 {
                dis2.mark(dis2.position)
                dis2.skipBytes(Int(numberOfRleHalfwords) + 2)
                angleNext = (450.0 - (Double(Int(dis2.getUnsignedShort())) / 10.0))
                dis2.reset()
            }
            level = 0
            levelCount = 0
            binStart = radarBuffers.rd.binSize
            if radial == 0 {
                angle0 = angle
            }
            if radial < numRadials - 1 {
                angleV = angleNext
            } else {
                angleV = angle0
            }
            (0..<numberOfRleHalfwords).forEach { bin in
                curLevel = dis2.get()
                if bin == 0 {
                    level = curLevel
                }
                if curLevel == level {
                    levelCount += 1
                } else {
                    angleVCos = cos((angleV)/k180DivPi)
                    angleVSin = sin((angleV)/k180DivPi)
                    radarBuffers.putFloat(binStart * angleVCos)
                    radarBuffers.putFloat(binStart * angleVSin)
                    radarBuffers.putFloat((binStart + (radarBuffers.rd.binSize * Double(levelCount))) * angleVCos)
                    radarBuffers.putFloat((binStart + (radarBuffers.rd.binSize * Double(levelCount))) * angleVSin)
                    angleCos = cos(angle/k180DivPi)
                    angleSin = sin(angle/k180DivPi)
                    radarBuffers.putFloat((binStart + (radarBuffers.rd.binSize * Double(levelCount))) * angleCos)
                    radarBuffers.putFloat((binStart + (radarBuffers.rd.binSize * Double(levelCount))) * angleSin)
                    radarBuffers.putFloat(binStart * angleCos)
                    radarBuffers.putFloat(binStart * angleSin)
                    (0...3).forEach { _ in
                        radarBuffers.putColor(radarBuffers.colormap.redValues.get(Int(level)))
                        radarBuffers.putColor(radarBuffers.colormap.greenValues.get(Int(level)))
                        radarBuffers.putColor(radarBuffers.colormap.blueValues.get(Int(level)))
                    }
                    totalBins += 1
                    level = curLevel
                    binStart = Double(bin) * radarBuffers.rd.binSize
                    levelCount = 1
                }
            }
        }
        return totalBins
    }

    static func genRadials(_ radarBuffers: ObjectOglRadarBuffers) -> Int {
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
        if radarBuffers.rd.productCode == 56 || radarBuffers.rd.productCode == 19 {
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
                    radarBuffers.putFloat(binStart * angleVCos)
                    radarBuffers.putFloat(binStart * angleVSin)
                    radarBuffers.putFloat((binStart + radarBuffers.rd.binSize * Double(levelCount)) * angleVCos)
                    radarBuffers.putFloat((binStart + radarBuffers.rd.binSize * Double(levelCount)) * angleVSin)
                    angleCos = cos(angle / k180DivPi)
                    angleSin = sin(angle / k180DivPi)
                    radarBuffers.putFloat((binStart + radarBuffers.rd.binSize * Double(levelCount)) * angleCos)
                    radarBuffers.putFloat((binStart + radarBuffers.rd.binSize * Double(levelCount)) * angleSin)
                    radarBuffers.putFloat(binStart * angleCos)
                    radarBuffers.putFloat(binStart * angleSin)
                    (0...3).forEach { _ in
                        radarBuffers.putColor(radarBuffers.colormap.redValues.get(Int(level)))
                        radarBuffers.putColor(radarBuffers.colormap.greenValues.get(Int(level)))
                        radarBuffers.putColor(radarBuffers.colormap.blueValues.get(Int(level)))
                    }
                    totalBins += 1
                    level = curLevel
                    binStart = Double(bin) * radarBuffers.rd.binSize + radarBlackHoleAdd
                    levelCount = 1
                }
            }
        }
        return totalBins
    }

    static func genIndex(_ indexBuff: MemoryBuffer) {
        let len = 15000
        let breakSize = 15000
        var incr: UInt16 = 0
        var remainder: Int
        var chunkCount = 1
        var breakSizeLocal = breakSize
        if len < breakSizeLocal {
            breakSizeLocal = len
            remainder = breakSizeLocal
        } else {
            chunkCount = len / breakSizeLocal
            remainder = len - breakSizeLocal * chunkCount
            chunkCount += 1
        }
        (0..<chunkCount).forEach { chunkIndex in
            incr = 0
            if chunkIndex == (chunkCount - 1) {
                breakSizeLocal = remainder
            }
            (0..<breakSizeLocal).forEach { _ in
                indexBuff.putShort(incr)
                indexBuff.putShort(1 + incr)
                indexBuff.putShort(2 + incr)
                indexBuff.putShort(incr)
                indexBuff.putShort(2 + incr)
                indexBuff.putShort(3 + incr)
                incr += 4
            }
        }
    }

    static func genIndexLine(_ indexBuff: MemoryBuffer) {
        let len = 30000 * 4
        let breakSize = 30000 * 2
        var incr: UInt16 = 0
        var remainder: Int
        var chunkCount = 1
        let totalBins: Int = len / 4
        var breakSizeLocal = breakSize
        if totalBins < breakSizeLocal {
            breakSizeLocal = totalBins
            remainder = breakSizeLocal
        } else {
            chunkCount = totalBins / breakSizeLocal
            remainder = totalBins - breakSizeLocal*chunkCount
            chunkCount += 1
        }
        indexBuff.position = 0
        (0..<chunkCount).forEach { chunkIndex in
            incr = 0
            if chunkIndex == (chunkCount - 1) {
                breakSizeLocal = remainder
            }
            (0..<breakSizeLocal).forEach { _ in
                indexBuff.putShort(incr)
                indexBuff.putShort(1 + incr)
                incr += 2
            }
        }
    }

    static func genTriangle(_ buffers: ObjectOglBuffers, _ pn: ProjectionNumbers) {
        var pointX = 0.0
        var pointY = 0.0
        var pixYD = 0.0
        var pixXD = 0.0
        var ixCount: UInt16 = 0
        var test1 = 0.0
        var test2 = 0.0
        let len = Double(buffers.lenInit)
        buffers.setToPositionZero()
        (0..<buffers.count).forEach {
            pointX = buffers.latList[$0]
            pointY = buffers.lonList[$0]
            test1 = k180DivPi * log(tan(piDiv4 + pointX * piDiv360))
            test2 = k180DivPi * log(tan(piDiv4 + pn.xDbl * piDiv360))
            pixYD = -((test1 - test2) *  pn.oneDegreeScaleFactor) + pn.yCenterDouble
            pixXD = ( -((pointY - pn.yDbl) * pn.oneDegreeScaleFactor) + pn.xCenterDouble)
            buffers.putFloat(pixXD)
            buffers.putFloat( -pixYD)
            buffers.putFloat(pixXD - len)
            buffers.putFloat(-pixYD + len)
            buffers.putFloat(pixXD + len)
            buffers.putFloat( -pixYD + len)
            buffers.putIndex(ixCount)
            buffers.putIndex(ixCount+1)
            buffers.putIndex(ixCount+2)
            ixCount +=  3
            (0...2).forEach { _ in
                buffers.putColor(buffers.red)
                buffers.putColor(buffers.green)
                buffers.putColor(buffers.blue)
            }
        }
    }

    static func genTriangleUp(_ buffers: ObjectOglBuffers, _ pn: ProjectionNumbers) {
        var pointX = 0.0
        var pointY = 0.0
        var pixYD = 0.0
        var pixXD = 0.0
        var ixCount: UInt16 = 0
        var test1 = 0.0
        var test2 = 0.0
        buffers.setToPositionZero()
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
            buffers.putFloat(pixXD - len)
            buffers.putFloat(-pixYD - len)
            buffers.putFloat(pixXD + len)
            buffers.putFloat( -pixYD - len)
            buffers.putIndex(ixCount)
            buffers.putIndex(ixCount+1)
            buffers.putIndex(ixCount+2)
            ixCount +=  3
            (0...2).forEach { _ in
                buffers.putColor(buffers.red)
                buffers.putColor(buffers.green)
                buffers.putColor(buffers.blue)
            }
        }
    }

    static func genCircle(_ buffers: ObjectOglBuffers, _ pn: ProjectionNumbers) {
        var pointX = 0.0
        var pointY = 0.0
        var pixYD = 0.0
        var pixXD = 0.0
        var ixCount: UInt16 = 0
        var test1 = 0.0
        var test2 = 0.0
        let lenLocal = buffers.lenInit * 0.50
        let triangleAmountF = Double(buffers.triangleCount)
        buffers.setToPositionZero()
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
                buffers.putFloat(pixXD + (lenLocal * cos(Double($0) *  twicePi / triangleAmountF)))
                buffers.putFloat(-pixYD + (lenLocal * sin(Double($0) * twicePi / triangleAmountF)))
                buffers.putFloat(pixXD + (lenLocal * cos((Double($0)+1) *  twicePi / triangleAmountF)))
                buffers.putFloat(-pixYD + (lenLocal * sin((Double($0)+1) * twicePi / triangleAmountF)))
                buffers.putIndex(ixCount)
                buffers.putIndex(ixCount + 1)
                buffers.putIndex(ixCount + 2)
                ixCount += 3
                (0...2).forEach { _ in
                    buffers.putColor(buffers.red)
                    buffers.putColor(buffers.green)
                    buffers.putColor(buffers.blue)
                }
            }
        }
    }

    static func genCircleWithColor(_ buffers: ObjectOglBuffers, _ pn: ProjectionNumbers) {
        var pointX = 0.0
        var pointY = 0.0
        var pixYD = 0.0
        var pixXD = 0.0
        var ixCount: UInt16 = 0
        var test1 = 0.0
        var test2 = 0.0
        let lenLocal = buffers.lenInit * 0.50
        let triangleAmountF = Double(buffers.triangleCount)
        var col = [UInt8]()
        buffers.setToPositionZero()
        (0..<buffers.count).forEach {
            col = []
            col.append(Color.red(Int(buffers.colorIntArray[$0])))
            col.append(Color.green(Int(buffers.colorIntArray[$0])))
            col.append(Color.blue(Int(buffers.colorIntArray[$0])))
            pointX = buffers.latList[$0]
            pointY = buffers.lonList[$0]
            test1 = k180DivPi * log(tan(piDiv4 + pointX * piDiv360))
            test2 = k180DivPi * log(tan(piDiv4 + pn.xDbl * piDiv360))
            pixYD = -((test1 - test2) *  pn.oneDegreeScaleFactor) + pn.yCenterDouble
            pixXD = (-((pointY - pn.yDbl) * pn.oneDegreeScaleFactor) + pn.xCenterDouble)
            (0..<buffers.triangleCount).forEach {
                buffers.putFloat(pixXD)
                buffers.putFloat(-pixYD)
                buffers.putFloat(pixXD + (lenLocal * cos(Double($0) *  twicePi / triangleAmountF)))
                buffers.putFloat(-pixYD + (lenLocal * sin(Double($0) * twicePi / triangleAmountF)))
                buffers.putFloat(pixXD + (lenLocal * cos((Double($0)+1) *  twicePi / triangleAmountF)))
                buffers.putFloat(-pixYD + (lenLocal * sin((Double($0)+1) * twicePi / triangleAmountF)))
                buffers.putIndex(ixCount)
                buffers.putIndex((ixCount + 1))
                buffers.putIndex((ixCount + 2))
                ixCount += 3
                (0...2).forEach { _ in
                    buffers.putColor(col[0])
                    buffers.putColor(col[1])
                    buffers.putColor(col[2])
                }
            }
        }
    }

    static func genCircleLocdot(_ buffers: ObjectOglBuffers, _ pn: ProjectionNumbers, _ location: LatLon) {
        buffers.setToPositionZero()
        var pixYD = 0.0
        var pixXD = 0.0
        var ixCount: UInt16 = 0
        var test1 = 0.0
        var test2 = 0.0
        let lenLocal = buffers.lenInit * 2.0
        let triangleAmountF = Double(buffers.triangleCount)
        test1 = k180DivPi * log(tan(piDiv4 + location.lat * piDiv360))
        test2 = k180DivPi * log(tan(piDiv4 + pn.xDbl * piDiv360))
        pixYD = -((test1 - test2) *  pn.oneDegreeScaleFactor) + pn.yCenterDouble
        pixXD = (-((location.lon - pn.yDbl) * pn.oneDegreeScaleFactor) + pn.xCenterDouble)
        (0..<buffers.triangleCount).forEach {
            buffers.putFloat(pixXD + (lenLocal*cos(Double($0) * twicePi / triangleAmountF)))
            buffers.putFloat(-pixYD + (lenLocal*sin(Double($0) * twicePi / triangleAmountF)))
            buffers.putFloat(pixXD + (lenLocal*cos((Double($0) + 1) * twicePi / triangleAmountF)))
            buffers.putFloat(-pixYD + (lenLocal*sin((Double($0) + 1) * twicePi / triangleAmountF)))
            buffers.putIndex(ixCount)
            buffers.putIndex(ixCount + 1)
            ixCount += 2
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
