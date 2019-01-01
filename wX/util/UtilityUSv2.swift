/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

final class UtilityUSv2 {

    static var obsClosestClass = ""
    static var obsCodeToLocation = [String: String]()

    static func getStatus(_ conditionsTimeStr: String) -> String {
        var conditionsTimeStrLocal = conditionsTimeStr
        var locationName: String?
        locationName = obsCodeToLocation[obsClosestClass]
        if locationName == nil {
            locationName = findObsName(obsClosestClass)
            if locationName != "" && obsClosestClass != "" {
                obsCodeToLocation[obsClosestClass] = locationName
            }
        }
        conditionsTimeStrLocal = UtilityTime.convertFromUTC(UtilityString.shortenTime(conditionsTimeStrLocal))
        return conditionsTimeStrLocal.replace(":00 ", " ")
            + " " + locationName!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            + " (" + obsClosestClass + ") "
    }

    static func getStatusViaMetar(_ conditionsTimeStr: String) -> String {
        var locationName: String?
        locationName = obsCodeToLocation[obsClosestClass]
        if locationName == nil {
            locationName = findObsName(obsClosestClass)
            if locationName != "" && obsClosestClass != "" {
                obsCodeToLocation[obsClosestClass] = locationName
            }
        }
        return conditionsTimeStr + " "
            + locationName!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            + " (" + obsClosestClass + ") "
    }

    static func findObsName(_ obsShortCode: String) -> String {
        var locatioName = ""
        let lines = UtilityIO.rawFileToStringArray(R.Raw.stations_us4)
        var tmp = ""
        lines.forEach {
            if $0.contains("," + obsShortCode) {
                tmp = $0
            }
        }
        let chunks = tmp.split(",")
        if chunks.count > 2 {
            locatioName = chunks[0] + ", " + chunks[1]
        }
        return locatioName
    }

    static func getObsFromLatLon(_ location: LatLon) -> String {
        let newLatLon = UtilityMath.latLonFix(location)
        let key = "LLTOOBS" + newLatLon.latString + "," + newLatLon.lonString
        var obsClosest = preferences.getString(key, "")
        if obsClosest == "" {
            let obsHtml = ("https://api.weather.gov/points/" + newLatLon.latString + ","
                + newLatLon.lonString + "/stations").getNwsHtml()
            obsClosest = obsHtml.parseFirst("gov/stations/(.*?)\"")
            obsClosestClass = obsClosest
            if key != "" && obsClosest != "" {
                editor.putString(key, obsClosest)
            }
        }
        obsClosestClass = obsClosest
        return obsClosest
    }
}
