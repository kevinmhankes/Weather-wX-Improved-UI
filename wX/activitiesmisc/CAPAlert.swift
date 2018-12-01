/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class CAPAlert {

    var text = ""
    var title = ""
    var summary = ""
    var area = ""
    var instructions = ""
    private var expireStr = "This alert has expired"
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
    convenience init(eventTxt: String) {
        self.init()
        url = eventTxt.parse("<id>(.*?)</id>")
        title  = eventTxt.parse("<title>(.*?)</title>")
        summary = eventTxt.parse("<summary>(.*?)</summary>")
        instructions = eventTxt.parse("</description>.*?<instruction>(.*?)</instruction>.*?<areaDesc>")
        area = eventTxt.parse("<cap:areaDesc>(.*?)</cap:areaDesc>")
        area = area.replace("&apos;", "'")
        effective = eventTxt.parse("<cap:effective>(.*?)</cap:effective>")
        //effective = eventTxt.parse("<cap:onset>(.*?)</cap:onset>")
        expires = eventTxt.parse("<cap:expires>(.*?)</cap:expires>")
        event = eventTxt.parse("<cap:event>(.*?)</cap:event>")
        vtec = eventTxt.parse("<valueName>VTEC</valueName>.*?<value>(.*?)</value>")
        zones = eventTxt.parse("<valueName>UGC</valueName>.*?<value>(.*?)</value>")
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
