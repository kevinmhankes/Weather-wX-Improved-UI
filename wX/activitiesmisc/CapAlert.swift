/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class CapAlert {

    var text = ""
    var title = ""
    var summary = ""
    var area = ""
    var instructions = ""
    private var zones = ""
    var vtec = ""
    var url = ""
    var event = ""
    private var effective = ""
    private var expires = ""
    var points = [String]()

    convenience init(url: String) {
        self.init()
        self.url = url
        var html: String
        if url.contains("urn:oid") {
            html = url.getNwsHtml()
        } else {
            print("22334")
            html = url.getHtmlSep()
        }
        points = getWarningsFromJson(html)
        title = html.parse("\"headline\": \"(.*?)\"")
        summary = html.parse("\"description\": \"(.*?)\"")
        instructions = html.parse("\"instruction\": \"(.*?)\"")
        area = html.parse("\"areaDesc\": \"(.*?)\"")
        summary = summary.replace("\\n", "\n")
        instructions = instructions.replace("\\n", "\n")
        text = ""
        text += title
        text += GlobalVariables.newline
        text += "Counties: "
        text += area
        text += GlobalVariables.newline
        text += summary
        text += GlobalVariables.newline
        text += instructions
        text += GlobalVariables.newline
    }

    // used by usAlerts
    convenience init(eventText: String) {
        self.init()
        url = eventText.parse("<id>(.*?)</id>")
        title  = eventText.parse("<title>(.*?)</title>")
        summary = eventText.parse("<summary>(.*?)</summary>")
        instructions = eventText.parse("</description>.*?<instruction>(.*?)</instruction>.*?<areaDesc>")
        area = eventText.parse("<cap:areaDesc>(.*?)</cap:areaDesc>")
        area = area.replace("&apos;", "'")
        effective = eventText.parse("<cap:effective>(.*?)</cap:effective>")
        expires = eventText.parse("<cap:expires>(.*?)</cap:expires>")
        event = eventText.parse("<cap:event>(.*?)</cap:event>")
        vtec = eventText.parse("<valueName>VTEC</valueName>.*?<value>(.*?)</value>")
        zones = eventText.parse("<valueName>UGC</valueName>.*?<value>(.*?)</value>")
        text = ""
        text += title
        text += GlobalVariables.newline
        text += "Counties: "
        text += area
        text += GlobalVariables.newline
        text += summary
        text += GlobalVariables.newline
        text += instructions
        text += GlobalVariables.newline
        summary = summary.replaceAll("<br>\\*", "<br><br>*")
    }

    func getClosestRadar() -> String {
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

    private func getWarningsFromJson(_ html: String) -> [String] {
        let data = html.replace("\n", "").replace(" ", "")
        var points = data.parseFirst("\"coordinates\":\\[\\[(.*?)\\]\\]\\}")
        points = points.replace("[", "").replace("]", "").replace(",", " ").replace("-", "")
        return points.split(" ")
    }
}
