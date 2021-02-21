/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityCitiesExtended {

    private static var initialized = false
    static var cities = [CityExt]()

    static func create() {
        if !initialized {
            initialized = true
            let text = UtilityIO.readTextFile("cityall.txt")
            let lines = text.split(GlobalVariables.newline)
            lines.forEach { line in
                let items = line.split(",")
                if items.count > 2 { cities.append(CityExt(items[0], Double(items[1])!, -1.0 * Double(items[2])!)) }
            }
        }
    }
}
