/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

class WXGLNexradLevel3TVS {

    private static let tvsPattern1 = "P  TVS(.{20})"
    private static let tvsPattern2 = ".{9}(.{7})"

    static func decode(_ projectionNumbers: ProjectionNumbers, _ fileName: String) -> [Double] {
        WXGLDownload.getNidsTab("TVS", projectionNumbers.radarSite, fileName)
        let data = UtilityIO.readFileToData(fileName)
        if let retStr1 = String(data: data, encoding: .ascii) {
            var stormList = [Double]()
            let tvs = retStr1.parseColumn(tvsPattern1)
            tvs.indices.forEach { index in
                let ecc =  ExternalGeodeticCalculator()
                let string = tvs[index].parse(tvsPattern2)
                let items = string.split("/")
                let degree = Int(items[0].replace(" ", "")) ?? 0
                let nm = Int(items[1].replace(" ", "")) ?? 0
                let start = ExternalGlobalCoordinates(projectionNumbers, lonNegativeOne: true)
                let ec = ecc.calculateEndingGlobalCoordinates(start, Double(degree), Double(nm) * 1852.0)
                stormList.append(ec.getLatitude())
                stormList.append(ec.getLongitude() * -1.0)
            }
            return stormList
        } else {
            return [Double]()
        }
    }
}
