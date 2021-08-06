// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

final class WXGLNexradLevel3TVS {

    static func decode(_ projectionNumbers: ProjectionNumbers, _ fileStorage: FileStorage) {        
        let productCode = "TVS"
        WXGLDownload.getNidsTab(productCode, projectionNumbers.radarSite, fileStorage)
        let retStr1 = fileStorage.level3TextProductMap[productCode] ?? ""
        var stormList = [Double]()
        if retStr1.count > 10 {
            let tvs = retStr1.parseColumn("P  TVS(.{20})")
            tvs.indices.forEach { index in
                let ecc = ExternalGeodeticCalculator()
                let s = tvs[index].parse(".{9}(.{7})")
                let items = s.split("/")
                let degree = to.Int(items[0].replace(" ", ""))
                let nm = to.Int(items[1].replace(" ", ""))
                let start = ExternalGlobalCoordinates(projectionNumbers, lonNegativeOne: true)
                let ec = ecc.calculateEndingGlobalCoordinates(start, Double(degree), Double(nm) * 1852.0)
                stormList.append(ec.getLatitude())
                stormList.append(ec.getLongitude() * -1.0)
            }
        }
        fileStorage.tvsData = stormList
    }
}
