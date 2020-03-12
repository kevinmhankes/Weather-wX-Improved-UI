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
            let threatList = ["HIGH", "MDT", "ENH", "SLGT", "MRGL"]
            let day = 1
            let urlBlob = MyApplication.nwsSPCwebsitePrefix + "/products/outlook/KWNSPTSDY" + String(day) + ".txt"
            let html = urlBlob.getHtmlSep()
            let htmlBlob = html.parse("... CATEGORICAL ...(.*?&)&")
            threatList.indices.forEach { m in
                var data = ""
                let threatLevelCode = threatList[m]
                let htmlList = htmlBlob.parseColumn(threatLevelCode.substring(1) + "(.*?)[A-Z&]")
                var warningList = [Double]()
                htmlList.forEach {
                    let coordinates =  $0.parseColumn("([0-9]{8}).*?")
                    coordinates.forEach { coordinate in
                        data += LatLon(coordinate).print()
                    }
                    data += ":"
                    data = data.replace(" :", ":")
                }
                let numberStringList = data.split(":")
                if numberStringList.count > 1 {
                    numberStringList.forEach { numberList in
                        if numberList != "" {
                            let numbers = numberList.split(" ")
                            let x = numbers.enumerated().filter { index, _ in index & 1 == 0 }.map { _, value in Double(value) ?? 0.0 }
                            let y = numbers.enumerated().filter { index, _ in index & 1 != 0 }.map { _, value in (Double(value) ?? 0.0) * -1.0 }
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
