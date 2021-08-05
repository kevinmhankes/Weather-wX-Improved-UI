// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

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
    var polygon = ""

    convenience init(url: String) {
        self.init()
        self.url = url
        var html: String
        if url.contains("urn:oid") {
            html = url.getNwsHtml()
        } else {
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
        title = eventText.parse("<title>(.*?)</title>")
        summary = eventText.parse("<summary>(.*?)</summary>")
        instructions = eventText.parse("</description>.*?<instruction>(.*?)</instruction>.*?<areaDesc>")
        area = eventText.parse("<cap:areaDesc>(.*?)</cap:areaDesc>")
        area = area.replace("&apos;", "'")
        effective = eventText.parse("<cap:effective>(.*?)</cap:effective>")
        expires = eventText.parse("<cap:expires>(.*?)</cap:expires>")
        event = eventText.parse("<cap:event>(.*?)</cap:event>")
        vtec = eventText.parse("<valueName>VTEC</valueName>.*?<value>(.*?)</value>")
        zones = eventText.parse("<valueName>UGC</valueName>.*?<value>(.*?)</value>")
        polygon = UtilityString.parse(eventText, "<cap:polygon>(.*?)</cap:polygon>")
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
        polygon = polygon.replace("-", "")
        points = polygon.split(" ")
        if points.count > 1 {
            points = points[0].split(",")
            if points.count > 1 {
                // reverse so lon is first
                points = [points[1], points[0], ""]
            }
        }
    }

    func getClosestRadar() -> String {
        ObjectWarning.getClosestRadarCompute(points)
    }

    private func getWarningsFromJson(_ html: String) -> [String] {
        let data = html.replace("\n", "").replace(" ", "")
        var points = data.parseFirst(GlobalVariables.warningLatLonPattern)
        points = points.replace("[", "").replace("]", "").replace(",", " ").replace("-", "")
        return points.split(" ")
    }
}
