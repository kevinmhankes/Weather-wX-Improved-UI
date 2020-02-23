/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

class WXGLNexradLevel3HailIndex {

    private static let hiPattern1 = "AZ/RAN(.*?)V"
    private static let hiPattern2 = "POSH/POH(.*?)V"
    private static let hiPattern3 = "MAX HAIL SIZE(.*?)V"
    private static let stiPattern3 = "(\\d+) "

    static func decocodeAndPlotNexradHailIndex(_ pn: ProjectionNumbers, _ fileName: String) -> [Double] {
        var stormList = [Double]()
        WXGLDownload.getNidsTab("HI", pn.radarSite, fileName)
        let dis = UtilityIO.readFiletoData(fileName)
        if let retStr1 = String(data: dis, encoding: .ascii) {
            let posn = retStr1.parseColumn(hiPattern1)
            let hailPercent = retStr1.parseColumn(hiPattern2)
            let hailSize = retStr1.parseColumn(hiPattern3)
            var posnStr = ""
            var hailPercentStr = ""
            var hailSizeStr = ""
            posn.forEach {posnStr += $0.replace("/", " ")}
            hailPercent.forEach {hailPercentStr += $0.replace("/", " ")}
            hailPercentStr = hailPercentStr.replace("UNKNOWN", " 0 0 ")
            hailSize.forEach {hailSizeStr += $0.replace("/", " ")}
            hailSizeStr = hailSizeStr.replace("UNKNOWN", " 0.00 ")
            hailSizeStr = hailSizeStr.replace("<0.50", " 0.49 ")
            let hiPattern4 = " ([0-9]{1}\\.[0-9]{2}) "
            posnStr = posnStr.replaceAllRegexp("\\s+", " ")
            hailPercentStr = hailPercentStr.replaceAllRegexp("\\s+", " ")
            let posnNumbers = posnStr.parseColumnAll(stiPattern3)
            let hailPercentNumbers = hailPercentStr.parseColumnAll(stiPattern3)
            let hailSizeNumbers = hailSizeStr.parseColumnAll(hiPattern4)
            if (posnNumbers.count == hailPercentNumbers.count) && posnNumbers.count > 1 {
                var degree = 0
                var nm = 0
                let bearing = [Double]()
                var start = ExternalGlobalCoordinates(pn, lonNegativeOne: true)
                var ec = ExternalGlobalCoordinates(pn, lonNegativeOne: true)
                var hailSizeDbl = 0.0
                var index = 0
                stride(from: 0, to: posnNumbers.count - 2, by: 2).forEach {
                    hailSizeDbl = Double(hailSizeNumbers[index]) ?? 0.0
                    if hailSizeDbl > 0.49 && ((Int(hailPercentNumbers[$0]) ?? 0 ) > 60
                        || (Int(hailPercentNumbers[$0+1]) ?? 0 ) > 60) {
                        let ecc = ExternalGeodeticCalculator()
                        degree = Int(posnNumbers[$0]) ?? 0
                        nm = Int(posnNumbers[$0 + 1]) ?? 0
                        start = ExternalGlobalCoordinates(pn, lonNegativeOne: true)
                        ec = ecc.calculateEndingGlobalCoordinates(
                            ExternalEllipsoid.WGS84,
                            start,
                            Double(degree),
                            Double(nm) * 1852.0,
                            bearing
                        )
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
