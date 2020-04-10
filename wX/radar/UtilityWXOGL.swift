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
            let polygonTmp = warning.replace("[", "").replace("]", "").replace(",", " ").split(" ")
            if polygonTmp.count > 1 {
                y = polygonTmp.enumerated().filter {index, _ in index & 1 == 0}.map { _, value in Double(value) ?? 0.0}
                x = polygonTmp.enumerated().filter {index, _ in index & 1 != 0}.map { _, value in Double(value) ?? 0.0}
            }
            if (y.count > 3 && x.count > 3) && (x.count == y.count) {
                let polygonFrame = ExternalPolygon.Builder()
                x.indices.forEach {
                    _ = polygonFrame.addVertex(point: ExternalPoint(x[$0], y[$0]))
                }
                let polygonShape = polygonFrame.build()
                let contains = polygonShape.contains(point: ExternalPoint(location.lat, location.lon))
                if contains && notFound {
                    string = urlList[urlIndex]
                    notFound = false
                }
            }
        }
        return string
    }
}
