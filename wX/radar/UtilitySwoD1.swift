/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilitySwoD1 {
    
    private static let timer = DownloadTimer("SWO")
    static var hashSwo = [Int: [Double]]()
    
    static func get() {
        if timer.isRefreshNeeded() {
            let threatList = ["HIGH", "MDT", "ENH", "SLGT", "MRGL"]
            let day = 1
            let html = (MyApplication.nwsSPCwebsitePrefix + "/products/outlook/KWNSPTSDY" + String(day) + ".txt").getHtmlSep()
            let htmlChunk = html.parse("... CATEGORICAL ...(.*?&)&")
            //
            // each threat level will have a string of numbers, each string has lat lon pairs (no neg for lon, will be handled later)
            // seperated by ":" to support multiple polygons in the same string
            //
            threatList.indices.forEach { m in
                var data = ""
                let threatLevelCode = threatList[m]
                let htmlList = htmlChunk.parseColumn(threatLevelCode.substring(1) + "(.*?)[A-Z&]")
                var warningList = [Double]()
                htmlList.forEach { polygon in
                    let coordinates =  polygon.parseColumn("([0-9]{8}).*?")
                    coordinates.forEach { data += LatLon($0).printSpaceSeparated() }
                    data += ":"
                    data = data.replace(" :", ":")
                }
                let polygons = data.split(":")
                //
                // for each polygon parse apart the numbers and then add even numbers to one list and odd numbers to the other list
                // from there transform into the normal dataset needed for drawing lines in the graphic renderer
                //
                if polygons.count > 1 {
                    polygons.forEach { polygon in
                        if polygon != "" {
                            let numbers = polygon.split(" ")
                            let x = numbers.enumerated().filter { index, _ in index & 1 == 0 }.map { _, value in Double(value) ?? 0.0 }
                            let y = numbers.enumerated().filter { index, _ in index & 1 != 0 }.map { _, value in (Double(value) ?? 0.0) * -1.0 }
                            if x.count > 0 && y.count > 0 {
                                warningList += [x[0], y[0]]
                                (1..<x.count - 1).forEach { j in
                                    if x[j] < 99.0 {
                                        warningList += [x[j], y[j], x[j], y[j]]
                                    } else {
                                        warningList += [x[j - 1], y[j - 1], x[j + 1], y[j + 1]]
                                    }
                                }
                                warningList += [x[x.count - 1], y[x.count - 1]]
                            }
                            hashSwo[m] = warningList
                        }
                    }
                }
            }
        }
    }
}
