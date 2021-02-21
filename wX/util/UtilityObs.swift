/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

final class UtilityObs {

    static var obsClosestClass = ""
    private static var obsCodeToLocation = [String: String]()

    static func getStatus(_ conditionsTimeStr: String) -> String {
        var conditionsTimeStrLocal = conditionsTimeStr
        var locationName: String?
        locationName = obsCodeToLocation[obsClosestClass]
        if locationName == nil {
            locationName = findObsName(obsClosestClass)
            if locationName != "" && obsClosestClass != "" { obsCodeToLocation[obsClosestClass] = locationName }
        }
        conditionsTimeStrLocal = UtilityTime.convertFromUTC(UtilityString.shortenTime(conditionsTimeStrLocal))
        return conditionsTimeStrLocal.replace(":00 ", " ") + " " + locationName!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) + " (" + obsClosestClass + ") "
    }

    static func getStatusViaMetar(_ conditionsTimeStr: String) -> String {
        var locationName: String?
        locationName = obsCodeToLocation[obsClosestClass]
        if locationName == nil {
            locationName = findObsName(obsClosestClass)
            if locationName != "" && obsClosestClass != "" { obsCodeToLocation[obsClosestClass] = locationName }
        }
        return conditionsTimeStr + " " + locationName!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) + " (" + obsClosestClass + ") "
    }

    static func findObsName(_ obsShortCode: String) -> String {
        var locationName = ""
        let lines = UtilityIO.rawFileToStringArray(R.Raw.stations_us4)
        var tmp = ""
        lines.forEach { line in if line.contains("," + obsShortCode) { tmp = line } }
        let chunks = tmp.split(",")
        if chunks.count > 2 { locationName = chunks[0] + ", " + chunks[1] }
        return locationName
    }

    static func getObsFromLatLon(_ location: LatLon) -> String {
        let newLatLon = UtilityMath.latLonFix(location)
        let key = "LLTOOBS" + newLatLon.latString + "," + newLatLon.lonString
        var obsClosest = Utility.readPref(key, "")
        if obsClosest == "" {
            let obsHtml = ("https://api.weather.gov/points/" + newLatLon.latString + "," + newLatLon.lonString + "/stations").getNwsHtml()
            obsClosest = obsHtml.parseFirst("gov/stations/(.*?)\"")
            obsClosestClass = obsClosest
            if key != "" && obsClosest != "" { Utility.writePref(key, obsClosest) }
        }
        obsClosestClass = obsClosest
        return obsClosest
    }
}
