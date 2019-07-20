/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
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

    init(_ bgColor: Int) {
        self.bgColor = bgColor
        colorRF = Float(Color.red(bgColor)) / 255.0
        colorGF = Float(Color.green(bgColor)) / 255.0
        colorBF = Float(Color.blue(bgColor)) / 255.0
    }

    var colormap: ObjectColorPalette {
        return MyApplication.colorMap[Int(self.rd.productCode)]!
    }

    func initialize() {
        if rd.productCode == 37 || rd.productCode == 38 || rd.productCode == 41 || rd.productCode == 57 {
            if floatBuffer.capacity < (64 * 464 * 464) {
                floatBuffer = MemoryBuffer(64 * 464 * 464)
            }
        } else {
            if floatBuffer.capacity < (32 * rd.numberOfRadials * rd.numberOfRangeBins) {
                floatBuffer = MemoryBuffer(32 * rd.numberOfRadials * rd.numberOfRangeBins)
            }
        }
        setToPositionZero()
    }

    func putColorsByIndex(_ level: UInt8) {
        putColor(colormap.redValues.get(Int(level)))
        putColor(colormap.greenValues.get(Int(level)))
        putColor(colormap.blueValues.get(Int(level)))
    }
}
