/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

class ColorPalettes {
    
    static func initialize() {
        let colorMapNumbers = [19, 30, 41, 56, 134, 135, 159, 161, 163, 165]
        let cm94 = ObjectColorPalette("94")
        MyApplication.colorMap[94] = cm94
        MyApplication.colorMap[94]!.initialize()
        MyApplication.colorMap[153] = cm94
        MyApplication.colorMap[180] = cm94
        MyApplication.colorMap[186] = cm94
        let cm99 = ObjectColorPalette("99")
        MyApplication.colorMap[99] = cm99
        MyApplication.colorMap[99]!.initialize()
        MyApplication.colorMap[154] = cm99
        MyApplication.colorMap[182] = cm99
        let cm172 = ObjectColorPalette("172")
        MyApplication.colorMap[172] = cm172
        MyApplication.colorMap[172]!.initialize()
        MyApplication.colorMap[170] = cm172
        colorMapNumbers.forEach { productNumber in
            MyApplication.colorMap[productNumber] = ObjectColorPalette(String(productNumber))
            MyApplication.colorMap[productNumber]!.initialize()
        }
        //MyApplication.colorMap[181] = MyApplication.colorMap[19]
        MyApplication.colorMap[37] = MyApplication.colorMap[19]
        MyApplication.colorMap[38] = MyApplication.colorMap[19]
        //MyApplication.colorMap[80] = MyApplication.colorMap[78]
    }
}
