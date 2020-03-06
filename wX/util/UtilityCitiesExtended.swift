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
            var list = [String]()
            let text = UtilityIO.readTextFile("cityall.txt")
            let lines = text.split(MyApplication.newline)
            lines.forEach { line in
                list = line.split(",")
                if list.count > 3 {
                    cities.append(CityExt(list[0], Double(list[1])!, -1.0 * Double(list[2])!, list[3]))
                } else if list.count > 2 {
                    cities.append(CityExt(list[0], Double(list[1])!, -1.0 * Double(list[2])!, ""))
                }
            }
        }
    }
}
