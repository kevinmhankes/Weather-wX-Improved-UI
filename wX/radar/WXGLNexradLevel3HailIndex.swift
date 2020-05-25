/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class WXGLNexradLevel3HailIndex {

    // TODO rename
    private static let hiPattern1 = "AZ/RAN(.*?)V"
    private static let hiPattern2 = "POSH/POH(.*?)V"
    private static let hiPattern3 = "MAX HAIL SIZE(.*?)V"
    private static let stiPattern3 = "(\\d+) "

    static func decode(_ projectionNumbers: ProjectionNumbers, _ fileName: String) -> [Double] {
        WXGLDownload.getNidsTab("HI", projectionNumbers.radarSite, fileName)
        let data = UtilityIO.readFileToData(fileName)
        if let retStr1 = String(data: data, encoding: .ascii) {
            var stormList = [Double]()
            let position = retStr1.parseColumn(hiPattern1)
            let hailPercent = retStr1.parseColumn(hiPattern2)
            let hailSize = retStr1.parseColumn(hiPattern3)
            var posnStr = ""
            position.forEach { posnStr += $0.replace("/", " ") }
            var hailPercentStr = ""
            hailPercent.forEach { hailPercentStr += $0.replace("/", " ") }
            hailPercentStr = hailPercentStr.replace("UNKNOWN", " 0 0 ")
            var hailSizeStr = ""
            hailSize.forEach { hailSizeStr += $0.replace("/", " ") }
            hailSizeStr = hailSizeStr.replace("UNKNOWN", " 0.00 ")
            hailSizeStr = hailSizeStr.replace("<0.50", " 0.49 ")
            let hiPattern4 = " ([0-9]{1}\\.[0-9]{2}) "
            posnStr = posnStr.replaceAllRegexp("\\s+", " ")
            hailPercentStr = hailPercentStr.replaceAllRegexp("\\s+", " ")
            let posnNumbers = posnStr.parseColumnAll(stiPattern3)
            let hailPercentNumbers = hailPercentStr.parseColumnAll(stiPattern3)
            let hailSizeNumbers = hailSizeStr.parseColumnAll(hiPattern4)
            if (posnNumbers.count == hailPercentNumbers.count) && posnNumbers.count > 1 {
                var index = 0
                stride(from: 0, to: posnNumbers.count - 2, by: 2).forEach {
                    let hailSizeDbl = Double(hailSizeNumbers[index]) ?? 0.0
                    if hailSizeDbl > 0.49 && ((Int(hailPercentNumbers[$0]) ?? 0 ) > 60 || (Int(hailPercentNumbers[$0 + 1]) ?? 0 ) > 60) {
                        let ecc = ExternalGeodeticCalculator()
                        let degree = Int(posnNumbers[$0]) ?? 0
                        let nm = Int(posnNumbers[$0 + 1]) ?? 0
                        let start = ExternalGlobalCoordinates(projectionNumbers, lonNegativeOne: true)
                        let ec = ecc.calculateEndingGlobalCoordinates(start, Double(degree), Double(nm) * 1852.0)
                        stormList += [ec.getLatitude(), ec.getLongitude() * -1.0]
                        let baseSize = 0.015
                        [0.99, 1.99, 2.99].enumerated().forEach { index, size in
                            if hailSizeDbl > size {
                                stormList.append(ec.getLatitude() + 0.015 + Double(index) * baseSize)
                                stormList.append(ec.getLongitude() * -1.0)
                            }
                        }
                    }
                    index += 1
                }
            }
            return stormList
        } else {
            return [Double]()
        }
    }
}
