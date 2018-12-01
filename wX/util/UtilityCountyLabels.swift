/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityCountyLabels {

    static var initialized = false
    static var countyName = [String]()
    static var location = [LatLon]()

    static func populateArrays() {
        if !initialized {
            initialized = true
            let text = UtilityIO.readTextFile(R.Raw.gaz_counties_national)
            var lines = text.split(MyApplication.newline)
            _ = lines.popLast()
            lines.forEach {
                let tokens = $0.split(",")
                countyName.append(tokens[1])
                location.append(LatLon(Double(tokens[2])!, -1.0 * Double(tokens[3])!))
            }
        }
    }
}
