/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class SevereWarning {

    var text = ""
    var count = 0
    private let type: PolygonEnum
    var idList = [String]()
    var areaDescList = [String]()
    var effectiveList = [String]()
    var expiresList = [String]()
    var eventList = [String]()
    var senderNameList = [String]()
    var warnings = [String]()
    var listOfWfo = [String]()
    private var listOfPolygonRaw = [String]()

    init(_ type: PolygonEnum) {
        self.type = type
        generateString()
    }

    func getCount() -> Int { count }

    func getName() -> String {
        switch type {
        case .TOR:
            return "Tornado Warning"
        case .TST:
            return "Severe Thunderstorm Warning"
        case .FFW:
            return "Flash Flood Warning"
        default:
            return ""
        }
    }

    private func getClosestRadar(_ index: Int) -> String {
        let data = listOfPolygonRaw[index].replace("[", "").replace("]", "").replace(",", " ").replace("-", "")
        let points = data.split(" ")
        // From CapAlert
        if points.count > 2 {
            let lat = points[1]
            let lon = "-" + points[0]
            let radarSites = UtilityLocation.getNearestRadarSites(LatLon(lat, lon), 1, includeTdwr: false)
            if radarSites.isEmpty {
                return ""
            } else {
                return radarSites[0].name
            }
        } else {
            return ""
        }
    }

    func generateString() {
        let html: String
        switch type {
        case .TOR:
            html = MyApplication.severeDashboardTor.value
        case .TST:
            html = MyApplication.severeDashboardTst.value
        case .FFW:
            html = MyApplication.severeDashboardFfw.value
        default:
            html = ""
        }
        text = ""
        count = 0
        // idList = html.parseColumn("\"id\": \"(NWS.*?)\"")
        idList = html.parseColumn("\"id\": \"(https://api.weather.gov/alerts/urn.*?)\"")
        areaDescList = html.parseColumn("\"areaDesc\": \"(.*?)\"")
        effectiveList = html.parseColumn("\"effective\": \"(.*?)\"")
        expiresList = html.parseColumn("\"expires\": \"(.*?)\"")
        eventList = html.parseColumn("\"event\": \"(.*?)\"")
        senderNameList = html.parseColumn("\"senderName\": \"(.*?)\"")
        let data = html.replace("\n", "").replace(" ", "")
        listOfPolygonRaw = data.parseColumn(WXGLPolygonWarnings.warningLatLonPattern)
        warnings = html.parseColumn(WXGLPolygonWarnings.vtecPattern)
        warnings.enumerated().forEach { index, warning in
            let vtecIsCurrent = UtilityTime.isVtecCurrent(warning)
            if !warning.startsWith("O.EXP") && vtecIsCurrent {
                count += 1
                let radarSite = getClosestRadar(index)
                listOfWfo.append(radarSite)
                let location = Utility.getWfoSiteName(radarSite)
                text += "  " + location + GlobalVariables.newline
            } else {
                listOfWfo.append("")
            }
        }
    }
}
