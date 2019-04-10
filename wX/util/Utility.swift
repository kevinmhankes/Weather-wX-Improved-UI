/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

final class Utility {
    
    static func getRadarSiteName(_ radarSite: String) -> String {
        return UtilityRadarUI.radarIdToName[radarSite] ?? ""
    }
    
    static func getRadarSiteLatLon(_ radarSite: String) -> LatLon {
        let lat = UtilityRadarUI.radarSiteToLat[radarSite] ?? ""
        let lon = UtilityRadarUI.radarSiteToLon[radarSite] ?? ""
        return LatLon(lat, lon)
    }
    
    static func getRadarSiteX(_ radarSite: String) -> String {
        return UtilityRadarUI.radarSiteToLat[radarSite] ?? ""
    }
    
    static func getRadarSiteY(_ radarSite: String) -> String {
        return UtilityRadarUI.radarSiteToLon[radarSite] ?? ""
    }
    
    static func getWfoSiteName(_ wfo: String) -> String {
        return UtilityRadarUI.wfoIdToName[wfo] ?? ""
    }
    
    static func getWfoSiteLatLon(_ wfo: String) -> LatLon {
        let lat = UtilityRadarUI.wfoSitetoLat[wfo] ?? ""
        let lon = UtilityRadarUI.wfoSitetoLon[wfo] ?? ""
        return LatLon(lat, lon)
    }
    
    static func getSoundingSiteLatLon(_ wfo: String) -> LatLon {
        let lat = UtilityRadarUI.soundingSiteToLat[wfo] ?? ""
        let lon = "-" + (UtilityRadarUI.soundingSiteToLon[wfo] ?? "")
        return LatLon(lat, lon)
    }
    
    static func getSoundingSiteName(_ wfo: String) -> String {
        var site = UtilityRadarUI.wfoIdToName[wfo] ?? ""
        if (site == "") {
            site = UtilityRadarUI.soundingIdToName[wfo] ?? ""
        }
        return site
    }
    
    /*static func generateSoundingNameList() -> [String] {
        var list = <String>[]
        GlobalArrays.soundingSites.sort()
        GlobalArrays.soundingSites.forEach((data) {
            list.add(data + ": " + getSoundingSiteName(data))
        });
        return list
    }*/
    
    static func getCurrentConditionsUS(_ locNum: Int) -> ObjectForecastPackage {
        let objCC = ObjectForecastPackageCurrentConditions(locNum)
        return ObjectForecastPackage(objCC)
    }
    
    static func getCurrentConditionsCanada(locNum: Int) -> ObjectForecastPackage {
        let html = UtilityCanada.getLocationHtml(Location.getLatLon(locNum))
        let objCC = ObjectForecastPackageCurrentConditions.createForCanada(html)
        return ObjectForecastPackage(objCC)
    }
    
    static func getCurrentConditions(_ locNum: Int) -> ObjectForecastPackage {
        if Location.isUS(locNum) {
            return getCurrentConditionsUS(locNum)
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
            let sevenDayJson = UtilityDownloadNWS.get7DayJson(Location.getLatLon(locNum))
            return ObjectForecastPackage7Day(locNum, sevenDayJson)
        } else {
            let html = UtilityCanada.getLocationHtml(Location.getLatLon(locNum))
            return ObjectForecastPackage7Day(locNum, html)
        }
    }
    
    static func getCurrentSevenDay(_ location: LatLon) -> ObjectForecastPackage7Day {
        let sevenDayJson = UtilityDownloadNWS.get7DayJson(location)
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
    
    static func readPref(_ key: String, _ value: Float) -> Float {
        return preferences.getFloat(key, value)
    }
    
    static func readPref(_ key: String, _ value: Int) -> Int {
        return preferences.getInt(key, value)
    }
    
    static func readPref(_ key: String, _ value: String) -> String {
        return preferences.getString(key, value)
    }
    
    static func writePref(_ key: String, _ value: Float) {
        editor.putFloat(key, value)
    }
    
    static func writePref(_ key: String, _ value: Int) {
        editor.putInt(key, value)
    }
    
    static func writePref(_ key: String, _ value: String) {
        editor.putString(key, value)
    }
    
    static func getClassName(_ uiv: UIViewController) -> String {
        return String(describing: uiv).split(":").safeGet(0).replace("<", "")
    }
}
