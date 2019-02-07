/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

class UtilitySWOD1 {

    static var initialized = false
    static var lastRefresh: CLong = 0
    static var refreshLocMin = RadarPreferences.radarDataRefreshInterval * 2
    static var hashSwo = [Int: [Double]]()

    static func getSWO() {
        let currentTime1: CLong = UtilityTime.currentTimeMillis()
        let currentTimeSec: CLong = currentTime1 / 1000
        let refreshIntervalSec: CLong = refreshLocMin * 60
        if (currentTimeSec > (lastRefresh + refreshIntervalSec)) || !initialized {
            var retStr = ""
            let threatList = ["HIGH", "MDT", "ENH", "SLGT", "MRGL"]
            let day = 1
            let urlBlob = MyApplication.nwsSPCwebsitePrefix + "/products/outlook/KWNSPTSDY" + String(day) + ".txt"
            let html = urlBlob.getHtmlSep()
            let htmlBlob = html.parse("... CATEGORICAL ...(.*?&)&")
            threatList.indices.forEach { m in
                retStr = ""
                let threatLevelCode = threatList[m]
                let htmlList = htmlBlob.parseColumn(threatLevelCode.substring(1) + "(.*?)[A-Z&]")
                var warningList = [Double]()
                htmlList.forEach {
                    let coords =  $0.parseColumn("([0-9]{8}).*?")
                    coords.forEach {temp in
                        retStr += LatLon(temp).print()
                    }
                    retStr += ":"
                    retStr = retStr.replace(" :", ":")
                }
                var x = [Double]()
                var y = [Double]()
                var tmpArr = retStr.split(":")
                var test = [String]()
                if tmpArr.count > 1 {
                    tmpArr.indices.forEach { z in
                        if tmpArr[z] != "" {
                            test = tmpArr[z].split(" ")
                            x = test.enumerated().filter {idx, _ in idx & 1 == 0}.map { _, value in
                                Double(value) ?? 0.0
                            }
                            y = test.enumerated().filter {idx, _ in idx & 1 != 0}.map { _, value in
                                (Double(value) ?? 0.0) * -1.0
                            }
                            if x.count > 0 && y.count > 0 {
                                warningList += [x[0], y[0]]
                                (1..<x.count-1).forEach { j in
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
            initialized = true
            let currentTime: CLong = UtilityTime.currentTimeMillis()
            lastRefresh = currentTime / 1000
        }
    }
}
