/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityWXMetalPerfL3FourBit {

    static func decodeRadial(_ radarBuffers: ObjectMetalRadarBuffers) -> UInt16 {
        let dis = UtilityIO.readFileToByteBuffer(radarBuffers.fileName)
        if dis.capacity > 0 {
            dis.skipBytes(170)
            let numberOfRangeBins = dis.getUnsignedShort()
            dis.skipBytes(6)
            _ = dis.getUnsignedShort()
            var numberOfRleHalfWords = [UInt16]()
            radarBuffers.rd.radialStartAngle.position = 0
            (0..<360).forEach { radial in
                numberOfRleHalfWords.append(dis.getUnsignedShort())
                radarBuffers.rd.radialStartAngle.putFloat((450.0 - Float((dis.getUnsignedShort() / 10))))
                dis.skipBytes(2)
                (0..<numberOfRleHalfWords[radial] * 2).forEach { _ in
                    let bin = Int(dis.get())
                    let numOfBins = Int(bin >> 4)
                    (0..<numOfBins).forEach { _ in radarBuffers.rd.binWord.put(UInt8(bin % 16)) }
                }
            }
            return numberOfRangeBins
        } else {
            return UInt16(230)
        }
    }

    static func decodeRaster(_ radarBuffers: ObjectMetalRadarBuffers) -> UInt16 {
        let dis = UtilityIO.readFileToByteBuffer(radarBuffers.fileName)
        if dis.capacity > 0 {
            dis.skipBytes(172)
            /*let iCoordinateStart = dis.getUnsignedShort()
            let jCoordinateStart = dis.getUnsignedShort()
            let xScaleInt = dis.getUnsignedShort()
            let xScaleFractional = dis.getUnsignedShort()
            let yScaleInt = dis.getUnsignedShort()
            let yScaleFractional = dis.getUnsignedShort()
            let numberOfRows = dis.getUnsignedShort()
            let packingDescriptor = dis.getUnsignedShort()*/
            _ = dis.getUnsignedShort()
            _ = dis.getUnsignedShort()
            _ = dis.getUnsignedShort()
            _ = dis.getUnsignedShort()
            _ = dis.getUnsignedShort()
            _ = dis.getUnsignedShort()
            let numberOfRows = dis.getUnsignedShort()
            _ = dis.getUnsignedShort()
            // 464 rows in NCR
            // 232 rows in NCZ
            (0..<numberOfRows).forEach { _ in
                let numberOfBytes = dis.getUnsignedShort()
                (0..<numberOfBytes).forEach { _ in
                    let bin = Int(dis.get())
                    let numOfBins = Int(bin >> 4)
                    (0..<numOfBins).forEach { _ in
                        let color = UInt8(bin % 16)
                        radarBuffers.rd.binWord.put(color)
                    }
                }
            }
        }
        return 0
    }
}
