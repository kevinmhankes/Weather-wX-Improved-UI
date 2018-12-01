/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

final class UtilitySunMoon {

    static func getExtendedSunMoonData() -> String {
        let timeZone = UtilityTime.getDateAsString("Z")
        let tzOffset = timeZone.substring(0, 3) + "." + timeZone.substring(3, 5)
        let url = "https://api.usno.navy.mil/rstt/oneday?date=today&coords="
            + Location.latlon.latString + "," + Location.latlon.lonString + "&tz=" + tzOffset
        return url.getHtml().replace("\n", " ").replace("\t", " ")
    }

    static func parseData(_ content: String) -> (String, String) {
        let sundataChunk = content.parse("sundata\":\\[(.*?)\\]")
        let moondataChunk = content.parse("\"(moondata.:\\[.*?\\])")
        let moonphaseChunk = content.parse("closestphase.:\\{(.*?)\\}")
        let moonFracillum = content.parse("fracillum\":\"(.*?)%")
        let moonCurrentphase = content.parse("curphase\":\"(.*?)\"")
        let sunTwilight = sundataChunk.parse(" \\{\"phen\":\"BC\", \"time\":\"(.*?)\"\\}")
        let sunRise = sundataChunk.parse(" \\{\"phen\":\"R\", \"time\":\"(.*?)\"\\}")
        let sunUppertransit = sundataChunk.parse(" \\{\"phen\":\"U\", \"time\":\"(.*?)\"\\}")
        let sunSet = sundataChunk.parse(" \\{\"phen\":\"S\", \"time\":\"(.*?)\"\\}")
        let sunEndTwilight = sundataChunk.parse(" \\{\"phen\":\"EC\", \"time\":\"(.*?)\"\\}")
        let moonRise = moondataChunk.parse("phen.*?R.*?time.*?([0-9]{2}:[0-9]{2})")
        let moonUppertransit = moondataChunk.parse("phen.*?U.*?time.*?([0-9]{2}:[0-9]{2})")
        let moonSet = moondataChunk.parse("phen.*?S.*?time.*?([0-9]{2}:[0-9]{2})")
        let header = "Sun/Moon Data"
        var content2 = sunTwilight + " Sun Twilight" + MyApplication.newline
            + sunRise + " Sunrise" + MyApplication.newline
            + sunUppertransit + " Sun Upper Transit" + MyApplication.newline
            + sunSet + " Sunset" + MyApplication.newline
            + sunEndTwilight + " Sun Twilight End" + MyApplication.newline
            + MyApplication.newline
            + moonRise + " Moonrise" + MyApplication.newline
            + moonUppertransit + " Moon Upper Transit" + MyApplication.newline
            + moonSet + " Moonset" + MyApplication.newline
            + MyApplication.newline
            + moonphaseChunk.replaceAll("\"time\"", "")
            + MyApplication.newline
        if moonFracillum != "" {content2 += moonFracillum + "% Moon fracillum" + MyApplication.newline}
        if moonCurrentphase != "" {content2 += moonCurrentphase + " is the current phase" + MyApplication.newline}
        return (header, content2)
    }

    static func getFullMoonDates() -> String {
        let url = "https://api.usno.navy.mil/moon/phase?date=" + String(UtilityTime.getMonth())
            + "/" + String(UtilityTime.getDay()) + "/" + String(UtilityTime.getYear()) + "&nump=99"
        let text = url.getHtml()
        var fullText = ""
        let phaseArr = text.parseColumn("\"phase\":\"(.*?)\"")
        let dateArr = text.parseColumn("\"date\":\"(.*?)\"")
        let timeArr = text.parseColumn("\"time\":\"(.*?)\"")
        phaseArr.enumerated().forEach { index, _ in
            if phaseArr[index].contains("Full Moon") {
                fullText += Utility.safeGet(dateArr, index) + " "
                    + Utility.safeGet(timeArr, index)
                    + " "
                    + Utility.safeGet(phaseArr, index)
                    + "  <-----" + MyApplication.newline
            } else {
                fullText += Utility.safeGet(dateArr, index) + " "
                    + Utility.safeGet(timeArr, index) + " " + Utility.safeGet(phaseArr, index) + MyApplication.newline
            }
        }
        return fullText
    }
}
