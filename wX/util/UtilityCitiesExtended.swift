/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityCitiesExtended {

    static var initialized = false
    static var cities = [CityExt]()

    static func populateArrays() {
        if !initialized {
            initialized = true
            var tmpArr = [String]()
            let text = UtilityIO.readTextFile("cityall.txt")
            let lines = text.split(MyApplication.newline)
            lines.forEach {
                tmpArr = $0.split(",")
                if tmpArr.count > 3 {
                    cities.append(CityExt(tmpArr[0], Double(tmpArr[1])!, -1.0 * Double(tmpArr[2])!, tmpArr[3]))
                } else if tmpArr.count > 2 {
                    cities.append(CityExt(tmpArr[0], Double(tmpArr[1])!, -1.0 * Double(tmpArr[2])!, ""))
                }
            }
        }
    }
}
