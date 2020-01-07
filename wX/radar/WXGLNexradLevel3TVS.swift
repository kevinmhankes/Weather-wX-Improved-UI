/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

class WXGLNexradLevel3TVS {

    static let tvsPattern1 = "P  TVS(.{20})"
    static let tvsPattern2 = ".{9}(.{7})"

    static func decocodeAndPlotNexradTVS(_ pn: ProjectionNumbers, _ fileName: String) -> [Double] {
        var stormList = [Double]()
        WXGLDownload.getNidsTab("TVS", pn.radarSite, fileName)
        let dis = UtilityIO.readFiletoData(fileName)
        if let retStr1 = String(data: dis, encoding: .ascii) {
            let tvs = retStr1.parseColumn(tvsPattern1)
            var tmpStr = ""
            var tmpStrArr = [String]()
            var degree = 0
            var nm = 0
            let bearing = [Double]()
            var start = ExternalGlobalCoordinates(pn, lonNegativeOne: true)
            var ec = ExternalGlobalCoordinates(pn, lonNegativeOne: true)
            tvs.indices.forEach {
                let ecc =  ExternalGeodeticCalculator()
                tmpStr = tvs[$0].parse(tvsPattern2)
                tmpStrArr = tmpStr.split("/")
                degree = Int(tmpStrArr[0].replace(" ", "")) ?? 0
                nm = Int(tmpStrArr[1].replace(" ", "")) ?? 0
                start = ExternalGlobalCoordinates(pn, lonNegativeOne: true)
                ec = ecc.calculateEndingGlobalCoordinates(
                    ExternalEllipsoid.WGS84,
                    start,
                    Double(degree),
                    Double(nm) * 1852.0,
                    bearing
                )
                stormList.append(ec.getLatitude())
                stormList.append(ec.getLongitude() * -1.0)
            }
            return stormList
        } else {
            return [Double]()
        }
    }
}
