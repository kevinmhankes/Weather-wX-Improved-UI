/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class ObjectColorPalette {

    var redValues = MemoryBuffer(16)
    var greenValues = MemoryBuffer(16)
    var blueValues = MemoryBuffer(16)
    private var colormapCode = ""

    init(_ colormapCode: String) {
        self.colormapCode = colormapCode
    }

    func setupBuffers(_ size: Int) {
        redValues = MemoryBuffer(size)
        greenValues = MemoryBuffer(size)
        blueValues = MemoryBuffer(size)
    }

    func initialize() {
        switch colormapCode {
        case "19":
            setupBuffers(16)
            UtilityColorPalette19.generate()
        case "30":
            setupBuffers(16)
            UtilityColorPalette30.generate()
        case "41":
            setupBuffers(16)
            UtilityColorPalette41.generate()
        case "56":
            setupBuffers(16)
            UtilityColorPalette56.generate()
        case "57":
            setupBuffers(16)
            UtilityColorPalette57.generate()
        case "78":
            setupBuffers(16)
            UtilityColorPalette78.generate()
        case "165":
            setupBuffers(256)
            UtilityColorPalette165.loadColorMap()
        default:
            setupBuffers(256)
            UtilityColorPaletteGeneric.loadColorMap(colormapCode)
        }
    }
}
