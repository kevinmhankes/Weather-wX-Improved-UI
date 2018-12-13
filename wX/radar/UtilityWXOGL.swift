/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

public class UtilityWXOGL {

    static func showTextProducts(_ location: LatLon) -> String {
        var x = [Double]()
        var y = [Double]()
        var warningChunk = MyApplication.severeDashboardTor.value
            + MyApplication.severeDashboardTst.value
            + MyApplication.severeDashboardFfw.value
        var urlList = warningChunk.parseColumn("\"id\"\\: .(https://api.weather.gov/alerts/NWS-IDP-.*?)\"")
        warningChunk = warningChunk.replace("\n", "").replace(" ", "")
        let polygons = warningChunk.parseColumn("\"coordinates\":\\[\\[(.*?)\\]\\]\\}")
        var retStr = ""
        var notFound = true
        polygons.enumerated().forEach { index, warning in
            let polyTmp = warning.replace("[", "").replace("]", "").replace(",", " ").split(" ")
            if polyTmp.count > 1 {
                y = polyTmp.enumerated().filter {idx, _ in idx & 1 == 0}.map { _, value in Double(value) ?? 0.0}
                x = polyTmp.enumerated().filter {idx, _ in idx & 1 != 0}.map { _, value in Double(value) ?? 0.0}
            }
            if (y.count > 3 && x.count > 3) && (x.count == y.count) {
                let poly2 = ExternalPolygon.Builder()
                x.indices.forEach {_ = poly2.addVertex(point: ExternalPoint(Float(x[$0]), Float(y[$0])))}
                let polygon2 = poly2.build()
                let contains = polygon2.contains(point: ExternalPoint(Float(location.lat), Float(location.lon)))
                if contains && notFound {
                    retStr = urlList[index]
                    notFound = false
                }
            }
        }
        return retStr
    }
}
