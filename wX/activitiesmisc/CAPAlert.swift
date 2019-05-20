/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

// FIXME camelcase
final class CAPAlert {

    var text = ""
    var title = ""
    var summary = ""
    var area = ""
    var instructions = ""
    private var expireToken = "This alert has expired"
    private var zones = ""
    var vtec = ""
    var url = ""
    var event = ""
    private var effective = ""
    private var expires = ""

    convenience init(url: String) {
        self.init()
        self.url = url
        var html = ""
        if url.contains("NWS-IDP-PROD") {
            html = url.getNwsHtml()
        } else {
            html = url.getHtmlSep()
        }
        title = html.parse("\"headline\": \"(.*?)\"")
        summary = html.parse("\"description\": \"(.*?)\"")
        instructions = html.parse("\"instruction\": \"(.*?)\"")
        area = html.parse("\"areaDesc\": \"(.*?)\"")
        summary = summary.replace("\\n", "\n")
        instructions = instructions.replace("\\n", "\n")
        text = "<h4><b>"
        text += title
        text += "</b></h4>"
        text += "<b>Counties: "
        text += area
        text += "</b><br><br>"
        text += summary
        text += "<br><br><br>"
        text += instructions
        text += "<br><br><br>"
        if UIPreferences.nwsTextRemovelinebreaks {
            instructions = instructions.replaceAll("<br><br>", "<BR><BR>").replaceAll("<br>", " ")
        }
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
        text = "<h4><b>"
        text += title
        text += "</b></h4>"
        text += "<b>Counties: "
        text += area
        text += "</b><br><br>"
        text += summary
        text += "<br><br><br>"
        text += instructions
        text += "<br><br><br>"
        summary = summary.replaceAll("<br>\\*", "<br><br>*")
        if UIPreferences.nwsTextRemovelinebreaks {
            instructions = instructions.replaceAll("<br><br>", "<BR><BR>").replaceAll("<br>", " ")
        }
    }
}
