/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

class UtilityWXMetalPerfL3FourBit {

    static func decodeRadial(_ radarBuffers: ObjectMetalRadarBuffers) -> UInt16 {
        let dis = UtilityIO.readFiletoByteByffer(radarBuffers.fileName)
        var numberOfRangeBins: UInt16 = 0
        if dis.capacity > 0 {
            dis.skipBytes(170)
            numberOfRangeBins = dis.getUnsignedShort()
            dis.skipBytes(6)
            _ = dis.getUnsignedShort()
            var numberOfRleHalfwords = [UInt16]()
            radarBuffers.rd.radialStartAngle.position = 0
            var numOfBins = 0
            let radials = 360
            (0..<radials).forEach { radial in
                numberOfRleHalfwords.append(dis.getUnsignedShort())
                radarBuffers.rd.radialStartAngle.putFloat((450.0 - Float((dis.getUnsignedShort() / 10))))
                dis.skipBytes(2)
                (0..<numberOfRleHalfwords[radial] * 2).forEach {_ in
                    let bin = Int(dis.get())
                    numOfBins = Int(bin >> 4)
                    (0..<numOfBins).forEach { _ in
                        radarBuffers.rd.binWord.put(UInt8(bin % 16))}
                }
            }
        } else {
            numberOfRangeBins = 230
        }
        return numberOfRangeBins
    }

    static func decodeRaster(_ radarBuffers: ObjectMetalRadarBuffers) -> UInt16 {
        let dis = UtilityIO.readFiletoByteByffer(radarBuffers.fileName)
        var numberOfRangeBins: UInt16 = 0
        if dis.capacity > 0 {
            
            /*dis.skipBytes(170)
            numberOfRangeBins = dis.getUnsignedShort()
            dis.skipBytes(6)
            _ = dis.getUnsignedShort()
            var numberOfRleHalfwords = [UInt16]()
            radarBuffers.rd.radialStartAngle.position = 0
            var numOfBins = 0
            let radials = 360
            (0..<radials).forEach { radial in
                numberOfRleHalfwords.append(dis.getUnsignedShort())
                radarBuffers.rd.radialStartAngle.putFloat((450.0 - Float((dis.getUnsignedShort() / 10))))
                dis.skipBytes(2)
                (0..<numberOfRleHalfwords[radial] * 2).forEach {_ in
                    let bin = Int(dis.get())
                    numOfBins = Int(bin >> 4)
                    (0..<numOfBins).forEach { _ in
                        radarBuffers.rd.binWord.put(UInt8(bin % 16))}
                }
            }*/
            
            dis.skipBytes(172)
            let iCoordinateStart = dis.getUnsignedShort()
            let jCoordinateStart = dis.getUnsignedShort()
            let xScaleInt = dis.getUnsignedShort()
            let xScaleFractional = dis.getUnsignedShort()
            let yScaleInt = dis.getUnsignedShort()
            let yScaleFractional = dis.getUnsignedShort()
            let numberOfRows = dis.getUnsignedShort()
            let packingDescriptor = dis.getUnsignedShort()
            // 464 rows in NCR
            // 232 rows in NCZ
            var s = 0
            //var bin: Short
            var numOfBins = 0
            var u = 0
            var totalPerRow = 0
            (0..<numberOfRows).forEach { radial in
                let numberOfBytes = dis.getUnsignedShort()
                totalPerRow = 0
                s = 0
                u = 0
                while s < numberOfBytes {
                    let bin = Int(dis.get())
                    numOfBins = Int(bin >> 4)
                    u = 0
                    while u < numOfBins {
                        //binWord.put((bin % 16).toByte())
                        let color = UInt8(bin % 16)
                        radarBuffers.rd.binWord.put(color)
                        //print(color)
                        u += 1
                        totalPerRow += 1
                    }
                    s += 1
                }
            }
        } else {
            numberOfRangeBins = 230
        }
        return numberOfRangeBins
    }
}
