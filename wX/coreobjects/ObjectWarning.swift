// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

final class ObjectWarning {

    var url = ""
    var area = ""
    var effective = ""
    var expires = ""
    var event = ""
    var sender = ""
    var polygon = ""
    var vtec = ""
    var isCurrent = true

    init(
        _ url: String,
        _ title: String,
        _ area: String,
        _ effective: String,
        _ expires: String,
        _ event: String,
        _ sender: String,
        _ polygon: String,
        _ vtec: String,
        _ geometry: String
    ) {
        self.url = url
        // detailed desc
        self.area = area

        self.effective = effective
        self.effective = self.effective.replace("T", " ")
        self.effective = UtilityString.replaceAllRegexp(self.effective, ":00-0[0-9]:00", "")

        self.expires = expires
        self.expires = self.expires.replace("T", " ")
        self.expires = UtilityString.replaceAllRegexp(self.expires, ":00-0[0-9]:00", "")

        self.event = event
        self.sender = sender
        self.polygon = polygon
        self.vtec = vtec
        isCurrent = UtilityTime.isVtecCurrent(self.vtec)
        if vtec.hasPrefix("O.EXP") || vtec.hasPrefix("O.CAN") {
            isCurrent = false
        }
    }
    
    static func parseJson(_ htmlF: String) -> [ObjectWarning] {
        var html = htmlF
        html = html.replace("\"geometry\": null,", "\"geometry\": null, \"coordinates\":[[]]}")
        var warnings = [ObjectWarning]()
        let urlList = UtilityString.parseColumn(html, "\"id\": \"(https://api.weather.gov/alerts/urn.*?)\"")
        let titleList = UtilityString.parseColumn(html, "\"description\": \"(.*?)\"")
        let areaDescList = UtilityString.parseColumn(html, "\"areaDesc\": \"(.*?)\"")
        let effectiveList = UtilityString.parseColumn(html, "\"effective\": \"(.*?)\"")
        let expiresList = UtilityString.parseColumn(html, "\"expires\": \"(.*?)\"")
        let eventList = UtilityString.parseColumn(html, "\"event\": \"(.*?)\"")
        let senderNameList = UtilityString.parseColumn(html, "\"senderName\": \"(.*?)\"")
        var data = html
        data = data.replace("\n", "")
        data = data.replace(" ", "")
        let listOfPolygonRaw = UtilityString.parseColumn(data, GlobalVariables.warningLatLonPattern)
        let vtecs = UtilityString.parseColumn(html, GlobalVariables.vtecPattern)
        let geometryList = UtilityString.parseColumn(html, "\"geometry\": (.*?),")
        for index in urlList.indices {
            warnings.append(ObjectWarning(
                Utility.safeGet(urlList, index),
                Utility.safeGet(titleList, index),
                Utility.safeGet(areaDescList, index),
                Utility.safeGet(effectiveList, index),
                Utility.safeGet(expiresList, index),
                Utility.safeGet(eventList, index),
                Utility.safeGet(senderNameList, index),
                Utility.safeGet(listOfPolygonRaw, index),
                Utility.safeGet(vtecs, index),
                Utility.safeGet(geometryList, index)
            ))
        }
        return warnings
    }

    func getClosestRadar() -> String {
        var data = polygon
        data = data.replace("[", "")
        data = data.replace("]", "")
        data = data.replace(",", " ")
        data = data.replace("-", "")
        let points = data.split(" ")
        return ObjectWarning.getClosestRadarCompute(points)
    }
    
    static func getClosestRadarCompute(_ points: [String]) -> String {
        if points.count > 2 {
            let lat = points[1]
            let lon = "-" + points[0]
            let latLon = LatLon(lat, lon)
            let radarSites = UtilityLocation.getNearestRadarSites(latLon, 1, includeTdwr: false)
            if radarSites.count == 0 {
                return ""
            } else {
                return radarSites[0].name
            }
        } else {
            return ""
        }
    }

    func getUrl() -> String {
        url
    }

    func getPolygonAsLatLons(_ mult: Int) -> [LatLon] {
        var polygonTmp = polygon
        polygonTmp = polygonTmp.replace("[", "")
        polygonTmp = polygonTmp.replace("]", "")
        polygonTmp = polygonTmp.replace(",", " ")
        let latLons = LatLon.parseStringToLatLons(polygonTmp, Double(mult), true)
        return latLons
    }
}
