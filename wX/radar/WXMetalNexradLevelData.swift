/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

final class WXMetalNexradLevelData {
    
    var radialStartAngle = MemoryBuffer()
    var binSize = 0.0
    var numberOfRangeBins = 916
    var numberOfRadials = 360
    var binWord = MemoryBuffer()
    var productCode: Int16 = 0
    private var radarType: RadarType = .level3
    private var days = MemoryBuffer(2)
    private var msecs = MemoryBuffer(4)
    private var halfWord3132: Float = 0.0
    private var timestampStr = ""
    private var seekStart: CLong = 0
    private var compressedFileSize = 0
    var radarBuffers: ObjectMetalRadarBuffers?
    var index = "0"
    var radarHeight = 0
    var degree = 0.0
    var operationalMode: Int16 = 0
    var volumeCoveragePattern: Int16 = 0
    
    convenience init(_ product: String, _ radarBuffers: ObjectMetalRadarBuffers, _ index: String) {
        self.init()
        self.radarBuffers = radarBuffers
        self.index = index
        productCode = GlobalDictionaries.radarProductStringToShortInt[product] ?? 0
        switch productCode {
        case 153, 154:
            radarType = .level2
        case 30, 56, 78, 80, 181:
            radarType = .level3bit4
        default:
            radarType = .level3
        }
    }
    
    func decode() {
        switch productCode {
        case 153, 154:
            decodeAndPlotNexradL2()
        case 30, 37, 38, 41, 56, 57, 78, 80, 181:
            decodeAndPlotNexradLevel3FourBit()
        default:
            decodeAndPlotNexradLevel3()
        }
    }
    
    func decodeAndPlotNexradLevel3() {
        let dis = UtilityIO.readFileToByteBuffer(radarBuffers!.fileName)
        if dis.capacity > 0 {
            while dis.getShort() != -1 {}
            dis.skipBytes(8)
            radarHeight = Int(dis.getUnsignedShort())
            productCode = Int16(dis.getUnsignedShort())
            operationalMode = Int16(dis.getUnsignedShort())
            volumeCoveragePattern = Int16(dis.getUnsignedShort())
            _ = Int16(dis.getUnsignedShort())
            _ = Int16(dis.getUnsignedShort())
            let volumeScanDate = Int16(dis.getUnsignedShort())
            let volumeScanTime = dis.getInt()
            writeTime(volumeScanDate, volumeScanTime)
            dis.skipBytes(10)
            // elevationNumber
            _ = dis.getUnsignedShort()
            let elevationAngle = dis.getShort()
            degree = Double(elevationAngle) / 10.0
            halfWord3132 = dis.getFloat()
            WXGLNexrad.wxoglDspLegendMax = (255.0 / Double(halfWord3132)) * 0.01
            dis.skipBytes(26)
            dis.skipBytes(30)
            seekStart = dis.filePointer
            binSize = WXGLNexrad.getBinSize(productCode)
            numberOfRangeBins = Int(WXGLNexrad.getNumberRangeBins(Int(productCode)))
            numberOfRadials = 360
        }
    }
    
    func decodeAndPlotNexradLevel3FourBit() {
        /*if productCode == 181 {
         binWord = MemoryBuffer(360 * 720)
         radialStartAngle = MemoryBuffer(4 * 360)
         } else if productCode == 78 || productCode == 80 {
         binWord = MemoryBuffer(360 * 592)
         radialStartAngle = MemoryBuffer(4 * 360)
         } else if productCode == 37 || productCode == 38 {
         binWord = MemoryBuffer(464 * 464)
         radialStartAngle = MemoryBuffer(4 * 360)
         } else {
         binWord = MemoryBuffer(360 * 230)
         radialStartAngle = MemoryBuffer(4 * 360)
         }*/
        switch productCode {
        case 181:
            binWord = MemoryBuffer(360 * 720)
        case 78, 80:
            binWord = MemoryBuffer(360 * 592)
        case 37, 38:
            binWord = MemoryBuffer(464 * 464)
        default:
            binWord = MemoryBuffer(360 * 230)
        }
        radialStartAngle = MemoryBuffer(4 * 360)
        let dis = UtilityIO.readFileToByteBuffer(radarBuffers!.fileName)
        if dis.capacity > 0 {
            dis.skipBytes(30)
            dis.skipBytes(20)
            dis.skipBytes(8)
            radarHeight = Int(dis.getUnsignedShort())
            productCode = Int16( dis.getUnsignedShort())
            operationalMode = Int16( dis.getUnsignedShort())
            volumeCoveragePattern = Int16(dis.getUnsignedShort())
            _ = Int16(dis.getUnsignedShort())
            _ = Int16(dis.getUnsignedShort())
            let volumeScanDate = Int16(dis.getUnsignedShort())
            let volumeScanTime = dis.getInt()
            writeTime(volumeScanDate, volumeScanTime)
            dis.skipBytes(6)
            dis.skipBytes(56)
            dis.skipBytes(32)
            if productCode == 37 || productCode == 38 || productCode == 41 || productCode == 57 {
                numberOfRangeBins = Int(UtilityWXMetalPerfL3FourBit.decodeRaster(radarBuffers!))
            } else {
                numberOfRangeBins = Int(UtilityWXMetalPerfL3FourBit.decodeRadial(radarBuffers!))
            }
            binSize = WXGLNexrad.getBinSize(productCode)
            numberOfRadials = 360
        } else {
            numberOfRangeBins = 230
            numberOfRadials = 360
        }
    }
    
    func decodeAndPlotNexradL2() {
        radialStartAngle = MemoryBuffer(720 * 4)
        binWord = MemoryBuffer(720 * numberOfRangeBins)
        UtilityWXMetalPerfL2.decompress(radarBuffers!)
        Level2Metal.decode(radarBuffers!, days, msecs)
        writeTimeL2()
        binSize = WXGLNexrad.getBinSize(productCode)
        binWord.position = 0
        numberOfRadials = radialStartAngle.capacity / 4
    }
    
    func writeTimeL2() {
        msecs.position = 0
        days.position = 0
        let days2: Int16 = days.getShortNative()
        let msecs2: Int =  msecs.getInt()
        let sec: CLong = (CLong(days2 - 1)) * 24 * 3600  + msecs2/1000
        let date = Date(timeIntervalSince1970: TimeInterval(sec))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: date)
        let radarInfoFinal = dateString + MyApplication.newline + "Product: " + String(productCode)
        WXGLNexrad.writeRadarInfo("", radarInfoFinal)
    }
    
    func writeTime(_ volumeScanDate: Int16, _ volumeScanTime: Int) {
        let radarInfo = "Mode: " + String(operationalMode) + ", VCP: " + String(volumeCoveragePattern)
            + ", " + "Product: " + String(productCode) + ", " + "Height: " + String(radarHeight)
        let sec = CLong((Int(volumeScanDate) - 1) * 3600 * 24) + Int(volumeScanTime)
        let date = Date(timeIntervalSince1970: TimeInterval(sec))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: date)
        let radarInfoFinal = dateString + MyApplication.newline + radarInfo
        WXGLNexrad.writeRadarInfo("", radarInfoFinal)
    }
}
