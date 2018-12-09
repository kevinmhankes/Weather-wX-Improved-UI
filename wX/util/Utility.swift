/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

final class Utility {

    static func getCurrentConditionsUSV2(_ locNum: Int) -> ObjectForecastPackage {
        let objCC = ObjectForecastPackageCurrentConditions(locNum)
        return ObjectForecastPackage(objCC)
    }

    static func getCurrentConditionsCanada(locNum: Int) -> ObjectForecastPackage {
        let html = UtilityCanada.getLocationHtml(Location.getLatLon(locNum))
        let objCC = ObjectForecastPackageCurrentConditions.createForCanada(html)
        return ObjectForecastPackage(objCC)
    }

    static func getCurrentConditionsV2(_ locNum: Int) -> ObjectForecastPackage {
        if Location.isUS(locNum) {
            return getCurrentConditionsUSV2(locNum)
        } else {
            return getCurrentConditionsCanada(locNum)
        }
    }

    static func getCurrentHazards(_ locNum: Int) -> ObjectForecastPackageHazards {
        if Location.isUS(locNum) {
            return ObjectForecastPackageHazards(locNum)
        } else {
            let html = UtilityCanada.getLocationHtml(Location.getLatLon(locNum))
            return ObjectForecastPackageHazards.createForCanada(html)
        }
    }

    static func getCurrentSevenDay(_ locNum: Int) -> ObjectForecastPackage7Day {
        if Location.isUS(locNum) {
            let sevenDayJson = UtilityDownloadNWS.get7DayJSON(Location.getLatLon(locNum))
            return ObjectForecastPackage7Day(locNum, sevenDayJson)
        } else {
            let html = UtilityCanada.getLocationHtml(Location.getLatLon(locNum))
            return ObjectForecastPackage7Day(locNum, html)
        }
    }

    static func getCurrentSevenDay(_ location: LatLon) -> ObjectForecastPackage7Day {
        let sevenDayJson = UtilityDownloadNWS.get7DayJSON(location)
        return ObjectForecastPackage7Day(-1, sevenDayJson)
    }

    static func getCurrentHazards(_ location: LatLon) -> ObjectForecastPackageHazards {
        return ObjectForecastPackageHazards(location)
    }

    static func getCurrentConditionsUSbyLatLon(_ location: LatLon) -> ObjectForecastPackage {
        let objCC = ObjectForecastPackageCurrentConditions(location)
        return ObjectForecastPackage(objCC)
    }

    static func getHazards(_ url: String) -> String {
        return url.parse("<!-- AddThis Button END -->   <hr /><br />(.*?)</div>")
    }

    static func getCurrentConditionsCanada(_ locNum: Int) -> ObjectForecastPackage {
        let html = UtilityCanada.getLocationHtml(Location.getLatLon(locNum))
        let objCC = ObjectForecastPackageCurrentConditions.createForCanada(html)
        return ObjectForecastPackage(objCC)
    }

    static func safeGet(_ list: [String], _ index: Int) -> String {
        if list.count <= index {
            return ""
        } else {
            return list[index]
        }
    }

    func readPref(_ key: String, _ value: Float) -> Float {
        return preferences.getFloat(key, value)
    }

    func readPref(_ key: String, _ value: Int) -> Int {
        return preferences.getInt(key, value)
    }

    func readPref(_ key: String, _ value: String) -> String {
        return preferences.getString(key, value)
    }

    func writePref(_ key: String, _ value: Float) {
        editor.putFloat(key, value)
    }

    func writePref(_ key: String, _ value: Int) {
        editor.putInt(key, value)
    }

    func writePref(_ key: String, _ value: String) {
        editor.putString(key, value)
    }
}
