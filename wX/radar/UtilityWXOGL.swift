/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityWXOGL {

    static func showTextProducts(_ latLon: LatLon) -> String {
        var warningChunk = MyApplication.severeDashboardTor.value + MyApplication.severeDashboardTst.value + MyApplication.severeDashboardFfw.value
        ObjectPolygonWarning.polygonList.forEach { poly in
            let it = ObjectPolygonWarning.polygonDataByType[poly]!
            if it.isEnabled { warningChunk += it.storage.value }
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
            let polygonTmp = warning.replace("[", "").replace("]", "").replace(",", " ")
            let latLons = LatLon.parseStringToLatLons(polygonTmp)
            if latLons.count > 0 {
                let contains = ExternalPolygon.polygonContainsPoint(latLon, latLons)
                if contains && notFound {
                    string = urlList[urlIndex]
                    notFound = false
                }
            }
        }
        return string
    }
}
