/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation
import UIKit

final class Utility {

    static func getRadarSiteName(_ radarSite: String) -> String { UtilityRadar.radarIdToName[radarSite] ?? "" }

    static func getRadarSiteLatLon(_ radarSite: String) -> LatLon {
        let lat = UtilityRadar.radarSiteToLat[radarSite] ?? ""
        let lon = "-" + (UtilityRadar.radarSiteToLon[radarSite] ?? "")
        return LatLon(lat, lon)
    }

    static func getRadarSiteX(_ radarSite: String) -> String { UtilityRadar.radarSiteToLat[radarSite] ?? "" }

    static func getRadarSiteY(_ radarSite: String) -> String { UtilityRadar.radarSiteToLon[radarSite] ?? "" }

    static func getWfoSiteName(_ wfo: String) -> String { UtilityRadar.wfoIdToName[wfo] ?? "" }

    static func getWfoSiteLatLon(_ wfo: String) -> LatLon {
        let lat = UtilityRadar.wfoSiteToLat[wfo] ?? ""
        let lon = UtilityRadar.wfoSiteToLon[wfo] ?? ""
        return LatLon(lat, lon)
    }

    static func getSoundingSiteLatLon(_ wfo: String) -> LatLon {
        let lat = UtilityRadar.soundingSiteToLat[wfo] ?? ""
        let lon = "-" + (UtilityRadar.soundingSiteToLon[wfo] ?? "")
        return LatLon(lat, lon)
    }

    static func getSoundingSiteName(_ wfo: String) -> String {
        var site = UtilityRadar.wfoIdToName[wfo] ?? ""
        if site == "" { site = UtilityRadar.soundingIdToName[wfo] ?? "" }
        return site
    }

    static func getCurrentHazards(_ uiv: UIViewController, _ locNum: Int) -> ObjectHazards {
        if Location.isUS(locNum) {
            return ObjectHazards(uiv, locNum)
        } else {
            let html = UtilityCanada.getLocationHtml(Location.getLatLon(locNum))
            return ObjectHazards.createForCanada(html)
        }
    }

    static func safeGet(_ list: [String], _ index: Int) -> String {
        if list.count <= index { return "" } else { return list[index] }
    }

    static func readPref(_ key: String, _ value: Float) -> Float { GlobalVariables.preferences.getFloat(key, value) }

    static func readPref(_ key: String, _ value: Int) -> Int { GlobalVariables.preferences.getInt(key, value) }

    static func readPref(_ key: String, _ value: String) -> String { GlobalVariables.preferences.getString(key, value) }

    static func writePref(_ key: String, _ value: Float) {
        GlobalVariables.editor.putFloat(key, value)
    }

    static func writePref(_ key: String, _ value: Int) {
        GlobalVariables.editor.putInt(key, value)
    }

    static func writePref(_ key: String, _ value: String) {
        GlobalVariables.editor.putString(key, value)
    }

    static func showDiagnostics() -> String {
        GlobalVariables.newline + "Is Tablet?: " + String(UtilityUI.isTablet()) + GlobalVariables.newline + GlobalVariables.forecastZone
    }
}
