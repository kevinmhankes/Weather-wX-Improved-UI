// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

final class UtilityCountyLabels {

    private static var initialized = false
    static var countyName = [String]()
    static var location = [LatLon]()

    static func create() {
        if !initialized {
            initialized = true
            let text = UtilityIO.readTextFile("gaz_counties_national.txt")
            var lines = text.split(GlobalVariables.newline)
            _ = lines.popLast()
            lines.forEach { line in
                let items = line.split(",")
                countyName.append(items[1])
                location.append(LatLon(Double(items[2])!, -1.0 * Double(items[3])!))
            }
        }
    }
}
