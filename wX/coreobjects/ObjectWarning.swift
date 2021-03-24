/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class ObjectWarning {

    var url = ""
    var title = ""
    var area = ""
    var effective = ""
    var expires = ""
    var event = ""
    var sender = ""
    var polygon = ""
    var vtec = ""
    var geometry = ""
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
        self.title = title
        self.area = area

        self.effective = effective
        self.effective = self.effective.replace("T", " ")
        self.effective = UtilityString.replaceAllRegexp(self.effective, ":00-0[0-9]:00", "")

        self.expires = expires;
        self.expires = self.expires.replace("T", " ")
        self.expires = UtilityString.replaceAllRegexp(self.expires, ":00-0[0-9]:00", "")

        self.event = event
        self.sender = sender
        self.polygon = polygon
        self.vtec = vtec
        self.geometry = geometry
        self.isCurrent = UtilityTime.isVtecCurrent(self.vtec)
        if vtec.hasPrefix("O.EXP") || vtec.hasPrefix("O.CAN") {
            self.isCurrent = false;
        }
    }

    // static func getCount(_ data: String) -> String {
    
    static func getBulkData(_ type1: PolygonEnum) -> String {
        var html = "";
        if (type1 == PolygonEnum.TOR) {
            html = MyApplication.severeDashboardTor.value
        } else if (type1 == PolygonEnum.TST) {
            html = MyApplication.severeDashboardTst.value
        } else if (type1 == PolygonEnum.FFW) {
            html = MyApplication.severeDashboardFfw.value
        } else {
            html = ""
        }
        return html
    }
    
    static func parseJson(_ htmlF: String) -> [ObjectWarning] {
        
        var html = htmlF
        html = html.replace("\"geometry\": null,", "\"geometry\": null, \"coordinates\":[[]]}")
        
        var warnings = [ObjectWarning]()
        var urlList = UtilityString.parseColumn(html, "\"id\": \"(https://api.weather.gov/alerts/urn.*?)\"");
        var titleList = UtilityString.parseColumn(html, "\"description\": \"(.*?)\"");
        var areaDescList = UtilityString.parseColumn(html, "\"areaDesc\": \"(.*?)\"");
        var effectiveList = UtilityString.parseColumn(html, "\"effective\": \"(.*?)\"");
        var expiresList = UtilityString.parseColumn(html, "\"expires\": \"(.*?)\"");
        var eventList = UtilityString.parseColumn(html, "\"event\": \"(.*?)\"");
        var senderNameList = UtilityString.parseColumn(html, "\"senderName\": \"(.*?)\"");
        var data = html;
        data = data.replace("\n", "");
        data = data.replace(" ", "");
        var listOfPolygonRaw = UtilityString.parseColumn(data, GlobalVariables.warningLatLonPattern);
        var vtecs = UtilityString.parseColumn(html, GlobalVariables.vtecPattern);
        var geometryList = UtilityString.parseColumn(html, "\"geometry\": (.*?),");
        // count = len(idList)
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
        return warnings;
    }


    func getClosestRadar() -> String {
        var data = polygon;
        data = data.replace("[", "");
        data = data.replace("]", "");
        data = data.replace(",", " ");
        data = data.replace("-", "");
        var points = data.split(" ");
        if (points.count > 2) {
            var lat = points[1];
            var lon = "-" + points[0];
            var latLon = LatLon(lat, lon);
            var radarSites = UtilityLocation.getNearestRadarSites(latLon, 1, includeTdwr: false);
            if (radarSites.count == 0) {
                return "";
            } else {
                return radarSites[0].name;
            }
        } else {
            return "";
        }
    }

    func getUrl() -> String {
        return url;
    }

    func getPolygonAsLatLons() -> [LatLon] {
        var polygonTmp = polygon;
        polygonTmp = polygonTmp.replace("[", "");
        polygonTmp = polygonTmp.replace("]", "");
        polygonTmp = polygonTmp.replace(",", " ");
        var latLons = LatLon.parseStringToLatLons(polygonTmp, 1, true);
        return latLons;
    }
}
