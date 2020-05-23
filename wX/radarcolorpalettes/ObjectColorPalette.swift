/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class ObjectColorPalette {
    
    var redValues = MemoryBuffer(16)
    var greenValues = MemoryBuffer(16)
    var blueValues = MemoryBuffer(16)
    private let colorMapCode: Int
    
    init(_ colorMapCode: Int) {
        self.colorMapCode = colorMapCode
    }
    
    private func setupBuffers(_ size: Int) {
        redValues = MemoryBuffer(size)
        greenValues = MemoryBuffer(size)
        blueValues = MemoryBuffer(size)
    }
    
    func position(_ index: Int) {
        redValues.position = index
        blueValues.position = index
        greenValues.position = index
    }
    
    func putInt(_ colorAsInt: Int) {
        redValues.put(Color.red(colorAsInt))
        greenValues.put(Color.green(colorAsInt))
        blueValues.put(Color.blue(colorAsInt))
    }
    
    func putBytes(_ redByte: UInt8, _ greenByte: UInt8, _ blueByte: UInt8) {
        redValues.put(redByte)
        greenValues.put(greenByte)
        blueValues.put(blueByte)
    }
    
    // comma separated r,g,b (4bit)
    //func putLine(_ line: String) {
    //    let colors = line.split(",")
    //    putBytes(colors[0].toInt().toByte(), colors[1].toInt().toByte(), colors[2].toInt().toByte())
    //}
    
    func initialize() {
        switch colorMapCode {
        case 19, 30, 41, 56, 78:
            setupBuffers(16)
            UtilityColorPalette4bitGeneric.generate(colorMapCode)
        case 165:
            setupBuffers(256)
            UtilityColorPalette165.loadColorMap()
        default:
            setupBuffers(256)
            UtilityColorPaletteGeneric.loadColorMap(colorMapCode)
        }
    }
}
