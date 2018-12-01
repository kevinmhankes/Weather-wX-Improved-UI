/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

class UtilityWXMetalPerfL3FourBit {

    static func decode4Bit(_ radarBuffers: ObjectMetalRadarBuffers) -> UInt16 {
        let dis = UtilityIO.readFiletoByteByffer(radarBuffers.fileName)
        var numberOfRangeBins: UInt16 = 0
        if dis.capacity>0 {
            dis.skipBytes(170)
            numberOfRangeBins = dis.getUnsignedShort()
            dis.skipBytes(6)
            _ = dis.getUnsignedShort()
            var numberOfRleHalfwords = [UInt16]()
            radarBuffers.rd.radialStartAngle.position = 0
            var numOfBins = 0
            (0..<360).forEach { radial in
                numberOfRleHalfwords.append(dis.getUnsignedShort())
                radarBuffers.rd.radialStartAngle.putFloat((450.0 - Float((dis.getUnsignedShort() / 10))))
                dis.skipBytes(2)
                (0..<numberOfRleHalfwords[radial] * 2).forEach {_ in
                    let bin = Int(dis.get())
                    numOfBins = Int(bin >> 4)
                    (0..<numOfBins).forEach { _ in radarBuffers.rd.binWord.put(UInt8(bin % 16))}
                }
            }
        }
        return numberOfRangeBins
    }
}
