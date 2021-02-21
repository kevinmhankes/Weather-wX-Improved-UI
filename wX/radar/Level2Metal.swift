/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class Level2Metal {

    private static let reflectivityHigh = 5
    private static let velocityHigh = 6
    private static let fileHeaderSize = 24
    private static var first = Level2Record()
    private static var vcp: Int16 = 0

    static func decode(_ radarBuffers: ObjectMetalRadarBuffers, _ days: MemoryBuffer, _ msecs: MemoryBuffer) {
        let fileName = radarBuffers.fileName + ".decomp" + radarBuffers.rd.index
        let velocityProd = (radarBuffers.rd.productCode == 154)
        let dis2 = UtilityIO.readFileToByteBuffer(fileName)
        if dis2.capacity > fileHeaderSize {
            var highReflectivity = [Level2Record]()
            var highVelocity = [Level2Record]()
            var messageOffset31: CLong = 0
            var recno = 0
            var record = Level2Record()
            while true {
                if let l2record = Level2Record.factory(dis2, recno, messageOffset31) {
                    record = l2record
                } else {
                    break
                }
                recno += 1
                if record.messageType == 31 { messageOffset31 += CLong(record.messageSize * 2 + 12 - 2432) }
                if record.messageType != 1 && record.messageType != 31 { continue }
                if vcp == 0 { vcp = record.vcp }
                if record.messageType == 31 {
                    if record.hasHighResREFData { highReflectivity.append(record) }
                    if record.hasHighResVELData { highVelocity.append(record) }
                }
            }
            var numberOfRadials = 720
            let rIdx = 1
            days.position = 0
            days.putSignedShort(Int16(highReflectivity[rIdx].dataJulianDate))
            msecs.position = 0
            msecs.putInt(Int32(highReflectivity[rIdx].dataMsecs))
            if numberOfRadials > highReflectivity.count { numberOfRadials = highReflectivity.count }
            if !velocityProd {
                (0..<numberOfRadials).forEach {
                    if highReflectivity[$0].elevationNum == 1 {
                        radarBuffers.rd.radialStartAngle.putFloat(450.0 - highReflectivity[$0].azimuth)
                        highReflectivity[$0].readData(dis2, reflectivityHigh, radarBuffers.rd.binWord)
                    }
                }
            } else {
                if numberOfRadials > highVelocity.count { numberOfRadials = highVelocity.count }
                (0..<numberOfRadials).forEach {
                    if highVelocity[$0].elevationNum == 2 {
                        radarBuffers.rd.radialStartAngle.putFloat(450.0 - highVelocity[$0].azimuth)
                        highVelocity[$0].readData(dis2, velocityHigh, radarBuffers.rd.binWord)
                    }
                }
            }
        }
    }
}
