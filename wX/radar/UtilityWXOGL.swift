/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

public class UtilityWXOGL {

    static func showTextProducts(_ location: LatLon) -> String {
        var x = [Double]()
        var y = [Double]()
        var warningChunk = MyApplication.severeDashboardTor.value + MyApplication.severeDashboardTst.value + MyApplication.severeDashboardFfw.value
        ObjectPolygonWarning.polygonList.forEach { poly in
            let it = ObjectPolygonWarning.polygonDataByType[poly]!
            if it.isEnabled {
                warningChunk += it.storage.value
            }
        }
        var urlList = warningChunk.parseColumn("\"id\"\\: .(https://api.weather.gov/alerts/NWS-IDP-.*?)\"")
        let urlListCopy = urlList
        // discard  "id": "https://api.weather.gov/alerts/NWS-IDP-PROD-3771044",            "type": "Feature",            "geometry": null,
        // Special Weather Statements can either have a polygon or maybe not, need to strip out those w/o polygon
        urlListCopy.forEach { url in
            //if (html.contains(Regex("\"id\"\\: ." + it + "\",            \"type\": \"Feature\",            \"geometry\": null"))) {
            if warningChunk.matches(regexp: "\"id\"\\: ." + url + "\",\\s*\"type\": \"Feature\",\\s*\"geometry\": null") {
                urlList.removeAll {$0 == url}
            }
        }
        warningChunk = warningChunk.replace("\n", "").replace(" ", "")
        let polygons = warningChunk.parseColumn("\"coordinates\":\\[\\[(.*?)\\]\\]\\}")
        var string = ""
        var notFound = true
        polygons.enumerated().forEach { urlIndex, warning in
            let polyTmp = warning.replace("[", "").replace("]", "").replace(",", " ").split(" ")
            if polyTmp.count > 1 {
                y = polyTmp.enumerated().filter {index, _ in index & 1 == 0}.map { _, value in Double(value) ?? 0.0}
                x = polyTmp.enumerated().filter {index, _ in index & 1 != 0}.map { _, value in Double(value) ?? 0.0}
            }
            if (y.count > 3 && x.count > 3) && (x.count == y.count) {
                let poly2 = ExternalPolygon.Builder()
                x.indices.forEach {
                    _ = poly2.addVertex(point: ExternalPoint(Float(x[$0]), Float(y[$0])))
                }
                let polygon2 = poly2.build()
                let contains = polygon2.contains(point: ExternalPoint(Float(location.lat), Float(location.lon)))
                if contains && notFound {
                    string = urlList[urlIndex]
                    notFound = false
                }
            }
        }
        return string
    }
}
