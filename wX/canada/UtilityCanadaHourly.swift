/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityCanadaHourly {
    
    static func getString(_ location: Int) -> String {
        let url = MyApplication.canadaEcSitePrefix + "/forecast/hourly/"
            + MyApplication.locations[location].lat.split(":")[1].lowercased()
            + "-" + MyApplication.locations[location].lon.split(":")[0]
            + "_metric_e.html"
        let html = url.getHtml()
        let header = "Time    Temp  Summary                  Precip   Wind"
        return header + parse(html)
    }
    
    static func getUrl(_ location: Int) -> String {
        let url =  MyApplication.canadaEcSitePrefix + "/forecast/hourly/"
            + MyApplication.locations[location].lat.split(":")[1].lowercased()
            + "-"
            + MyApplication.locations[location].lon.split(":")[0]
            + "_metric_e.html"
        return url
    }
    
    static func parse(_ htmlFullPage: String) -> String {
        let html = htmlFullPage.parse("<tbody>(.*?)</tbody>")
        let times = html.parseColumn("<td headers=.header1. class=.text-center.>([0-9]{2}:[0-9]{2})</td>")
        let temperatures = html.parseColumn("<td headers=.header2. class=.text-center.>(.*?)</td>")
        let currentConditions = html.parseColumn("</span><div class=.media-body.><p>(.*?)</p></div>")
        let precipChances = html.parseColumn("<td headers=.header4. class=.text-center.>(.*?)</td>")
        var winds = html.parseColumn("<abbr title=(.*?.>.*?<.abbr>..[0-9]{2})<br>")
        let space = "   "
        var string = ""
        winds.indices.forEach { index in
            let cleanString = removeSpecialCharsFromString(winds[index])
            winds[index] = cleanString.parse(">(.*?)<") + " " + cleanString.parse(".*?([0-9]{1,3})")
        }
        times.indices.forEach { index in
            string += MyApplication.newline + times[index] + space
                + Utility.safeGet(temperatures, index).padding(toLength: 3, withPad: " ", startingAt: 0) + space
                + Utility.safeGet(currentConditions, index).padding(toLength: 22, withPad: " ", startingAt: 0) + space
                + Utility.safeGet(precipChances, index).padding(toLength: 6, withPad: " ", startingAt: 0)
                + space + Utility.safeGet(winds, index)
        }
        return string
    }
    
    static func removeSpecialCharsFromString(_ text: String) -> String {
        let okayChars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-=().!_<>")
        return text.filter { okayChars.contains($0) }
    }
}
