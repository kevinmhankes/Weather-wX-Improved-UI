/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilitySPCStormReports {

    static func processData(_ lines: [String]) -> [StormReport] {
        var output = ""
        var stormReports = [StormReport]()
        var lineChunks = [String]()
        var lat = ""
        var lon = ""
        var state = ""
        var time = ""
        lines.forEach {
            lat = ""
            lon = ""
            state = ""
            time = ""
            output = ""
            if $0.contains(",F_Scale,") {
                output = "Tornado Reports"
            } else if $0.contains(",Speed,") {
                output = "Wind Reports"
            } else if $0.contains(",Size,") {
                output = "Hail Reports"
            } else {
                lineChunks = $0.split(",")
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
                    lat = lineChunks[5]
                    lon = lineChunks[6]
                    time = lineChunks[0]
                    state = lineChunks[4]
                }
            }
            stormReports.append(StormReport(output, lat, lon, time, state))
        }
        return stormReports
    }
}
