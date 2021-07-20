/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class WXGLNexradLevel3TVS {

    static func decode(_ projectionNumbers: ProjectionNumbers, _ fileStorage: FileStorage) {
        // WXGLDownload.getNidsTab("TVS", projectionNumbers.radarSite, fileName)
        
        let productCode = "TVS"
        WXGLDownload.getNidsTabNew(productCode, projectionNumbers.radarSite, fileStorage)
        let retStr1 = fileStorage.level3TextProductMap[productCode] ?? ""
        var stormList = [Double]()
        if retStr1.count > 10 {
        // if let retStr1 = String(data: UtilityIO.readFileToData(fileName), encoding: .ascii) {
            let tvs = retStr1.parseColumn("P  TVS(.{20})")
            tvs.indices.forEach { index in
                let ecc = ExternalGeodeticCalculator()
                let s = tvs[index].parse(".{9}(.{7})")
                let items = s.split("/")
                let degree = Int(items[0].replace(" ", "")) ?? 0
                let nm = Int(items[1].replace(" ", "")) ?? 0
                let start = ExternalGlobalCoordinates(projectionNumbers, lonNegativeOne: true)
                let ec = ecc.calculateEndingGlobalCoordinates(start, Double(degree), Double(nm) * 1852.0)
                stormList.append(ec.getLatitude())
                stormList.append(ec.getLongitude() * -1.0)
            }
            // return stormList
        } else {
            // return [Double]()
        }
        fileStorage.tvsData = stormList
    }
}
