/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilitySpcStormReports {

    static func process(_ lines: [String]) -> [StormReport] {
        var output = ""
        var stormReports = [StormReport]()
        var lineChunks = [String]()
        var lat = ""
        var lon = ""
        var state = ""
        var time = ""
        var address = ""
        var damageReport = ""
        var magnitude = ""
        var city = ""
        var damageHeader = ""
        lines.forEach { line in
            lat = ""
            lon = ""
            state = ""
            time = ""
            address = ""
            damageReport = ""
            magnitude = ""
            city = ""
            output = ""
            damageHeader = ""
            if line.contains(",F_Scale,") {
                damageHeader = "Tornado Reports"
            } else if line.contains(",Speed,") {
                damageHeader = "Wind Reports"
            } else if line.contains(",Size,") {
                damageHeader = "Hail Reports"
            } else {
                lineChunks = line.split(",")
                if lineChunks.count > 7 {
                    output += lineChunks[0]
                    output += " "
                    output += lineChunks[1]
                    output += " "
                    output += lineChunks[2]
                    output += " "
                    output += lineChunks[3]
                    output += " "
                    output += lineChunks[4]
                    output += " "
                    output += lineChunks[5]
                    output += " "
                    output += lineChunks[6]
                    output += MyApplication.newline
                    output += lineChunks[7]
                    time = lineChunks[0]
                    magnitude = lineChunks[1]
                    address = lineChunks[2]
                    city = lineChunks[3]
                    state = lineChunks[4]
                    lat = lineChunks[5]
                    lon = lineChunks[6]
                    damageReport = lineChunks[7]
                }
            }
            stormReports.append(
                StormReport(output, lat, lon, time, magnitude, address, city, state, damageReport, damageHeader)
            )
        }
        return stormReports
    }
}
