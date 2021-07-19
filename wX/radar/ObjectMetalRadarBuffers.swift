/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class ObjectMetalRadarBuffers: ObjectMetalBuffers {
    
    var bgColor = 0
    var fileName = "nids"
    var rd = WXMetalNexradLevelData()
    let colorRF: Float
    let colorGF: Float
    let colorBF: Float
    var fileStorage = FileStorage()
    
    init(_ bgColor: Int) {
        self.bgColor = bgColor
        colorRF = Float(Color.red(bgColor)) / 255.0
        colorGF = Float(Color.green(bgColor)) / 255.0
        colorBF = Float(Color.blue(bgColor)) / 255.0
    }
    
    var colorMap: ObjectColorPalette { ObjectColorPalette.colorMap[Int(rd.productCode)]! }
    
    func initialize() {
        if !RadarPreferences.showRadarWhenPan {
            honorDisplayHold = true
        }
        if rd.productCode == 37 || rd.productCode == 38 || rd.productCode == 41 || rd.productCode == 57 {
            if floatBuffer.capacity < (48 * 464 * 464) {
                floatBuffer = MemoryBuffer(48 * 464 * 464)
            }
        } else {
            if floatBuffer.capacity < (32 * rd.numberOfRadials * rd.numberOfRangeBins) {
                floatBuffer = MemoryBuffer(32 * rd.numberOfRadials * rd.numberOfRangeBins)
            }
        }
        setToPositionZero()
    }
    
    func putColorsByIndex(_ level: UInt8) {
        putColor(colorMap.redValues.get(Int(level)))
        putColor(colorMap.greenValues.get(Int(level)))
        putColor(colorMap.blueValues.get(Int(level)))
    }
    
    func generateRadials() -> Int {
        let totalBins: Int
        switch rd.productCode {
        case 37, 38:
            totalBins = UtilityWXMetalPerfRaster.generate(self, fileStorage)
        case 153, 154, 30, 56, 78, 80, 181:
            totalBins = UtilityWXMetalPerf.genRadials(self, fileStorage)
        case 0:
            totalBins = 0
        default:
            totalBins = UtilityWXMetalPerf.decode8BitAndGenRadials(self, fileStorage)
        }
        return totalBins
    }
    
    func setCount() {
        count = (metalBuffer.count / floatCountPerVertex) * 2
    }
}
