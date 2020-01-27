/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation
import UIKit

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
        if site == "" {
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

    static func getCurrentHazards(_ locNum: Int) -> ObjectForecastPackageHazards {
        if Location.isUS(locNum) {
            return ObjectForecastPackageHazards(locNum)
        } else {
            let html = UtilityCanada.getLocationHtml(Location.getLatLon(locNum))
            return ObjectForecastPackageHazards.createForCanada(html)
        }
    }

    static func getHazards(_ url: String) -> String {
        return url.parse("<!-- AddThis Button END -->   <hr /><br />(.*?)</div>")
    }

    static func safeGet(_ list: [String], _ index: Int) -> String {
        if list.count <= index {
            return ""
        } else {
            return list[index]
        }
    }

    static func readPref(_ key: String, _ value: Float) -> Float {
        return GlobalVariables.preferences.getFloat(key, value)
    }

    static func readPref(_ key: String, _ value: Int) -> Int {
        return GlobalVariables.preferences.getInt(key, value)
    }

    static func readPref(_ key: String, _ value: String) -> String {
        return GlobalVariables.preferences.getString(key, value)
    }

    static func writePref(_ key: String, _ value: Float) {
        GlobalVariables.editor.putFloat(key, value)
    }

    static func writePref(_ key: String, _ value: Int) {
        GlobalVariables.editor.putInt(key, value)
    }

    static func writePref(_ key: String, _ value: String) {
        GlobalVariables.editor.putString(key, value)
    }

    static func getClassName(_ uiv: UIViewController) -> String {
        return String(describing: uiv).split(":").safeGet(0).replace("<", "")
    }
    
    static func showMainScreenShortCuts() -> String {
        return "Ctrl-r: Nexrad radar" + MyApplication.newline +
                "Ctrl-m: Show submenu" + MyApplication.newline +
                "Ctrl-d: Severe Dashboard" + MyApplication.newline +
                "Ctrl-c: Goes Viewer" + MyApplication.newline +
                "Ctrl-a: Local text product viewer" + MyApplication.newline +
                "Ctrl-s: Settings" + MyApplication.newline +
                "Ctrl-2: Dual Pane Radar" + MyApplication.newline +
                "Ctrl-4: Quad Pane Radar" + MyApplication.newline +
                "Ctrl-w: US Alerts" + MyApplication.newline +
                "Ctrl-e: SPC Mesoanalysis" + MyApplication.newline +
                "Ctrl-n: NCEP Models" + MyApplication.newline +
                "Ctrl-h: Hourly" + MyApplication.newline +
                "Ctrl-t: NHC" + MyApplication.newline +
                "Ctrl-l: Lightning" + MyApplication.newline +
                "Ctrl-i: National images" + MyApplication.newline +
                "Ctrl-z: National text discussions" + MyApplication.newline +
                "<-: Previous tab" + MyApplication.newline +
                "->: Next tab" + MyApplication.newline
    }

    static func showRadarShortCuts() -> String {
        //return "Ctrl-l: Show map" + MyApplication.newline +
                //"Ctrl-m: Show submenu" + MyApplication.newline +
        return "Ctrl-a: Animate" + MyApplication.newline +
                "Ctrl-a: Stop animate" + MyApplication.newline +
                //"Ctrl-r: Show reflectivity" + MyApplication.newline +
                //"Ctrl-v: Show velocity" + MyApplication.newline +
                //"Ctrl-f: Toggle favorite" + MyApplication.newline +
                "Ctrl-2: Show dual pane radar" + MyApplication.newline +
                //"Ctrl-4: Show quad pane radar" + MyApplication.newline +
                //"Ctrl-UpArrow: Zoom out" + MyApplication.newline +
                //"Ctrl-DownArrow: Zoom in" + MyApplication.newline +
                "Arrow keys: pan radar" + MyApplication.newline
                //"Reload key: reload radar" + MyApplication.newline
    }
}
