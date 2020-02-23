/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

class UtilitySwoD1 {

    private static var timer = DownloadTimer("SWO")
    static var hashSwo = [Int: [Double]]()

    static func get() {
        if timer.isRefreshNeeded() {
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
                let tmpArr = retStr.split(":")
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
        }
    }
}
